-- TokyoNight colorscheme
return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 2000, -- Load color scheme early
	config = function ()
		vim.cmd[[colorscheme tokyonight-storm]]
	end,
}
