-- LSP Support
return {
	"neovim/nvim-lspconfig",
	config = function()
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
					vim.keymap.set('n', '[d', function() vim.diagnostic.goto_prev({ float = true }) end,
						{ buffer = true, desc = 'Diagnostics: prev' })
					vim.keymap.set('n', ']d', function() vim.diagnostic.goto_next({ float = true }) end,
						{ buffer = true, desc = 'Diagnostics: next' })
					vim.keymap.set('n', '<space>e', vim.diagnostic.open_float,
						{ buffer = true, desc = "Open floating error window" })
					vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist,
						{ buffer = true, desc = "Add diagnostics to location list" })
				end

				if client:supports_method('textDocument/declaration') then
					vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = true, desc = "Jump to Declaration" })
				end

				if client:supports_method('textDocument/definition') then
					vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = true, desc = "Jump to Definition" })
				end

				if client:supports_method('textDocument/typeDefinition') then
					vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition,
						{ buffer = true, desc = "Jump to Type definition" })
				end

				if client:supports_method('textDocument/implementation') then
					vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = true, desc = "Jump to Implementation" })
				end

				if client:supports_method('textDocument/references') then
					vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = true, desc = "Jump to References" })
				end

				if client:supports_method('textDocument/signatureHelp') then
					vim.keymap.set('n', 'KK', vim.lsp.buf.signature_help, { buffer = true, desc = "Show Signature Help" })
				end

				if client:supports_method('workspace/workspaceFolders') then
					vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder,
						{ buffer = true, desc = "Add workspace folder" })
					vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder,
						{ buffer = true, desc = "Remove workspace folder" })
					vim.keymap.set('n', '<space>wl', function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, { buffer = true, desc = "List workspace folders" })
				end

				if client:supports_method('textDocument/rename') then
					vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, { buffer = true, desc = "Rename symbol" })
				end

				if client:supports_method('textDocument/codeAction') then
					vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, { buffer = true, desc = "Code Action" })
				end

				if client:supports_method('textDocument/formatting') then
					vim.keymap.set('n', '<leader>f', function()
						vim.lsp.buf.format { async = true }
					end, { buffer = true, desc = "Format" })
				end
			end,
		})
	end,
	dependencies = {
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-nvim-lsp",
	},
}
