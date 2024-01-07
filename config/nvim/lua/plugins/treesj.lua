-- Split/Join written in lua
return {
	'Wansmer/treesj',
	keys = {
		{ '<leader>J', '<cmd>TSJToggle<cr>', desc = "Join Toggle" }
	},
	dependencies = { 'nvim-treesitter/nvim-treesitter' },
	opts = {
		use_default_keymaps = false,
		max_join_length = 120,
	},
}
