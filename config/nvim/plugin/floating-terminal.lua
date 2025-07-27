-- Define the reusable function with 'command' as a parameter
--
-- From https://lazybea.rs/nvim-ft/
-- Modified to replace deprecated termopen() with jobstart()
local function terminal_popup(command)
	local buf = vim.api.nvim_create_buf(false, true) -- create scratch buffer
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		border = "none",
		style = "minimal",
	})

	-- Start terminal in the buffer with your specified command
	vim.fn.jobstart(command, { term = true })

	-- Map 'Escape and Ctrl-C' in terminal mode to close the window
	local opts = { noremap = true, silent = true }
	vim.api.nvim_buf_set_keymap(buf, 't', '<C-c>', [[<C-\><C-n>:bd!<CR>]], opts)
	vim.api.nvim_buf_set_keymap(buf, 't', '<Esc>', [[<C-\><C-n>:bd!<CR>]], opts)

	-- Start in insert mode so terminal input is live
	vim.cmd("startinsert")
end

-- Create a Neovim user command that calls terminal_popup with a given argument
vim.api.nvim_create_user_command('TermPopup', function(opts)
	-- opts.args contains the command string, split by spaces if needed
	local term_cmd = opts.args ~= "" and vim.split(opts.args, " ") or { "zsh" }
	terminal_popup(term_cmd)
end, { nargs = "?" })     -- nargs="?" allows zero or one argument to the command
