-- status line

-- Add a word count to status line for text files
local function getWords()
	local ft = vim.bo.filetype
	-- Display word-count for text documents
	if ft:match "^asciidoc" or ft == 'markdown' or ft == 'text'  or ft == 'org' then
		local mode = vim.fn.mode()
		-- If visual-mode
		if mode:match "^[vV\22]" then
			return vim.fn.wordcount().visual_words .. " words"
		else
			return vim.fn.wordcount().words .. " words"
		end
	end
	return ""
end

return {
	"nvim-lualine/lualine.nvim",
	config = function()
		require("lualine").setup {
			options = {
				theme = "tokyonight",
			},
			sections = {
				lualine_c = {
					{
						'filename',
						newfile_status = true,
						path = 3,
					}
				},
				lualine_z = {
					{ getWords, draw_empty = false, },
					'location',
					"os.date('%H:%M')" },
			},
		}
	end,
	dependencies = {
		'nvim-tree/nvim-web-devicons', -- for file icons
	},
}
