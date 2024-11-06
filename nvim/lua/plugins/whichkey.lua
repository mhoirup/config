return {
  'folke/which-key.nvim',
  event = 'InsertEnter',
  config = function ()
    local whichkey = require('which-key')

    whichkey.add {
      { '<leader>l', group = 'LSP' },
      { '<leader>lr', function() vim.lsp.buf.rename() end, desc = 'Rename symbol' },
      { '<leader>ld', function() vim.lsp.buf.definition() end, desc = 'Go to definition' },
    }

    whichkey.setup {
      preset = 'classic',
      win = {
        border = 'rounded',
        title = false,
        padding = { 1, 2 }
      },
      icons = {
        breadcrumb = '+',
        separator = ':',
        group = '',
        rules = false,
        mappings = false,
        keys = {
          Up = '<Up>',
          Down = '<Down>',
          Left = '<Left>',
          Right = '<Right>',
          C = '<C>',
          M = '<M>',
          S = '<S>',
          CR = '<CR>',
          Esc = '<Esc>',
          BS = '<BS>',
          Space = '<Space>',
          Tab = '<Tab>',
        }
      }
    }
  end
}
