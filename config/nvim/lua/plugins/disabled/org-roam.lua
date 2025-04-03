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
		local orgfiles = '~/Documents/orgfiles/'
		if vim.env.ORGROOT then
			orgfiles = vim.env.ORGROOT
		end
		require("org-roam").setup({
			directory = orgfiles .. "/roam",
		})
	end
}
