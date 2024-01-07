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
			},
			-- Install parsers asynchronously (only applied to 'ensure_installed')
			sync_install = false,
			-- Auto-install missing parsers (needs tree-sitter command locally available)
			auto_install = true,
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
				'org',
				'perl',
				'python',
				'regex',
				'sql',
				'todotxt',
				'vim',
				'vimdoc',
				'yaml',
			},
		})
	end,
}
