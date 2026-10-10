# Language servers

[Back to the main README](../README.md)

Lua, Python, Rust, C/C++, Go, and TypeScript/JavaScript have LSP enabled. `nvim-lspconfig`
supplies server commands, filetypes, and project-root detection.

Install these executables on your PATH:

| Language | Server executable | Purpose |
| --- | --- | --- |
| Lua | `lua-language-server` | Completion, diagnostics, navigation |
| Python | `ty` and `ruff` | Types/navigation/completion and linting/formatting |
| Rust | `rust-analyzer` | Rust language support |
| C/C++ | `clangd` | C/C++ language support |
| Go | `gopls` (plus the `go` toolchain) | Go language support |
| TypeScript / JavaScript | `typescript-language-server` (plus `node` and `typescript@5`) | TS/JS language support |

## Installing or updating the Go and TypeScript servers

Once Go and Node.js are installed, the same two commands work on every
operating system and also update the servers later:

```text
go install golang.org/x/tools/gopls@latest
npm install -g typescript@5 typescript-language-server
```

Keep TypeScript on the 5.x line for now: `typescript-language-server` looks
for `tsserver.js`, which TypeScript 7 does not provide. A project that has its
own `typescript` in `node_modules` uses that version instead. `ts_ls` fails to
initialize with "Could not find a valid TypeScript installation" when no
usable TypeScript is found.

For C/C++ projects, provide a `compile_commands.json` when needed so clangd
knows your include paths and compiler flags.

Use `:checkhealth vim.lsp` to check server setup. Built-in shortcuts include
`K` for hover, `Ctrl-]` for definition, `grr` for references, `grn` for rename,
`gra` for code actions, and insert-mode `Ctrl-x Ctrl-o` for completion.

Inlay hints (such as Rust's inferred types and parameter names) start enabled
when the server supports them. Press `Ctrl-Shift-s` in normal or insert mode
to toggle hints in the current buffer. In normal mode, `<Space>lh` also toggles
them; use this fallback if your terminal does not distinguish `Ctrl-Shift-s`.
`<Space>lf` formats the current buffer.
