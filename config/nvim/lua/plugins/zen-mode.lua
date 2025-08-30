-- Zen Mode coding/Writing
return {
	"folke/zen-mode.nvim",
	enabled = false,
	opts = {
		plugins = {
        -- this will change the font size on alacritty when in zen mode
        -- requires  Alacritty Version 0.10.0 or higher
        -- uses `alacritty msg` subcommand to change font size
        alacritty = {
          enabled = true,
          font = "18", -- font size increment
        },
		},
	}
}
