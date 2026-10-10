# Install on Windows

[Back to the main README](../README.md)

These steps target native Windows 10/11 using PowerShell and WinGet. For WSL,
follow the instructions for the Linux distribution inside WSL instead.

## Editor and command-line tools

Install [App Installer](https://learn.microsoft.com/windows/package-manager/winget/)
if `winget` is unavailable. Run:

```powershell
winget install --exact --id Git.Git
winget install --exact --id Neovim.Neovim
winget install --exact --id junegunn.fzf
winget install --exact --id BurntSushi.ripgrep.MSVC
winget install --exact --id LLVM.LLVM
winget install --exact --id Rustlang.Rustup
winget install --exact --id GoLang.Go
winget install --exact --id OpenJS.NodeJS.LTS
```

LLVM supplies `clangd`; add `C:\Program Files\LLVM\bin` to your **user PATH**
through Windows' Environment Variables settings if the installer did not.
Restart the terminal after installation so it sees the updated PATH.

## Compiler and Windows SDK

Install [Visual Studio Build Tools](https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio).
In its installer, select **Desktop development with C++**, including the MSVC
compiler and a Windows SDK. LLVM alone does not supply that SDK.

Open **Developer PowerShell for Visual Studio** from the Start menu after
installation. Use that terminal for `cargo install`, `:TSSetup`, and future
parser updates so the compiler and SDK are available. Verify the compiler with
`Get-Command cl`, then run:

```powershell
rustup default stable
rustup component add rust-analyzer
cargo install --locked tree-sitter-cli
```

## Go and TypeScript servers

Open a new terminal (so `go`, `node`, and `npm` are on PATH) and run:

```powershell
go install golang.org/x/tools/gopls@latest
npm install -g typescript@5 typescript-language-server
```

Add `$env:USERPROFILE\go\bin` to your **user PATH** so `gopls` is found.

## Python tools

Install uv using its [official PowerShell installer](https://docs.astral.sh/uv/getting-started/installation/):

```powershell
powershell -ExecutionPolicy Bypass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

Open a new Developer PowerShell terminal, then run:

```powershell
uv tool install ty
uv tool install ruff
uv tool update-shell
```

Reopen the terminal if `uv tool update-shell` changes PATH. A separate Python
installation is not needed for these tools; uv can install it when required.

## Lua Language Server

Download the Windows archive matching your architecture from the
[official LuaLS releases](https://github.com/LuaLS/lua-language-server/releases/latest).
Extract the entire archive into a permanent directory such as
`$env:LOCALAPPDATA\Programs\lua-language-server` and add its `bin` directory
to your **user PATH**. Keep the adjacent `script`, `meta`, and other supplied
files; do not move only the executable. Open a new terminal and verify:

```powershell
lua-language-server --version
Get-Command nvim, git, fzf, rg, tree-sitter, clangd, rust-analyzer, ty, ruff, go, gopls, node, typescript-language-server
Get-Command curl.exe, tar.exe
```

Current Windows 10/11 installations normally include `curl.exe` and `tar.exe`.
Use a Developer PowerShell terminal for the parser-installation step in
[Install this configuration and verify](install-and-verify.md).
