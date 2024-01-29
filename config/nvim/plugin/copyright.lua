---  Update copyright strings
local M = {}

function M.setup()
end

-- Update copyrights with optional pattern
-- @param post_text post-copyright string to match
function M.update_copyright(post_pattern)
	local this_year = vim.fn.strftime("%Y")
	local match_year = "[0-9]\\{4\\}"
	local cmd = "g#\\cCOPYRIGHT " ..                   -- ignore case of "Copyright" text
			"(c) " ..                                      -- Copyright symbol
			"\\(" .. this_year .. "\\)\\@!" ..             -- Does not match current year
			match_year .. "\\(-" .. this_year .. "\\)\\@!" .. -- Does not match range ending in current year
			"\\s*" .. post_pattern ..                      -- with text after copyright
			"#s#" .. "\\(" .. match_year .. "\\)\\(-" .. match_year .. "\\)\\?" ..
			"#\\1-" .. this_year .. "#"
	vim.api.nvim_exec2(cmd, {})
end

-- Create command that takes a parameter
vim.api.nvim_create_user_command('UpdateCopyright', function(cmd)
	M.update_copyright(cmd.args)
end, { nargs = '?' })

return M
