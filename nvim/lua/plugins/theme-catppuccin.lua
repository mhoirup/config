return {
  'catppuccin/nvim',
  priority = 1000,
  config = function ()
    function _G.theme_catppuccin_mocha()
      require('catppuccin').setup {
        flavor = 'mocha'
      }

      vim.cmd.colorscheme 'catppuccin-mocha'
      _G.dark_mode = true

      _G.colors = {
        background = '#1e1e2f',
        background_darker = '#181826',
        background_ligher = '#2a2b3d',
        blue = '#89b4fb',
        comments = '#4c566a',
        dimmed = '#2C323D',
        cyan = '#89dceb',
        green = '#a6e3a2',
        lines = '#313245',
        orange = '#fab388',
        orange_lighter = '#f2cdce',
        purple = '#cba6f8',
        purple_lighter = '#b4beff',
        red = '#f38ba9',
        white = '#cdd6f5',
        yellow = '#f9e2b0',
      }

      local highlights = {
        ['@ibl.indent.char.1'] = { fg = _G.colors.dimmed },
        ['@attribute.builtin.python'] = { fg = _G.colors.yellow, bold = false },
        ['@attribute.python'] = { fg = _G.colors.yellow, bold = false },
        ['@boolean'] = { fg = _G.colors.orange, bold = true },
        ['@class.python'] = { fg = _G.colors.blue, bold = true },
        ['@constant.builtin.lua'] = { fg = _G.colors.orange, bold = true },
        ['@constant.builtin.r'] = { fg = _G.colors.orange, bold = true },
        ['@constant.lua'] = { fg = _G.colors.white },
        ['@constant.python'] = { fg = _G.colors.orange, bold = true },
        ['@constructor.python'] = { link = 'Function' },
        ['@function.builtin'] = { fg = _G.colors.blue, bold = true },
        ['@keyword'] = { fg = _G.colors.purple, bold = true, italic = true },
        ['@keyword.conditional'] = { fg = _G.colors.purple, bold = true, italic = true },
        ['@keyword.exception.python'] = { fg = _G.colors.purple, bold = true, italic = false },
        ['@keyword.function'] = { fg = _G.colors.purple, bold = true, italic = true },
        ['@keyword.function.r'] = { fg = _G.colors.purple, bold = true, italic = false },
        ['@keyword.import'] = { fg = _G.colors.purple, bold = true, italic = true },
        ['@keyword.local.lua'] = { fg = _G.colors.purple, bold = true, italic = false },
        ['tmuxCommands'] = { fg = _G.colors.purple, bold = true, italic = false },
        ['@keyword.lua'] = { fg = _G.colors.purple, bold = true, italic = false },
        ['@keyword.operator'] = { fg = _G.colors.purple, bold = true, italic = true },
        ['@keyword.operator.sql'] = { fg = _G.colors.purple, bold = true, italic = false },
        ['@keyword.repeat'] = { fg = _G.colors.purple, bold = true, italic = true },
        ['@keyword.return'] = { fg = _G.colors.purple, bold = true, italic = true },
        ['@keyword.return.r'] = { fg = _G.colors.purple, bold = true, italic = false },
        ['@keyword.sql'] = { fg = _G.colors.purple, bold = true, italic = false },
        ['@keyword.type.python'] = { fg = _G.colors.purple, bold = true, italic = false },
        ['@keyword.vim'] = { fg = _G.colors.purple, bold = true, italic = false },
        ['@markup.raw.block.markdown'] = { fg = 'NONE' },
        ['@module.builtin.lua'] = { fg = _G.colors.red },
        ['@module.python'] = { fg = _G.colors.red },
        ['@module.r'] = { fg = _G.colors.red },
        ['@named.constant.python'] = { fg = 'NONE', bold = true },
        ['@named.constant.r'] = { fg = _G.colors.yellow, bold = true },
        ['@namespace.python'] = { fg = _G.colors.red },
        ['@namespace.r'] = { fg = _G.colors.red },
        ['@string.escape'] = { fg = _G.colors.yellow },
        ['@string.regexp'] = { fg = _G.colors.yellow },
        ['@type.builtin.python'] = { fg = _G.colors.blue, bold = true },
        ['@type.python'] = { fg = 'NONE' },
        ['@type.sql'] = { fg = 'NONE' },
        ['@variable'] = { fg = 'NONE' },
        ['@variable.member.sql'] = { fg = _G.colors.white },
        ['@variable.parameter'] = { fg = 'NONE' },
        ['@variable.throwaway.lua'] = { fg = _G.colors.comments },
        ['CmpBorder'] = { fg = _G.colors.lines },
        ['CmpItemAbbr'] = { fg = _G.colors.white },
        ['CmpItemAbbrDefault'] = { fg = _G.colors.white },
        ['CmpItemAbbrMatch'] = { fg = _G.colors.white },
        ['CmpItemAbbrMatchFuzzy'] = { fg = _G.colors.white},
        ['CmpItemKindFile'] = { fg = _G.colors.yellow },
        ['CmpItemKindFunction'] = { fg = _G.colors.blue },
        ['CmpItemKindClass'] = { fg = _G.colors.blue },
        ['CmpItemKindKeyword'] = { fg = _G.colors.purple },
        ['CmpItemKindModule'] = { fg = _G.colors.red },
        ['CmpItemKindSnippet'] = { fg = _G.colors.orange },
        ['CmpItemKindText'] = { fg = _G.colors.white },
        ['CmpItemKindVariable'] = { fg = _G.colors.white },
        ['CmpSelection'] = { fg = 'NONE', bg = _G.colors.background_ligher },
        ['Comment'] = { fg = _G.colors.comments, italic = false },
        ['CursorLine'] = { bg = _G.colors.background_ligher },
        ['CursorLineNr'] = { fg = _G.colors.white, bold = true },
        ['DiagnosticCode'] = { fg = _G.colors.purple, bold = true },
        ['DiagnosticType'] = { fg = _G.colors.blue, bold = true },
        ['DiagnosticUnnecessary'] = { fg = 'NONE' },
        ['DiagnosticVirtualTextError'] = { fg = _G.colors.red, bg = '#32283b' },
        ['DiagnosticVirtualTextHint'] = { fg = '#94e2d6', bg = '#29313f' },
        ['DiagnosticVirtualTextInfo'] = { fg = _G.colors.cyan, bg = '#283041' },
        ['DiagnosticVirtualTextWarn'] = { fg = _G.colors.yellow, bg = '#33313b' },
        ['DiagnosticsCount'] = { fg = _G.colors.orange, bold = true },
        ['ErrorMsg'] = { fg = _G.colors.red },
        ['FloatBorder'] = { fg = _G.colors.lines },
        ['Function'] = { fg = _G.colors.blue, bold = true },
        ['Keyword'] = { fg = _G.colors.purple, bold = true, italic = true },
        ['LineNr'] = { fg = _G.colors.comments },
        ['NormalFloat'] = { link = 'Normal' },
        ['STFileName'] = { bg = _G.colors.background_ligher },
        ['Search'] = { link = 'CurSearch' },
        ['SnippetTabStop'] = { bg = 'NONE' },
        ['StatusLine'] = { fg = _G.colors.white, bg = _G.colors.background_ligher },
        ['TelescopeBorder'] = { fg = _G.colors.lines },
        ['TelescopeDiagnosticType'] = { fg = _G.colors.purple_lighter },
        ['TelescopeMatching'] = { fg = 'NONE', link = 'NONE' },
        ['TelescopePromptCounter'] = { fg = _G.colors.comments },
        ['TelescopePromptPrefix'] = { fg = _G.colors.comments },
        ['TelescopeSelection'] = { fg = 'NONE', bg = _G.colors.background_ligher },
        ['TelescopeTermProgram'] = { fg = _G.colors.purple_lighter },
        ['TelescopeTitle'] = { fg = _G.colors.black, bg = _G.colors.white, bold = true },
        ['TermCursorNC'] = { fg = 'NONE', bg = 'NONE' },
        ['WhichKeyDesc'] = { fg = _G.colors.white },
        ['WhichKey'] = { fg = _G.colors.blue, bold = false, italic = false },
        ['WhichKeyGroup'] = { fg = _G.colors.purple, bold = true, italic = false },
        ['WhichKeyNormal'] = { bg = _G.colors.black },
        ['WinSeparator'] = { fg = _G.colors.lines },
        ['pythonREPLInput'] = { fg = _G.colors.comments },
        ['pythonREPLPrompt'] = { fg = _G.colors.blue },
        ['pythonREPLPromptContinued'] = { fg = _G.colors.blue },
        ['rREPLInput'] = { fg = _G.colors.comments },
        ['rREPLOutputNonText'] = { fg = _G.colors.comments },
        ['rREPLPrompt'] = { fg = _G.colors.blue },
        ['rREPLPromptContinued'] = { fg = _G.colors.blue },
        ['sqlKeyword'] = { fg = _G.colors.purple, bold = true, italic = false },
        ['sqlOperator'] = { fg = 'NONE' },
        ['zshCommands'] = { fg = _G.colors.purple, bold = true, italic = false },
        ['zshConditional'] = { fg = _G.colors.purple, bold = true, italic = true },
        ['SearchNormal'] = { bg = _G.colors.background_darker },
        ['SearchButton'] = { fg = _G.colors.purple },
        ['StatusLineCoordinate'] = { fg = _G.colors.purple, bg = _G.colors.background_ligher },
        ['NvimTreeNormal'] = { link = 'Normal' },
        ['NvimTreeIndentMarker'] = { link = '@ibl.indent.char.1' },
        ['NvimTreeWinSeparator'] = { link = 'WinSeparator' },
        ['StlNumber'] = { fg = _G.colors.orange, bg = _G.colors.background_ligher },
        ['StlDimmed'] = { fg = _G.colors.comments, bg = _G.colors.background_ligher },
        ['StlBreak'] = { fg = _G.colors.background, bg = _G.colors.background_ligher },
        ['StlBufAlt'] = { fg = _G.colors.orange_lighter, bg = _G.colors.background_ligher },
      }

      for group, opts in pairs(highlights) do
        vim.api.nvim_set_hl(0, group, opts)
      end
    end

  end
}
