-- Treesitter based syntax highlights
return {
	"nvim-treesitter/nvim-treesitter",
	init = function()
		-- By default use treesitter for folding
		vim.opt.foldmethod = "expr"
		vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
		vim.opt.foldlevel = 1
	end,
	config = function()
		require('nvim-treesitter.configs').setup({
			highlight = {
				enable = true,
				-- Setting this to true or a list of languages will run `:h syntax` and tree-sitter at the same time.
				additional_vim_regex_highlighting = false,
			},
			-- Install parsers asynchronously (only applied to 'ensure_installed')
			sync_install = false,
			-- Auto-install missing parsers (needs tree-sitter command locally available)
			auto_install = false,
			ensure_installed = {
				'awk',
				'bash',
				'c',
				'cmake',
				'diff',
				'dockerfile',
				'dot',
				'git_config',
				'git_rebase',
				'gitattributes',
				'gitcommit',
				'gitignore',
				'graphql',
				'json',
				'lua',
				'make',
				'markdown',
				'ninja',
				'perl',
				'python',
				'regex',
				'sql',
				'todotxt',
				'vim',
				'vimdoc',
				'yaml',
			},
			ignore_install = {
			},
		})
	end,
}
