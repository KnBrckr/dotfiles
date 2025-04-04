-- TokyoNight colorscheme
-- https://github.com/folke/tokyonight.nvim
return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 2000, -- Load color scheme early
	config = function()
		require("tokyonight").setup({
			-- Use night style
			style = "night",
			-- Override specific color groups
			on_colors = function(colors)
				-- Comments are too dark, brighten them
				colors.comment = "#8a8a8a"
			end,
			-- Override specific highlights
			on_highlights = function(highlights, colors)
				-- Line number is too dark
				highlights.LineNr= { fg = "#6c6c6c" }
				highlights.LineNrAbove = { fg = "#6c6c6c" }
				highlights.LineNrBelow = { fg = "#6c6c6c" }
				-- TabLines are nearly invisible
				highlights.TabLine = { bg = "#4e4e4e", fg="#b2b2b2" }
			end
		})
		vim.cmd [[colorscheme tokyonight]]
	end,
}
