local luasnip = require('luasnip')
local snippet = luasnip.snippet
local text_node = luasnip.text_node
local insert_node = luasnip.insert_node
-- local dynamic_node = luasnip.dynamic_node
-- local function_node = luasnip.function_node
-- local snippet_node = luasnip.snippet_node

luasnip.add_snippets('r', {
  snippet('for', {
    text_node('for ('),
    insert_node(1, 'iterator'),
    text_node(' in '),
    insert_node(2, 'collection'),
    text_node({') {', '\t'}),
    insert_node(3),
    text_node({'', '}'}),
  }),
  snippet('function', {
    insert_node(1, 'name'),
    text_node(' = function('),
    insert_node(2, 'args'),
    text_node({') {', '\t'}),
    insert_node(3),
    text_node({'', '}'}),
  }),
})

