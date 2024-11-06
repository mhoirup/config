local M = {}
local entry_display = require('telescope.pickers.entry_display')
local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local conf = require('telescope.config').values
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'
local devicons = require('nvim-web-devicons')
local statusline = require('core.statusline')

function M.split_message(str)
  str = str:gsub('%.$', '')
  local n_delims = string.len(str) - string.len(str:gsub('[\'`"]', ''))
  local indices, index_right_delim = { 1 }, 0
  for _ = 1, n_delims, 1 do
    index_right_delim = str:find('[\'`"]', index_right_delim+1)
    table.insert(indices, index_right_delim)
  end
  table.insert(indices, string.len(str) ~= indices[#indices] and string.len(str) or nil)
  local substrings = {}
  for i = 1, #indices - 1, 1 do
    local x = str:sub(indices[i], indices[i+1]):gsub('[\'`"]', '')
    table.insert(substrings, x)
  end
  for _ = #substrings+1, 4, 1 do table.insert(substrings, ' ') end
  return substrings
end

function M.list_diagnostics()

  local workspace_diagnostics = vim.diagnostic.get(nil, { severity = {1, 2, 3, 4} })
  local digits = 0
  for _, diagnostic in ipairs(workspace_diagnostics) do
    local b_digits = string.len(tostring(diagnostic.bufnr))
    digits = b_digits > digits and b_digits or digits
  end

  local results, type_hl, message_len = {}, { 'Error', 'Warn', 'Hint', 'Info' }, 0
  for _, diagnostic in ipairs(workspace_diagnostics) do
    if vim.api.nvim_get_option_value('bl', {buf=diagnostic.bufnr}) then
      local entry = {}
      local handle_len = string.len(tostring(diagnostic.bufnr))
      entry.padding = string.rep(' ', digits - handle_len)
      entry.bufnr = diagnostic.bufnr
      entry.bufname = vim.fn.fnamemodify(vim.fn.bufname(diagnostic.bufnr), ':t')
      entry.filetype = vim.api.nvim_get_option_value('filetype', {buf=diagnostic.bufnr})
      entry.sign = '●'
      entry.sign_hl = 'DiagnosticSign' .. type_hl[diagnostic.severity]
      entry.severity = string.lower(type_hl[diagnostic.severity])
      entry.code = diagnostic.code or ''
      entry.lnum = diagnostic.lnum
      entry.col = diagnostic.col
      entry.icon, entry.icon_hl = devicons.get_icon_by_filetype(entry.filetype)
      local messages = {}
      for sub_message in string.gmatch(diagnostic.message, '([^\n]+)') do
        table.insert(messages, sub_message)
      end
      local substrings = M.split_message(messages[1])
      entry.message1 = substrings[1]
      entry.message2 = substrings[2]
      entry.message3 = substrings[3]
      entry.message4 = substrings[4]
      entry.message0 = entry.message1..entry.message2..entry.message3..entry.message4
      entry.n = string.len(entry.message0)
      table.insert(results, entry)
      message_len = entry.n > message_len and entry.n or message_len
    end
  end
  for _, entry in ipairs(results) do
    entry.padding2 = string.rep(' ', message_len - entry.n)
  end
  return results
end

function M.diagnostics(opts)
  opts = opts or {}
  local current_window, current_bufnr = vim.fn.win_getid(vim.fn.winnr()), vim.fn.bufnr('%')
  local cursor = vim.api.nvim_win_get_cursor(current_window)
  local current_row, current_col = cursor[1], cursor[2]

  local function make_display(entry)
    local displayer = entry_display.create {
      separator = '',
      items = {
        -- { width = string.len(entry.padding) }, -- Padding to right align buffer numbers
        -- { width = string.len(tostring(entry.bufnr)) + 1 }, -- The buffer number
        { width = 2 }, -- The diagnostic sign
        { width = string.len(entry.message1) }, -- First part of the message
        { width = string.len(entry.message2) }, -- Second part of the message
        { width = string.len(entry.message3) }, -- Third part of the message
        { width = string.len(entry.message4) }, -- Fourth part of the message
        { width = string.len(entry.padding2) + 1}, -- Padding to right align buffer numbers
        { width = 2 }, -- The icon
        { remaining = true }, -- The filename
      }
    }

    return displayer {
      -- entry.padding,
      -- { entry.bufnr, 'TelescopeResultsNumber' },
      { entry.sign, entry.sign_hl },
      entry.message1,
      { entry.message2, 'TelescopeDiagnosticType' },
      entry.message3,
      { entry.message4, 'TelescopeDiagnosticType' },
      entry.padding2,
      { entry.icon, entry.icon_hl },
      entry.bufname,
    }
  end

  local function move_down(prompt_bufnr)
    actions.move_selection_next(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    vim.api.nvim_win_set_buf(current_window, selection.bufnr)
    vim.api.nvim_set_option_value('cursorline', true, {scope='local', win=current_window})
    vim.api.nvim_win_set_cursor(current_window, {selection.lnum+1, selection.col})
  end

  local function move_up(prompt_bufnr)
    actions.move_selection_previous(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    vim.api.nvim_win_set_buf(current_window, selection.bufnr)
    vim.api.nvim_set_option_value('cursorline', true, {scope='local', win=current_window})
    vim.api.nvim_win_set_cursor(current_window, {selection.lnum+1, selection.col})
  end

  local function select(prompt_bufnr)
    actions.close(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    vim.api.nvim_win_set_buf(current_window, selection.bufnr)
    vim.api.nvim_set_option_value('cursorline', false, {})
    vim.api.nvim_win_set_cursor(current_window, {selection.lnum+1, selection.col})
  end

  local function close(prompt_bufnr)
    actions.close(prompt_bufnr)
    vim.api.nvim_win_set_buf(current_window, current_bufnr)
    vim.api.nvim_set_option_value('cursorline', false, {})
    vim.api.nvim_win_set_cursor(current_window, {current_row, current_col})
  end

  local diagnostics = M.list_diagnostics()
  opts.layout_config = {
    height = (#diagnostics > 11 and 11 or #diagnostics) + 4,
    width = math.floor(vim.api.nvim_list_uis()[1].width * 1),
    anchor = 'SE',
    anchor_padding = 0
  }
  opts.borderchars = { '─', ' ', ' ', ' ', '─', '─', ' ', ' ' }
  opts.selection_caret = '  '
  opts = require('telescope.themes').get_dropdown(opts)
  -- opts = require('telescope.themes').get_ivy(opts or {})

  pickers.new(opts, {
    prompt_title = 'Diagnostics',
    results_title = false,
    finder = finders.new_table {
      results = diagnostics,
      entry_maker = function(entry)
        return {
          display = make_display,
          ordinal = entry.code .. entry.severity .. entry.filetype .. entry.message0 .. entry.bufname,
          sign = entry.sign,
          sign_hl = entry.sign_hl,
          bufname = entry.bufname,
          padding = entry.padding,
          bufnr = entry.bufnr,
          code = entry.code,
          lnum = entry.lnum,
          col = entry.col,
          icon = entry.icon,
          icon_hl = entry.icon_hl,
          message1 = entry.message1,
          message2 = entry.message2,
          message3 = entry.message3,
          message4 = entry.message4,
          padding2 = entry.padding2,
        }
      end
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(_, map)
      map('i', '<C-j>', move_down)
      map('i', '<Tab>', move_down)
      map('i', '<C-k>', move_up)
      map('i', '<S-Tab>', move_up)
      map('i', '<CR>', select)
      map('i', '<Esc>', close)
      map('i', '<C-d>', close)
      return true
    end
  }):find()

      -- vim.api.nvim_set_hl(0, 'StlFileIcon', {
      --   fg = M.hex_colours(highlight).fg,
      --   bg = M.hex_colours('StatusLine').bg
      -- })
  local stl_background = statusline.hex_colours('StatusLine').bg
  vim.opt.statusline = ' '
  vim.api.nvim_set_hl(0, 'StatusLine', { bg = statusline.hex_colours('Normal').bg })
  vim.api.nvim_create_autocmd({ 'BufWinLeave' }, {
    buffer = vim.fn.bufnr('%'),
    callback = function ()
      vim.opt.statusline = '%{%v:lua.require("core.statusline").status_line()%}'
      vim.api.nvim_set_hl(0, 'StatusLine', { bg = stl_background })
      -- vim.opt.laststatus = 3
    end,
  })
end

return M
