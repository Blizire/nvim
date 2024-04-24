vim.keymap.set("n", "<leader>fb", ":Telescope file_browser<CR>")

-- open file_browser with the path of the current buffer
vim.keymap.set("n", "<leader>fb", ":Telescope file_browser path=%:p:h select_buffer=true<CR>")

-- Alternatively, using lua API
vim.keymap.set("n", "<leader>fb", function()
	require("telescope").extensions.file_browser.file_browser()
end)
