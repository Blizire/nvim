require('shell')

vim.pack.add{
  { src = 'https://github.com/ibhagwan/fzf-lua' },
  { src = 'https://github.com/Blizire/stiles.nvim' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
  { src = 'https://github.com/neovim/nvim-lspconfig' },
}

require('keymaps')
require('options')
require('clipboard')
require('treesitter')
require('lsp')
