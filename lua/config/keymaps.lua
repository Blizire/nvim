-- custom keybinds
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>w", ":w<CR>") -- write file
vim.keymap.set("n", "<leader>q", ":q!<CR>") -- force quit
vim.keymap.set("n", "<leader>e", ":e .<CR>") -- file explore
vim.keymap.set("n", "<leader>vv", "<C-v>", { noremap = true }) -- visual block mode
