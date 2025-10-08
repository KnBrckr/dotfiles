-- Setup location for org files via envvar if defined
local orgfiles = '~/Documents/orgfiles/'
if vim.env.ORGROOT then
	orgfiles = vim.env.ORGROOT
end

-- Default refile location
local refile = orgfiles .. "/refile.org"

-- orgmode has setup that must be run as nvim loads. Do not lazy load
return {
	"nvim-orgmode/orgmode",
	event = "VeryLazy",
	config = function()
		local personal_journal_target = orgfiles .. 'journal/%<%Y-%m>.org'

		-- Override default colors
		vim.api.nvim_set_hl(0, '@org.agenda.scheduled', { fg = '#87ffff' })
		vim.api.nvim_set_hl(0, '@org.keyword.done', { fg = '#0087ff' })

		require('orgmode').setup {
			-- Can provide multiple dirs: org_agenda_files = {'~/onedrive/org-mode/**/*', '~/my-orgs/**/*'},
			org_agenda_files = { orgfiles .. '**/*', },
			org_default_notes_file = refile,
			org_todo_keywords = { 'TODO(t)', 'WIP', 'REVIEWING', 'NEXT', 'BLOCKED', 'LATER', '|', 'DONE(d)', 'APPROVED', 'CANCELED',},
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
