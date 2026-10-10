# Clipboard (all operating systems)

[Back to the main README](../README.md)

`lua/clipboard.lua` uses Neovim's built-in OSC 52 support to copy through your
terminal, including inside Zellij and over SSH. No separate clipboard utility
is needed. The terminal and any multiplexers in the connection must support
OSC 52 writes; automatic provider detection is bypassed.

- Normal `y`, `yy`, and visual-mode yanks copy to both Neovim's internal register
  and the system clipboard.
- `p` / `P` paste from Neovim's internal registers. Deletes and changes retain
  normal Vim behavior without replacing the system clipboard.
- Paste text copied from another application using your terminal's paste action
  (commonly Cmd-V on macOS or Ctrl-Shift-V on Linux/Windows; bindings vary).
- Explicit named-register yanks stay internal. Use `"+y` for an explicit system
  clipboard copy. Avoid `"+p`: it requests a clipboard read through OSC 52,
  which Zellij blocks by default and some terminals do not support.

Keep Zellij's clipboard-read permission at its default; this workflow only needs
writes. To test, yank a line in Neovim and paste into another application, then
copy text in that application and use your terminal's paste action in Neovim.
