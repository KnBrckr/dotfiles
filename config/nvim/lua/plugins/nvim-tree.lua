-- File Viewer
return {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		'nvim-tree/nvim-web-devicons', -- for file icons
	},
	tag = 'nightly',                -- optional, updated every week. (see issue #1193)
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
}
