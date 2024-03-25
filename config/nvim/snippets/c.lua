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

local current_file = function(_, snip)
	return snip.env.TM_FILENAME
end

local year = function()
	return os.date("%Y")
end

-- Start of snippets

-- header: file header {{{
local header = s("header", fmt([[
/*
 * File: {}
 * Description: {}
 *
 * - CONFIDENTIAL -
 *
 * Copyright (c) {} International Lottery & Totalizator Systems, Inc.
 * All Rights Reserved www.ilts.com
 */

]],
	{
		f(current_file),
		i(1, "Description"),
		f(year),
	}))
table.insert(snippets, header)
-- }}}

-- unit_main: main() for unit tests {{{
local unit_main = s("unit_main", fmt([[
#include <setjmp.h>
#include <stdarg.h>
#include <stdlib.h>
#include <unistd.h>

#include <cmocka.h>

/**
 * @brief {}
 *
 * @param state Test state
 */
static void {a}_test(void **state)
{{
	fail();
}}

int main(int argc, char const *argv[])
{{
	const struct CMUnitTest tests[] = {{
		cmocka_unit_test({a}_test),
	}};

	return cmocka_run_group_tests(tests, NULL, NULL);
}}
]], {
		i(1, "Description"),
		a = i(2, "func"),
	},
	{ repeat_duplicates = true }
))
table.insert(snippets, unit_main)

-- }}}

-- unit_func: New function for unit tests {{{
local unit_func = s("unit_func", fmt([[
/**
 * @brief {}
 *
 * @param state Test state
 */
static void {}_test(void **state)
{{
	fail();
}}
]], {
	i(1, "Description"),
	i(2, "func"),
}))
table.insert(snippets, unit_func)

-- End of snippets

return snippets, autosnippets
