return {
  'nvim-treesitter/nvim-treesitter',
  config = function ()
    local ensure_installed = {
      'lua',
      'vim',
      'vimdoc',
      'query',
      'sql',
      'markdown',
      'python',
      'r',
    }
    require'nvim-treesitter.configs'.setup {
      ensure_installed = ensure_installed,
      highlight = {
        enable = true,
        disable = function(_, buf)
          local max_filesize = 100 * 1024
          ---@diagnostic disable-next-line: undefined-field
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
        additional_vim_regex_highlighting = false,
      },
    }
  end
}
