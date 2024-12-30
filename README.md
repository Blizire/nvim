# Personal NVIM Config

I do not recommend using this. Tailored specifically for me.

# favorite keybinds

  \<leader\>w (:write)

  \<leader\>q (:quit!)

  shift v (visual line select) (default)

  \<leader\> vv (custom) OR ctrl Q (default) (visual block select)

# favorite commands

  :%s/text/newtext (replaces all occurences of text with new text)

# telescope (fuzzy search file finder)

https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#usage

Trigger Search Menu

  \<leader\> ff search for files/directories

  \<leader\> fg search text in files with regex

  \<leader\> fb search for open buffers

  \<leader\> fh search files with help tags

Menu Shortcuts

\<C-x\>, \<C-v\> : split horizontal/vertical
\<C-t\> : goto file in newtab

# macro guide

ex   : qwf;a\<CR\>\<ESC\>q

desc : finds a semicolon on line and appends newline char

use  : @w ( @@ for repeat )

q     - starts the macro

w     - key to register macro too

f     - follow char 

;     - char to follow

a     - append

\<CR\>  - enter key

\<ESC\> - go normal mode

q     - end macro recording
