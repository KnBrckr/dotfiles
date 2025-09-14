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
		local item = require('neogen.types.template').item
		local doxygen_setup = {
			{ nil,            "/**",                                                    { no_results = true, type = { "func", "file", "class" } } },
			{ nil,            " * @file ",                                              { no_results = true, type = { "file" } } },
			{ nil,            " * @brief $1",                                     { no_results = true, type = { "file" } } },
			{ nil,            " * ",                                                    { no_results = true, type = { "file" } } },
			{ nil,            " * Copyright © 2024 COMPANY_NAME. All rights reserved.", { no_results = true, type = { "file" } } },
			{ nil,            " */",                                                    { no_results = true, type = { "func", "file", "class" } } },
			{ nil,            "",                                                       { no_results = true, type = { "file" } } },

			{ nil,            "/**",                                                    { type = { "func", "class", "type" } } },
			{ item.ClassName, " * @class %s",                                           { type = { "class" } } },
			{ item.Type,      " * @typedef %s",                                         { type = { "type" } } },
			{ nil,            " * @brief $1",                                           { type = { "func", "class", "type" } } },
			{ nil,            " *",                                                     { type = { "func", "class", "type" } } },
			{ item.Tparam,    " * @tparam %s $1" },
			{ item.Parameter, " * @param %s $1" },
			{ nil,            " *",                                                     { type = { "func", "class", "type" } } },
			{ item.Return,    " * @return $1" },
			{ nil,            " */",                                                    { type = { "func", "class", "type" } } },

		}
		neogen.setup {
			enabled = true,
			languages = {
				c = {
					template = {
						annotation_convention = "custom_doxygen",
						custom_doxygen = doxygen_setup,
					},
				},
			},
		}
	end,
}
