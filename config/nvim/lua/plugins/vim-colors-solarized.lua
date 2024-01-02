-- Colorscheme should be available when starting Neovim
return {
	"altercation/vim-colors-solarized",
	lazy = false,    -- make sure we load this during startup as main colorscheme
	priority = 1000, -- make sure to load this before all the other start plugins
	config = function()
		-- load the colorscheme here
		vim.cmd([[colorscheme solarized]])

		-- After entering nvim, perform highlight overrides
		vim.api.nvim_create_autocmd("VimEnter", {
			pattern = "*",
			callback = function(ev)
				-- Insert any highlight commands required to override color scheme defaults

				-- Display comments in italic
				vim.cmd([[hi Comment cterm=italic gui=italic]])
			end
		})
	end,
}
