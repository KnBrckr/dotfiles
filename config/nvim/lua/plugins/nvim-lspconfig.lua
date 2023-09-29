-- LSP Support
return {
	"neovim/nvim-lspconfig",
	config = function()
		local lspconfig = require('lspconfig')

		-- Mappings.
		-- See `:help vim.diagnostic.*` for documentation on any of the below functions
		local opts = { noremap = true, silent = true }
		vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts) -- Open floating error window
		vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)      -- Previous diagnostic
		vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)      -- Next diagnostic
		vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts) -- Add diagnostics to location list

		local lsp_flags = {
			-- This is the default in Nvim 0.7+
			debounce_text_changes = 150,
		}

		-- Add additional capabilities supported by nvim-cmp
		local capabilities = require('cmp_nvim_lsp').default_capabilities()

		lspconfig.lua_ls.setup {
			on_attach = lsp_on_attach,
			flags = lsp_flags,
			capabilities = capabilities,
			settings = {
				Lua = {
					runtime = {
						-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
						version = 'LuaJIT',
					},
					diagnostics = {
						-- Get the language server to recognize the `vim` global
						globals = { 'vim' },
					},
					workspace = {
						-- Make the server aware of Neovim runtime files
						library = vim.api.nvim_get_runtime_file("", true),
						-- Do not display message about configuring lua environment
						checkThirdParty = false
					},
					-- Do not send telemetry data containing a randomized but unique identifier
					telemetry = {
						enable = false,
					},
				},
			},
		}

		-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lua_ls
		-- lspconfig.lua.setup({
		-- 	on_attach = on_attach,
		-- 	flags = lsp_flags,
		-- })
	end,
	dependencies = {
		{
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
							on_attach = lsp_on_attach
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
		},
		{
			"hrsh7th/nvim-cmp",
			config = function()
				local cmp = require('cmp')
				local luasnip = require('luasnip')

				local select_opts = { behavior = cmp.SelectBehavior.Select }

				cmp.setup({
					snippet = {
						expand = function(args)
							luasnip.lsp_expand(args.body)
						end,
					},
					sources = {
						{ name = 'path' },
						{ name = 'orgmode' },
						{ name = 'nvim_lsp', keyword_length = 1 },
						{ name = 'luasnip',  keyword_length = 2 },
						{ name = 'buffer',   keyword_length = 3 },
					},
					window = {
						documentation = cmp.config.window.bordered(),
					},
					formatting = {
						fields = { 'menu', 'abbr', 'kind' },
						format = function(entry, item)
							local menu_icon = {
								nvim_lsp = 'λ',
								luasnip = '⋗',
								buffer = 'Ω',
								path = string.format('')
							}

							item.menu = menu_icon[entry.source.name]
							return item
						end,
					},
					mapping = {
						['<Up>'] = cmp.mapping.select_prev_item(select_opts),
						['<Down>'] = cmp.mapping.select_next_item(select_opts),
						['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
						['<C-n>'] = cmp.mapping.select_next_item(select_opts),
						['<C-u>'] = cmp.mapping.scroll_docs(-4),
						['<C-d>'] = cmp.mapping.scroll_docs(4),
						['<C-e>'] = cmp.mapping.abort(),
						['<C-y>'] = cmp.mapping.confirm({ select = true }),
						['<CR>'] = cmp.mapping.confirm({ select = false }),
						['<C-f>'] = cmp.mapping(function(fallback)
							if luasnip.jumpable(1) then
								luasnip.jump(1)
							else
								fallback()
							end
						end, { 'i', 's' }),
						['<C-b>'] = cmp.mapping(function(fallback)
							if luasnip.jumpable(-1) then
								luasnip.jump(-1)
							else
								fallback()
							end
						end, { 'i', 's' }),
						['<Tab>'] = cmp.mapping(function(fallback)
							local col = vim.fn.col('.') - 1

							if cmp.visible() then
								cmp.select_next_item(select_opts)
							elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
								fallback()
							else
								cmp.complete()
							end
						end, { 'i', 's' }),
						['<S-Tab>'] = cmp.mapping(function(fallback)
							if cmp.visible() then
								cmp.select_prev_item(select_opts)
							else
								fallback()
							end
						end, { 'i', 's' }),
					},
				})
			end,
			dependencies = {
				{
					"hrsh7th/cmp-buffer", -- Include buffer word completion
					config = function()
						require('cmp').setup({
							sources = {
								{ name = 'buffer' },
							},
						})
					end,
				},
				{
					"hrsh7th/cmp-path", -- Include file-system path completion
					config = function()
						require('cmp').setup({
							sources = {
								{ name = 'path' },
							},
						})
					end,
				},
				"saadparwaiz1/cmp_luasnip", -- Include luasnip completion
				{
					"hrsh7th/cmp-nvim-lsp", -- Include lsp completion
					config = function()
						require('cmp').setup({
							sources = {
								{ name = 'nvim_lsp' },
							},
						})
					end,
				},
			},
		},
		"hrsh7th/cmp-nvim-lsp",
	},
}
