-- mini swiss-army knife
return
{
	'nvim-mini/mini.nvim',
	version = '*',
	config = function()
		require('mini.icons').setup()
	end,
}
