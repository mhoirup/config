local opts = { noremap=true, silent=true, buffer=true}

vim.keymap.set('n', '<S-j>', '<nop>', opts)
vim.keymap.set('n', '<S-k>', '<nop>', opts)
vim.keymap.set('n', '<S-j>', '10j', opts)
vim.keymap.set('n', '<S-k>', '10k', opts)
