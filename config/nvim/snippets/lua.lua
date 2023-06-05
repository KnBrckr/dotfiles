local ls = require("luasnip") -- {{{
local s = ls.s                -- Snippet
local i = ls.i                -- insert node
local t = ls.t                -- text node

local d = ls.dynamic_node
local c = ls.choice_node
local f = ls.function_node
local sn = ls.snippet_node

local fmt = require("luasnip.extras.fmt").fmt

local snippets, autosnippets = {}, {} -- }}}

local mySnip = s("mySnip", fmt([[
local {} = function({})
	{}
end
]], {
	i(1,"var"),
	c(2,{ t("arg"), t("arg2") } ),
	i(3,"-- stuff"),
}))
table.insert(snippets, mySnip)

return snippets, autosnippets
