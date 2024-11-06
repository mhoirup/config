local M = {}
local terminal = require('utils.terminal')
M.tabstop = vim.api.nvim_get_option_value('tabstop', {})

function M.codeblock_as_table(block_start, block_end)
  return vim.api.nvim_buf_get_lines(0, block_start-1, block_end or block_start, false)
end

function M.line_is_indented(line_number)
  line_number = line_number > vim.fn.line('$') and vim.fn.line('$') or line_number
  local line = M.codeblock_as_table(line_number)
  return string.sub(line[1], 1, M.tabstop) == string.rep(' ', M.tabstop)
end

function M.find_codeblock_bounds(block_check)
  block_check = block_check or true
  local cursor_pos, still_on_block = vim.api.nvim_win_get_cursor(0), true
  local current_line = vim.fn.line('.')
  local is_whitespace_end, is_buffer_end, is_block_end
  -- Initializa the bounds array - without the checks, it just returns the current line number (x2)
  local bounds = { block_start = current_line, block_end = current_line }
  if block_check and (M.line_is_indented(current_line) or M.line_is_indented(current_line + 1)) then
    -- Looped procedure to find the end of the block:
    -- - Move down one paragraph and check if the line is empty and the preceding is indented: `whitespace_end`
    -- - Check if the current line number equals the max line number of the buffer: `buffer_end`
    -- - Move up on line and check if current line isn't indented and the preceding line is: `block_end`
    -- - If either of the above three checks are true, we switch `still_on_block`
    while still_on_block do
      vim.api.nvim_feedkeys('}', 'x', false)
      current_line = vim.fn.line('.')
      is_whitespace_end = M.codeblock_as_table(current_line)[1] == '' and M.line_is_indented(current_line-1)
      is_buffer_end = current_line == vim.fn.line('$')
      vim.api.nvim_feedkeys('k', 'x', false)
      current_line = vim.fn.line('.')
      is_block_end = not M.line_is_indented(current_line) and M.line_is_indented(current_line-1)
      still_on_block = not (is_whitespace_end or is_buffer_end or is_block_end)
    end
    -- Store the current line number and reset the cursor position
    bounds.block_end = current_line
    vim.api.nvim_win_set_cursor(0, cursor_pos)
    current_line = vim.fn.line('.')
    -- Looped procedure to find the end of the block:
    -- - Move up one paragraph, and down one line, and check if the current line is indented
    while M.line_is_indented(current_line) do
      vim.api.nvim_feedkeys('{j', 'x', false)
      current_line = vim.fn.line('.')
    end
    bounds.block_start = current_line
    vim.api.nvim_win_set_cursor(0, cursor_pos)
  end
  return bounds
end

function M.send_code(channel)
  local bounds = M.find_codeblock_bounds()
  local lines = M.codeblock_as_table(bounds.block_start, bounds.block_end)
  for index, line in ipairs(lines) do
    vim.api.nvim_chan_send(channel, line .. '\n')
    if vim.bo.filetype == 'python' and #lines > 1 and index == #lines then
      vim.api.nvim_chan_send(channel, '\n')
    end
  end
  terminal.scroll_to_end()
end

function M.send_word_under_cursor(input, channel)
  local cword = vim.fn.expandcmd('<cword>')
  input, _ = input:gsub('%<cword%>', cword)
  vim.api.nvim_chan_send(channel, input .. '\n')
end

return M
