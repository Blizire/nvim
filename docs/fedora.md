# Install on Fedora

[Back to the main README](../README.md)

Run these commands in Bash:

```bash
sudo dnf install -y neovim git gcc gcc-c++ make curl ca-certificates tar gzip \
    fzf ripgrep clang-tools-extra golang nodejs npm
```

Fedora provides `clangd` through
[`clang-tools-extra`](https://packages.fedoraproject.org/pkgs/llvm/clang-tools-extra/).
Check `nvim --version` for **0.12+**. If your Fedora release ships an older
version, use the
[upstream archive instructions](linux-common.md#neovim-fallback-when-the-distribution-package-is-too-old).
Then complete the [shared Debian/Fedora setup](linux-common.md) and follow
[Install this configuration and verify](install-and-verify.md).
