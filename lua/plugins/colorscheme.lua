return { 
	"https://github.com/Mofiqul/vscode.nvim", 
	name="vscode",
	config = function (_, opts)
		vim.cmd [[colorscheme vscode]]
	end,
}
