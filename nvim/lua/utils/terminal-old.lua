local M = {}

function M.active_terminals()
  local terminal_buffers = {}
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    local filetype = vim.api.nvim_get_option_value('filetype', {buf=b})
    if filetype == 'terminal' then
      table.insert(terminal_buffers, b)
    end
  end
  return terminal_buffers
end

function M.terminal_mru()
  local bufnr_most_recent, timestamp = _, 0
  local terminals = M.active_terminals()
  if #terminals > 0 then
    for _, bufnr in ipairs(terminals) do
      local b_timestamp = vim.api.nvim_buf_get_var(bufnr, 'last_toggle_ms')
      if b_timestamp > timestamp then
        bufnr_most_recent = bufnr
        timestamp = b_timestamp
      end
    end
  end
  return bufnr_most_recent
end

function M.update_timestamp(bufnr)
  ---@diagnostic disable-next-line: undefined-field
  local s, ms = vim.uv.gettimeofday()
  vim.api.nvim_buf_set_var(bufnr, 'last_toggle_ms', (s * 1000000) + ms)
end

function M.term_win()
  local term_win
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local bufnr = vim.api.nvim_win_get_buf(win)
    local filetype = vim.api.nvim_get_option_value('filetype', {buf=bufnr})
    if filetype == 'terminal' then
      term_win = win
      break
    end
  end
  return term_win
end

function M.create_terminal(command)
  command = command or ''
  local b = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_call(b, function () vim.cmd('terminal ' .. command) end)
  vim.api.nvim_set_option_value('buflisted', false, {buf=b})
  M.update_timestamp(b)
  vim.api.nvim_set_option_value('filetype', 'terminal', {buf=b})
  vim.api.nvim_create_autocmd({ 'BufWinEnter', 'BufHidden' }, {
    buffer = b,
    callback = function ()
      local bufnr = vim.api.nvim_get_current_buf()
      M.update_timestamp(bufnr)
    end,
  })
  vim.api.nvim_create_autocmd({ 'BufDelete', 'BufWipeout' }, {
    buffer = b,
    callback = function ()
      local listed_buffers = vim.api.nvim_list_bufs()
      for _, bufnr in ipairs(listed_buffers) do
        for _, variable in ipairs({ 'term_channel', 'repl_channel' }) do
          local variable_present, _ = pcall(vim.api.nvim_buf_get_var, bufnr, variable)
          if variable_present then
            vim.api.nvim_buf_del_var(bufnr, variable)
          end
        end
      end
    end,
  })
  return b
end

function M.toggle_terminal(command)
  command = command or ''
  local bufnr
  local win = M.term_win()
  if #M.active_terminals() == 0 or command ~= '' then
    bufnr = M.create_terminal(command)
  end
  bufnr = bufnr or M.terminal_mru()
  if not win then
    local height = math.floor(vim.api.nvim_win_get_height(0) * 0.3)
    vim.api.nvim_command('belowright split')
    vim.api.nvim_set_current_buf(bufnr)
    vim.api.nvim_set_option_value('number', false, {scope='local'})
    vim.api.nvim_set_option_value('signcolumn', 'no', {scope='local'})
    vim.api.nvim_win_set_height(0, height)
    vim.api.nvim_command('wincmd p')
  else
    vim.api.nvim_win_close(win, true)
  end
  return bufnr
end

function M.link_terminal(other_b, link_name)
  local current_b = vim.api.nvim_get_current_buf()
  local filetype = vim.api.nvim_get_option_value('filetype', {buf=other_b})
  if filetype ~= 'terminal' and vim.bo.filetype ~= 'terminal' then
    return
  end
  local bufnr = vim.bo.filetype == 'terminal' and current_b or other_b
  vim.api.nvim_buf_set_var(
    vim.bo.filetype ~= 'terminal' and current_b or other_b,
    link_name,
    vim.api.nvim_get_option_value('channel', {buf=bufnr})
  )
end

function M.force_down_scroll()
  local terminial_window = M.term_win()
  if terminial_window then
    local buffer_window = vim.api.nvim_get_current_win()
    vim.api.nvim_set_current_win(terminial_window)
    local n = vim.api.nvim_buf_line_count(0)
    vim.api.nvim_win_set_cursor(terminial_window, {n, 0})
    vim.api.nvim_set_current_win(buffer_window)
  end
end

return M
