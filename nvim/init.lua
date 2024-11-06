if not vim.g.vscode then
  -- Standard Lazy.nvim boiler plate
  local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
  ---@diagnostic disable-next-line: undefined-field
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
      vim.api.nvim_echo({
        { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
        { out, 'WarningMsg' },
        { '\nPress any key to exit...' },
      }, true, {})
      vim.fn.getchar()
      os.exit(1)
    end
  end

  vim.opt.rtp:prepend(lazypath)
  -- Loop over the files in the /core/ and /plugins/ directories and source them
  local dirs, plugins = { 'core', 'plugins' }, {}
  for _, dir in ipairs(dirs) do
    local files = vim.split(vim.fn.glob('~/.config/nvim/lua/' .. dir .. '/*.lua'), '\n')
    for _, path in ipairs(files) do
      -- First we extract the substrings "{dir}/{filename}" (w/o extension) and
      -- then substitute the "/" for ".", eg "plugins/telescope.lua" -> "plugins.telescope"
      local _, module = pcall(require, path:match('lua/(.-)%.lua$'):gsub('/', '.'))
      if dir == 'plugins' then
        table.insert(plugins, module)
      end
    end
  end

  require('lazy').setup { spec = plugins }
  _G.theme_catppuccin_mocha()
end
