local M = {}
local console = require('utils.console')
local terminal = require('utils.terminal')
local whichkey = require('which-key')

M.console_command = 'python3 -q'
M.run_command = 'python'

whichkey.add {
  { '<leader>c', group = 'Console Operations' },
  { '<leader>cw', function () console.send_word_under_cursor('<cword>', vim.b.console) end, desc = 'View Object' },
  { '<leader>cc', function () M.create_console() end, desc = 'Create Console' },
  { '<leader>r', function () M.run_file() end, desc = 'Run Script' },
}

local opts = { noremap = true, silent = true }
local keymaps = {
  { mode = 'n', lhs = '<Space>', rhs = function () console.send_code(vim.bo[vim.b.console].channel) end },
}

for _, keymap in ipairs(keymaps) do
  vim.keymap.set(keymap.mode, keymap.lhs, keymap.rhs, opts)
end

function M.init_terminal(type, cli_program)
  if not vim.b[type] or vim.fn.bufexists(vim.b[type]) == 0 then
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

