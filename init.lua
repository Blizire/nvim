require('shell')

vim.pack.add{
  { src = 'https://github.com/ibhagwan/fzf-lua' },
  { src = 'https://github.com/Blizire/stiles.nvim' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('*') },
}

require('keymaps')
require('options')
require('clipboard')
require('treesitter')
require('autocomeplete')
require('lsp')
