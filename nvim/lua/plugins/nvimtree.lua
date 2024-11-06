return {
  'nvim-tree/nvim-tree.lua',
  event = 'VeryLazy',
  config = function ()
    require('nvim-tree').setup {
      view = {
        signcolumn = 'no',
        width = function ()
          return math.min(math.floor(vim.api.nvim_list_uis()[1].width * 0.35), 40)
        end,
      },
      renderer = {
        root_folder_label = false,
        indent_markers = {
          enable = true
        },
        icons = {
          show = {
            folder_arrow = false
          },
          glyphs = {
            folder = {
              default = '',
              open = '',
              empty = '',
              empty_open = '',
            }
          }
        }
      },
      filters = {
        custom = {
          '.DS_Store',
          '.RData',
          '.RHistory',
        }
      }
    }
  end
}

