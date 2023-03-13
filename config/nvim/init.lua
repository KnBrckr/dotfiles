-- init.lua

vim.opt.number = true         -- Line numbers in gutter
vim.opt.relativenumber = true
vim.opt.cursorline = true     -- highlight cursor line
vim.opt.startofline = false  -- Don't reset cursor to start of line when moving around
vim.opt.cmdheight = 2 -- Better display for messages
vim.opt.termguicolors = true -- True color support
vim.opt.mouse = 'a'        -- Mouse in all modes
vim.opt.ignorecase = true -- Ignore case, but use smart case search
vim.opt.smartcase = true
vim.opt.wrap = true -- Wrap long lines, preserving indent
vim.opt.breakindent = true
vim.opt.tabstop = 2 -- Default tab stop
vim.opt.shiftwidth = 2
vim.opt.expandtab = false -- Do not expand tab to spaces by default
vim.opt.signcolumn = "yes"  -- Always display the sign column

vim.g.mapleader = ' ' -- Set map leader

-- Copy/Paste 
vim.keymap.set('n', 'Y', 'yy') -- Default is y$ vs whole line
vim.keymap.set({'n', 'x'}, 'cp', '"+y') -- Yank to clipboard
vim.keymap.set({'n', 'x'}, 'cv', '"+p') -- Paste from clipboard

-- Faster viewport scrolling (3 lines at a time)
vim.keymap.set('n', '<C-e>', '3<C-e>')
vim.keymap.set('n', '<C-y>', '3<C-y>')
vim.keymap.set('n', '<C-e>', '3<C-e>')
vim.keymap.set('n', '<C-y>', '3<C-y>')

-- Window Navigation
vim.keymap.set('n', '<C-h>', '<cmd>wincmd h<cr>')
vim.keymap.set('n', '<C-j>', '<cmd>wincmd j<cr>')
vim.keymap.set('n', '<C-k>', '<cmd>wincmd k<cr>')
vim.keymap.set('n', '<C-l>', '<cmd>wincmd l<cr>')
vim.keymap.set('n', '<C-\\>', '<cmd>wincmd p<cr>')

-- When editing a file, always jump to the last known cursor position.
-- Don't do it when the position is invalid, when inside an event handler
-- (happens when dropping a file on gvim) and for a commit message (it's
-- likely a different one than last time).
vim.cmd([[ autocmd BufReadPost *
			\ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~ 'commit'
			\ |   exe "normal! g`\""
			\ | endif ]])

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
vim.opt.formatoptions="cro/qlnj1"

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

-- Add plugins
require("lazy").setup({
	-- Colorscheme should be available when starting Neovim
	{
		"altercation/vim-colors-solarized",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme solarized]])
			vim.api.nvim_create_autocmd("VimEnter", {
				pattern="*",
				callback = function(ev)
					-- Insert any highlight commands required to override color scheme defaults
					vim.cmd([[hi FgCocHintFloatBgCocFloating ctermbg=8]])

					-- Display comments in italic
					vim.cmd([[hi Comment cterm=italic gui=italic]])
				end
			})
    end,
  },

	-- Treesitter based syntax highlights
	{
		"nvim-treesitter/nvim-treesitter",
    config = function()
			require('nvim-treesitter.configs').setup({
				highlight = {
					enable = true,
				},
				ensure_installed = {
				-- 	'awk',
				-- 	'bash',
				-- 	'cmake',
				-- 	'c',
				-- 	'dockerfile',
				-- 	'dot',
				-- 	'json',
				-- 	'lua',
				-- 	'make',
				-- 	'markdown',
				-- 	'ninja',
				-- 	'perl',
				-- 	'python',
				-- 	'regex',
				-- 	'todotxt',
				-- 	'vim',
				-- 	'yaml',
				},
			})
    end,
	},

	-- LSP Support
  { 
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require('lspconfig')

			-- Mappings.
			-- See `:help vim.diagnostic.*` for documentation on any of the below functions
			local opts = { noremap=true, silent=true }
			vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts) -- Open floating error window
			vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)        -- Previous diagnostic
			vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)        -- Next diagnostic
			vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts) -- Add diagnostics to location list

			-- Use an on_attach function to only map the following keys
			-- after the language server attaches to the current buffer
			local on_attach = function(client, bufnr)
				-- Mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local bufopts = { noremap=true, silent=true, buffer=bufnr }
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

			local lsp_flags = {
				-- This is the default in Nvim 0.7+
				debounce_text_changes = 150,
			}

			-- Add additional capabilities supported by nvim-cmp
			local capabilities = require('cmp_nvim_lsp').default_capabilities()
			
			-- local mason_lspconfig = require('mason-lspconfig')
			-- mason_lspconfig.setup {
			-- 	ensure_installed = {
			-- 		"bash-language-server",
			-- 	},
			-- }

			lspconfig.clangd.setup({
				on_attach = on_attach,
				flags = lsp_flags,
				capabilities = capabilities,
			})

			lspconfig.bashls.setup { }

			lspconfig.lua_ls.setup { }

			-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lua_ls
			-- lspconfig.lua.setup({
			-- 	on_attach = on_attach,
			-- 	flags = lsp_flags,
			-- })
		end,
		dependencies = {
			{ 
				"williamboman/mason-lspconfig.nvim",
				config = function()
					local mason_lspconfig = require('mason-lspconfig')

					mason_lspconfig.setup { }

					-- mason_lspconfig.setup_handlers {
					-- 	-- First entry (without a key) is the default handler
					-- 	-- and will be called for each installed server that doesn't have
					-- 	-- a dedicated handler.
					-- 	function(server_name) -- default handler
					-- 		require("lspconfig")[server_name].setup {}
					-- 	end,
					-- 	-- Next provide dedicated handler for specific servers.
					-- 	-- For example:
					-- 	-- ["rust_analyzer"] = function()
					-- 		-- require("rust-tools").setup {}
					-- 	-- end,
					-- } 
				end,
				dependencies = {
					{ 
						"williamboman/mason.nvim",
						config = function()
							require("mason").setup()
						end,
					},
				}
			},
			{
				"hrsh7th/nvim-cmp",
				config = function()
					local cmp = require('cmp')
					local luasnip = require('luasnip')
					
					local select_opts = { behavior = cmp.SelectBehavior.Select }

					cmp.setup({
						snippet = {
							expand = function(args)
								luasnip.lsp_expand(args.body)
							end,
						},
						sources = {
							{ name = 'path' },
							{ name = 'nvim_lsp', keyword_length = 1 },
							{ name = 'buffer', keyword_length = 3 },
							{ name = 'luasnip', keyword_length = 2 },
						},
						window = {
							documentation = cmp.config.window.bordered(),
						},
						formatting = {
							fields = { 'menu', 'abbr', 'kind' },
							format = function(entry, item)
								local menu_icon = {
									nvim_lsp = 'λ',
									luasnip = '⋗',
									buffer = 'Ω',
									path = string.format('')
								}

								item.menu = menu_icon[entry.source.name]
								return item
							end,
						},
						mapping = {
							['<Up>'] = cmp.mapping.select_prev_item(select_opts),
							['<Down>'] = cmp.mapping.select_next_item(select_opts),

							['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
							['<C-n>'] = cmp.mapping.select_next_item(select_opts),

							['<C-u>'] = cmp.mapping.scroll_docs(-4),
							['<C-d>'] = cmp.mapping.scroll_docs(4),

							['<C-e>'] = cmp.mapping.abort(),
							['<C-y>'] = cmp.mapping.confirm({select = true}),
							['<CR>'] = cmp.mapping.confirm({select = false}),

							['<C-f>'] = cmp.mapping(function(fallback)
								if luasnip.jumpable(1) then
									luasnip.jump(1)
								else
									fallback()
								end
							end, {'i', 's'}),

							['<C-b>'] = cmp.mapping(function(fallback)
								if luasnip.jumpable(-1) then
									luasnip.jump(-1)
								else
									fallback()
								end
							end, {'i', 's'}),

							['<Tab>'] = cmp.mapping(function(fallback)
								local col = vim.fn.col('.') - 1

								if cmp.visible() then
									cmp.select_next_item(select_opts)
								elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
									fallback()
								else
									cmp.complete()
								end
							end, {'i', 's'}),

							['<S-Tab>'] = cmp.mapping(function(fallback)
								if cmp.visible() then
									cmp.select_prev_item(select_opts)
								else
									fallback()
								end
							end, {'i', 's'}),
						},
					})
				end,
				dependencies = {
					{
						"L3MON4D3/LuaSnip",
						-- follow latest release.
						version = "1.*",
						-- install jsregexp (optional!).
						build = "make install_jsregexp",
						dependencies = {
							"rafamadriz/friendly-snippets",
						},
						config = function()
							require('luasnip.loaders.from_vscode').lazy_load()
						end,
					},
					{ 
						"hrsh7th/cmp-buffer", -- Include buffer word completion
						config = function()
							require('cmp').setup({
								sources = {
									{ name = 'buffer' },
								},
							})
						end,
					},
					{ 
						"hrsh7th/cmp-path", -- Include file-system path completion
						config = function()
							require('cmp').setup({
								sources = {
									{ name = 'path' },
								},
							})
						end,
					},
					"saadparwaiz1/cmp_luasnip", -- Include luasnip completion
					{ 
						"hrsh7th/cmp-nvim-lsp",
						config = function()
							require('cmp').setup({
								sources = {
									{ name = 'nvim_lsp' },
								},
							})
						end,
					},
				},
			},
			"hrsh7th/cmp-nvim-lsp",
		},
	},

	-- Comment lines of code
	{
    "numToStr/Comment.nvim",
    config = function()
        require('Comment').setup()
    end,
	},

	-- File Viewer
	{
		"nvim-tree/nvim-tree.lua",  
		dependencies = {
			'nvim-tree/nvim-web-devicons', -- for file icons
		},
		tag = 'nightly', -- optional, updated every week. (see issue #1193)
	  config = function()
        require('nvim-tree').setup({
					filters = {
						custom = {
							"^\\.git",
						},
					},
					update_focused_file = {
						enable = true,
						update_root = true,
					},
					actions = {
						open_file = {
							quit_on_open = true,
							window_picker = {
								enable = false,
							},
						},
					},
				})
    end,
		keys = {
			{ "<leader>t", "<cmd>NvimTreeToggle<cr>" },
		},
	},

	-- Git Integration
	"tpope/vim-fugitive",
	{	
		"lewis6991/gitsigns.nvim",
		config = function()
			require('gitsigns').setup()
		end
	},

	-- Do more with repeat (.)
	"tpope/vim-repeat",

	-- Editorconfig support
	"editorconfig/editorconfig-vim",

	-- Silver SEarcher + FZF Support
  {
	  "junegunn/fzf.vim",
		dependencies = {
			{
				"junegunn/fzf", 
				build = function()
					vim.cmd([[ call fzf#install() ]])
				end,
				config = function()
					vim.g.fzf_preview_window = {"right,50%", "ctrl-/"}
					vim.opt.grepprg = "rg --vimgrep"  -- Use ripgrep for :grep

					-- Use ctrl-a/ctrl-d to select/deselect all items in :Ag list
					vim.env.FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all,ctrl-d:deselect-all'

					-- Display file list based on git repo
					vim.keymap.set('n', '<C-p>', '<cmd>GFiles<cr>')

					-- Display Buffer list for quick navigation
					vim.keymap.set('n', '<Leader>b', '<cmd>Buffers<cr>')

					-- AgIn: Start ag in the specified directory
					-- e.g.
					--   :AgIn .. foo
					vim.cmd([[
					function! s:ag_in(bang, ...)
						let start_dir=expand(a:1)

						if !isdirectory(start_dir)
							throw 'not a valid directory: ' . start_dir
						endif
						" Press `?' to enable preview window.
						call fzf#vim#ag(join(a:000[1:], ' '), fzf#vim#with_preview({'dir': start_dir}, 'right:50%:hidden', '?'), a:bang)
					endfunction
					]])

					vim.cmd([[ command! -bang -nargs=+ -complete=dir AgIn call s:ag_in(<bang>0, <f-args>) ]])

					-- --column: Show column number
					-- --line-number: Show line number
					-- --no-heading: Do not show file headings in results
					-- --fixed-strings: Search term as a literal string
					-- --ignore-case: Case insensitive search
					-- --no-ignore: Do not respect .gitignore, etc...
					-- --hidden: Search hidden files and folders
					-- --follow: Follow symlinks
					-- --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
					-- --color: Search color options

					vim.cmd([[
					command! -bang -nargs=* Find
						\ call fzf#vim#grep(
						\   'rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --glob "!*build*/" --glob "!notused" --color "always" '.shellescape(<q-args>), 1,
						\   fzf#vim#with_preview(), <bang>0)
						]])

					vim.cmd([[
					command! -bang -nargs=* FindCword
						\ call fzf#vim#grep(
						\   'rg --column --line-number --no-heading --color=always '.shellescape(expand('<cword>')), 1,
						\   <bang>0 ? fzf#vim#with_preview('up:60%')
						\           : fzf#vim#with_preview('right:50%:hidden', '?'),
						\   <bang>0)
						]])

					vim.keymap.set('n', '<Leader>fw', '<cmd>FindCword<cr>')

					vim.cmd([[
					command! -bang Gstat
						\ call fzf#run(fzf#wrap(
						\     {'source': 'git diff --name-only $(git merge-base HEAD "main")'}))
						]])

					vim.keymap.set('n', '<Leader>s', '<cmd>Gstat<cr>')
				end
			},
		},
	},

	-- Cmake support
	{
		"ilyachur/cmake4vim",
		dependencies = {
			"tpope/vim-dispatch",
		},
		config = function()
			-- Save files and build (Make)
			vim.keymap.set('n', '<leader>m', function() 
				vim.cmd([[wa]])
				vim.cmd([[CMakeBuild]])
			end)

			-- Redefine CTest command to include --output-on-failure
			vim.api.nvim_create_user_command("Ctest", 
				"call cmake4vim#CTest('--output-on-failure', <f-args>)", 
				{ force = true }
			)
			
			-- Quickfix not parsing cmake error:
			--   CMake Error at <file>:<line> (add_library)
			--     Cannot file source file:
			--
			--     <missing-file>
			vim.cmd([[set errorformat^=CMake\ Error\ at\ %f:%l\ (%m):]])

			-- Quickfix list error format for ctest errors using CMocka environment
			--
			-- General assertion failure:
			--   [  ERROR   ] --- <error text>
			--   [   LINE   ] --- <file>:<line>: error: Failure!
      vim.cmd([[set errorformat^=%E[\ \ %tRROR\ \ \ ]\ ---\ %m,%Z[\ \ \ LINE\ \ \ ]\ ---\ %f:%l:\ error:\ Failure!]])
			-- fail() Error format: 
			--   [ ERROR ] --- [   LINE   ] --- <file>|<line>| error: <error text>
			vim.cmd([[set errorformat^=[\ \ %tRROR\ \ \ ]\ ---\ [\ \ \ LINE\ \ \ ]\ ---\ %f:%l:\ error:\ %m]])
			-- Cmock test setup failure:
			--   [   LINE   ] --- <file>:<line>: error: <error text>
			vim.cmd([[set errorformat^=[\ \ \ LINE\ \ \ ]\ ---\ %f:%l:\ %trror:\ %m]])
		end,
	}
})

-- Load local machine settings if they exist
if vim.fn.filereadable(vim.fn.glob('$HOME/.vimrc.local')) then
	vim.cmd([[source $HOME/.vimrc.local]])
end
