local M = {}
local console = require('utils.console')
local terminal = require('utils.terminal')
local whichkey = require('which-key')

M.console_command = 'R --silent --vanilla'

whichkey.add {
  { '<leader>c', group = 'Console Operations' },
  { '<leader>cw', function () console.send_word_under_cursor('<cword>', vim.bo[vim.b.console].channel) end, desc = 'View Object' },
  { '<leader>ch', function () console.send_word_under_cursor('head(<cword>)', vim.bo[vim.b.console].channel) end, desc = 'Head of dataframe' },
  { '<leader>ct', function () console.send_word_under_cursor('head(<cword>)', vim.bo[vim.b.console].channel) end, desc = 'Tail of dataframe' },
  { '<leader>cg', function () console.send_word_under_cursor('dplyr::glimpse(<cword>)', vim.bo[vim.b.console].channel) end, desc = 'Glimpse dataframe' },
  { '<leader>cs', function () console.send_custom() end, desc = 'Send Custom Command' },
  { '<leader>cc', function () M.create_console() end, desc = 'Create Console' },
}

local opts = { noremap=true, silent=true }
local keymaps = {
  { mode = 'n', lhs = '<Space>', rhs = function () console.send_code(vim.bo[vim.b.console].channel) end },
  { mode = 'i', lhs = '<C-p>', rhs = '<Space>%>%<CR>' },
}

for _, keymap in ipairs(keymaps) do
  vim.keymap.set(keymap.mode, keymap.lhs, keymap.rhs, opts)
end

function M.init_terminal(type, cli_program)
  if not vim.b[type] then
    vim.b[type] = terminal.create_terminal(cli_program)
    terminal.link_terminal(vim.fn.bufnr('%'), vim.b[type])
  end
  local win = terminal.terminal_window()
  if not win then
    terminal.toggle_terminal()
    win = terminal.terminal_window()
  end
  vim.api.nvim_win_set_buf(win, vim.b[type])
end

function M.create_console()
  M.init_terminal('console', M.console_command)
end

function M.run_file()
  M.init_terminal('shell')
  vim.api.nvim_chan_send(
    vim.bo[vim.b.shell].channel,
    M.run_command .. ' ' .. vim.fn.bufname('%') .. '\n'
  )
  terminal.scroll_to_end()
end

-- function M.create_console()
--   if not vim.b.console then
--     local term_b = terminal.create_terminal(M.console_command)
--     terminal.link_terminal(vim.fn.bufnr('%'), term_b)
--     for _, term in ipairs(vim.b.linked_terminals) do
--       if term.cli_program == M.console_command then
--         vim.b[0].console = term.channel
--       end
--     end
--     local window = terminal.terminal_window()
--     if not window then
--       terminal.toggle_terminal()
--       window = terminal.terminal_window()
--     end
--     vim.api.nvim_win_set_buf(window, term_b)
--   end
-- end
