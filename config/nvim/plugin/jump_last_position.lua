-- When editing a file, always jump to the last known cursor position.
-- Don't do it when the position is invalid, and for a commit message (it's
-- likely a different one than last time).
local jlp_group = vim.api.nvim_create_augroup("jump_last_position", { clear = true })
vim.api.nvim_create_autocmd(
	"BufReadPost",
	{
		callback = function()
			local row, _ = unpack(vim.api.nvim_buf_get_mark(0, "\""))
			if row >= 1 and row <= vim.api.nvim_buf_line_count(0)
					and not string.match(vim.bo.filetype, 'commit') then
				vim.api.nvim_win_set_cursor(0, { row, 0 })
			end
		end,
		group = jlp_group
	}
)
