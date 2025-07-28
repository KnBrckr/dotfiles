-- Mason LSP package manager
-- https://github.com/mason-org/mason.nvim
-- https://github.com/mason-org/mason-lspconfig.nvim
return {
	"mason-org/mason-lspconfig.nvim",
	opts={},
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
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
		"neovim/nvim-lspconfig",
	}
}
