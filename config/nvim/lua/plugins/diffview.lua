-- Better diff views
return {
	'sindrets/diffview.nvim',
	config = function()
		require("diffview").setup({
			view = {
				merge_tool = {
					layout = "diff4_mixed",
				}
			}
		})
	end,
	dependencies = {
		'nvim-lua/plenary.nvim',
	},
}
