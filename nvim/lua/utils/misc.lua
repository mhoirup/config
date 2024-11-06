local M = {}
local terminal = require('utils.terminal')

function M.listed_buffers()
  local loaded_buffers, listed_buffers = vim.api.nvim_list_bufs(), {}
  for _, buffer in ipairs(loaded_buffers) do
    if vim.api.nvim_get_option_value('bl', {buf=buffer}) then
      table.insert(listed_buffers, buffer)
    end
  end
  return listed_buffers
end

function M.window_adjust_width()
  local width = vim.api.nvim_win_get_width(0)
  local max_column_length = 0
  local lines = vim.api.nvim_buf_get_lines(0, 0, vim.fn.line('$'), false)
  for _, line in ipairs(lines) do
    local line_n = string.len(line)
    max_column_length = line_n > max_column_length and line_n or max_column_length
  end
  if (max_column_length + 10) > width then
    vim.api.nvim_win_set_width(0, (max_column_length + 11))
  end
end

function M.bmove(direction)
  local this_b, index = vim.fn.bufnr('%'), nil
  local listed = M.listed_buffers()
  for i, b in ipairs(listed) do
    if b == this_b then
      index = i
      break
    end
  end
  index = index + (direction == 'next' and 1 or -1)
  index = index > #listed and 1 or (index == 0 and #listed or index)
  vim.api.nvim_win_set_buf(0, listed[index])
  vim.b[listed[index]].lastused = os.time()
end

function M.close()
  local this_b = vim.fn.bufnr('%')
  if vim.bo.filetype == 'help' or vim.bo.filetype == 'query' then
    vim.api.nvim_command('bdelete')
    return
  end
  -- Simply closes the window, rather than the buffer, if the buffer is open in multiple windows
  if #vim.fn.win_findbuf(this_b) > 1 and vim.api.nvim_win_get_buf(0) == this_b then
    vim.api.nvim_win_close(0, true)
    return
  end
  local any_unfocused = false
  local loaded_buffers = M.listed_buffers()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local win_b = vim.api.nvim_win_get_buf(win)
    if vim.api.nvim_get_option_value('filetype', {buf=win_b}) ~= 'NvimTree' and win_b ~= this_b then
      any_unfocused = true
      break
    end
  end
  if not any_unfocused and #loaded_buffers > 1 then
    vim.api.nvim_command('update')
    local alternative_b = vim.fn.bufnr('#')
    alternative_b = alternative_b > 0 and alternative_b or loaded_buffers[math.random(#loaded_buffers)]
    vim.api.nvim_win_set_buf(0, alternative_b)
    vim.api.nvim_command(this_b .. 'bw!')
  else
    vim.api.nvim_command('up|' .. (#loaded_buffers > 1 and 'bw!' or 'qa!'))
  end
end

function M.delim_escape(direction)
  local escape_ahead = direction == 'ahead'
  local node = require('nvim-treesitter.ts_utils').get_node_at_cursor()
  if node:type() == 'string_content' then
    local row, col
    if escape_ahead then
      row, col = node:end_()
    else
      row, col = node:start()
    end
    vim.api.nvim_win_set_cursor(0, { row + 1, col })
    return
  end
  local brackets = {
    ahead = { ['('] = ')', ['\\['] = '\\]', ['{'] = '}' },
    behind = { [')'] = '(', ['\\]'] = '\\[', ['}'] = '{' }
  }
  local current_line = vim.api.nvim_get_current_line()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local iteration = escape_ahead and { 1, -1 } or { #current_line, 1 }
  for i = cursor[2], iteration[1], iteration[2] do
    local char = string.sub(current_line, i, i)
    char = ((char == ']' or char == '[') and '\\' or '') .. char
    if brackets[direction][char] then
      vim.api.nvim_win_set_cursor(0, { vim.fn.line('.'), i - 1 })
      local flags = (escape_ahead and '' or 'b') .. 'n'
      local open = escape_ahead and char or brackets[direction][char]
      local close = escape_ahead and brackets[direction][char] or char
      ---@diagnostic disable-next-line: redundant-parameter
      local pair_pos = vim.fn.searchpairpos(open, '', close, flags)[2]
      if (escape_ahead and pair_pos > cursor[2]) or (not escape_ahead and pair_pos < cursor[2]) then
        vim.api.nvim_win_set_cursor(0, { vim.fn.line('.'), pair_pos - 1 })
        return
      end
    end
  end
end

return M
