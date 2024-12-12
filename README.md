# Personal NVIM Config

I do not recommend using this. Tailored specifically for me.

# favorite keybinds

  \<leader\>w (:write)

  \<leader\>q (:quit!)

  shift v (visual line select) (default)

  \<leader\> vv (custom) OR ctrl Q (default) (visual block select)

  \<leader\> ff (telescope file search) (plugin custom)

  \<leader\> fg (telescope regex search in files) (plugin custom)

# favorite commands

  :%s/text/newtext (replaces all occurences of text with new text)

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
