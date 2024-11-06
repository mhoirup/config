return {
  'shaunsingh/nord.nvim',
  priority = 1000,
  config = function ()
    _G.theme_nord = function ()
      vim.cmd.colorscheme 'nord'
      _G.dark_mode = true

      _G.colors = {
        cyan = '#88c0d0',
        blue = '#81a1c1',
        green = '#a3be8c',
        lines = '#4c566a',
        background_lighter = '#3b4252'
      }

      local highlights = {
        ['@keyword.return'] = { fg = _G.colors.blue, italic = true, bold = true },
        ['@ibl.indent.char.1'] = { fg = _G.colors.lines },
        ['@keyword.function'] = { fg = _G.colors.blue, italic = true, bold = true },
        ['@keyword.repeat'] = { fg = _G.colors.blue, italic = true, bold = true },
        ['@keyword.conditional'] = { fg = _G.colors.blue, italic = true, bold = true },
        ['@keyword.local.lua'] = { fg = _G.colors.blue, italic = false, bold = true },
        ['@keyword'] = { fg = _G.colors.blue, italic = true, bold = true },
        ['@keyword.operator'] = { fg = _G.colors.blue, italic = true, bold = true },
        ['Function'] = { fg = _G.colors.cyan, bold = true },
        ['@function'] = { link = 'Function' },
        ['@punctuation.delimiter'] = { fg = _G.colors.blue },
        ['@function.builtin'] = { link = 'Function' },
        ['String'] = { fg = _G.colors.green, italic = false },
        ['StatusLine'] = { bg = _G.colors.background_ligher },
        ['@string'] = { fg = _G.colors.green, italic = false },
        ['@property'] = { fg = 'NONE' },
        ['@variable'] = { fg = 'NONE' },
      }

      for group, opts in pairs(highlights) do
        vim.api.nvim_set_hl(0, group, opts)
      end
    end

  end
}
