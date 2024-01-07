return {
	"danymat/neogen",
	dependencies = "nvim-treesitter/nvim-treesitter",
	-- Uncomment next line if you want to follow only stable versions
	version = "*",
	keys = {
		{
			'<leader>dc',
			function() require('neogen').generate({ type = 'class' }) end,
			desc = 'Document class'
		},
		{
			'<leader>df',
			function() require('neogen').generate({ type = 'func' }) end,
			desc = 'Document function'
		},
		{
			'<leader>dF',
			function() require('neogen').generate({ type = 'file' }) end,
			desc = 'Document file'
		},
		{
			'<leader>dt',
			function() require('neogen').generate({ type = 'type' }) end,
			desc = 'Document type'
		},
	},
	config = function()
		local neogen = require('neogen')
		neogen.setup {
			enabled = true,
		}
	end,
}
