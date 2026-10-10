<#
.SYNOPSIS
  Install every external dependency of this Neovim configuration on Windows.

.DESCRIPTION
  Uses winget for system software, pipx for Python tools, and npm/go for the
  language servers. Safe to re-run. Run from a normal (non-admin) PowerShell:

    powershell -ExecutionPolicy Bypass -File .\scripts\win-install-deps.ps1

  See README.md ("External software checklist") for what each tool is used for.
#>

$ErrorActionPreference = 'Stop'

function Write-Step($msg) { Write-Host "`n==> $msg" -ForegroundColor Blue }
function Test-Command($name) { [bool](Get-Command $name -ErrorAction SilentlyContinue) }

if (-not (Test-Command winget)) {
    throw "winget not found. Install 'App Installer' from the Microsoft Store and retry."
}

# Reload PATH from the registry so freshly installed tools are visible.
function Update-SessionPath {
    $machine = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    $user    = [Environment]::GetEnvironmentVariable('Path', 'User')
    $env:Path = "$machine;$user"
}

# Append a directory to the *user* PATH (idempotent) and to this session.
function Add-UserPath($dir) {
    $user = [Environment]::GetEnvironmentVariable('Path', 'User')
    $parts = @($user -split ';' | Where-Object { $_ })
    if ($parts -notcontains $dir) {
        [Environment]::SetEnvironmentVariable('Path', (($parts + $dir) -join ';'), 'User')
        Write-Host "added to user PATH: $dir"
    }
    if (($env:Path -split ';') -notcontains $dir) { $env:Path += ";$dir" }
}

function Install-WingetPackage($id, $extraArgs = @()) {
    $listed = winget list --exact --id $id --accept-source-agreements 2>$null | Out-String
    if ($listed -match [regex]::Escape($id)) {
        Write-Host "$id already installed"
        return
    }
    winget install --exact --id $id --silent `
        --accept-package-agreements --accept-source-agreements @extraArgs
    # winget returns non-zero for "already installed / no upgrade"; don't abort on that.
    if ($LASTEXITCODE -ne 0) { Write-Warning "winget exited with $LASTEXITCODE for $id" }
}

# ------------------------------------------------------------ winget packages

Write-Step 'Installing packages with winget'
$packages = @(
    'Git.Git',
    'Neovim.Neovim',
    'junegunn.fzf',
    'BurntSushi.ripgrep.MSVC',
    'sharkdp.fd',
    'LLVM.LLVM',            # clangd
    'Rustlang.Rustup',
    'GoLang.Go',
    'OpenJS.NodeJS.LTS',
    'Python.Python.3.12'    # python3; pipx is installed below
)
foreach ($id in $packages) { Install-WingetPackage $id }

Write-Step 'Installing Visual Studio Build Tools (MSVC + Windows SDK)'
Install-WingetPackage 'Microsoft.VisualStudio.2022.BuildTools' @(
    '--override',
    '--wait --quiet --norestart --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended'
)

Update-SessionPath
Add-UserPath 'C:\Program Files\LLVM\bin'
Add-UserPath "$env:USERPROFILE\.cargo\bin"
Add-UserPath "$env:USERPROFILE\go\bin"

# ------------------------------------------------------------------- Rust

Write-Step 'Configuring Rust toolchain'
if (Test-Command rustup) {
    rustup default stable
    rustup component add rust-analyzer
} else {
    Write-Warning 'rustup not on PATH yet; open a new terminal and re-run this script.'
}

# ---------------------------------------------------------------- Python

Write-Step 'Installing pipx and Python tools'
if (Test-Command py) { $py = 'py' } elseif (Test-Command python) { $py = 'python' } else { $py = $null }
if (-not $py) {
    Write-Warning 'python not on PATH yet; open a new terminal and re-run this script.'
} else {
    if (-not (Test-Command pipx)) {
        & $py -m pip install --user pipx
        & $py -m pipx ensurepath
        Update-SessionPath
        # pipx lives in the user Scripts dir until PATH refreshes.
        $scripts = & $py -c "import sysconfig; print(sysconfig.get_path('scripts', 'nt_user'))"
        if ($scripts) { Add-UserPath $scripts.Trim() }
    }
    foreach ($pkg in 'ty', 'ruff') {
        if (Test-Command pipx) { pipx install --force $pkg }
        else { & $py -m pipx install --force $pkg }
    }
}

# ------------------------------------------------------------- Go / TypeScript

Write-Step 'Installing gopls'
if (Test-Command go) {
    go install golang.org/x/tools/gopls@latest
} else {
    Write-Warning 'go not on PATH yet; open a new terminal and re-run this script.'
}

Write-Step 'Installing TypeScript 5.x and typescript-language-server'
if (Test-Command npm) {
    npm install -g typescript@5 typescript-language-server
} else {
    Write-Warning 'npm not on PATH yet; open a new terminal and re-run this script.'
}

# ------------------------------------------------------- GitHub release downloads

function Get-GitHubAssetUrl($repo, $pattern) {
    $release = Invoke-RestMethod "https://api.github.com/repos/$repo/releases/latest" `
        -Headers @{ 'User-Agent' = 'nvim-config-installer' }
    ($release.assets | Where-Object { $_.name -match $pattern } | Select-Object -First 1).browser_download_url
}

$arch = if ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64') { 'arm64' } else { 'x64' }

# Lua Language Server: extract the whole archive into a permanent directory.
Write-Step 'Installing Lua Language Server'
if (-not (Test-Command lua-language-server)) {
    $url = Get-GitHubAssetUrl 'LuaLS/lua-language-server' "win32-$arch\.zip$"
    if (-not $url) { throw "no LuaLS release found for win32-$arch" }
    $dest = "$env:LOCALAPPDATA\Programs\lua-language-server"
    $zip = Join-Path $env:TEMP 'luals.zip'
    Invoke-WebRequest $url -OutFile $zip
    if (Test-Path $dest) { Remove-Item $dest -Recurse -Force }
    Expand-Archive $zip -DestinationPath $dest
    Add-UserPath "$dest\bin"
} else {
    Write-Host 'lua-language-server already installed'
}

# tree-sitter CLI: use the prebuilt binary (cargo install needs the MSVC
# environment, which a plain PowerShell session does not have).
Write-Step 'Installing tree-sitter CLI'
if (-not (Test-Command tree-sitter)) {
    $url = Get-GitHubAssetUrl 'tree-sitter/tree-sitter' "tree-sitter-windows-$arch\.gz$"
    if (-not $url) { throw "no tree-sitter CLI release found for windows-$arch" }
    $dest = "$env:LOCALAPPDATA\Programs\tree-sitter"
    New-Item -ItemType Directory -Force $dest | Out-Null
    $gz = Join-Path $env:TEMP 'tree-sitter.gz'
    Invoke-WebRequest $url -OutFile $gz
    $in  = [IO.File]::OpenRead($gz)
    $out = [IO.File]::Create("$dest\tree-sitter.exe")
    try {
        $gzip = New-Object IO.Compression.GzipStream($in, [IO.Compression.CompressionMode]::Decompress)
        $gzip.CopyTo($out)
    } finally { $out.Dispose(); $in.Dispose() }
    Add-UserPath $dest
} else {
    Write-Host 'tree-sitter already installed'
}

# ----------------------------------------------------------------- verify

Write-Step 'Verifying executables'
Update-SessionPath
$missing = $false
foreach ($cmd in 'nvim','git','fzf','rg','tree-sitter','clangd','curl.exe','tar.exe',
                 'lua-language-server','ty','ruff','rust-analyzer','rustc','cargo',
                 'go','gopls','node','npm','typescript-language-server','tsc',
                 'python','pipx') {
    if (Test-Command $cmd) { Write-Host "  ok       $cmd" }
    else { Write-Host "  MISSING  $cmd" -ForegroundColor Yellow; $missing = $true }
}
if ($missing) {
    Write-Warning 'Some tools are missing. Open a new terminal (PATH changes need it) and re-run to check.'
}

Write-Host @'

Done. Next steps:
  * Open "Developer PowerShell for Visual Studio" (needed for the MSVC compiler).
  * Follow docs/install-and-verify.md and run :TSSetup from that terminal.
'@
