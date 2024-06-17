-- Add C header guard to a file
local M = {}

math.randomseed(os.time())

-- Generate a random UUID
local function generateUUID()
	local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
	return string.gsub(template, '[xy]', function(c)
		local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
		return string.format('%x', v)
	end)
end

-- Provide a valid guard name for use in #ifdef
local function header_guard_name()
	local name = generateUUID()
	local filtered_name = name:gsub("-", "")
	return "HEADER_GUARD_" .. filtered_name:upper()
end

-- Find existing header guard
-- expected format:
--   #ifndef TEXT
--   #define TEXT
--   ...
--   #endif // TEXT
--   or
--   #endif /* TEXT */
local function find_existing_guards(bufnr)
	local line_count = vim.api.nvim_buf_line_count(bufnr)
	local re1 = vim.regex("^#ifndef")
	local re2 = vim.regex("^#define")
	local re3 = vim.regex("^#endif")

	local guard_line_1 = nil
	local guard_line_2 = nil
	local guard_line_3 = nil

	-- Find starting guard line (No need to search last two lines)
	for i = 0, line_count - 3 do
		local start_offset, _ = re1:match_line(bufnr, i)
		if start_offset then
			guard_line_1 = i
			break
		end
	end
	-- Initial guard line not found
	if not guard_line_1 then
		return
	end

	-- 2nd guard line expected to immediately follow the first
	if not re2:match_line(bufnr, guard_line_1 + 1) then
		return
	end
	guard_line_2 = guard_line_1 + 1

	-- Locate ending guard line starting from end of file
	for i = line_count - 1, guard_line_2 + 1, -1 do
		local start_offset, _ = re3:match_line(bufnr, i)
		if start_offset then
			guard_line_3 = i
			break
		end
	end

	if not guard_line_3 then
		return
	end

	return guard_line_1, guard_line_2, guard_line_3
end

function M.add_header_guard(window)
	local curpos = vim.api.nvim_win_get_cursor(window)
	local bufnr = vim.api.nvim_win_get_buf(window)

	-- Skip if not in a C file
	local allowed_types = {
		c = true,
		ch = true,
		cpp = true,
	}
	if not allowed_types[vim.api.nvim_buf_get_option(bufnr, "filetype")] then
		return
	end

	local new_name = header_guard_name()
	local open_guard_lines = {
		"#ifndef " .. new_name,
		"#define " .. new_name,
	}
	local close_guard_line = {
		"#endif /* " .. new_name .. " */",
	}

	-- Locate existing header guard
	local gl1, gl2, gl3 = find_existing_guards(bufnr)

	if not gl1 or not gl2 or not gl3 then
		-- insert new guard do last line first...
		vim.api.nvim_buf_set_lines(bufnr, curpos[1], curpos[1], false, close_guard_line)
		vim.api.nvim_buf_set_lines(bufnr, curpos[1], curpos[1], false, open_guard_lines)
	else
		-- Change existing to new
		vim.api.nvim_buf_set_lines(bufnr, gl1, gl2 + 1, false, open_guard_lines)
		vim.api.nvim_buf_set_lines(bufnr, gl3, gl3 + 1, false, close_guard_line)
	end
end

-- Create command to add/update a header guard
vim.api.nvim_create_user_command("AddHeaderGuard", function()
		-- Add headers in current window
		M.add_header_guard(0)
	end,
	{
		desc = "Add/Update header guards to C file",
	}
)

return M
