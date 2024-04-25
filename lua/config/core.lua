-- core.lua - hold the basic nvim key bindings and configuration here

-- set shell to posh on windows or use default for others

--[[ 
-- will figure this out later for the LUA version of this solution.
-- https://www.reddit.com/r/neovim/comments/vpnhrl/how_do_i_make_neovim_use_powershell_for_external/
--
if (vim.loop.os_uname().sysname == "Windows_NT") then
    vim.opt.shell = 'powershell.exe'
    print('windows!!!')
end
]]--

vim.opt.mouse = 'a'
vim.g.mapleader = " "
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.autoindent = true
vim.opt.tabstop=2
vim.opt.shiftwidth=2
vim.opt.softtabstop=2
vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.clipboard=unnamedplus -- does not work unless mouse=v
vim.opt.mouse = 'v'
-- custom keymap bindings for default controls
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>q', ':quit<CR>', {noremap = true, silent = true})
vim.keymap.set('n', '<leader>Q', ':quit!<CR>', {noremap = true, silent = true})
vim.keymap.set("n", "<leader>v", ":vsplit<CR><C-w>w") -- vertically split window and select it
vim.keymap.set("n", "<leader>b", ":split<CR><C-w>w") -- vertically split window and select it
vim.keymap.set("n", "<leader>e", ":E<CR>")

-- Define key mappings for navigating windows with arrow keys
vim.api.nvim_set_keymap('n', '<leader><Up>', '<C-w>k', { noremap = true, silent = true })    -- Move to window above
vim.api.nvim_set_keymap('n', '<leader><Down>', '<C-w>j', { noremap = true, silent = true })  -- Move to window below
vim.api.nvim_set_keymap('n', '<leader><Left>', '<C-w>h', { noremap = true, silent = true })  -- Move to window left
vim.api.nvim_set_keymap('n', '<leader><Right>', '<C-w>l', { noremap = true, silent = true }) -- Move to window right

-- nvim-tree specific ( DISABLES NETRW )
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeOpen<CR>', {}) -- open tree browser
vim.api.nvim_set_keymap('n', '<leader>E', ':NvimTreeClose<CR>', {}) -- open tree browser
