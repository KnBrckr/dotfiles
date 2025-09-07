-- Mason LSP package manager
-- https://github.com/mason-org/mason.nvim
-- https://github.com/mason-org/mason-lspconfig.nvim
return {
	"mason-org/mason-lspconfig.nvim",
	config = function()
		local mason_lspconfig = require('mason-lspconfig')

		mason_lspconfig.setup {
			ensure_installed = {
				"bashls", -- bash language server
				"clangd", -- C language server
				"cmake", -- cmake language server
				"jsonls", -- JSON language server
				"lua_ls", -- Lua language server
				"pylsp", -- Python language server
				"yamlls" -- YAML language server
			},
		}
	end,
	dependencies = {
		{
			"mason-org/mason.nvim",
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
