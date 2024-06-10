-- Org-roam mode for nvim
return {
	"chipsenkbeil/org-roam.nvim",
	tag = "0.1.0",
	dependencies = {
		{
			"nvim-orgmode/orgmode",
		},
	},
	config = function()
		require("org-roam").setup({
			directory = "~/Documents/orgfiles/roam",
		})
	end
}
