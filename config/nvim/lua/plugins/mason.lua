-- Mason LSP package manager
-- https://github.com/williamboman/mason.nvim
-- https://github.com/williamboman/mason-lspconfig.nvim
return {
	"williamboman/mason-lspconfig.nvim",
	config = function()
		local mason_lspconfig = require('mason-lspconfig')
		local lspconfig = require('lspconfig')

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

		-- Add additional capabilities supported by nvim-cmp
		local capabilities = require('cmp_nvim_lsp').default_capabilities()

		mason_lspconfig.setup_handlers {
			-- First entry (without a key) is the default handler
			-- and will be called for each installed server that doesn't have
			-- a dedicated handler.
			function(server_name) -- default handler
				lspconfig[server_name].setup {
					capabilities = capabilities,
				}
			end,

			-- Next provide dedicated handler for specific servers.
			-- For example:
			-- ["rust_analyzer"] = function()
			-- require("rust-tools").setup {}
			-- end,

			-- Lua
			-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lua_ls
			["lua_ls"] = function()
				lspconfig.lua_ls.setup {
					capabilities = capabilities,
					settings = {
						Lua = {
							runtime = {
								-- Tell the language server which version of Lua you're using
								-- (most likely LuaJIT in the case of Neovim)
								version = 'LuaJIT'
							},
							diagnostics = {
								-- Get the language server to recognize the `vim` global
								globals = { 'vim' },
							},
							-- Make the server aware of Neovim runtime files
							workspace = {
								checkThirdParty = false,
								library = {
									vim.env.VIMRUNTIME
									-- "${3rd}/luv/library"
									-- "${3rd}/busted/library",
								}
								-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
								-- library = vim.api.nvim_get_runtime_file("", true)
							},
							-- Do not send telemetry data containing a randomized but unique identifier
							telemetry = {
								enable = false,
							},
						}
					}
				}
				lspconfig.cmake.setup {
					init_options = {
						buildDirectory = "cmake-build-Debug",
					},
				}
			end
		}
	end,
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
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
