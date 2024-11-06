local luasnip = require('luasnip')
local snippet = luasnip.snippet
local text_node = luasnip.text_node
local insert_node = luasnip.insert_node
local dynamic_node = luasnip.dynamic_node
local function_node = luasnip.function_node
local snippet_node = luasnip.snippet_node

local function python_conditional_self(_)
  local parser = vim.treesitter.get_parser(0, 'python')
  local root = parser:parse()[1]:root()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1
  local node = root:named_descendant_for_range(row, col, row, col)
  while node do
    if node:type() == 'class_definition' then
      return 'self, '
    end
    node = node:parent()
  end
  return ''
end

local function python_class_self_assignment(args)
  local assignments = {}
  local indent = string.rep(' ', vim.o.tabstop * 2)
  for _, arg in ipairs(vim.split(args[1][1], ',')) do
    arg = vim.trim(arg)
    if arg ~= 'self' and arg ~= '' then
      table.insert(assignments, indent .. 'self.' .. arg .. ' = ' .. arg)
    end
  end
  table.insert(assignments, indent)
  return snippet_node(nil, text_node(assignments))
end

luasnip.add_snippets('python', {
  snippet('def', {
    text_node('def '),
    insert_node(1, 'name'),
    text_node('('),
    function_node(python_conditional_self, {}),
    insert_node(2),
    text_node({'):', '\t'}),
    insert_node(3, 'pass'),
  }),
  snippet('class', {
    text_node('class '),
    insert_node(1, 'class_name'),
    text_node({':', '\tdef __init__(self, '}),
    insert_node(2),
    text_node({'):', ''}),
    dynamic_node(3, python_class_self_assignment, {2})
  })
})

