-- Create Status Report from org data

local api = require('orgmode.api')
local Date = require('orgmode.objects.date')

-- Calculate date of previous Friday
local function prev_friday()
	local dow = os.date("%w") -- 0 = Sunday
	-- Offset to the previous Friday (dow + 7 - Friday(5))
	local offset = (dow + 2) % 7
	if offset == 0 then
		offset = 7
	end
	return os.date("%Y-%m-%d", os.time() - offset * 24 * 60 * 60)
end

--- Determine if headline should be included in the report
local function include_in_report(headline)
	if not headline then
		return false
	end

	-- Skip if "status" property is not set
	if headline:get_property("CATEGORY") ~= "status" then
		return false
	end

	-- Unresolved headlines are included
	if not headline.closed then
		return true
	end

	if headline.closed:is_after(Date:set_from_string(prev_friday())) then
		return true
	end

	return false
end

-- Perform map transformation f() on table
local function map(tbl, f)
	local t = {}
	for k, v in pairs(tbl) do
		t[k] = f(v)
	end
	return t
end

-- Filter a table using f()
local function filter(tbl, f)
	local t = {}
	for k, v in pairs(tbl) do
		if f(v) then
			t[k] = v
		end
	end
	return t
end

-- Convert org-mode links to markdown format
local function orglink_to_md(s)
	local match = { string.match(s, "^(.*)%[%[([^%[%]]+)%]%[([^%[%]]+)%]%](.*)$") }
	if #match > 0 then
		return match[1] .. "[" .. match[3] .. "](" .. match[2] .. ")" .. match [4]
	end

	return s
end

--- Create markdown buffer to hold report
local function create_report_buf()
	local bufname = vim.fn.tempname() .. ".md"
	-- Setup scratch buffer
	for _, buf_hndl in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf_hndl) and
				vim.api.nvim_buf_get_name(buf_hndl) == bufname then
			-- Empty buffer for re-use
			vim.api.nvim_buf_set_lines(buf_hndl, 0, -1, false, {})
			return buf_hndl
		end
	end

	local buf = vim.api.nvim_create_buf(true, true)
	if (buf ~= 0) then
		vim.api.nvim_set_option_value("filetype", "markdown", { buf = buf })
		vim.api.nvim_set_option_value("swapfile", false, { buf = buf })
		vim.api.nvim_buf_set_name(buf, bufname)
	end
	vim.api.nvim_win_set_buf(0, buf)
	return buf
end

-- Create status report command
vim.api.nvim_create_user_command('StatusReport', function()
	local files = api.load()

	-- Initialize expected report section collections
	-- <todo state>,  <report section title>
	local include_todo_state = {
		{ state = "WIP",       title = "Active" },
		{ state = "REVIEWING", title = "Reviewing" },
		{ state = "BLOCKED",   title = "Blocked" },
		{ state = "DONE",      title = "Completed" },
		{ state = "APPROVED",  title = "Approved" },
		{ state = "NEXT",      title = "Next" },
	}

	-- Per todo-state collection tables
	local report = {}
	for _, tuple in ipairs(include_todo_state) do
		report[string.upper(tuple.state)] = {}
	end

	-- Gather todos for report
	for _, file in ipairs(files) do
		local tbl = filter(file.headlines, include_in_report)
		map(tbl, function(h)
			if report[h.todo_value] then
				table.insert(report[h.todo_value], h)
				return h
			end
		end)
	end

	-- Send report to buffer in markdown format
	local buf = create_report_buf()
	vim.api.nvim_buf_set_lines(buf, 0, -1, true, { "# " .. os.date("%e %B %Y") .. " Status Report" })

	-- For each report section
	for _, tuple in ipairs(include_todo_state) do
		vim.api.nvim_buf_set_lines(buf, -1, -1, true, { "", "## " .. tuple.title , ""})

		-- Emit the action
		for _, todo in ipairs(report[string.upper(tuple.state)]) do
			vim.api.nvim_buf_set_lines(buf, -1, -1, true, { "* " .. orglink_to_md(todo.title) })
			-- If it has sub-headings, output them too
			if todo.headlines then
				for _, subhead in ipairs(todo.headlines) do
					-- But only if it's not also a todo to avoid duplication
					if not subhead.todo_type then
						vim.api.nvim_buf_set_lines(buf, -1, -1, true, { "  * " .. orglink_to_md(subhead.title) })
					end
				end
			end
		end
	end
end, {})
