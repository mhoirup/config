vim.api.nvim_create_user_command(
  'TermNew',
  function (opts)
    local terminal = require('utils.terminal')
    local b = terminal.create_terminal(opts.args)
    local win = terminal.term_win()
    if win then
      vim.api.nvim_win_set_buf(win, b)
    else
      terminal.toggle_terminal()
    end
  end,
  { nargs = '?' }
)
