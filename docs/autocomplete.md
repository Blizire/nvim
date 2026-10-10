# Autocomplete

[Back to the main README](../README.md)

`lua/autocomeplete.lua` configures blink.cmp using the latest stable release.
It uses the pure-Lua matcher, so no native matcher download or build is needed.
Suggestions appear while typing, with documentation for the selected item and
experimental automatic function-signature help. LSP, path, snippet, and buffer
sources are enabled; buffer words are a fallback, not proof of scope validity.

Insert-mode controls:

- `Ctrl-n` / `Ctrl-p` or arrow keys: select the next / previous suggestion.
- `Ctrl-y`: accept the selected suggestion (or the first if none is selected).
- `Ctrl-space`: request suggestions or toggle completion documentation.
- `Ctrl-e`: dismiss suggestions.
- `Tab` / `Shift-Tab`: move between snippet parameter placeholders when available.
- `Ctrl-s`: toggle signature help.
- `Ctrl-b` / `Ctrl-f`: scroll completion documentation.

Enter keeps its normal newline behavior. Parameter placeholders and library
information depend on the language server and the project's dependencies.
Use `:BlinkCmp status` or `:checkhealth blink.cmp` to troubleshoot. Use `:lua vim.pack.update({ "blink.cmp" })` to check for newer stable releases;
review release notes before accepting updates. The lockfile records the installed
revision. Major releases may require configuration changes.
