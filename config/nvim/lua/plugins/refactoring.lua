-- Code refactoring
-- https://github.com/ThePrimeagen/refactoring.nvim
return {
	"ThePrimeagen/refactoring.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	lazy = false,
	opts = {},
	config = function ()
		require("refactoring").setup()
	end
}
