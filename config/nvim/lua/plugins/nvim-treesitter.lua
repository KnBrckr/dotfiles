-- Treesitter based syntax highlights
return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	branch = "main",
	build = ":TSUpdate",
	config = function()
		require('nvim-treesitter').install {
			'awk',
			'bash',
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
			'make',
			'ninja',
			'perl',
			'python',
			'regex',
			'sql',
			'todotxt',
			'yaml',
		}
	end,
}
