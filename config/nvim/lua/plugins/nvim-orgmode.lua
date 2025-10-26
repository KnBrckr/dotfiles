local api = require('orgmode.api')
local Date = require('orgmode.objects.date')

-- Setup location for org files via envvar if defined
local orgfiles = '~/Documents/orgfiles/'
if vim.env.ORGROOT then
	orgfiles = vim.env.ORGROOT
end

-- Default refile location
local refile = orgfiles .. "/refile.org"

-- Initialize expected Status Report section collections
-- <todo state>,  <report section title>
local status_report_todo_states = {
	{ state = "WIP",       title = "Active" },
	{ state = "REVIEWING", title = "Reviewing" },
	{ state = "BLOCKED",   title = "Blocked" },
	{ state = "DONE",      title = "Completed" },
	{ state = "APPROVED",  title = "Approved" },
	{ state = "NEXT",      title = "Next" },
}

--- Calculate date of previous Friday
---@return string|osdate: Date of previous Friday
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
---@param from_date string|osdate Oldest closed state to include
---@param category string category to filter on
---@param headline any orgmode headline to test
---@return boolean: true if headline should be included
local function include_in_report(from_date, category, headline)
	if not headline then
		return false
	end

	-- Skip if "status" property is not set
	if headline:get_property("CATEGORY") ~= category then
		return false
	end

	-- Unresolved headlines are included
	if not headline.closed then
		return true
	end

	if headline.closed:is_after(Date:set_from_string(from_date)) then
		return true
	end

	return false
end

--- Convert org-mode links to markdown format
---@param s string Orgmode link
---@return string: Markdown formatted link
local function orglink_to_md(s)
	local match = { string.match(s, "^(.*)%[%[([^%[%]]+)%]%[([^%[%]]+)%]%](.*)$") }
	if #match > 0 then
		return match[1] .. "[" .. match[3] .. "](" .. match[2] .. ")" .. match[4]
	end

	return s
end

--- Create markdown buffer to hold report
---@return integer: buffer number
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

local function create_status_report(opts)
	-- Use date from command line
	local from_date
	if #opts.fargs > 0 then
		from_date = opts.fargs[1]
	else
		from_date = prev_friday()
	end

	-- Per todo-state collection tables
	local report = {}
	vim.tbl_map(function(t)
		report[string.upper(t.state)] = {}
	end, status_report_todo_states)

	-- Collect entries from "status" category
	local function include_status(h)
		return include_in_report(from_date, "status", h)
	end

	-- Gather todos for report from each file provided by api.load()
	vim.tbl_map(function(file)
		vim.tbl_map(function(h)
			if report[h.todo_value] then
				table.insert(report[h.todo_value], h) -- Add headline to report section
			end
		end, vim.tbl_filter(include_status, file.headlines))
	end, api.load())

	-- Send report to buffer in markdown format
	local buf = create_report_buf()
	vim.api.nvim_buf_set_lines(buf, 0, -1, true, { "# " .. os.date("%e %B %Y") .. " Status Report" })

	-- For each report section
	vim.tbl_map(function(tuple)
		vim.api.nvim_buf_set_lines(buf, -1, -1, true, { "", "## " .. tuple.title, "" })

		-- Emit the action
		vim.tbl_map(function(todo)
			vim.api.nvim_buf_set_lines(buf, -1, -1, true, { "* " .. orglink_to_md(todo.title) })

			-- If it has sub-headings, output them too
			vim.tbl_map(function(subhead)
				-- But only if it's not also a todo to avoid duplication
				if not subhead.todo_type then
					vim.api.nvim_buf_set_lines(buf, -1, -1, true, { "  * " .. orglink_to_md(subhead.title) })
				end
			end, todo.headlines)
		end, report[string.upper(tuple.state)])
	end, status_report_todo_states)
end

-- orgmode has setup that must be run as nvim loads. Do not lazy load
return {
	"nvim-orgmode/orgmode",
	event = "VeryLazy",
	config = function()
		local personal_journal_target = orgfiles .. 'journal/%<%Y-%m>.org'

		-- Override default colors
		vim.api.nvim_set_hl(0, '@org.agenda.scheduled', { fg = '#87ffff' })
		vim.api.nvim_set_hl(0, '@org.keyword.done', { fg = '#0087ff' })

		-- Create status report command
		vim.api.nvim_create_user_command('StatusReport', create_status_report, { nargs = '?' })

		require('orgmode').setup {
			-- Can provide multiple dirs: org_agenda_files = {'~/onedrive/org-mode/**/*', '~/my-orgs/**/*'},
			org_agenda_files = { orgfiles .. '**/*', },
			org_default_notes_file = refile,
			org_todo_keywords = { 'TODO(t)', 'WIP', 'REVIEWING', 'NEXT', 'BLOCKED', 'LATER', '|', 'DONE(d)', 'APPROVED', 'CANCELED', },
			org_capture_templates = {
				t = { description = 'Task', template = '* TODO %?\n  %u' },
				j = {
					description = 'Journal',
					template = '** %?\n   %T\n',
					target = personal_journal_target,
				},
			},
		}
	end,
}
