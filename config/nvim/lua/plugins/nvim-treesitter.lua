-- Treesitter based syntax highlights
return {
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
}
