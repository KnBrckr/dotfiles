return {
	"williamboman/mason-lspconfig.nvim",
	config = function()
		local mason_lspconfig = require('mason-lspconfig')

		mason_lspconfig.setup {}

		mason_lspconfig.setup_handlers {
			-- First entry (without a key) is the default handler
			-- and will be called for each installed server that doesn't have
			-- a dedicated handler.
			function(server_name) -- default handler
				require("lspconfig")[server_name].setup {
				}
			end,
			-- Next provide dedicated handler for specific servers.
			-- For example:
			-- ["rust_analyzer"] = function()
			-- require("rust-tools").setup {}
			-- end,
		}
	end,
	dependencies = {
		{
			"williamboman/mason.nvim",
			build = ":MasonUpdate", -- Update Mason registry
			config = function()
				require("mason").setup({
					ui = {
						icons = {
							package_installed = "✓",
							package_pending = "➜",
							package_uninstalled = "✗"
						}
					}
				})
			end,
		},
	}
}
