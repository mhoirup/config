return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make'
    },
  },
  event = 'VeryLazy',
  config = function ()

    local ignore_patterns = {
      '.csv$',
      '.xlsx$',
      '.pdf$',
      '.docx$',
      'kitty.*py',
      'kitty.conf.bak',
      'DS_Store',
      'RData',
      'Rhistory',
      -- 'lazy-lock.json$',
      '/.DS_Store',
      '__pycache__/*',
      'tmux/*',
    }

    local win_opts = {
      previewer = false,
      -- prompt_title = '',
      results_title = '',
      theme = 'dropdown',
      winopts = {
        anchor_padding = 0,
        width = math.floor(vim.api.nvim_list_uis()[1].width * 1),
      }
      -- theme = 'ivy'
    }

    local pickers = {
      'find_files',
      'buffers',
      'builtin',
      'help_tags',
      'highlights',
    }

    local actions = require('telescope.actions')
    -- local action_state = require('telescope.actions.state')

    local picker_opts = {}
    for _, picker in ipairs(pickers) do
      picker_opts[picker] = win_opts
    end

    require('telescope').setup {
      defaults = {
        vimgrep_arguments = {
          'rg',
          -- '-L',
          '--color=never',
          '--no-heading',
          '--with-filename',
          -- '--column',
          '--smart-case',
          '--ignore',
          '--hidden'
        },
        file_ignore_patterns = ignore_patterns,
        prompt_prefix = '    ',
        prompt_title = false,
        hidden = true,
        results_title = false,
        -- selection_caret = '+ ',
        selection_caret = ' ',
        layout_config = {
          anchor = 'N',
          anchor_padding = 0,
        },
        mappings = {
          i = {
            ['<Esc>']   = actions.close,
            ['<C-j>']   = actions.move_selection_next,
            ['<C-k>']   = actions.move_selection_previous,
            ['<Tab>']   = actions.move_selection_next,
            ['<S-Tab>'] = actions.move_selection_previous,
            ['<CR>']    = actions.select_default,
            ['<C-p>']   = actions.toggle_selection,
            ['<C-s>']   = actions.select_vertical,
            ['<C-x>']   = actions.select_horizontal,
            ['<C-n>']   = actions.nop,
            ['<C-l>']   = actions.nop,
            ['<C-h>']   = actions.nop,
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = true,  -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = 'smart_case',        -- or 'ignore_case' or 'respect_case'
          }
        }
      },
      pickers = picker_opts
    }
    require('telescope').load_extension('fzf')
  end
}
