-- status line
return {
	"ahmedkhalf/project.nvim",
	event = "VeryLazy",
	config = function()
		require("project_nvim").setup {
		}
		require("telescope").load_extension("projects")
	end,
	keys = {
		{
			'<Leader>p',
			function() require('telescope').extensions.projects.projects() end,
			desc = 'Switch project',
		}
	},
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
}
