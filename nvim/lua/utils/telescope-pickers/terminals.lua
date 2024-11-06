local M = {}
local terminal = require 'utils.terminal'
local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'
local conf = require('telescope.config').values
local entry_display = require('telescope.pickers.entry_display')
local devicons = require('nvim-web-devicons')

function M.list_terminals(links)

  local active_terminals, digits = terminal.active_terminals(), 0
  for _, term_b in ipairs(active_terminals) do
    local b_digits = string.len(tostring(term_b))
    digits = b_digits > digits and b_digits or digits
  end

  local results = {}
  for _, term_b in ipairs(active_terminals) do
    local entry = {}
    local bhandle_len = string.len(tostring(term_b))
    entry.padding = string.rep(' ', digits - bhandle_len)
    entry.bufnr = term_b
    entry.icon, entry.icon_hl = devicons.get_icon_by_filetype('terminal')
    local name = vim.fn.bufname(term_b)
    entry.cwd = string.match(name, '//(.-)//')
    entry.program = string.match(name, '^[^:]*:[^:]*:(.*)$')
    -- local ts = vim.api.nvim_buf_get_var(term_b, 'last_toggle')
    -- ts = math.floor(ts / 1000000)
    entry.timestamp = os.date('%Y-%m-%d %H:%M:%S', math.floor(vim.b[term_b].last_toggle / 1000000))
    -- local term_channel = vim.api.nvim_get_option_value('channel', {buf=term_b})
    -- entry.connected = channel == term_channel and '󱘖' or ' '
    entry.connected, entry.connection_index = false, 0
    for index, linked_terminal in ipairs(links) do
      if linked_terminal.channel == vim.bo[term_b].channel then
        entry.connected, entry.connection_index = true, index
        break
      end
    end
    entry.connection_icon = entry.connected and '󱘖' or ' '
    table.insert(results, entry)
  end
  return results
end

function M.terminals(opts)
  opts = opts or {}
  local filetype, this_b = vim.bo.filetype, vim.fn.bufnr('%')
  local has_links, links = pcall(vim.api.nvim_buf_get_var, 0, 'linked_terminals')
  links = has_links and links or {}

  local function make_display(entry)
    local displayer = entry_display.create {
      separator = ' ',
      items = {
        { width = string.len(entry.padding) }, -- Padding to right align buffer numbers
        { width = string.len(tostring(entry.bufnr)) }, -- The buffer number
        -- { width = 2 }, -- file icon
        { width = string.len(tostring(entry.cwd)) }, -- The working directory
        { width = string.len(tostring(entry.program)) }, -- The running program
        { width = string.len(tostring(entry.timestamp)) }, -- Timestamp
        { width = 1 },
      }
    }
    return displayer {
      entry.padding,
      { entry.bufnr, 'TelescopeResultsNumber' },
      -- { entry.icon, entry.icon_hl },
      entry.cwd,
      { entry.program, 'TelescopeTermProgram' },
      { entry.timestamp, 'TelescopeResultsComment' },
      { entry.connection_icon, '@string' },
    }
  end

  local function select(prompt_bufnr)
    actions.close(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    local terminal_win = terminal.terminal_window()
    if not terminal_win then
      terminal.toggle_terminal()
      terminal_win = terminal.terminal_window()
    end
    vim.api.nvim_win_set_buf(terminal_win, selection.bufnr)
  end

  local function link_channel(prompt_bufnr)
    if filetype ~= 'terminal' then
      local selection = action_state.get_selected_entry()
      if not selection.connected then
        terminal.link_terminal(this_b, selection.bufnr)
      else
        local linked_terminals = vim.b[this_b].linked_terminals
        table.remove(linked_terminals, selection.connection_index)
        vim.b[this_b].linked_terminals = linked_terminals
      end
      actions.close(prompt_bufnr)
      M.terminals()
    end
  end

  local terminals = M.list_terminals(links)
  opts.layout_config = { height = (#terminals > 11 and 11 or #terminals) + 4}
  opts = require('telescope.themes').get_dropdown(opts or {})

  pickers.new(opts, {
    prompt_title = 'Active Terminals',
    results_title = '',
    finder = finders.new_table {
      results = terminals,
      entry_maker = function(entry)
        return {
          display = make_display,
          ordinal = entry.cwd .. entry.program,
          padding = entry.padding,
          bufnr = entry.bufnr,
          cwd = entry.cwd,
          program = entry.program,
          timestamp = entry.timestamp,
          connected = entry.connected,
          connection_icon = entry.connection_icon,
          connection_index = entry.connection_index,
          icon = entry.icon,
          icon_hl = entry.icon_hl,
        }
      end
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(_, map)
      map('i', '<C-p>', link_channel)
      map('i', '<CR>', select)
      return true
    end
  }):find()

end

return M
