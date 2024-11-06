vim.g.mapleader = 'æ'

local keymaps = {
  { mode = 'i', lhs = '<C-h>', rhs = '<cmd>lua require("utils.misc").delim_escape("behind")<CR><Left>' },
  { mode = 'i', lhs = '<C-l>', rhs = '<cmd>lua require("utils.misc").delim_escape("ahead")<CR><Right>' },
  { mode = 'i', lhs = '<M-Backspace>' , rhs = '<Esc>"_ciw<Backspace>' },
  { mode = 'i', lhs = '<M-Left>', rhs = '<C-o>b' },
  { mode = 'i', lhs = '<M-Right>', rhs = '<C-o>w' },
  { mode = 'i', lhs = '<S-Backspace>', rhs = '<Esc>lc^' },
  { mode = 'i', lhs = '<S-Left>', rhs = '<C-o>^' },
  { mode = 'i', lhs = '<S-Right>', rhs = '<C-o>$' },
  { mode = 'n', lhs = '*', rhs = '*``' },
  { mode = 'n', lhs = '+', rhs = '<S-o><ESC>j' },
  { mode = 'n', lhs = '<BS>', rhs = ':b#<CR>' },
  { mode = 'n', lhs = '<C-+>', rhs = function() require('telescope.builtin').help_tags({prompt_title = 'Help Files'}) end },
  { mode = 'n', lhs = '<C-b>', rhs = ':NvimTreeFindFileToggle<CR>' },
  { mode = 'n', lhs = '<C-d>', rhs = function() require('utils.telescope-pickers.diagnostics').diagnostics() end },
  { mode = 'n', lhs = '<C-f>', rhs = function() require('telescope.builtin').find_files({prompt_title = 'Open File', hidden=true}) end },
  { mode = 'n', lhs = '<C-j>', rhs = function() require('utils.terminal').toggle_terminal() end },
  { mode = 'n', lhs = '<C-m>', rhs = ':Inspect<CR>' },
  { mode = 'n', lhs = '<C-p>', rhs = function() require('telescope.builtin').builtin({prompt_title = 'Choose Picker'}) end },
  { mode = 'n', lhs = '<Esc>', rhs = ':noh<CR>' },
  { mode = 'n', lhs = '<C-l>', rhs = ':lua require("utils.misc").bmove("next")<CR>' },
  { mode = 'n', lhs = '<C-h>', rhs = ':lua require("utils.misc").bmove("prev")<CR>' },
  { mode = 'n', lhs = '<M-Down>', rhs = function() require('smart-splits').resize_down(1) end },
  { mode = 'n', lhs = '<M-Left>', rhs = function() require('smart-splits').resize_left(1) end },
  { mode = 'n', lhs = '<M-Right>', rhs = function() require('smart-splits').resize_right(1) end },
  { mode = 'n', lhs = '<M-Up>' , rhs = function() require('smart-splits').resize_up(1) end },
  { mode = 'n', lhs = '<S-Backspace>' , rhs = function() require('utils.telescope-pickers.buffers').buffers() end },
  { mode = 'n', lhs = '<S-Tab>', rhs = '<<' },
  { mode = 'n', lhs = '<S-h>', rhs = '{' },
  { mode = 'n', lhs = '<S-j>', rhs = '10j' },
  { mode = 'n', lhs = '<S-k>', rhs = '10k' },
  { mode = 'n', lhs = '<S-l>', rhs = '}' },
  { mode = 'n', lhs = '<Tab>', rhs = '>>' },
  { mode = 'n', lhs = '<leader>d', rhs = function() require('utils.telescope-pickers.cwd-switcher').dir_switcher() end, desc = 'Change working directory' },
  { mode = 'n', lhs = '<leader>z', rhs = function() require('utils.misc').window_adjust_width() end, desc = 'Adjust window width' },
  { mode = 'n', lhs = '<leader>t', rhs = function() require('utils.telescope-pickers.terminals').terminals() end, desc = 'Active terminals' },
  { mode = 'n', lhs = 'm', rhs = 'q' },
  { mode = 'n', lhs = 'q', rhs = function() require('utils.misc').close() end },
  { mode = 't', lhs = '<Esc>', rhs = [[<C-\><C-n>]] },
  { mode = 'v', lhs = '<S-Tab>', rhs = '<gv' },
  { mode = 'v', lhs = '<S-j>', rhs = '10j' },
  { mode = 'v', lhs = '<S-k>', rhs = '10k' },
  { mode = 'v', lhs = '<Tab>', rhs = '>gv' },
}

for _, keymap in ipairs(keymaps) do
  local opts = { noremap = true, silent = true }
  if keymap.desc then
    opts.desc = keymap.desc
  end
  vim.keymap.set(keymap.mode, keymap.lhs, keymap.rhs, opts)
end
