vim.cmd [[let &stc = ' %s %3l   ']]
-- vim.cmd [[let &stc = ' %2l  %s']]
vim.cmd [[let &stl = '%s']]
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.autoindent = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.cmdheight = 1
vim.opt.copyindent = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = 'number'
vim.opt.eol = false
vim.opt.expandtab = true
vim.opt.gdefault = true
vim.opt.hidden = true
vim.opt.hidden = true
vim.opt.ignorecase = true
vim.opt.laststatus = 3
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.updatetime = 200
vim.opt.pumheight = 8
vim.opt.ruler = false
vim.opt.scrolloff = 5
vim.opt.shiftwidth = 2
vim.opt.showcmd = false
vim.opt.showmode = false
vim.opt.signcolumn = 'yes'
vim.opt.smartindent = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.statusline = '%{%v:lua.require("core.statusline").status_line()%}'
vim.opt.swapfile = false
vim.opt.tabline = ' '
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.timeout = true
vim.opt.timeoutlen = 500
vim.opt.wrap = false
