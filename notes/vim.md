# VIM Cheatsheet #

`<leader>qf` - Fix code line using suggested change

`gu<motion>` translate to lower case
`gU<motion>` translate to upper case
`~` toggle current character case (can be used in visual mode)

## git change ##

`gs` Show git change at current line

## vimdiff ##

```VimL
:diffget LO
:diffget RE
:diffget BA
```

## Swap text ##
delete first section of text
with visual mode, highlight 2nd section of text and use 'p'aste.
Go back to first location and paste 2nd selection.

## Insert mode ##

`<ctrl-r>"` Paste last yank

`C-k <2-character-shortcut>` Inserts unicode characters. See :help :digraph

## Help ##

`:h i_^r`  - Help for ctrl-r in insert mode
`:h c_^r`  - Help for ctrl-r in command mode

## Telescope ##

`c-q` Copy results to quickfix list

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

### makefiles ###

```VimL
:map <fn> :make  -- Map fn key to make command
:set makeprg     -- Change what :make does

:copen           -- Open mini-window of errors
:ccl[ose]        -- closes mini-window
:cw              -- toggle mini-window
```

### Auto-update copyrights ###

(Based on: [https://vim.fandom.com/wiki/Automatically_Update_Copyright_Notice_in_Files])

Place in .vimrc:

```VimL
augroup vimrc
  " Remove all vimrc commands
  autocmd!

  " Automatically update copyright notice with current year
  autocmd BufWritePre *
    \ if &modified |
    \   exe "g#\\cCOPYRIGHT (c) \\(".strftime("%Y")."\\)\\@![0-9]\\{4\\}\\(-".strftime("%Y")."\\)\\@!#s#\\([0-9]\\{4\\}\\)\\(-[0-9]\\{4\\}\\)\\?#\\1-".strftime("%Y") |
    \ endif
augroup END
```

## Batch mode processing ##

    find -print0 | xargs -0 -L 10 nvim -u <path to init.lua> -es -S <command script>

## Column formatting

Select rows in visual mode then:
`:! tr -s ' ' | column -t -s '|' -o '|'`
