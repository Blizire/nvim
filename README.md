# stiles-nvim

A repo for my personal neovim configuration

This is a Neovim 0.12+ configuration built on the built-in `vim.pack` plugin
manager, native LSP, and Tree-sitter, with fzf-lua pickers, blink.cmp
autocomplete, OSC 52 clipboard support, and per-OS shell selection.

Follow the setup guide for your operating system, then complete
[Install this configuration and verify](docs/install-and-verify.md).

## External software checklist

Install the following tools after copying this configuration. Their executables
must be available on the PATH used by Neovim.

| Software | Required for |
| --- | --- |
| Neovim 0.12 or newer (`nvim`) | This configuration uses the built-in `vim.pack` plugin manager. |
| Git (`git`) | Downloading and updating plugins. |
| fzf (`fzf`, newer than 0.36) | File, buffer, and search pickers. |
| ripgrep (`rg`) | Project text search with `<Space>fg`. |
| Tree-sitter CLI (`tree-sitter`, 0.26.1 or newer) | Building the configured syntax parsers. |
| C compiler (Clang, GCC, or MSVC) | Compiling Tree-sitter parsers; Windows also needs the compiler's SDK/build environment. |
| curl and tar | Downloading and extracting parser sources. |
| Lua Language Server (`lua-language-server`) | Lua completion, diagnostics, and navigation. |
| ty (`ty`) | Python type checking, completion, and navigation. |
| Ruff (`ruff`) | Python linting, formatting, and import fixes. |
| rust-analyzer (`rust-analyzer`) | Rust completion, diagnostics, and navigation. |
| Rust toolchain (`rustc` and `cargo`, usually installed through rustup) | Rust projects; Cargo can also install the Tree-sitter CLI. |
| clangd (`clangd`) | C/C++ completion, diagnostics, and navigation. |
| Go toolchain (`go`) and gopls (`gopls`) | Go support; gopls runs `go env`, so Go must be installed too. |
| Node.js (`node` and `npm`) | Runs the TypeScript language server. |
| typescript-language-server and TypeScript 5.x (`typescript-language-server`, `tsc`) | TypeScript/JavaScript completion, diagnostics, and navigation. |

Language servers are needed for the languages you use. Project interpreters,
libraries, and build tools still belong to each project's own environment.

Optional or platform-specific tools:

- `uv` is a convenient installer for `ty` and `ruff`; it is not required by
  Neovim once those executables are installed. `pipx` is an alternative installer.
- `fd` speeds up file discovery; fzf-lua can use other available file-listing tools.
- `pynvim` is not required by this configuration: its plugins and LSP clients
  do not use Neovim's Python provider.

Neovim downloads `fzf-lua`, `stiles.nvim`, `nvim-treesitter`, `nvim-lspconfig`,
and `blink.cmp` through `vim.pack.add` in `init.lua`. These plugins do not
install the external programs listed above. Run `:TSSetup` after installing
the parser build tools to download and compile the configured parsers.


## Setup guides

Pick the guide for your operating system. Each one installs the software in the
checklist above and then points you to the verification steps.

- [Debian](docs/debian.md) (continues in the [shared Debian/Fedora setup](docs/linux-common.md))
- [Fedora](docs/fedora.md) (continues in the [shared Debian/Fedora setup](docs/linux-common.md))
- [macOS](docs/macos.md)
- [Windows](docs/windows.md) (native PowerShell; WSL users follow the Linux guide for their distribution)

When the software is installed, finish with
[Install this configuration and verify](docs/install-and-verify.md).

## Using the configuration

- [Language servers](docs/language-servers.md): which servers are enabled, how to install and update them, and the LSP shortcuts.
- [Tree-sitter](docs/tree-sitter.md): parser installation, highlighting, and folding.
- [Autocomplete](docs/autocomplete.md): blink.cmp setup and insert-mode controls.
- [Clipboard](docs/clipboard.md): OSC 52 copy and paste behavior.
- [Shell selection](docs/shell.md): how the shell is chosen on each operating system.
