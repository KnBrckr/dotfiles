local ls = require("luasnip") -- {{{
local s = ls.s -- Snippet
local i = ls.i -- insert node
local t = ls.t -- text node

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

-- Start of snippets

-- End of snippets

return snippets, autosnippets
