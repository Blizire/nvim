# Shared Debian/Fedora setup

[Back to the main README](../README.md)

## Neovim fallback when the distribution package is too old

The [official Neovim installation guide](https://neovim.io/doc/install/)
provides prebuilt Linux archives. For an x86-64 machine:

```bash
mkdir -p "$HOME/.local/opt" "$HOME/.local/bin"
curl -fL https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz \
    -o /tmp/nvim-linux-x86_64.tar.gz
tar -xzf /tmp/nvim-linux-x86_64.tar.gz -C "$HOME/.local/opt"
ln -sfn "$HOME/.local/opt/nvim-linux-x86_64/bin/nvim" "$HOME/.local/bin/nvim"
export PATH="$HOME/.local/bin:$PATH"
hash -r
nvim --version
```

For ARM64 (`uname -m` reports `aarch64`), replace every `x86_64` above with
`arm64`. Add `export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"` to
`~/.bashrc` (or `~/.zshrc` if using Zsh) so these tools remain available in new
terminals. The upstream `nvim` should appear before `/usr/bin/nvim` in PATH.

## Rust, Tree-sitter, ty, and Ruff

Install [rustup](https://rust-lang.org/tools/install/) if it is not already
installed; accept the default stable toolchain:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o /tmp/rustup-init.sh
sh /tmp/rustup-init.sh
. "$HOME/.cargo/env"
rustup default stable
rustup component add rust-analyzer
cargo install --locked tree-sitter-cli
```

Install [uv](https://docs.astral.sh/uv/getting-started/installation/) and the two
Python tools. uv can obtain Python automatically; a separate system Python or
`pynvim` installation is not needed for these commands.

```bash
curl -LsSf https://astral.sh/uv/install.sh -o /tmp/uv-install.sh
sh /tmp/uv-install.sh
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
uv tool install ty
uv tool install ruff
uv tool update-shell
```

## Go and TypeScript servers

`gopls` needs Go 1.22 or newer; if `go version` is older, install a current
release from [go.dev/dl](https://go.dev/dl/). The TypeScript server needs Node.js:

```bash
go install golang.org/x/tools/gopls@latest
npm install -g typescript@5 typescript-language-server
export PATH="$HOME/go/bin:$PATH"
```

Add `export PATH="$HOME/go/bin:$PATH"` to your shell profile so `gopls` is found
in new terminals. If `npm install -g` fails with a permissions error, set an npm
prefix in your home directory (`npm config set prefix "$HOME/.local"`) instead
of using `sudo`.

## Lua Language Server

Use the [official LuaLS releases](https://github.com/LuaLS/lua-language-server/releases/latest)
when your distribution does not provide a suitable package. Download the
`linux-x64.tar.gz` archive for x86-64, or `linux-arm64.tar.gz` for ARM64.
Extract the **entire archive**, preserving its directory structure:

```bash
mkdir -p "$HOME/.local/opt/lua-language-server" "$HOME/.local/bin"
# Replace this example filename with the exact archive you downloaded.
tar -xzf "$HOME/Downloads/lua-language-server-VERSION-linux-x64.tar.gz" \
    -C "$HOME/.local/opt/lua-language-server"
cat > "$HOME/.local/bin/lua-language-server" <<'EOF'
#!/bin/sh
exec "$HOME/.local/opt/lua-language-server/bin/lua-language-server" "$@"
EOF
chmod +x "$HOME/.local/bin/lua-language-server"
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
lua-language-server --version
```

The wrapper keeps the executable alongside its supporting files, following the
[LuaLS installation guidance](https://github.com/LuaLS/lua-language-server/wiki/Getting-Started).
Continue with [Install this configuration and verify](install-and-verify.md).
