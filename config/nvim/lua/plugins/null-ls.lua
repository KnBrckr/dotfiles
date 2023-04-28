-- Buffer formatting
return {
	"jose-elias-alvarez/null-ls.nvim",
	dependencies = {
		'nvim-lua/plenary.nvim',
	},
	config = function()
		local null_ls = require("null-ls")

		null_ls.setup({
			sources = {
				-- null_ls.builtins.formatting.clang_format
				null_ls.builtins.formatting.yamlfmt
			},
			on_init = function(new_client, _)
				-- Use utf-8 to match clang usage to avoid "warning: multiple different client offset_encodings detected for buffer, this is not supported yet"

				new_client.offset_encoding = 'utf-8'
			end,
		})
	end,
}
