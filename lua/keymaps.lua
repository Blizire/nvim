-- keymaps.lua
-- Defines my personal keybinds for standard neovim functions

vim.g.mapleader = ' '

vim.keymap.set('n', '<leader>bg', function()
  if vim.o.background == 'dark' then
    vim.o.background = 'light'
  else
    vim.o.background = 'dark'
  end
end, { desc = 'Toggle light/dark background' })

-- buffers and navigation
vim.keymap.set('n', '<leader>bn', '<cmd>bnext<cr>', { desc = 'Next buffer' })
vim.keymap.set('n', '<leader>bp', '<cmd>bprev<cr>', { desc = 'Previous buffer' })
vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<cr>', { desc = 'Delete buffer' })
vim.keymap.set('n', '<S-h>', '<cmd>bprev<cr>', { desc = 'Previous buffer' })
vim.keymap.set('n', '<S-l>', '<cmd>bnext<cr>', { desc = 'Next buffer' })
vim.keymap.set('n', '<leader>ls', '<cmd>ls<cr>', { desc = 'List buffers' })
vim.keymap.set('n', '<leader>e', '<cmd>Ex<cr>', { desc = 'File explorer' })

-- window / ctrl-w alternative
vim.keymap.set('n', '<leader>w', '<C-w>', { desc = 'Window commands' })

-- save/quit shortcuts
vim.keymap.set('n', '<leader>s', '<cmd>write<cr>', { desc = 'Save file' })
vim.keymap.set('n', '<leader>q', '<cmd>quit<cr>', { desc = 'Quit window' })

-- clear search highlight
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<cr>', { desc = 'Clear search highlight' })

-- fzf keybinds
local fzf = require('fzf-lua')
vim.keymap.set('n', '<leader>ff', fzf.files, { desc = 'Fzf Files' })
vim.keymap.set('n', '<leader>fg', fzf.live_grep, { desc = 'Fzf Live Grep' })
vim.keymap.set('n', '<leader>fb', fzf.buffers, { desc = 'Fzf Buffers' })
vim.keymap.set('n', '<leader>fh', fzf.helptags, { desc = 'Fzf Help' })
vim.keymap.set('n', '<leader>fr', fzf.resume, { desc = 'Fzf Resume last search' })
vim.keymap.set('n', '<leader>fd', fzf.diagnostics_document, { desc = 'Fzf Diagnostics' })

-- custom commands
vim.keymap.set('n', '<F5>', '<cmd>read !date<cr>', { silent = true, desc = 'Insert date' })
