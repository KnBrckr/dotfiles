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

		-- Automatically start tree sitter for a buffer when its filetype has an
		-- installed language
		vim.api.nvim_create_autocmd('FileType', {
			callback = function()
				-- file type matched in autocommand
				local amatch = vim.fn.expand("<amatch>")
				-- LSP language to use for that file type
				local lang = vim.treesitter.language.get_lang(amatch)
				-- Installed treesitter languages
				local installed_langs = require("nvim-treesitter").get_installed()

				if vim.tbl_contains(installed_langs, lang) then
					vim.treesitter.start()

					-- Use treesitter for folding
					vim.wo.foldmethod = 'expr'
					vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
				end
			end,
		})
	end,
}
