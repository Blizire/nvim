# Install on macOS

[Back to the main README](../README.md)

First install Apple's command-line tools, then finish the installer before
continuing:

```bash
xcode-select --install
```

Install [Homebrew](https://brew.sh/) if needed and follow its printed
`brew shellenv` instructions. Then install the tools:

```bash
brew install neovim git fzf ripgrep tree-sitter-cli lua-language-server llvm uv \
    go gopls node
```

Homebrew's LLVM includes `clangd` but is keg-only. Add its binaries to PATH in
`~/.zshrc` (use `~/.bashrc` if that is your interactive shell):

```bash
export PATH="$(brew --prefix llvm)/bin:$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
```

Run that same line in your current terminal. Install Rust through
[rustup](https://rust-lang.org/tools/install/) if it is not already installed:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o /tmp/rustup-init.sh
sh /tmp/rustup-init.sh
. "$HOME/.cargo/env"
rustup default stable
rustup component add rust-analyzer
uv tool install ty
uv tool install ruff
uv tool update-shell
```

Install the TypeScript language server with npm (Node.js came from Homebrew
above). Use TypeScript **5.x**: Homebrew's `typescript` formula is version 7,
which no longer includes the `tsserver` that `typescript-language-server`
needs, so do not install `typescript` or `typescript-language-server` with
Homebrew:

```bash
npm install -g typescript@5 typescript-language-server
```

macOS supplies `curl` and `tar`.
Homebrew installs the Tree-sitter CLI here, so a second Cargo installation is
unnecessary. Open a new terminal, then follow
[Install this configuration and verify](install-and-verify.md).
