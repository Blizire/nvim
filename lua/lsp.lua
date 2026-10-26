vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = {
        checkThirdParty = false,
        library = { vim.env.VIMRUNTIME .. "/lua" },
      },
    },
  },
})

-- Ruff handles linting/formatting; ty handles Python types and navigation.
vim.lsp.config("ruff", {
  on_attach = function(client)
    client.server_capabilities.hoverProvider = false
  end,
})

vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
  float = { border = "rounded", source = true },
  jump = { float = true },
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
  desc = "Buffer-local LSP keymaps and inlay hints",
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    vim.keymap.set("n", "gd", vim.lsp.buf.definition,
      { buffer = args.buf, desc = "LSP go to definition" })
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration,
      { buffer = args.buf, desc = "LSP go to declaration" })

    vim.keymap.set("n", "<leader>lf", function()
      vim.lsp.buf.format({ bufnr = args.buf })
    end, { buffer = args.buf, desc = "LSP format buffer" })

    if client and client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })

      local function toggle_inlay_hints()
        local filter = { bufnr = args.buf }
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(filter), filter)
      end

      vim.keymap.set({ "n", "i" }, "<C-S-s>", toggle_inlay_hints,
        { buffer = args.buf, desc = "Toggle LSP inlay hints" })
      vim.keymap.set("n", "<leader>lh", toggle_inlay_hints,
        { buffer = args.buf, desc = "Toggle LSP inlay hints" })
    end
  end,
})

vim.lsp.enable({
  "lua_ls", "ty", "ruff", "rust_analyzer", "clangd", "gopls", "ts_ls",
})
