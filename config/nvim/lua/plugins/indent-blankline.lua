-- Show indent lines
return {
	"lukas-reineke/indent-blankline.nvim",
	config = function()
		require("indent_blankline").setup {
			use_treesitter = true,
			show_current_context = true,
			show_current_context_start = true,
			show_first_indent_level = false,
		}
	end,
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
}
