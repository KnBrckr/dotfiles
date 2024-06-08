-- orgmode has setup that must be run as nvim loads. Do not lazy load
return {
	"nvim-orgmode/orgmode",
	dependencies = {
		'nvim-treesitter/nvim-treesitter',
	},
	lazy = false, -- make sure we load this during startup
	ft = { 'org' },
	config = function()
		local work_journal_target = '~/org-mode/work/%<%Y-%m>.org'
		local personal_journal_target = '~/org-mode/journal/%<%Y-%m>.org'
		local journal_template = '* %t\n** %U\n\n   '
		local meeting_tempate =
				'* Meeting: %s\n  %%T\n' ..
				'** Attendees\n' ..
				'   - %s\n' ..
				'** Agenda/Discussion\n' ..
				'*** \n' ..
				'** Tasks\n' ..
				'*** TODO '

		require('orgmode').setup {
			-- Can provide multiple dirs: org_agenda_files = {'~/onedrive/org-mode/**/*', '~/my-orgs/**/*'},
			org_agenda_files = { '~/org-mode/**/*', '~/logseq/**/*' },
			org_default_notes_file = '~/org-mode/refile.org',
			org_todo_keywords = { 'TODO(t)', 'NEXT', 'NOW', 'LATER', '|', 'CANCELED', 'DONE(d)' },
			org_capture_templates = {
				t = { description = 'Task', template = '* TODO %?\n  %u' },
				j = {
					description = 'Journal',
					subtemplates = {
						w = {
							description = 'Work',
							template = journal_template .. '%?',
							target = work_journal_target,
						},
						p = {
							description = 'Personal',
							template = journal_template .. '%?',
							target = personal_journal_target,
						},
					},
				},
				a = {
					description = 'Agenda',
					subtemplates = {
						d = {
							description = "default",
							-- Place cursor where meeting title would go
							template = string.format(meeting_tempate, '%?', ''),
							target = work_journal_target,
						},
						s = {
							description = "Linux Staff Agenda",
							-- Place cursor in Attendees section
							template = '*** %?\n    %U',
							target = '~/org-mode/work/linux-staff.org',
							headline = 'Future Agenda'
						},
					},
				},
				m = {
					description = 'Meeting',
					subtemplates = {
						d = {
							description = "default",
							-- Place cursor where meeting title would go
							template = string.format(meeting_tempate, '%?', ''),
							target = work_journal_target,
						},
						l = {
							description = "Linux Staff",
							-- Place cursor in Attendees section
							template = string.format(meeting_tempate, 'Linux Staff', '%?'),
							target = '~/org-mode/work/linux-staff.org',
						},
					},
				},
			},
		}

		-- Treesitter configuration
		require('nvim-treesitter.configs').setup {
			-- If TS highlights are not enabled at all, or disabled via `disable` prop,
			-- highlighting will fallback to default Vim syntax highlighting
			highlight = {
				enable = true,
				-- Required for spellcheck, some LaTex highlights and
				-- code block highlights that do not have ts grammar
				additional_vim_regex_highlighting = { 'org' },
			},
			ensure_installed = { 'org' }, -- Or run :TSUpdate org
		}
	end,
}
