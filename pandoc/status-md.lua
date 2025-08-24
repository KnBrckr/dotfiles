-- Pandoc LUA filters documented at https://pandoc.org/lua-filters.html
-- a part of pandoc manual at https://pandoc.org/MANUAL.html

-- Logging library used to debug pandoc filter from https://github.com/wlupton/pandoc-lua-logging
--
-- eg. logging.temp('header', header)
--
local logging = require 'logging'

-- Find a string (str) in a table (tbl) of strings
local function find_string_in(str, tbl)
	for _, element in ipairs(tbl) do
		if (element == str) then
			return true
		end
	end
	return false
end

local function string_in_action_types(str)
	local action_types = { "TODO", "NEXT", "WIP", "REVIEWING", "BLOCKED", "DONE" }
	return find_string_in(str, action_types)
end

-- Filter document headers
function Header(header)
	local header_styles = {
		"font-size: 1.5rem; font-weight: bold; border-bottom: 1px solid black; margin-top: 4rem; margin-bottom: 1.5rem;",
		"font-size: 1.2rem; font-weight: normal; margin-top: 2.1rem; margin-bottom: 1.4rem;",
		"font-size: 1rem; font-style: italic; font-weight: normal; margin-top: 2rem; margin-bottom: 1.4rem;"
	}

	local style_text = ""
	if header_styles[header.level] ~= nil then
		style_text = header_styles[header.level]
	end

	-- Strip TODO tags
	if string_in_action_types(header.content[1].text) then
		table.remove(header.content, 1) -- Removes the tag
		table.remove(header.content, 1) -- Removes space after the tag
		style_text = style_text .. "font-family: \"Aptos Mono\", ui-monospace, monospace;"
	end

	header.attr.attributes = { style = style_text }

	return pandoc.Header(header.level, header.content, header.attr)
	-- return pandoc.Header(header.level, header.content, pandoc.Attr())
end

function Meta(meta)
	-- Date to report title
	table.insert(meta.title, 1, pandoc.Str(os.date("%e %B %Y ")))

	return meta
end
