local M = {}
local entry_display = require('telescope.pickers.entry_display')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local utils = require('utils.telescope-pickers.utils')
-- local devicons = require('nvim-web-devicons')

function M.count_elements(root, name)
  local handle = io.popen('ls -lf ' .. root .. '/' .. name)
  local content = vim.split(handle and handle:read('*a') or '', '\n', {trimempty=true})
  local entries, dirs = 0, 0
  table.remove(content, 1)
  table.remove(content, 2)
  for _, value in ipairs(content) do
    local ls_name = value:match('.*%s(.*)')
    if string.sub(ls_name, string.len(ls_name), string.len(ls_name)) ~= '.' and ls_name ~= '.DS_Store' then
      local is_dir = vim.fn.isdirectory(root .. '/' .. name .. '/' .. value:match('.*%s(.*)'))
      dirs = dirs + is_dir
      entries = entries + 1
    end
  end
  return (entries - dirs) .. 'f:'.. dirs..'d'
end

function M.list_directories(directory)
  local handle = io.popen('ls -lf ' .. directory)
  local content = vim.split(handle and handle:read('*a') or '', '\n', {trimempty=true})
  table.remove(content, 1)
  table.remove(content, 2)
  table.remove(content, 3)
  local results = {}
  for _, ls_line in ipairs(content) do
    local name = ls_line:match('.*%s(.*)')
    if vim.fn.isdirectory(directory .. '/' .. name) == 1 and name ~= '.' and name ~= '..' then
      local entry = {}
      entry.dir_display = '/' .. name
      entry.dir = vim.fn.getcwd() .. entry.dir_display
      entry.icon = ''
      entry.code = string.match(ls_line, '^(.-)%s')
      entry.name = name
      entry.count = M.count_elements(directory, name)
      entry.directory = directory
      table.insert(results, entry)
    end
  end
  return results
end

function M.dir_switcher(opts, directory, prompt_file_selection)
  opts = opts or {}
  directory = directory or vim.fn.getcwd()
  prompt_file_selection = prompt_file_selection or false

  local function make_display(entry)
    local displayer = entry_display.create {
      separator = ' ',
      items = {
        { width = 11 },
        { width = 1 },
        { width = string.len(entry.dir_display) },
        { remaining = true },
      }
    }

    return displayer {
      { entry.code, 'TelescopePromptCounter' },
      { entry.icon, 'CmpItemKindFunction' },
      entry.dir_display,
      { entry.count, 'TelescopePromptCounter' },
    }
  end

  local function move_cwd_ahead(prompt_bufnr)
    actions.close(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    local new_directory = selection.directory .. '/' .. selection.name
    M.dir_switcher({}, new_directory)
  end

  local function move_cwd_back(prompt_bufnr)
    actions.close(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    local new_directory = selection.directory:match("(.*)/")
    M.dir_switcher({}, new_directory)
  end

  local function set_cwd(prompt_bufnr)
    local picker = action_state.get_current_picker(prompt_bufnr)
    actions.close(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    vim.api.nvim_command('cd ' .. selection.directory .. '/' .. selection.name)
    if prompt_file_selection then
      local file_picker_opts = picker.layout_config
      file_picker_opts.prompt_title = 'Open File'
      file_picker_opts.hidden = true
      -- require('telescope.builtin').find_files({prompt_title = 'Open File', hidden=true})
      require('telescope.builtin').find_files(file_picker_opts)
    end
  end

  local directories = M.list_directories(directory)
  table.sort(directories, function (a, b)
    return a.dir_display < b.dir_display
  end)

  opts.layout_config = {
    height = (#directories > 11 and 11 or #directories) + 4,
    width = math.floor(vim.api.nvim_list_uis()[1].width * 1),
    anchor = 'SE',
    anchor_padding = 0
  }
  opts.borderchars = { '─', ' ', ' ', ' ', '─', '─', ' ', ' ' }
  opts.selection_caret = '  '
  opts = require('telescope.themes').get_dropdown(opts)

  pickers.new(opts, {
    prompt_title = 'Select Directory',
    results_title = false,
    finder = finders.new_table {
      results = directories,
      entry_maker = function(entry)
        return {
          display = make_display,
          ordinal = entry.dir,
          dir_display = entry.dir_display,
          dir = entry.dir,
          icon = entry.icon,
          code = entry.code,
          directory = entry.directory,
          name = entry.name,
          count = entry.count,
        }
      end
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(_, map)
      map('i', '<C-l>', move_cwd_ahead)
      map('i', '<C-h>', move_cwd_back)
      map('i', '<CR>', set_cwd)
      return true
    end
    -- attach_mappings = link_channel
  }):find()

  utils.stl_autocmd()
end

return M
