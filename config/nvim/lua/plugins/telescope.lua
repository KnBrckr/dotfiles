-- plugins/telescope.lua:
return {
	'nvim-telescope/telescope.nvim',
	tag = '0.1.1',
	dependencies = {
		'nvim-lua/plenary.nvim',
		-- {
		-- 	'nvim-telescope/telescope-fzf-native.nvim',
		--
		-- },
	},
	config = function()
		require("telescope").setup({
			defaults = {
				path_display = { "shorten" },
			},
		})
	end,
	keys = {
		{ '<leader>b',  '<cmd>Telescope buffers<cr>' },
		{ '<leader>ff', '<cmd>Telescope find_files<cr>' },
		{ '<leader>fg', '<cmd>Telescope live_grep<cr>' },
		{ '<leader>fw', '<cmd>Telescope grep_string<cr>' },
		{ '<leader>gf', '<cmd>Telescope git_files<cr>' },
		{ '<leader>gs', '<cmd>Telescope git_status<cr>' },
		{ '<leader>fh', '<cmd>Telescope help_tags<cr>' },
		{ '<leader>ld', '<cmd>Telescope lsp_definitions<cr>' },
		{ '<leader>li', '<cmd>Telescope lsp_implementations<cr>' },
		{ '<leader>lr', '<cmd>Telescope lsp_references<cr>' },
	},
}
