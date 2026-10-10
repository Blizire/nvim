-- a colored column appears at 80 and 120 to mark a soft and hard limit for
-- how long a row of text should be.
vim.opt.colorcolumn = "80,120"

vim.opt.ignorecase = true -- ignore case in search
vim.opt.swapfile = false -- disable swap files
vim.opt.number = true -- show line numbers
vim.opt.relativenumber = true -- numbers are relative to current pos
vim.opt.cursorline = true -- highlight current line
vim.opt.scrolloff = 8 -- pad 8 lines below and above the cursor
vim.opt.splitright = true -- vertical splits open to the right
vim.opt.splitbelow = true -- horizontal splits open below
vim.opt.signcolumn = "yes" -- always show the sign column so text doesn't shift
vim.opt.updatetime = 250 -- ms of idle time before CursorHold fires

vim.opt.background = "dark"
require("stiles").setup()
vim.cmd.colorscheme("stiles")

-- setting tab width
vim.opt.tabstop = 4      -- Number of spaces that a <Tab> in the file counts for
vim.opt.shiftwidth = 4   -- Size of an indent
vim.opt.softtabstop = 4  -- Number of spaces that a <Tab> counts for while performing editing operations
vim.opt.expandtab = true -- Insert spaces instead of a tab character
