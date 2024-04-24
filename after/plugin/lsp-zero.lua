local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.default_keymaps({
        buffer = bufnr,
        preserve_mappings = false
    })
end)

-- here you can setup the language servers
-- require('lspconfig').example_server.setup({})
-- in your own config you should replace `example_server`
-- with the name of a language server you have installed
-- require('lspconfig').example_server.setup({})

local generic_signature_setup = {
    bind = true,
    handler_opts = {
        border = "rounded"
    }
}

local generic_setup = {
  on_attach = function(client, bufnr)
    require "lsp_signature".on_attach(generic_signature_setup, bufnr)
  end,
}

require('lspconfig').lua_ls.setup(generic_setup)
require('lspconfig').clangd.setup({})
require('lspconfig').pyright.setup(generic_setup)
require('lspconfig').cmake.setup({})
require('lspconfig').rust_analyzer.setup({})
