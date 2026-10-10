#!/usr/bin/env bash
# Install every external dependency of this Neovim configuration on macOS.
# Safe to re-run.
#
#   ./scripts/macos-install-deps.sh
#
# See README.md ("External software checklist") for what each tool is used for.

set -euo pipefail

log()  { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33mwarning:\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31merror:\033[0m %s\n' "$*" >&2; exit 1; }
have() { command -v "$1" >/dev/null 2>&1; }

[ "$(uname -s)" = Darwin ] || die "this script is for macOS"

export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/go/bin:$PATH"

# --------------------------------------------------------- prerequisites

install_prerequisites() {
  if ! xcode-select -p >/dev/null 2>&1; then
    log "Installing Xcode command-line tools"
    xcode-select --install || true
    die "finish the Xcode command-line tools installer, then re-run this script"
  fi

  if ! have brew; then
    log "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  if ! have brew; then
    local b
    for b in /opt/homebrew/bin/brew /usr/local/bin/brew; do
      if [ -x "$b" ]; then eval "$("$b" shellenv)"; break; fi
    done
  fi
  have brew || die "Homebrew not found on PATH after install"
}

# --------------------------------------------------------- Homebrew packages

install_brew_packages() {
  log "Installing Homebrew packages"
  # llvm is keg-only and provides clangd; typescript is deliberately NOT
  # installed here (Homebrew ships TS 7, which lacks the tsserver needed by
  # typescript-language-server). It comes from npm below.
  brew install neovim git fzf ripgrep fd tree-sitter-cli lua-language-server \
    llvm go gopls node python pipx
  export PATH="$(brew --prefix llvm)/bin:$PATH"
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
}

install_python_tools() {
  log "Installing Python tools with pipx"
  pipx ensurepath || true
  local pkg
  for pkg in ty ruff; do
    if pipx list --short 2>/dev/null | grep -q "^$pkg "; then
      pipx upgrade "$pkg" || true
    else
      pipx install "$pkg"
    fi
  done
}

install_ts_server() {
  log "Installing TypeScript 5.x and typescript-language-server"
  npm install -g typescript@5 typescript-language-server
}

# ----------------------------------------------------------------- PATH

# Persist PATH additions for new terminals (idempotent).
persist_path() {
  local rc="$HOME/.zshrc" marker="# >>> nvim-config deps >>>"
  grep -qF "$marker" "$rc" 2>/dev/null && return
  {
    echo "$marker"
    echo 'export PATH="$(brew --prefix llvm)/bin:$HOME/.local/bin:$HOME/.cargo/bin:$HOME/go/bin:$PATH"'
    echo "# <<< nvim-config deps <<<"
  } >> "$rc"
  echo "updated PATH in $rc (add the same line to ~/.bashrc if bash is your shell)"
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
  log "Detected: macOS ($(uname -m))"
  install_prerequisites
  install_brew_packages
  install_rust
  install_python_tools
  install_ts_server
  persist_path
  verify
  log "Done. Open a new terminal, then follow docs/install-and-verify.md (run :TSSetup in nvim)."
}

main "$@"
