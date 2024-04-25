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
require('lspconfig').clangd.setup(generic_setup)
require('lspconfig').pyright.setup(generic_setup)
require('lspconfig').cmake.setup(generic_setup)
require('lspconfig').rust_analyzer.setup(generic_setup)

local cmp = require('cmp')

cmp.setup({
  sources = {
    {name = 'nvim_lsp'},
  },
  mapping = {
    ['<C-y>'] = cmp.mapping.confirm({select = false}),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<Up>'] = cmp.mapping.select_prev_item({behavior = 'select'}),
    ['<Down>'] = cmp.mapping.select_next_item({behavior = 'select'}),
    ['<C-p>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item({behavior = 'insert'})
      else
        cmp.complete()
      end
    end),
    ['<C-n>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_next_item({behavior = 'insert'})
      else
        cmp.complete()
      end
    end),
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
})
