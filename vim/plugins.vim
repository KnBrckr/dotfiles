" Plugin Settings

" --------------------------------------------------------------------------------
" Gutentags
"

" Enable gtags module
let g:gutentags_modules = [ 'ctags', 'gtags_cscope' ]

" Don't define all gutentag project roots by default to reduce disk accesses
let g:gutentags_add_default_project_roots = 0
let g:gutentags_project_root = ['.git', 'package.json']

" Put all tag files in a single location
let g:gutentags_cache_dir = expand('~/.cache/vim/ctags')
" Provide a simple method to clear the cache
command! -nargs=0 GutentagsClearCache call system('rm ' . g:gutentags_cache_dir . '/*')

let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_write = 1
let g:gutentags_generate_on_empty_buffer = 0

" Generate more info for tags
" Explaining --fields=+ailmnS (info gathered from: $ ctags --list-fields)
" a: Access (or export) of class members
" i: Inheritance information
" l: Language of input file containing tag
" m: Implementation information
" n: Line number of tag definition
" S: Signature of routine (e.g. prototype or parameter list)
let g:gutentags_ctags_extra_args = [
      \ '--tag-relative=yes',
      \ '--fields=+ailmnS',
      \ ]

" For debug tracing set gutentags_define_advanced_commands then:
" Restart vim and execute :GutentagsToggleTrace
" Open some files, regenerate gtags with :GutentagsUpdate
" See :messages for trace data
" let g:gutentags_define_advanced_commands = 1

"--------------------------------------------------------------------------------
" gutentags_plus
"

" change focus to quickfix window after search
let g:gutentags_plus_switch = 1

"--------------------------------------------------------------------------------
" Configure NERDTree
"

" start with NERDTree open on empty vim session
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Toggle display of NERDTree
nnoremap <Leader>t :NERDTreeToggle<CR>

" Find current file in NERDTree
nnoremap <Leader>v :NERDTreeFind<CR>

" Automatically close NERDTree when a file is opened
let NERDTreeQuitOnOpen = 1

" Exit Vim if NERDTree is the only window left.
autocmd vimStartup BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Use installed nerd fonts for git status symbols in NERDTree
let g:NERDTreeGitStatusUseNerdFonts = 1

"--------------------------------------------------------------------------------
" Silver Searcher + FZF + ripgrep
"

let g:fzf_preview_window = ['right,50%', 'ctrl-/']

" Use ripgrep for :grep
set grepprg=rg\ --vimgrep

" Use ctrl-a/ctrl-d to select/deselect all items in :Ag list
let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all,ctrl-d:deselect-all'

" Display file list based on git repo
nnoremap <C-p> :GFiles<CR>

" Display Buffer list for quick navigation
nnoremap <Leader>b :Buffers<CR>

" AgIn: Start ag in the specified directory
"
" e.g.
"   :AgIn .. foo
function! s:ag_in(bang, ...)
	let start_dir=expand(a:1)

	if !isdirectory(start_dir)
		throw 'not a valid directory: ' . start_dir
	endif
	" Press `?' to enable preview window.
	call fzf#vim#ag(join(a:000[1:], ' '), fzf#vim#with_preview({'dir': start_dir}, 'right:50%:hidden', '?'), a:bang)
endfunction

command! -bang -nargs=+ -complete=dir AgIn call s:ag_in(<bang>0, <f-args>)

" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --no-ignore: Do not respect .gitignore, etc...
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
" --color: Search color options

command! -bang -nargs=* Find
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --glob "!*build*/" --glob "!notused" --color "always" '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=* FindCword
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(expand('<cword>')), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

nnoremap <Leader>fw :FindCword<CR>

command! -bang Gstat
  \ call fzf#run(fzf#wrap(
  \     {'source': 'git diff --name-only $(git merge-base HEAD "main")'}))

nnoremap <Leader>s :Gstat<CR>
