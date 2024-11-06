return {
  'lukas-reineke/indent-blankline.nvim',
  name = 'ibl',
  config = function ()
    require('ibl').setup {
      scope = {
        enabled = false
      },
      exclude = {
        filetypes = { 'pseudo_qf' }
      }
    }
  end
}
