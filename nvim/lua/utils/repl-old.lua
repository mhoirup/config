local M = {}
local api = vim.api

M.commands = {
  r = 'R --silent --vanilla',
  python = 'python -q',
}

function M.create_console()
  local ok, _ = pcall(api.nvim_buf_get_var, 0, 'console_channel')
  local filetype = vim.bo.filetype
  if ok then
    print('Console already active for this buffer')
    return
  end
  local buffers = {
    console = api.nvim_create_buf(true, false),
    script = vim.fn.bufnr('%')
  }
  local height = math.floor(vim.api.nvim_win_get_height(0) * 0.3)
  api.nvim_open_win(buffers.console, true, { split='below', win=0, height=height })
  vim.cmd('terminal ' .. M.commands[filetype])
  local channel = vim.api.nvim_get_option_value('channel', {})
  api.nvim_buf_set_var(buffers.script, 'console_channel', channel)
  api.nvim_buf_set_var(buffers.script, 'console_buffer', buffers.console)
  api.nvim_buf_set_name(0, filetype:gsub("^%l", string.upper) .. ' Console')
  api.nvim_set_option_value('number', false, {})
  api.nvim_create_autocmd('BufDelete', {
    buffer = buffers.console,
    callback = function ()
      vim.api.nvim_buf_del_var(buffers.script, 'console_channel')
      vim.api.nvim_buf_del_var(buffers.script, 'console_buffer')
    end,
  })
  vim.api.nvim_set_option_value('filetype', 'repl', {scope='local'})
  vim.cmd('set syntax=' .. filetype .. '_repl')
  vim.cmd('wincmd p')
end

M.utils = {}

function M.utils.get_lines(_start, _end)
  local lines = api.nvim_buf_get_lines(0, _start - 1, _end or _start, false)
  return (_start == _end) and lines[1] or lines
end

function M.utils.is_indent(line_no)
  local line, tabstop = M.utils.get_lines(line_no), api.nvim_get_option_value('tabstop', {})
  if type(line) == 'string' then
    return string.sub(line, 1, tabstop) == string.rep(' ', tabstop)
  end
end

function M.utils.block_end()
  local cursor, on_block, line = api.nvim_win_get_cursor(0), true, nil
  while on_block do
    api.nvim_feedkeys('}', 'x', false)
    line = vim.fn.line('.')
    if M.utils.get_lines(line) == '' and M.utils.is_indent(line - 1) then
      on_block, line = false, line - 1
    elseif vim.fn.line('.') == vim.fn.line('$') then
      on_block = false
    else
      vim.api.nvim_feedkeys('k', 'x', false)
      line = vim.fn.line('.')
      on_block = M.utils.is_indent(line)
    end
  end
  api.nvim_win_set_cursor(0, cursor)
  return line
end

function M.utils.block_start()
  local cursor = vim.api.nvim_win_get_cursor(0)
end

-- function M.find_block_start()
--   local original_position = vim.api.nvim_win_get_cursor(0)
--   vim.api.nvim_feedkeys('{j', 'x', false)
--   local line = vim.fn.line('.')
--   while M.is_indented(line) do
--     vim.api.nvim_feedkeys('{j', 'x', false)
--     line = vim.fn.line('.')
--   end
--   vim.api.nvim_win_set_cursor(0, original_position)
--   return line
-- end






function M.lines_as_strings(line_block_start, line_block_end)
  line_block_end = line_block_end or line_block_start
  local lines = vim.api.nvim_buf_get_lines(0, line_block_start - 1, line_block_end, false)
  return (line_block_start == line_block_end) and lines[1] or lines
end

function M.is_indented(line_no)
  local line = M.lines_as_strings(line_no)
  local editor_tabstop = vim.api.nvim_get_option_value('tabstop', {})
  return string.sub(line, 1, editor_tabstop) == string.rep(' ', editor_tabstop)
end

-- function M.is_last_line()
--   return vim.fn.line('.') == vim.fn.line('$')
-- end

function M.python_block_end(line)
  local is_empty_line = M.lines_as_strings(line) == ''
  local previous_line_is_indented = M.is_indented(line - 1)
  return is_empty_line and previous_line_is_indented
end

function M.find_block_end()
  local original_cursor_position = vim.api.nvim_win_get_cursor(0)
  local still_on_block, line = true, nil
  while still_on_block do
    vim.api.nvim_feedkeys('}', 'x', false)
    line = vim.fn.line('.')
    if M.python_block_end(line) then
      still_on_block = false
      line = line - 1
    -- elseif M.is_last_line() then
    elseif vim.fn.line('.') == vim.fn.line('$') then
      still_on_block = false
    else
      vim.api.nvim_feedkeys('k', 'x', false)
      line = vim.fn.line('.')
      still_on_block = M.is_indented(line)
    end
  end
  vim.api.nvim_win_set_cursor(0, original_cursor_position)
  return line
end

function M.find_block_start()
  local original_position = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_feedkeys('{j', 'x', false)
  local line = vim.fn.line('.')
  while M.is_indented(line) do
    vim.api.nvim_feedkeys('{j', 'x', false)
    line = vim.fn.line('.')
  end
  vim.api.nvim_win_set_cursor(0, original_position)
  return line
end

function M.is_block(line)
  return M.is_indented(line) or M.is_indented(line + 1)
end

function M.channel_send(content)
  local channel = vim.api.nvim_buf_get_var(0, 'console_channel')
  if type(content) == 'table' then
    for _, line in ipairs(content) do
      vim.api.nvim_chan_send(channel, line .. '\n')
    end
    if vim.bo.filetype == 'python' then
      vim.api.nvim_chan_send(channel, '\n')
    end
  else
    vim.api.nvim_chan_send(channel, content .. '\n')
  end
end

function M.sleep(seconds)
  local sleep_end = tonumber(os.clock() + seconds)
  while (os.clock() < sleep_end) do end
end

function M.send_code_to_console()
  local channel_active, _ = pcall(vim.api.nvim_buf_get_var, 0, 'console_channel')
  if not channel_active then
    M.create_console()
    M.sleep(1)
  end
  local line, code, cursor_position = vim.fn.line('.'), nil, vim.fn.line('.')
  if M.is_block(line) then
    local block_end = M.find_block_end()
    code = M.lines_as_strings(M.find_block_start(), block_end)
    cursor_position = block_end + 1
  else
    code = M.lines_as_strings(line)
  end
  M.channel_send(code)
  vim.api.nvim_command('' .. cursor_position)
  M.go_to_next_nonempty_line()
end

function M.send_until_cursor()
  local line_no = vim.fn.line('.')
  if M.is_block(line_no) then
    line_no = M.find_block_end()
  end
  local code = M.lines_as_strings(1, line_no)
  M.channel_send(code)
  vim.api.nvim_command(tostring(line_no))
end

function M.send_word_under_cursor(command)
  local cword = vim.fn.expandcmd('<cword>')
  command, _ = command:gsub('%<cword%>', cword)
  M.channel_send(command)
end

function M.send_custom()
  local command = vim.fn.input('')
  M.channel_send(command)
end

function M.go_to_next_nonempty_line()
  local line_no, line_content = vim.fn.line('.'), ''
  while line_content == '' do
    line_no = line_no + 1
    line_content = M.lines_as_strings(line_no)
  end
  vim.api.nvim_command(tostring(line_no))
end

return M
