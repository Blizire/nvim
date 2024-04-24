--[[
local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)

-- here you can setup the language servers
-- require('lspconfig').example_server.setup({})
-- in your own config you should replace `example_server`
-- with the name of a language server you have installed
-- require('lspconfig').example_server.setup({})

require('lspconfig').clangd.setup({})
require('lspconfig').pyright.setup({})
]]--
