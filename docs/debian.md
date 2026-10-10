# Install on Debian

[Back to the main README](../README.md)

Run these commands in Bash. Install the distribution packages first:

```bash
sudo apt update
sudo apt install -y neovim git build-essential curl ca-certificates tar gzip \
    fzf ripgrep clangd golang nodejs npm
```

Check `nvim --version`: this configuration requires **Neovim 0.12+**.
If Debian's package is older, use the
[upstream archive instructions](linux-common.md#neovim-fallback-when-the-distribution-package-is-too-old).
Also check `fzf --version`; if it is 0.36 or older, install a newer binary from
[the official fzf releases](https://github.com/junegunn/fzf/releases) in
`~/.local/bin`.

Continue with the [shared Debian/Fedora setup](linux-common.md) to install Rust,
Tree-sitter, Python tools, Lua Language Server, and the Go and TypeScript
servers. Then follow [Install this configuration and verify](install-and-verify.md).
