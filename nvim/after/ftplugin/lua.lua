local keymaps = {
  { mode = 'n', lhs = '<leader>r', rhs = ':up|luafile %<CR>', desc = 'Source file'}
}

for _, keymap in ipairs(keymaps) do
  local opts = { noremap = true, silent = true, buffer = true }
  if keymap.desc then
    opts.desc = keymap.desc
  end
  vim.keymap.set(keymap.mode, keymap.lhs, keymap.rhs, opts)
end
