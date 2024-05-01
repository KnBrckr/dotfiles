-- Orgmode Templates

local ls = require("luasnip") -- {{{
local s = ls.s                -- Snippet
local i = ls.i                -- insert node
local t = ls.t                -- text node

local d = ls.dynamic_node
local c = ls.choice_node
local f = ls.function_node
local sn = ls.snippet_node

local fmt = require("luasnip.extras.fmt").fmt

local snippets, autosnippets = {}, {}

local current_file = function(_, snip)
	return snip.env.TM_FILENAME
end

local year = function()
	return os.date("%Y")
end -- }}}

local schedule_today = function()
	local date = os.date("%Y-%m-%d %a")
	return "[" .. date .. "] SCHEDULED: <" .. date .. ">"
end

-- Generate a string from a list of values
function ListValues(list, prefix, suffix)
	local strings = {}
	for idx, v in ipairs(list) do
		strings[idx] = prefix .. v .. suffix
	end
	return table.concat(strings, '\n')
end

-- Start of snippets

-- Meeting Template {{{
local meeting = s("template-meeting", fmt([[
*** Meeting
**** Attendees
  -
**** Discussion
  -
**** Tasks
  *
]], {
}))
table.insert(snippets, meeting)

-- }}}

-- Password Change Template {{{
local passwd_chg = s(
	"template-passwd-change",
	fmt(ListValues({
		'Windows AD',
		'Local Admin User',
		'Accurev',
		'Accurev Admin',
		'gitlab token',
	}, "**** TODO Change ", " passwd\n  {d}"), {
		d = f(schedule_today)
	}))
table.insert(snippets, passwd_chg)
-- }}}

-- Weekly Staff Status Update Template {{{
local staff_todo = s("template-weekly-status", fmt(ListValues({
	'George Brink',
	'Hoa Quang Le',
	'James Hollister',
	'LC Wong',
	'Nguyen Tran',
	'Thanh Le',
	'Vy H. Vu',
	'You Wen Chin',
}, "**** TODO ", " Weekly Status Report\n  {d}"), {
	d = f(schedule_today)
}))
table.insert(snippets, staff_todo)
-- }}}

-- End of snippets

return snippets, autosnippets
