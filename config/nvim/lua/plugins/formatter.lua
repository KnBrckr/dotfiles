-- Formatter https://github.com/mhartington/formatter.nvim
return {
	"mhartington/formatter.nvim",
	cmd = { "Format", "FormatWrite" },
	config = function()
		-- Utilities for creating configurations
		local util = require "formatter.util"
		local xml_format = function()
			return {
				exe = "xmlformat",
				args = {
					"--selfclose", -- Self-close elements
					"--blanks", -- Preserve blank lines
					"-",
				},
				stdin = true,
			}
		end

		local xml_tidy = function()
			return {
				exe = "tidy",
				args = {
					"-xml",               -- File is in XML format
					"-i",                 -- Indent elements
					"--quiet yes",        -- omit non-document output
					"--indent-attributes yes", -- Indent element attributes
				},
				stdin = true,
			}
		end

		-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
		require("formatter").setup {
			-- Enable or disable logging
			logging = true,
			-- Set the log level
			log_level = vim.log.levels.WARN,
			-- All formatter configurations are opt-in
			filetype = {
				sql = {
					exe = "sqlfmt",
					stdin = true,
				},
				xml = { xml_tidy },
				xsd = { xml_tidy },

				-- Formatter configurations for filetype "lua" go here
				-- and will be executed in order
				-- lua = {
				-- 	-- "formatter.filetypes.lua" defines default configurations for the
				-- 	-- "lua" filetype
				-- 	require("formatter.filetypes.lua").stylua,
				--
				-- 	-- You can also define your own configuration
				-- 	function()
				-- 		-- Supports conditional formatting
				-- 		if util.get_current_buffer_file_name() == "special.lua" then
				-- 			return nil
				-- 		end
				--
				-- 		-- Full specification of configurations is down below and in Vim help
				-- 		-- files
				-- 		return {
				-- 			exe = "stylua",
				-- 			args = {
				-- 				"--search-parent-directories",
				-- 				"--stdin-filepath",
				-- 				util.escape_path(util.get_current_buffer_file_path()),
				-- 				"--",
				-- 				"-",
				-- 			},
				-- 			stdin = true,
				-- 		}
				-- 	end
				-- },
				--
				-- Use the special "*" filetype for defining formatter configurations on
				-- any filetype
				["*"] = {
					-- "formatter.filetypes.any" defines default configurations for any
					-- filetype
					require("formatter.filetypes.any").remove_trailing_whitespace
				}
			}
		}
	end,
}
