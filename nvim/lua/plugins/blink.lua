return {
  'saghen/blink.cmp',
  enabled = false,
  version = 'v0.*',
  opts = {
    accept = {
      auto_brackets = {
        enabled = true,
      },
    },
    keymap = {
      -- ["<Tab>"] = { "accept" },
      -- ["<C-k>"] = { "select_prev" },
      -- ["<C-j>"] = { "select_next" },
    },
    windows = {
      autocomplete = {
        border = 'rounded',
      }
    }
  }
}
