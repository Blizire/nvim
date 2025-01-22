return {
  {
    "https://github.com/rebelot/kanagawa.nvim",
  },
  {
    "https://github.com/sainnhe/gruvbox-material",
    init = function (LazyPlugin)
      vim.o.background = "dark"
      vim.cmd.colorscheme "gruvbox-material"
    end
  }
}
