local keymaps = {
  ['<S-Backspace>'] = function() require('utils.telescope-pickers.terminals').terminals() end,
  -- ['<leader>t']     = function() require('utils.telescope-pickers.buffers').buffers() end,
  ['q']             = function() require('utils.terminal').toggle_terminal() end,
}

for key, command in pairs(keymaps) do
  vim.keymap.set('n', key, command, { noremap=true, silent=true, buffer=true })
end

vim.api.nvim_set_option_value('number', false, { scope='local' })
vim.api.nvim_set_option_value('signcolumn', 'no', { scope='local' })
