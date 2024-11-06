local M = {}
local utils = require('utils.misc')

function M.hex_colours(hl_group)
  local highlights = vim.api.nvim_get_hl(0, { name=hl_group })
  return {
    fg = highlights.fg and string.format('#%06x', highlights.fg) or nil,
    bg = highlights.bg and string.format('#%06x', highlights.bg) or nil
  }
end

function M.stl_end(side)
  local icon = side == 'left' and '' or ''
  vim.api.nvim_set_hl(0, 'StatusLineEnd', {
    bg = M.hex_colours('Normal').bg,
    fg = M.hex_colours('StatusLine').bg
  })
  return '%#StatusLineEnd#' .. icon .. '%#StatusLine#'
end

function M.coordinates()
  local stl_win = 0
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_get_buf(win) == _G.stlbufnr then
      stl_win = win
      break
    end
  end
  local cursor = vim.api.nvim_win_get_cursor(stl_win)
  local line = (cursor[1] < 9 and '0' or '') .. tostring(cursor[1])
  local col = (cursor[2] < 9 and '0' or '') .. tostring(cursor[2]+1)
  return '%#StatusLineCoordinate#󰆤 ' .. line .. ':' .. col
end

function M.buffers(n_entries)
  local devicons_available, devicons = pcall(require, 'nvim-web-devicons')
  local listed, statusline = utils.listed_buffers(), ''
  if #listed == 1 and vim.fn.bufname(listed[1]) == '' then
    return statusline
  end

  local function format(b, is_last)
    local is_this = b == _G.stlbufnr
    local name, component = vim.fn.bufname(b), ''
    if devicons_available then
      local icon, icon_hl = devicons.get_icon(name, vim.fn.fnamemodify(name, ':e'))
      icon, icon_hl = icon or '', icon_hl or 'DevIconDefault'
      vim.api.nvim_set_hl(0, 'StlFileIcon' .. b, {
        fg = M.hex_colours(is_this and icon_hl or 'StlDimmed').fg,
        bg = M.hex_colours('StatusLine').bg
      })
      component = component .. '%#StlFileIcon' .. b .. '#' .. icon .. ' '
    end
    name = name ~= '' and vim.fn.fnamemodify(name, ':t') or '[unnamed]'
    component = component .. '%#' .. (is_this and 'StatusLine' or 'StlDimmed') .. '#' .. name
    component = component .. (not is_last and ' %#StlBreak#│ ' or '')
    return component
  end
  if #listed > 1 then
    for _ = 1, #listed, 1 do
      if listed[math.max(2, math.floor(n_entries / 2))] == _G.stlbufnr then
        break
      end
      local last_entry = listed[#listed]
      table.remove(listed, #listed)
      table.insert(listed, 1, last_entry)
    end
  end
  n_entries = math.min(n_entries, #listed)
  for index, nvim_b in ipairs(listed) do
    if index <= n_entries then
      statusline = statusline .. format(nvim_b, index == n_entries)
    end
  end
  return statusline
end

function M.bufname()
  local statusline = ''
  local name = vim.fn.bufname(_G.stlbufnr)
  if name ~= '' then
    local devicons_availble, devicons = pcall(require, 'nvim-web-devicons')
    if devicons_availble then
      local icon, highlight = devicons.get_icon(name, vim.fn.fnamemodify(name, ':e'))
      icon, highlight = icon or '', highlight or 'DevIconDefault'
      vim.api.nvim_set_hl(0, 'StlFileIcon', {
        fg = M.hex_colours(highlight).fg,
        bg = M.hex_colours('StatusLine').bg
      })
      statusline = statusline .. '%#StlFileIcon#' .. icon .. '%#StatusLine# '
    end
    statusline = statusline .. './' .. name
  end
  return statusline
end

function M.stl_divider()
  vim.api.nvim_set_hl(0, 'StlDivider', {
    fg = M.hex_colours('Normal').bg,
    bg = M.hex_colours('StatusLine').bg
  })
  return '%#StlDivider# │%#StatusLine# '
end

-- function M.bufname()
--   local bufnr, statusline = M.stlbufnr(), ''
--   local bufname = vim.api.nvim_buf_get_name(bufnr)
--   if bufname ~= '' then
--     -- bufname = string.gsub(bufname, '/Users/me', '~')
--     bufname = string.gsub(bufname, vim.fn.getcwd(), '.')
--     local filetype = vim.api.nvim_get_option_value('filetype', {buf=bufnr})
--     local devicons_availble, devicons = pcall(require, 'nvim-web-devicons')
--     devicons_availble = false
--     if devicons_availble then
--       local icon, icon_hl = devicons.get_icon_by_filetype(filetype, {})
--       if not icon then
--         icon, icon_hl = '', 'DevIconDefault'
--       end
--       vim.api.nvim_set_hl(0, 'StatusLineFileIcon', {
--         fg = M.hex_colours(icon_hl).fg,
--         bg = M.hex_colours('StatusLine').bg
--       })
--       statusline = statusline .. '%#StatusLineFileIcon#' .. icon .. ' '
--     end
--   end
--   return statusline .. '%#StatusLine#'.. bufname
-- end

function M.lsp_active()
  vim.api.nvim_set_hl(0, 'StatusLineLsp', {
    fg = M.hex_colours('Comment').fg,
    bg = M.hex_colours('StatusLine').bg,
  })
  local name = vim.fn.bufname(M.stlbufnr())
  for _, client in ipairs(vim.lsp.get_clients()) do
    if client.attached_buffers[M.stlbufnr()] then
      vim.api.nvim_set_hl(0, 'StatusLineLsp', {
        fg = M.hex_colours('@string.lua').fg,
        bg = M.hex_colours('StatusLine').bg
      })
    end
  end
  return '%#StatusLineLsp#' .. (name ~= '' and 'lsp' or '') .. '%#StatusLine#'
end

function M.status_line()
  return table.concat {
    M.stl_end('left'),
    ' ',
    -- M.buffers(4),
    M.bufname(),
    '%=',
    M.stl_divider(),
    M.coordinates(),
    ' ',
    M.stl_end('right'),
  }
end

return M
