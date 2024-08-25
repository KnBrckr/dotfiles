-- VIM as a writing tool
local file_types = { "asciidoc", "text", "markdown" }

return {
	"preservim/vim-pencil",
	ft = file_types,
	config = function()
		local group = vim.api.nvim_create_augroup("pencil", { clear = true })
		vim.api.nvim_create_autocmd('FileType', {
			pattern = file_types,
			command = "call pencil#init()",
			group = group
		}
		)
	end,
}
