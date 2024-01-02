-- LSP Support
return {
	"neovim/nvim-lspconfig",
	config = function()
		-- Mappings.
		-- See `:help vim.diagnostic.*` for documentation on any of the below functions
		local key_opts = function(description)
			return { noremap = true, silent = true, desc = description }
		end
		vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, key_opts("Open floating error window"))
		vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, key_opts("Previous diagnostic"))
		vim.keymap.set('n', ']d', vim.diagnostic.goto_next, key_opts("Next diagnostic"))
		vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, key_opts("Add diagnostics to location list"))

		-- Use LspAttach autocommand to only map the following keys
		-- after the language server attaches to the current buffer
		vim.api.nvim_create_autocmd('LspAttach', {
			group = vim.api.nvim_create_augroup('UserLspConfig', {}),
			callback = function(ev)
				-- Enable completion triggered by <c-x><c-o>
				vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = function(description)
					return { buffer = ev.buf, desc = description }
				end
				vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts("Declaration"))
				vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts("Definition"))
				vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts("Hover info"))
				vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts("Implementation"))
				vim.keymap.set('n', 'KK', vim.lsp.buf.signature_help, opts("Signature Help"))
				vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts("Add workspace folder"))
				vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts("Remove workspace folder"))
				vim.keymap.set('n', '<space>wl', function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, opts("List workspace folders"))
				vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts("Type definition"))
				vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts("Rename"))
				vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts("Code Action"))
				vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts("References"))
				vim.keymap.set('n', '<leader>f', function()
					vim.lsp.buf.format { async = true }
				end, opts("Format"))
			end,
		})
	end,
	dependencies = {
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-nvim-lsp",
	},
}
