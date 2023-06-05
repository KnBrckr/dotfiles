-- init.lua

vim.opt.number = true        -- Line numbers in gutter
vim.opt.relativenumber = true
vim.opt.cursorline = true    -- highlight cursor line
vim.opt.startofline = false  -- Don't reset cursor to start of line when moving around
vim.opt.cmdheight = 2        -- Better display for messages
vim.opt.termguicolors = true -- True color support
vim.opt.mouse = 'a'          -- Mouse in all modes
vim.opt.ignorecase = true    -- Ignore case, but use smart case search
vim.opt.smartcase = true
vim.opt.wrap = true          -- Wrap long lines, preserving indent
vim.opt.breakindent = true
vim.opt.tabstop = 2          -- Default tab stop
vim.opt.shiftwidth = 2
vim.opt.scrolloff = 4        -- Keep lines before/after cursor on display
vim.opt.expandtab = false    -- Do not expand tab to spaces by default
vim.opt.signcolumn = "yes"   -- Always display the sign column
vim.opt.hlsearch = false     -- Do not highlight search token

vim.g.mapleader = ' '        -- Set map leader

-- Window Navigation
vim.keymap.set('n', '<C-h>', '<cmd>wincmd h<cr>')
vim.keymap.set('n', '<C-j>', '<cmd>wincmd j<cr>')
vim.keymap.set('n', '<C-k>', '<cmd>wincmd k<cr>')
vim.keymap.set('n', '<C-l>', '<cmd>wincmd l<cr>')
vim.keymap.set('n', '<C-\\>', '<cmd>wincmd p<cr>')

-- Faster viewport scrolling (3 lines at a time)
vim.keymap.set('n', '<C-e>', '3<C-e>')
vim.keymap.set('n', '<C-y>', '3<C-y>')
vim.keymap.set('n', '<C-e>', '3<C-e>')
vim.keymap.set('n', '<C-y>', '3<C-y>')

-- Quickfix navigation
-- [q jumps to previous quick fix list item
-- ]q jumps to next quick fix list item
vim.keymap.set('n', '[q', '<cmd>cp<cr>')
vim.keymap.set('n', ']q', '<cmd>cn<cr>')

-- Copy/Paste
vim.keymap.set('n', 'Y', 'yy')            -- Default is y$ vs whole line
vim.keymap.set({ 'n', 'x' }, 'cp', '"+y') -- Yank to clipboard
vim.keymap.set({ 'n', 'x' }, 'cv', '"+p') -- Paste from clipboard

-- Automatically strip trailing whitespace on file save
vim.cmd([[autocmd BufWritePre *.css,*.html,*.js,*.json,*.md,*.php,*.py,*.rb,*.scss,*.sh,*.txt,*.c,*.h,*.lua
									\	:call StripTrailingWhitespace()]])

-- When editing a file, always jump to the last known cursor position.
-- Don't do it when the position is invalid, when inside an event handler
-- (happens when dropping a file on gvim) and for a commit message (it's
-- likely a different one than last time).
vim.cmd([[autocmd BufReadPost *
			\ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~ 'commit'
			\ |   exe "normal! g`\""
			\ | endif]])

-- Auto-format options
--   c = auto-wrap comments
--   r = auto-insert comment leader after <enter>
--   o = auto-insert comment leader after oO
--   / = Only insert comment leader when // at start of line
--   q = Allow format with 'gq'
--   l = Do not auto-break long lines
--   n = Recognize numbers lists
--   j = Remove comment leader when joining lines
--   1 = don't break line after a one-letter word
vim.opt.formatoptions = "cro/qlnj1"

-- Improve Quickfix error detection
-- Quckfix not parsing gcc error: inlined from '<fn>' at <file>:<line>:<column>:
vim.cmd([[set errorformat^=%W\ \ \ \ inlined\ from\ %.%#\ at\ %f:%l:%c:,%Z%.%#\ warning:\ %m]])

-- Quickfix not parsing ld error: /usr/bin/ld: <file>:<line>:<error>
vim.cmd([[set errorformat^=/usr/bin/ld:\ %f:%l:\ %m]])

-- Spelling
vim.opt.spell = true
vim.opt.spelllang = "en_us"

-- Disable netrw, replaced by nvim-tree below
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
lsp_on_attach = function(client, bufnr)
	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
	vim.keymap.set('n', 'KK', vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set('n', '<space>wl', function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
	vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
	vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
	vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

-- Add plugins (config/nvim/lua/plugins)
require("lazy").setup("plugins")

-- Load local machine settings if they exist
if vim.fn.filereadable(vim.fn.glob('$HOME/.vimrc.local')) then
	vim.cmd([[source $HOME/.vimrc.local]])
end
