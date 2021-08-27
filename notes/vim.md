# VIM Cheatsheet #

`<leader>qf` - Fix code line using suggested change

`gu<motion>` translate to lower case
`gU<motion>` translate to upper case
`~` toggle current character case (can be used in visual mode)

## vimdiff ##

```VimL
:diffget LO
:diffget RE
:diffget BA
```

## Insert mode ##

`<ctrl-r>"` Paste last yank

## Help ##

`:h i_^r`  - Help for ctrl-r in insert mode
`:h c_^r`  - Help for ctrl-r in command mode

## Gutentags Plus -- gtags/ctags ##

```VimL
:GscopeFind {type} {name}
```

{type} | Keymap | Description
---|---
s | `<leader>cs` | Find this symbol
g | `<leader>cg` | Find this definition
d | `<leader>cd` | Find functions called by this function
c | `<leader>cc` | Find functions calling this function
t | `<leader>ct` | Find text string
e | `<leader>ce` | Find egrep pattern
f | `<leader>cf` | Find file
i | `<leader>ci` | Find files #including file
a | `<leader>ca` | Find places where symbol is assigned
z | `<leader>cz` | Find current word in ctags database

### Define new mappings ###

```VimL
noremap <silent> <leader>gs :GscopeFind s <C-R><C-W><cr>
noremap <silent> <leader>gg :GscopeFind g <C-R><C-W><cr>
noremap <silent> <leader>gc :GscopeFind c <C-R><C-W><cr>
noremap <silent> <leader>gt :GscopeFind t <C-R><C-W><cr>
noremap <silent> <leader>ge :GscopeFind e <C-R><C-W><cr>
noremap <silent> <leader>gf :GscopeFind f <C-R>=expand("<cfile>")<cr><cr>
noremap <silent> <leader>gi :GscopeFind i <C-R>=expand("<cfile>")<cr><cr>
noremap <silent> <leader>gd :GscopeFind d <C-R><C-W><cr>
noremap <silent> <leader>ga :GscopeFind a <C-R><C-W><cr>
noremap <silent> <leader>gz :GscopeFind z <C-R><C-W><cr>
```
