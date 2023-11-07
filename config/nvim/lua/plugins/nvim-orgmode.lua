-- orgmode has setup that must be run as nvim loads. Do not lazy load
return {
	"nvim-orgmode/orgmode",
	dependencies = {
		'nvim-treesitter/nvim-treesitter',
	},
	lazy = false, -- make sure we load this during startup
	ft = { 'org' },
	config = function()
		local journal_target = '~/org-mode/journal/%<%Y-%m>.org'
		local journal_template_header = '\n** %<%Y-%m-%d> %<%A>\n*** %U\n\n'

		require('orgmode').setup {
			-- Can provide multiple dirs: org_agenda_files = {'~/onedrive/org-mode/**/*', '~/my-orgs/**/*'},
			org_agenda_files = { '~/org-mode/**/*', '~/logseq/**/*' },
			org_default_notes_file = '~/org-mode/refile.org',
			org_todo_keywords = { 'TODO(t)', 'NEXT', 'NOW', 'LATER', '|','CANCELED', 'DONE(d)' },
			org_capture_templates = {
				t = { description = 'Task', template = '* TODO %?\n  %u' },
				j = {
					description = 'Journal',
					template = journal_template_header .. "%?",
					target = journal_target
				},
			},
		}
		require('orgmode').setup_ts_grammar()

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
