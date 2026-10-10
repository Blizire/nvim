# Tree-sitter

[Back to the main README](../README.md)

Run `:TSSetup` once to install all parsers listed in `lua/treesitter.lua`.
This waits for installation to finish, including when running headless.
Parser installation needs `tree-sitter` (0.26.1 or newer), a C compiler,
`curl`, and `tar` on your PATH. Run `:TSUpdate` after updating the plugin.

Highlighting and syntax-based folding activate when a parser is available.
Files without parsers retain normal syntax highlighting. Files without Tree-sitter
folding support have no automatic folds; indentation-based folding is disabled.
Language-specific indentation remains unchanged.

- `za`: toggle the fold under the cursor.
- `zc` / `zo`: close / open a fold.
- `zM` / `zR`: close / open all folds.
- `:Inspect`: show highlighting captures under the cursor.
- `:InspectTree`: explore the syntax tree.

Folds start open so opening a file does not hide code.
