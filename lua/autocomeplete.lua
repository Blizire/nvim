local cmp = require('blink.cmp')
cmp.setup({
  -- Use Lua only: no native matcher download or Rust build required.
  fuzzy = { implementation = 'lua' },
  keymap = {
    preset = 'default',
    ['<C-s>'] = { 'show_signature', 'hide_signature', 'fallback' },
  },
  sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
  snippets = { preset = 'default' }, -- Neovim's built-in snippet engine.
  completion = {
    menu = {
      auto_show = true,
      draw = { columns = { { 'label', 'label_description', gap = 1 }, { 'kind' } } },
    },
    list = { selection = { preselect = false, auto_insert = false } },
    documentation = { auto_show = true, auto_show_delay_ms = 250 },
  },
  signature = { enabled = true },
  cmdline = { enabled = false },
  term = { enabled = false },
})

-- Advertise completion/snippet support before the selected LSPs start.
vim.lsp.config('*', { capabilities = cmp.get_lsp_capabilities() })
