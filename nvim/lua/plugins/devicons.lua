return {
  'nvim-tree/nvim-web-devicons',
  event = 'VimEnter',
  config = function ()
    function _G.devicons()
      local devicons = require('nvim-web-devicons')
      devicons.setup {
        strict = false,
        override_by_extension = {
          ['txt']            = { icon = '󰈚', name = "Txt" },
          ['R Console']      = { icon = '󰆍', name = 'RConsole' },
          ['Python Console'] = { icon = '󰆍', name = 'PyConsole' },
          ['qmd']            = { icon = '', name = 'Quarto' },
          ['json']           = { icon = '󰘦', name = 'Json' },
          ['csv']            = { icon = '', name = 'Csv' },
          ['xlsx']           = { icon = '󱎏', name = 'Xlsx' },
          ['docx']           = { icon = '', name = 'Docx' },
          ['pdf']            = { icon = '', name = 'Pdf' },
          ['rmd']            = { icon = '󰟔', name = 'Rmd' },
          ['Rmd']            = { icon = '󰟔', name = 'Rmd' },
        },
        override_by_filename = {
          ['.zshrc']         = { icon = '', name = 'Zshrc' },
          ['.lintr']         = { icon = '󰟔', name = 'R' },
          ['tmux.conf']      = { icon = '', name = 'Conf'}
        }
      }

      local colors = {
        cyan   = _G.dark_mode and '#78dce8' or '#1c8ca8',
        green  = _G.dark_mode and '#a9dc76' or '#269d69',
        orange = _G.dark_mode and '#fc9867' or '#e16032',
        pink   = _G.dark_mode and '#ff6188' or '#e14775',
        purple = _G.dark_mode and '#ab9df2' or '#7058be',
        normal = _G.dark_mode and '#c7d1ff' or '#0a3069',
        yellow = _G.dark_mode and '#ffd866' or '#cc7a0a',
      }

      local icon_highlights = {
        green = {
          'Py', 'Vim', 'PyConsole', 'Zsh', 'Zshrc', 'Xlsx'
        },
        cyan = {
          'Lua', 'R', 'RConsole', 'Docx', 'Rmd'
        },
        purple = {
          'Json', 'Quarto', 'Tex'
        },
        pink = {
          'Sql', 'Pdf'
        },
        normal = {
          'Conf', 'Backup', 'Sh', 'Terminal', 'Csv'
        },
        orange = {
          'Markdown', 'Md', 'GitIgnore'
        },
        yellow = {
          'Txt', 'Default',
        },
      }

      for color, groups in pairs(icon_highlights) do
        for _, group in ipairs(groups) do
          vim.api.nvim_set_hl(0, 'DevIcon' .. group, { fg = colors[color] })
        end
      end
    end
    _G.devicons()
  end
}

