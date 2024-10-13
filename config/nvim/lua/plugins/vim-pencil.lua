-- VIM as a writing tool

-- Map file types to desired wrap mode
local file_table = {
	asciidoc = "soft",
	text = "hard",
	markdown = "hard",
}

-- List of file types for lazy loading
local file_types = {}
for type, _ in pairs(file_table) do
	table.insert(file_types, type)
end

return {
	"preservim/vim-pencil",
	ft = file_types,
	config = function()
		local group = vim.api.nvim_create_augroup("pencil", { clear = true })
		for type, wrap in pairs(file_table) do
			vim.api.nvim_create_autocmd('FileType', {
				pattern = type,
				command = "call pencil#init({'wrap': '" .. wrap .. "' })",
				group = group
			}
			)
		end
	end,
}
