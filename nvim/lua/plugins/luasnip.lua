return {
	'L3MON4D3/LuaSnip',
	event = 'InsertEnter',
	version = 'v2.*',
	build = 'make install_jsregexp',
	config = function ()
	  local luasnip = require('luasnip')
	  luasnip.config.set_config {
	    history = true,
	    enable_autosnippets = true
    }
    local modules = vim.split(vim.fn.glob('~/.config/nvim/lua/snippets/*.lua'), '\n')
    for _, module in ipairs(modules) do
      require(module:match('lua/(.-)%.lua$'):gsub('/', '.'))
    end

	end
}
