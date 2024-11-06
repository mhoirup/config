local luasnip = require('luasnip')
local snippet = luasnip.snippet
local text_node = luasnip.text_node
local insert_node = luasnip.insert_node
-- local dynamic_node = luasnip.dynamic_node
-- local function_node = luasnip.function_node
-- local snippet_node = luasnip.snippet_node
local extras = require('luasnip.extras')
local repeat_node = extras.rep

luasnip.add_snippets('sql', {
  snippet({ trig = 'select', name = 'select/from' }, {
    text_node('select '),
    insert_node(3, 'column_name'),
    text_node({'', 'from '}),
    insert_node(1, 'schema'),
    text_node('.'),
    insert_node(2, 'table_name'),
  })
})

luasnip.add_snippets('sql', {
  snippet('join', {
    insert_node(1, 'join_type'),
    text_node(' join '),
    insert_node(2, 'schema'),
    text_node('.'),
    insert_node(3, 'table_name'),
    text_node(' on '),
    repeat_node(3)
    -- text_node('.'),
    -- insert_node(3, 'column'),
    -- text_node(' = '),
    -- insert_node(4, 'table_name'),
    -- text_node('.'),
    -- insert_node(5, 'column'),
  })
})


