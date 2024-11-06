local M = {}
local statusline = require('core.statusline')

function M.stl_autocmd()
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
