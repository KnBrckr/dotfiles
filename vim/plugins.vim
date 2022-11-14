" Plugin Settings

"--------------------------------------------------------------------------------
" Configure cmake4vim plugin
"

" Save files and build (Make)
nnoremap <leader>m :wa <bar> :CMakeBuild <cr>

" Redefine CTest command to include --output-on-failure
autocmd vimStartup VimEnter * command! -nargs=? CTest :call cmake4vim#CTest('--output-on-failure', <f-args>)

" Quickfix list error format for ctest errors using CMocka environment
"
" General assertion failure:
"   [  ERROR   ] --- <error text>
"   [   LINE   ] --- <file>:<line>: error: Failure!
set errorformat^=%E[\ \ %tRROR\ \ \ ]\ ---\ %m,%Z[\ \ \ LINE\ \ \ ]\ ---\ %f:%l:\ error:\ Failure!
" fail() Error format: 
"   [ ERROR ] --- [   LINE   ] --- <file>|<line>| error: <error text>
set errorformat^=[\ \ %tRROR\ \ \ ]\ ---\ [\ \ \ LINE\ \ \ ]\ ---\ %f:%l:\ error:\ %m
" Cmock test setup failure:
"   [   LINE   ] --- <file>:<line>: error: <error text>
set errorformat^=[\ \ \ LINE\ \ \ ]\ ---\ %f:%l:\ %trror:\ %m

" Quckfix not parsing gcc error: inlined from '<fn>' at <file>:<line>:<column>:
"
set errorformat^=%W\ \ \ \ inlined\ from\ %.%#\ at\ %f:%l:%c:,%Z%.%#\ warning:\ %m

" Quickfix not parsing ld error: /usr/bin/ld: <file>:<line>:<error>
"
set errorformat^=/usr/bin/ld:\ %f:%l:\ %m

" Quickfix not parsing cmake error:
"   CMake Error at <file>:<line> (add_library)
"     Cannot file source file:
"
"     <missing-file>
set errorformat^=CMake\ Error\ at\ %f:%l\ (%m):

""--------------------------------------------------------------------------------
" coc.nvim configuration
" https://github.com/neoclide/coc.nvim/tree/release
"

" Change update time (milliseconds) to more frequently update git gutter
" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" Some servers have issues with backup files, see #649 (for coc.nvim)
set nobackup
set nowritebackup

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[c` and `]c` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Goto code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd vimStartup CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Remap for formatting 
xmap <leader>f  <Plug>(coc-format)
nmap <leader>f  <Plug>(coc-format)
xmap <leader>F  <Plug>(coc-format-selected)
nmap <leader>F  <Plug>(coc-format-selected)

augroup vimStartup
	" Setup formatexpr specified filetype(s).
	autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
	" Update signature help on jump placeholder
	autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" Use [h and ]h to navigate git hunks
nmap <silent> [h <Plug>(coc-git-prevchunk)
nmap <silent> ]h <Plug>(coc-git-nextchunk)

" Show chunk diff at current position
nmap gs <Plug>(coc-git-chunkinfo)

" Stage the current chunk
nmap ga :CocCommand git.chunkStage <CR>

" Yank first diagnostic message for current line into the paste buffer.
nnoremap <silent> <leader>diag :call StatusDiagnosticToClipboard()<CR>
function! StatusDiagnosticToClipboard()
	call setreg('+','')
	let diagList=CocAction('diagnosticList')
	let line=line('.')
	for diagItem in diagList
		if line == diagItem['lnum']
			let str=diagItem['message']
			call setreg('+',str)
			return
		endif
	endfor
endfunction

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
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --glob "!*build*/" --glob "!notused" --color "always" '.shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0)

