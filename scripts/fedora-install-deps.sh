#!/usr/bin/env bash
# Install every external dependency of this Neovim configuration on Fedora.
# Safe to re-run.
#
#   ./scripts/fedora-install-deps.sh
#
# See README.md ("External software checklist") for what each tool is used for.

set -euo pipefail

NVIM_MIN="0.12.0"
FZF_MIN="0.37.0"   # README requires fzf newer than 0.36
GO_MIN="1.22.0"    # gopls requirement

LOCAL_BIN="$HOME/.local/bin"
LOCAL_OPT="$HOME/.local/opt"

log()  { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33mwarning:\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31merror:\033[0m %s\n' "$*" >&2; exit 1; }
have() { command -v "$1" >/dev/null 2>&1; }

# ver_ge A B: true when version A >= version B.
ver_ge() { [ "$(printf '%s\n%s\n' "$2" "$1" | sort -V | head -n1)" = "$2" ]; }

# GitHub release helper: gh_asset_url OWNER/REPO REGEX -> first matching download URL.
gh_asset_url() {
  curl -fsSL "https://api.github.com/repos/$1/releases/latest" \
    | grep -o '"browser_download_url": *"[^"]*"' \
    | cut -d'"' -f4 \
    | grep -E "$2" | head -n1
}

# ---------------------------------------------------------------- detection

[ "$(uname -s)" = Linux ] || die "this script is for Fedora"
[ -r /etc/os-release ] || die "cannot read /etc/os-release"
. /etc/os-release
case " ${ID:-} ${ID_LIKE:-} " in
  *" fedora "*|*" rhel "*) ;;
  *) die "unsupported distribution: ${ID:-unknown} (this script is for Fedora)" ;;
esac

case "$(uname -m)" in
  x86_64|amd64)  ARCH=x86_64 ;;
  aarch64|arm64) ARCH=arm64 ;;
  *) die "unsupported architecture: $(uname -m)" ;;
esac

SUDO=""
if [ "$(id -u)" -ne 0 ]; then
  have sudo || die "sudo is required to install system packages"
  SUDO="sudo"
else
  warn "running as root: user-level tools will be installed into root's home"
fi

mkdir -p "$LOCAL_BIN" "$LOCAL_OPT"
export PATH="$LOCAL_BIN:$HOME/.cargo/bin:$HOME/go/bin:$LOCAL_OPT/go/bin:$PATH"

# Persist PATH additions for new terminals (idempotent).
persist_path() {
  local rc="$HOME/.bashrc" marker="# >>> nvim-config deps >>>"
  grep -qF "$marker" "$rc" 2>/dev/null && return
  {
    echo "$marker"
    echo 'export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/go/bin:$HOME/.local/opt/go/bin:$PATH"'
    echo "# <<< nvim-config deps <<<"
  } >> "$rc"
  echo "updated PATH in $rc"
}

# --------------------------------------------------------- system packages

install_system_packages() {
  log "Installing dnf packages"
  $SUDO dnf install -y \
    neovim git gcc gcc-c++ make curl ca-certificates tar gzip unzip \
    fzf ripgrep fd-find clang-tools-extra golang nodejs npm \
    python3 python3-pip pipx
}

# ------------------------------------------- tools needing newer versions

ensure_neovim() {
  local cur=""
  have nvim && cur="$(nvim --version | sed -n '1s/^NVIM v\([0-9.]*\).*/\1/p')"
  if [ -n "$cur" ] && ver_ge "$cur" "$NVIM_MIN"; then
    echo "neovim $cur ok"; return
  fi
  log "Installing upstream Neovim (found: ${cur:-none}, need >= $NVIM_MIN)"
  local name="nvim-linux-$ARCH"
  curl -fL "https://github.com/neovim/neovim/releases/latest/download/$name.tar.gz" -o "/tmp/$name.tar.gz"
  rm -rf "${LOCAL_OPT:?}/$name"
  tar -xzf "/tmp/$name.tar.gz" -C "$LOCAL_OPT"
  ln -sfn "$LOCAL_OPT/$name/bin/nvim" "$LOCAL_BIN/nvim"
  hash -r
  nvim --version | head -n1
}

ensure_fzf() {
  local cur=""
  have fzf && cur="$(fzf --version | awk '{print $1}')"
  if [ -n "$cur" ] && ver_ge "$cur" "$FZF_MIN"; then
    echo "fzf $cur ok"; return
  fi
  log "Installing upstream fzf (found: ${cur:-none}, need >= $FZF_MIN)"
  local garch=amd64; [ "$ARCH" = arm64 ] && garch=arm64
  local url; url="$(gh_asset_url junegunn/fzf "linux_${garch}\.tar\.gz$")"
  [ -n "$url" ] || die "could not find an fzf release for linux_$garch"
  curl -fL "$url" -o /tmp/fzf.tar.gz
  tar -xzf /tmp/fzf.tar.gz -C "$LOCAL_BIN" fzf
  hash -r
  fzf --version
}

ensure_go() {
  local cur=""
  have go && cur="$(go version | sed 's/.*go\([0-9][0-9.]*\).*/\1/')"
  if [ -n "$cur" ] && ver_ge "$cur" "$GO_MIN"; then
    echo "go $cur ok"; return
  fi
  log "Installing upstream Go (found: ${cur:-none}, need >= $GO_MIN)"
  local garch=amd64; [ "$ARCH" = arm64 ] && garch=arm64
  local ver; ver="$(curl -fsSL 'https://go.dev/VERSION?m=text' | head -n1)"
  curl -fL "https://go.dev/dl/$ver.linux-$garch.tar.gz" -o /tmp/go.tar.gz
  rm -rf "$LOCAL_OPT/go"
  tar -xzf /tmp/go.tar.gz -C "$LOCAL_OPT"
  hash -r
  go version
}

ensure_lua_ls() {
  if have lua-language-server; then echo "lua-language-server ok"; return; fi
  log "Installing Lua Language Server"
  local larch=x64; [ "$ARCH" = arm64 ] && larch=arm64
  local url; url="$(gh_asset_url LuaLS/lua-language-server "linux-${larch}\.tar\.gz$")"
  [ -n "$url" ] || die "could not find a LuaLS release for linux-$larch"
  local dest="$LOCAL_OPT/lua-language-server"
  rm -rf "$dest"; mkdir -p "$dest"
  curl -fL "$url" -o /tmp/luals.tar.gz
  tar -xzf /tmp/luals.tar.gz -C "$dest"
  # Wrapper keeps the binary next to its supporting files.
  cat > "$LOCAL_BIN/lua-language-server" <<'EOF'
#!/bin/sh
exec "$HOME/.local/opt/lua-language-server/bin/lua-language-server" "$@"
EOF
  chmod +x "$LOCAL_BIN/lua-language-server"
  hash -r
}

# ------------------------------------------------- language toolchains

install_rust() {
  log "Installing Rust toolchain and rust-analyzer"
  if ! have rustup; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o /tmp/rustup-init.sh
    sh /tmp/rustup-init.sh -y --default-toolchain stable --no-modify-path
  fi
  . "$HOME/.cargo/env"
  rustup default stable
  rustup component add rust-analyzer
  if ! have tree-sitter; then
    log "Building tree-sitter-cli with cargo (this takes a few minutes)"
    cargo install --locked tree-sitter-cli
  fi
}

install_python_tools() {
  log "Installing Python tools with pipx"
  have python3 || die "python3 not found"
  have pipx || python3 -m pip install --user pipx
  pipx ensurepath || true
  for pkg in ty ruff; do
    if pipx list --short 2>/dev/null | grep -q "^$pkg "; then
      pipx upgrade "$pkg" || true
    else
      pipx install "$pkg"
    fi
  done
}

install_go_and_ts_servers() {
  log "Installing gopls"
  have gopls || go install golang.org/x/tools/gopls@latest

  log "Installing TypeScript 5.x and typescript-language-server"
  if [ ! -w "$(npm prefix -g 2>/dev/null || echo /)" ]; then
    # Avoid sudo for global npm packages (see docs/linux-common.md).
    npm config set prefix "$HOME/.local"
  fi
  npm install -g typescript@5 typescript-language-server
}

# --------------------------------------------------------------- verify

verify() {
  log "Verifying executables"
  local missing=0 cmd
  for cmd in nvim git fzf rg tree-sitter cc curl tar lua-language-server ty ruff \
             rust-analyzer rustc cargo clangd go gopls node npm \
             typescript-language-server tsc python3 pipx; do
    if have "$cmd"; then
      printf '  ok       %s\n' "$cmd"
    else
      printf '  MISSING  %s\n' "$cmd"; missing=1
    fi
  done
  [ "$missing" -eq 0 ] || warn "some tools are missing; open a new terminal and re-run to check PATH"
}

main() {
  log "Detected: Fedora ($ARCH)"
  install_system_packages
  ensure_neovim
  ensure_fzf
  ensure_go
  ensure_lua_ls
  install_rust
  install_python_tools
  install_go_and_ts_servers
  persist_path
  verify
  log "Done. Open a new terminal, then follow docs/install-and-verify.md (run :TSSetup in nvim)."
}

main "$@"
