local M = {}
local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'
local conf = require('telescope.config').values
local entry_display = require('telescope.pickers.entry_display')
local devicons = require('nvim-web-devicons')

function M.get_channel(bufnr)
  if vim.api.nvim_get_option_value('filetype', {buf=bufnr}) == 'terminal' then
    return vim.api.nvim_get_option_value('channel', {buf=bufnr})
  else
    local _, channel = pcall(vim.api.nvim_buf_get_var, bufnr, 'term_channel')
    return tonumber(channel)
  end
end

function M.list_buffers(channel)
  local current_bufnr = vim.fn.bufnr('%')
  local loaded, digits = vim.api.nvim_list_bufs(), 0
  for _, b in ipairs(loaded) do
    if vim.api.nvim_get_option_value('bl', {buf=b}) then
      local b_digits = string.len(tostring(b))
      digits = b_digits > digits and b_digits or digits
    end
  end

  local results = {}
  for index, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_get_option_value('bl', {buf=b}) then
      local entry = {}
      local handle_len = string.len(tostring(b))
      local name = vim.fn.bufname(b)
      entry.padding = string.rep(' ', digits - handle_len)
      entry.bufnr = b
      local flags = (b == vim.fn.bufnr('%') and '%' or (b == vim.fn.bufnr('#') and '#' or ' '))
      flags = flags .. (#vim.fn.win_findbuf(b) == 0 and 'h' or 'a')
      flags = flags .. (vim.api.nvim_get_option_value('readonly', {buf=b}) and '=' or ' ')
      entry.flags = flags .. (vim.api.nvim_get_option_value('modified', {buf=b}) and '+' or ' ')
      entry.filetype = vim.bo[b].filetype
      entry.icon, entry.icon_hl = devicons.get_icon(name, vim.fn.fnamemodify(name, ':e'))
      -- entry.icon, entry.icon_hl = devicons.get_icon_by_filetype(entry.filetype)
      entry.icon = entry.icon or ''
      entry.icon_hl = entry.icon_hl or 'DevIconDefault'
      entry.bufname = name == '' and '[NO NAME]' or name
      local b_channel = M.get_channel(b)
      entry.connected = (channel == b_channel and channel > 0 and b ~= current_bufnr) and '󱘖' or ' '
      entry.index = index
      entry.is_current = b == vim.fn.bufnr('%')
      -- local has_channel, b_channel = pcall(vim.api.nvim_buf_get_var, b, 'term_channel')
      -- entry.connected = (has_channel and b_channel == channel) and '󱘖' or ' '
      table.insert(results, entry)
    end
  end
  return results
end

function M.buffers(opts)
  opts = opts or {}
  local channel = M.get_channel(vim.fn.bufnr('%')) or -1

  local function make_display(entry)
    local displayer = entry_display.create {
      separator = ' ',
      items = {
        { width = string.len(entry.padding) }, -- Padding to right align buffer numbers
        { width = string.len(tostring(entry.bufnr)) }, -- The buffer number
        { width = 4 }, -- buffer flags
        { width = 1 }, -- file icon
        { remaining = true }, -- file name
        { width = 1 },
      }
    }
    return displayer {
      entry.padding,
      { entry.bufnr, 'TelescopeResultsNumber' },
      { entry.flags, 'TelescopeResultsComment' },
      { entry.icon, entry.icon_hl },
      -- { entry.bufname, entry.is_current and '@string' or nil },
      entry.bufname,
      { entry.connected, '@string' },
    }
  end

  local function close_buffer(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    vim.api.nvim_buf_call(
      selection.bufnr,
      function () vim.api.nvim_command('up') end
    )
    vim.api.nvim_buf_delete(selection.bufnr, {force=true})
    actions.close(prompt_bufnr)
    M.buffers()
  end

  local function link_channel(prompt_bufnr)
    actions.close(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    local present, _ = pcall(vim.api.nvim_buf_get_var, selection.bufnr, 'term_channel')
    if not present then
      vim.api.nvim_buf_set_var(selection.bufnr, 'term_channel', channel)
    else
      vim.api.nvim_buf_del_var(selection.bufnr, 'term_channel')
    end
    M.buffers()
  end

  local buffers = M.list_buffers(channel)
  opts.layout_config = { height = (#buffers > 11 and 11 or #buffers) + 4}
  opts = require('telescope.themes').get_dropdown(opts or {})
  -- opts = require('telescope.themes').get_ivy(opts or {})

  pickers.new(opts, {
    prompt_title = 'Listed Buffers',
    results_title = '',
    finder = finders.new_table {
      results = M.list_buffers(channel),
      entry_maker = function(entry)
        return {
          display = make_display,
          ordinal = entry.bufname .. entry.bufnr,
          padding = entry.padding,
          bufname = entry.bufname,
          connected = entry.connected,
          bufnr = entry.bufnr,
          icon = entry.icon,
          icon_hl = entry.icon_hl,
          flags = entry.flags,
          index = entry.index,
          is_current = entry.is_current,
        }
      end
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(_, map)
      map('i', '<C-p>', link_channel)
      map('i', '<C-c>', close_buffer)
      return true
    end
    -- attach_mappings = link_channel
  }):find()

end

return M
