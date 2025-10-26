-- LSP Support
return {
	"neovim/nvim-lspconfig",
	config = function()
		-- Setup defaults for clangd
		vim.lsp.config('clangd', {
			cmd = { "clangd", '--background-index', '--clang-tidy', '--log=verbose' },
		})

		-- Setup defaults for cmake
		vim.lsp.config('cmake', {
			init_options = {
				buildDirectory = "cmake-build-Debug",
			},
		})

		-- Setup defaults for lua
		vim.lsp.config('lua_ls', {
			on_init = function(client)
				if client.workspace_folders then
					local path = client.workspace_folders[1].name
					if
							path ~= vim.fn.stdpath('config')
							and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
					then
						return
					end
				end

				client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
					runtime = {
						-- Tell the language server which version of Lua you're using (most
						-- likely LuaJIT in the case of Neovim)
						version = 'LuaJIT',
						-- Tell the language server how to find Lua modules same way as Neovim
						-- (see `:h lua-module-load`)
						path = {
							'lua/?.lua',
							'lua/?/init.lua',
						},
					},
					-- Make the server aware of Neovim runtime files
					workspace = {
						checkThirdParty = false,
						library = {
							vim.env.VIMRUNTIME
							-- Depending on the usage, you might want to add additional paths
							-- here.
							-- '${3rd}/luv/library'
							-- '${3rd}/busted/library'
						}
						-- Or pull in all of 'runtimepath'.
						-- NOTE: this is a lot slower and will cause issues when working on
						-- your own configuration.
						-- See https://github.com/neovim/nvim-lspconfig/issues/3189
						-- library = {
						--   vim.api.nvim_get_runtime_file('', true),
						-- }
					}
				})
			end,
			settings = {
				Lua = {}
			}
		})

		-- Use LspAttach autocommand to map the following keys only
		-- after the language server attaches to the current buffer
		vim.api.nvim_create_autocmd('LspAttach', {
			group = vim.api.nvim_create_augroup('UserLspConfig', {}),
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if client == nil then
					return
				end

				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				-- See `:help vim-api` for list of methods
				if client:supports_method('textDocument/publishDiagnostics') then
					-- See `:help vim.diagnostic.*` for documentation on any of the below functions

					-- Default mappings:
					--  <C-w>d Show diagnostics under cursor
					--  [D Jump to first diagnostic
					--  [d Jump to previous diagnostic
					--  ]D Jump to last diagnostic
					--  ]d Jump to next diagnostic

					vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist,
						{ buffer = true, desc = "Add diagnostics to location list" })
				end

				-- Default LSP mappings
				--
				-- Use client method to test for support e.g. client:supports_method('textDocument/declaration')
				--       client method
				--  K                                  vim.lsp.buf.hover
				--       textDocument/declaration      vim.lsp.buf.declaration
				--       textDocument/definition       vim.lsp.buf.definition
				--  gO                                 vim.lsp.buf.document_symbol
				--  grt  textDocument/typeDefinition   vim.lsp.buf.type_definition
				--  gri  textDocument/implementation   vim.lsp.buf.implementation
				--  grr  textDocument/references       vim.lsp.buf.references
				--  gra  textDocument/codeAction       vim.lsp.buf.code_action
				--  grn  textDocument/rename           vim.lsp.buf.rename

				-- grD => declaration
				if client:supports_method('textDocument/declaration') then
					vim.keymap.set('n', 'grD', vim.lsp.buf.declaration, { buffer = true, desc = "Jump to Declaration" })
				end

				-- grd => definition
				if client:supports_method('textDocument/definition') then
					vim.keymap.set('n', 'grd', vim.lsp.buf.definition, { buffer = true, desc = "Jump to Definition" })
				end

				-- KK => signature help
				if client:supports_method('textDocument/signatureHelp') then
					vim.keymap.set('n', 'KK', vim.lsp.buf.signature_help, { buffer = true, desc = "Show Signature Help" })
				end

				-- grf => format buffer
				if client:supports_method('textDocument/formatting') then
					vim.keymap.set('n', 'gQ', function()
						vim.lsp.buf.format { async = true }
					end, { buffer = true, desc = "Format" })
				end

				if client:supports_method('workspace/workspaceFolders') then
					vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder,
						{ buffer = true, desc = "Add workspace folder" })
					vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder,
						{ buffer = true, desc = "Remove workspace folder" })
					vim.keymap.set('n', '<leader>wl', function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, { buffer = true, desc = "List workspace folders" })
				end
			end,
		})
	end,
}
