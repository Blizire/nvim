# Install this configuration and verify

[Back to the main README](../README.md)

Install dependencies first, using the guide for your operating system:
[Debian](debian.md), [Fedora](fedora.md), [macOS](macos.md), or
[Windows](windows.md). If the configuration is already in the correct
location, skip cloning. Otherwise, back up any existing configuration before
cloning; the destination must not already contain another configuration. The
SSH repository URL requires access to the server and an authorized SSH key.

**Debian, Fedora, and macOS:**

```bash
git clone ssh://git@git.grugs.grocks.org:3001/stiles/stiles-nvim.git "$HOME/.config/nvim"
```

**Native Windows (PowerShell):**

```powershell
git clone ssh://git@git.grugs.grocks.org:3001/stiles/stiles-nvim.git "$env:LOCALAPPDATA\nvim"
```

These are Neovim's default paths; if you customize `XDG_CONFIG_HOME` or
`NVIM_APPNAME`, use `:echo stdpath('config')` to find your actual location.

Check versions in a fresh terminal:

```text
nvim --version
fzf --version
tree-sitter --version
lua-language-server --version
rust-analyzer --version
clangd --version
ty --version
ruff --version
go version
gopls version
node --version
typescript-language-server --version
tsc --version
```

Require Neovim **0.12+**, fzf **newer than 0.36**, and Tree-sitter CLI
**0.26.1+**. All commands must resolve before proceeding. Start `nvim` once,
allow `vim.pack` to install its plugins, and quit. Then install the parsers
(the command is the same in Bash, Zsh, and PowerShell):

```text
nvim --headless -c "TSSetup" -c "qa"
```

Inside Neovim, run:

```vim
:checkhealth vim.lsp
:checkhealth nvim-treesitter
:checkhealth fzf-lua
:checkhealth vim.provider
```

Open a Lua, Python, Rust, C/C++, Go, or TypeScript/JavaScript file in a project and run
`:lua vim.print(vim.lsp.get_clients({ bufnr = 0 }))` to confirm the relevant
server attached. Python should show both `ty` and `ruff`. Unused Python,
Ruby, or Perl provider warnings do not require installing those providers for
this configuration. Clipboard behavior is described in [Clipboard](clipboard.md).
