-- Treesitter based syntax highlights
return {
	"nvim-treesitter/nvim-treesitter",
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
					'csv',
					'diff',
					'dockerfile',
					'dot',
					'doxygen',
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
					'ssh_config',
					'strace',
					'todotxt',
					'vim',
					'vimdoc',
					'yaml',
			},
		})
	end,
}
