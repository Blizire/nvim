# Shell selection

[Back to the main README](../README.md)

`lua/shell.lua` configures Neovim's shell automatically before plugins load:

- **Windows:** PowerShell 7 (`pwsh`) when installed, otherwise Windows PowerShell
  (`powershell`). Output is configured for UTF-8 and compatible redirection.
- **macOS / Linux / WSL:** Bash from PATH, using `-c` for shell commands.
- If the preferred executable is missing, Neovim keeps its existing shell and
  displays a warning. No login-shell or operating-system settings are changed.

This controls shell-based commands such as `:!`, `:read !`, `:make`, and the
shell started by a bare `:terminal`. Programs started directly (such as LSP
servers) still use their own commands. PowerShell runs without loading profiles;
Bash command execution is non-interactive and does not load interactive aliases.
Use `:set shell? shellcmdflag?` to check the selected shell.
