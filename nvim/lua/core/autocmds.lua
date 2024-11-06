vim.api.nvim_create_autocmd({ 'VimEnter', 'DirChanged' }, {
  callback = function ()
    if not vim.g.config then
      vim.cmd('silent !kitty @ set-tab-title " "')
    end
    if vim.fn.getcwd() == '/Users/me' then
      vim.api.nvim_command('cd Documents')
    end
  end
})

vim.api.nvim_create_autocmd({ 'VimLeave' }, {
  callback = function ()
    vim.cmd('silent !kitty @ set-tab-title " "')
  end
})


vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  callback = function ()
    local b = vim.fn.bufnr('%')
    if vim.bo[b].buflisted then
      _G.stlbufnr = b
    end
  end
})

vim.api.nvim_create_autocmd({ 'BufReadPre' }, {
  pattern = '*.tex',
  callback = function ()
    vim.b.vimtex_main = vim.fn.expand('%')
  end
})

