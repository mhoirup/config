return {
  'projekt0n/github-nvim-theme',
  name = 'github-theme',
  priority = 1000,
  config = function ()
    function _G.theme_github_light()
      require('github-theme').setup {}
      vim.cmd.colorscheme 'github_light'
      _G.dark_mode = false

      _G.colors = {
        lines = '#d6dee8',
        dimmed = '#babbbd',
        comment = '#6A737D',
        black = '#0550ae',
        background_darker = '#f6f8fa',
        red = '#D73A49',
        purple = '#6F42C1',
        yellow = '#f9c513'
      }

      local highlights = {
        ['@ibl.indent.char.1'] = { fg = '#eff2f6' },
        ['LineNr'] = { fg = _G.colors.dimmed },
        ['TelescopeBorder'] = { fg = _G.colors.lines },
        ['TelescopeMatching'] = { fg = 'NONE', link = 'NONE' },
        ['TelescopeTitle'] = { fg = _G.colors.black, bold = true },
        ['TelescopeSelection'] = { fg = 'NONE', bg = _G.colors.background_darker },
        ['StatusLine'] = { bg = _G.colors.background_darker },
        ['Comment'] = { fg = _G.colors.comment },
        ['@keyword.function'] = { fg = _G.colors.red, italic = true },
        ['@keyword.repeat'] = { fg = _G.colors.red, italic = true },
        ['@keyword.return'] = { fg = _G.colors.red, italic = true },
        ['@keyword.conditional'] = { fg = _G.colors.red, italic = true },
        ['@keyword.operator'] = { fg = _G.colors.red, italic = true },
        ['@keyword.import'] = { fg = _G.colors.red, italic = true },
        ['@keyword.type'] = { fg = _G.colors.red, italic = true },
        ['@keyword.local.lua'] = { fg = _G.colors.red, italic = false },
        ['CmpBorder'] = { fg = _G.colors.lines },
        ['@class'] = { fg = _G.colors.purple },
        ['@constructor'] = { fg = _G.colors.purple },
        ['CmpSelection'] = { fg = 'NONE', bg = _G.colors.background_darker },
        ['CmpItemAbbr'] = { fg = _G.colors.black },
        ['CmpItemAbbrDefault'] = { fg = _G.colors.black },
        ['CmpItemAbbrMatch'] = { fg = _G.colors.black },
        ['CmpItemAbbrMatchFuzzy'] = { fg = _G.colors.black },
      }
      for group, opts in pairs(highlights) do
        vim.api.nvim_set_hl(0, group, opts)
      end
    end

    function _G.theme_github_dark()
      require('github-theme').setup {}
      vim.cmd.colorscheme 'github_dark_dimmed'
      _G.dark_mode = true

      _G.colors = {
        dimmed = '#343A43',
        lines = '#373e47',
        comment = '#525b64',
        background_lighter = '#30363d',
        red = '#F47067',
        blue_dark = '#6CB6FF',
        white = '#adbac7',
      }

      local highlights = {
        ['@ibl.indent.char.1'] = { fg = _G.colors.dimmed },
        ['LineNr'] = { fg = _G.colors.dimmed },
        ['TelescopeBorder'] = { fg = _G.colors.lines },
        ['Function'] = { fg = _G.colors.blue_dark, bold = true },
        ['TelescopeMatching'] = { fg = 'NONE', link = 'NONE' },
      --   ['TelescopeTitle'] = { fg = _G.colors.black, bold = true },
      --   ['TelescopeSelection'] = { fg = 'NONE', bg = _G.colors.background_darker },
      --   ['StatusLine'] = { bg = _G.colors.background_darker },
        ['Comment'] = { fg = _G.colors.comment },
        ['@keyword.function'] = { fg = _G.colors.red, italic = true, bold = true },
        ['@keyword.repeat'] = { fg = _G.colors.red, italic = true, bold = true },
        ['@keyword.return'] = { fg = _G.colors.red, italic = true, bold = true },
        ['@keyword.conditional'] = { fg = _G.colors.red, italic = true, bold = true },
        ['@keyword.operator'] = { fg = _G.colors.red, italic = true, bold = true },
        ['@keyword.import'] = { fg = _G.colors.red, italic = true, bold = true },
        ['@keyword.type'] = { fg = _G.colors.red, italic = true, bold = true },
        ['@keyword.local.lua'] = { fg = _G.colors.red, italic = false, bold = true },
        ['@operator'] = { fg = _G.colors.white },
        ['@operator.lua'] = { fg = _G.colors.white },
      --   ['CmpBorder'] = { fg = _G.colors.lines },
      --   ['@class'] = { fg = _G.colors.purple },
      --   ['@constructor'] = { fg = _G.colors.purple },
      --   ['CmpSelection'] = { fg = 'NONE', bg = _G.colors.background_darker },
      --   ['CmpItemAbbr'] = { fg = _G.colors.black },
      --   ['CmpItemAbbrDefault'] = { fg = _G.colors.black },
      --   ['CmpItemAbbrMatch'] = { fg = _G.colors.black },
      --   ['CmpItemAbbrMatchFuzzy'] = { fg = _G.colors.black },
        ['StatusLine'] = { fg = _G.colors.white, bg = _G.colors.background_ligher },
      }
      for group, opts in pairs(highlights) do
        vim.api.nvim_set_hl(0, group, opts)
      end
    end

  end
}
