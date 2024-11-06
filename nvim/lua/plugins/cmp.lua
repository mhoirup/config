local icons = {
  Array = "[]",
  Boolean = "",
  Calendar = "",
  Class = "󰠱",
  Codeium = "",
  Color = "󰏘",
  Constant = "󰏿",
  Constructor = "",
  Copilot = "",
  Enum = "",
  EnumMember = "",
  Event = "",
  Field = "󰜢",
  File = "󰈚",
  Folder = "󰉋",
  Function = "󰆧",
  Interface = "",
  Keyword = "",
  Method = "󰆧",
  Module = "󰅩",
  Namespace = "󰌗",
  Null = "󰟢",
  Number = "",
  Object = "󰅩",
  Operator = "󰆕",
  Package = "",
  Property = "󰜢",
  Reference = "󰈇",
  Snippet = "",
  String = "󰉿",
  Struct = "󰙅",
  TabNine = "",
  Table = "",
  Tag = "",
  Text = "󰉿",
  TypeParameter = "",
  Unit = "󰑭",
  Value = "󰎠",
  Variable = "",
  Watch = "󰥔",
}

return {
  'hrsh7th/nvim-cmp',
  -- enabled = false,
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'saadparwaiz1/cmp_luasnip',
    -- 'hrsh7th/cmp-nvim-lua',
    -- 'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'micangl/cmp-vimtex'
    -- 'onsails/lspkind.nvim',
  },
  enabled = true,
  event = { 'InsertEnter', 'CmdlineEnter' },
  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')
    cmp.setup {
      matching = {
        disallow_fuzzy_matching = true,
        disallow_fullfuzzy_matching = true,
        disallow_partial_fuzzy_matching = true,
        disallow_partial_matching = false,
        disallow_prefix_unmatching = true,
      },
      performance = {
        debounce = 0,
        throttle = 0,
        fetching_timeout = 5,
        confirm_resolve_timeout = 80,
        max_view_entries = 12,
      },
      window = {
        completion = cmp.config.window.bordered {
          side_padding = 1,
          winhighlight = "Normal:CmpPmenu,FloatBorder:CmpBorder,CursorLine:CmpSelection,Search:PmenuSel",
          scrollbar = false,
        },
        documentation = false,
        -- documentation = cmp.config.window.bordered {
        --   side_padding = 1,
        --   winhighlight = "Normal:CmpPmenu,FloatBorder:CmpBorder,CursorLine:CmpSelection,Search:PmenuSel",
        --   scrollbar = false,
        -- },
      },
      snippet = {
        expand = function(args)
          vim.snippet.expand(args.body)
        end,
      },
      formatting = {
        fields = { 'kind', 'abbr', 'menu' },
        format = function(_, item)
          item.abbr = string.gsub(item.abbr, '%~', '')
          item.menu = item.kind
          item.menu_hl_group = 'CmpItemKind' .. (item.kind or '')
          item.kind = icons[item.kind] .. string.rep(' ', 1)
          return item
        end
      },
      sources = cmp.config.sources({
        { name = 'luasnip' },
        {
          name = 'nvim_lsp',
          -- Dont suggest Text from nvm_lsp
          entry_filter = function(entry, _)
            return require('cmp').lsp.CompletionItemKind.Text ~= entry:get_kind()
          end,
          keyword_length = 1
        },
        {
          name = 'nvim_lua',
          entry_filter = function(entry, _)
            local not_text  = require('cmp').lsp.CompletionItemKind.Text ~= entry:get_kind()
            local not_value = require('cmp').lsp.CompletionItemKind.Value ~= entry:get_kind()
            return not_text and not_value
          end,
          keyword_length = 1
        },
      }),
      mapping = cmp.mapping.preset.insert({
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
        -- ['<Esc>'] = cmp.mapping.close(),
        -- ['<C-l>'] = cmp.mapping.open_docs(),
        -- ['<C-h>'] = cmp.mapping.close_docs(),
        ['<C-p>'] = cmp.config.disable,
        ['<C-k>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ['<C-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ['<C-Space>'] = function() if cmp.visible() then cmp.abort() else cmp.mapping.complete() end end,
        ['<Tab>'] = cmp.mapping(
          function(fallback)
            if cmp.visible() then cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            elseif luasnip.locally_jumpable(1) then luasnip.jump(1)
            else fallback()
            end
          end,
          { 'i', 's' }
        ),
        ['<S-Tab>'] = cmp.mapping(
          function(fallback)
            if cmp.visible() then cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
            elseif luasnip.locally_jumpable(-1) then luasnip.jump(-1)
            else fallback()
            end
          end,
          { 'i', 's' }
        ),
      }),
    }

    cmp.event:on(
      'confirm_done',
      require('nvim-autopairs.completion.cmp').on_confirm_done()
    )

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' }}),
      matching = { disallow_symbol_nonprefix_matching = false },
      performance = {
        debounce = 0,
        throttle = 0,
        fetching_timeout = 5,
        confirm_resolve_timeout = 80,
        max_view_entries = 10,
      },
      formatting = {
        fields = { 'abbr' },
        format = function(_, vim_item)
          local abbr_len = string.len(vim_item.abbr)
          vim_item.abbr = vim_item.abbr .. (abbr_len < 15 and string.rep(' ', 15 - abbr_len) or '')
          vim_item.kind = nil
          vim_item.menu = nil
          return vim_item
        end
      },
    })
  end
}
