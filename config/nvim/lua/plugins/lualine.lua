-- status line
return {
	"nvim-lualine/lualine.nvim",
	config = function()
		require("lualine").setup {
			sections = {
				lualine_z = { 'location', "os.date('%H:%M')" },
			},
		}
	end,
	dependencies = {
		'nvim-tree/nvim-web-devicons', -- for file icons
	},
}
