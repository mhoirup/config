local servers = {
  'lua_ls',
  -- 'pylsp',
  'sqls',
  -- 'pyright',
  'basedpyright',
  'r_language_server'
}

local server_options = {
  basedpyright = {
    basedpyright = {
      analysis = {
        typeCheckingMode = 'off',
        -- reportMissingTypeStubs = false
      }
    }
  },
  sqls = {},
  r_language_server = {},
  lua_ls = {
    Lua = {
      diagnostics = { globals = { 'vim' } },
      workspace = {
        library = {
          [vim.fn.expand '$VIMRUNTIME/lua'] = true,
          [vim.fn.expand '$VIMRUNTIME/lua/vim/lsp'] = true,
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  },
  -- pylsp = {
  --   pylsp = {
  --     plugins = {
  --       pycodestyle = { enabled = false },
  --     },
  --   },
  -- },
}

local plugins = {
  { 'williamboman/mason.nvim', config = { ui = { border = 'rounded' } } },
  { 'williamboman/mason-lspconfig.nvim', opts = { ensure_installed = servers } },
  {
    'neovim/nvim-lspconfig',
    config = function()
      local lspconfig = require('lspconfig')
      for server, options in pairs(server_options) do
        lspconfig[server].setup {
          capabilities = require('cmp_nvim_lsp').default_capabilities(),
          on_attach = function(client)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
            client.server_capabilities.semanticTokensProvider = false
          end,
          settings = options,
        }
      end

      vim.diagnostic.config({
        -- virtual_text = false,
      })

      for _, type in ipairs({'Error', 'Warn', 'Info', 'Hint'}) do
        local group = 'DiagnosticSign' .. type
        vim.fn.sign_define(group, { text = '●', texthl = group })
      end
    end
  }
}

return plugins
