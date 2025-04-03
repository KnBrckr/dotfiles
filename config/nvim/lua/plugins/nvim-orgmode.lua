-- orgmode has setup that must be run as nvim loads. Do not lazy load
return {
	"nvim-orgmode/orgmode",
	event = "VeryLazy",
	config = function()
		local orgfiles = '~/Documents/orgfiles/'
		if vim.env.ORGROOT then
			orgfiles = vim.env.ORGROOT
		end
		local personal_journal_target = orgfiles .. 'journal/%<%Y-%m>.org'
		local journal_template = '* %t\n** %U\n\n   '

		require('orgmode').setup {
			-- Can provide multiple dirs: org_agenda_files = {'~/onedrive/org-mode/**/*', '~/my-orgs/**/*'},
			org_agenda_files = { orgfiles .. '**/*', },
			org_default_notes_file = orgfiles .. 'refile.org',
			org_todo_keywords = { 'TODO(t)', 'NEXT', 'NOW', 'LATER', '|', 'CANCELED', 'DONE(d)' },
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
