local M = {}

local function get_ts()
  ---@diagnostic disable-next-line: undefined-field
  local s, ms = vim.uv.gettimeofday()
  return (s * 1000000) + ms
end

function M.create_terminal(cli_program)
  cli_program = cli_program or ''
  local term_b = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_call(term_b, function () vim.cmd('terminal ' .. cli_program) end)
  -- vim.api.nvim_set_option_value('buflisted', false, {buf=term_b})
  vim.bo[term_b].buflisted = false
  vim.bo[term_b].filetype = 'terminal'
  vim.b[term_b].cli_program = cli_program
  vim.b[term_b].linked_buffers = {}
  vim.b[term_b].last_toggle = get_ts()
  _G.stlbufnr = vim.fn.bufnr('%')

  vim.api.nvim_create_autocmd({ 'BufWinEnter', 'TextChangedI', 'TextChangedT' }, {
    buffer = term_b,
    callback = function ()
      vim.b[term_b].last_toggle = get_ts()
    end,
  })

  vim.api.nvim_create_autocmd({ 'BufDelete', 'BufWipeout' }, {
    buffer = term_b,
    callback = function ()
      local links = vim.b[term_b].linked_buffers
      for _, script_b in ipairs(links) do
        local linked_terminals = vim.b[script_b].linked_terminals
        for index, terminal in ipairs(linked_terminals) do
          if terminal.bufnr == term_b then
            table.remove(linked_terminals, index)
          end
        end
        vim.b[script_b].linked_terminals = linked_terminals
      end
    end,
  })

  return term_b
end

function M.link_terminal(this_b, term_b)
  this_b = type(this_b) == 'number' and this_b or vim.fn.bufnr('%')
  local has_links, links = pcall(vim.api.nvim_buf_get_var, this_b, 'linked_terminals')
  links = has_links and links or {}
  table.insert(links, {
    bufnr = term_b,
    cli_program = vim.api.nvim_buf_get_var(term_b, 'cli_program'),
    channel = vim.bo[term_b].channel
  })
  vim.b[this_b].linked_terminals = links
  local b_links = vim.b[term_b].linked_buffers
  table.insert(b_links, this_b)
  vim.b[term_b].linked_buffers = b_links
end

function M.active_terminals()
  local terminals = {}
  for _, nvim_b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[nvim_b].filetype == 'terminal' then
      table.insert(terminals, nvim_b)
    end
  end
  return terminals
end

function M.terminal_window()
  for _, window in ipairs(vim.api.nvim_list_wins()) do
    if vim.bo[vim.api.nvim_win_get_buf(window)].filetype == 'terminal' then
      return window
    end
  end
end

function M.open_terminal(term_b)
  local terminal_window = M.terminal_window()
  if terminal_window then
    vim.api.nvim_win_set_buf(terminal_window, term_b)
    return
  end
  vim.api.nvim_command('belowright split|wincmd J')
  vim.cmd [[let &stc = ' ']]
  -- vim.api.nvim_command('belowright split')
  vim.api.nvim_win_set_buf(0, term_b)
  vim.api.nvim_win_set_height(0, math.floor(vim.api.nvim_list_uis()[1].height * 0.3))
  vim.api.nvim_set_option_value('number', false, { scope='local' })
  vim.api.nvim_set_option_value('signcolumn', 'no', { scope='local' })
  vim.api.nvim_command('wincmd p')
end

function M.toggle_terminal()
  local terminal_window = M.terminal_window()
  local active_terminals = M.active_terminals()
  local term_b = nil

  if not terminal_window then
    if #active_terminals == 0 then
      term_b = M.create_terminal()
    end
    if not term_b then
      local last_toggle_all = 0
      for _, b in ipairs(active_terminals) do
        local b_last_toggle = vim.b[b].last_toggle
        last_toggle_all = math.max(last_toggle_all, b_last_toggle)
        term_b = b_last_toggle >= last_toggle_all and b or term_b
      end
    end
    M.open_terminal(term_b)
    return
  end
  vim.api.nvim_win_close(terminal_window, true)
end

function M.scroll_to_end()
  local term_window = M.terminal_window()
  if term_window then
    local line_count, _ = vim.fn.line('$', term_window)
    vim.api.nvim_win_set_cursor(term_window, { line_count, 0 })
  end
end

return M
