local orgfiles = '~/Documents/orgfiles/'
if vim.env.ORGROOT then
	orgfiles = vim.env.ORGROOT
end

local refile = orgfiles .. "/refile.org"

local function map(tbl, f)
	local t = {}
	for k, v in pairs(tbl) do
		t[k] = f(v)
	end
	return t
end

function Register_contents(register)
	local reginfo = vim.fn.getreginfo(register)
	if not (reginfo.regcontents and type(reginfo.regcontents) == "table" and reginfo.regcontents[1]) then
		return ''
	end

	return table.concat(reginfo.regcontents, '\n')
end


-- Function used in templates to return org-mod reference to gitlab Issue/MR
-- Expected input format:
--   - https://gitlab.ilts.com/ilts/datatrak-flx/pgmc/pgmc-oss/-/merge_requests/349
--   - https://gitlab.ilts.com/ilts/datatrak-flx/pgmc/pgmc-oss/-/issues/349
-- Produces:
--   [[https://gitlab.ilts.com/ilts/datatrak-flx/pgmc/pgmc-oss/-/issues/349][pgmc-oss#349]]
function Gitlab_url_to_ref(url)
	local project, type, num = string.match(url, "([^/]+)/%-/([%w_]+)/([%d]+)$")
	if project == nil then
		return ''
	end

	local type_char
	if type == "merge_requests" then
		type_char = "!"
	elseif type == "issues" then
		type_char = "#"
	elseif type == "epics" then
		type_char = "&"
	else
		return ''
	end

	return '[[' .. url .. '][' .. project .. type_char .. num .. ']]'
end

-- orgmode has setup that must be run as nvim loads. Do not lazy load
return {
	"nvim-orgmode/orgmode",
	dependencies = {
		'nvim-treesitter/nvim-treesitter',
	},
	lazy = false, -- make sure we load this during startup
	ft = { 'org' },
	config = function()
		local journal_target = orgfiles .. '/journal/%<%Y-%m>.org'
		local status_target = orgfiles .. '/journal/status-report.org'
		local linux_staff_target = orgfiles .. '/journal/linux-staff.org'
		local linux_staff = {
			'George Brink',
			'Hoa Quang Le',
			'James Hollister',
			'LC Wong',
			'Nguyen Tran',
			'Thanh Le',
			'Vy H. Vu',
			'You Wen Chin',
		}
		local minutes_template =
				'* Minutes: %s\n  %%T\n' ..
				'** Attendees\n' ..
				table.concat(map(linux_staff,
					function(s) return '   - [ ] ' .. s end
				), '\n') .. '\n' ..
				'   - [ ] Joel Tay\n' ..
				'   - [ ] Ian Moncrief\n' ..
				'** Agenda/Discussion\n' ..
				'*** %s\n' ..
				'** Tasks\n' ..
				'*** TODO '

		require('orgmode').setup {
			-- Can provide multiple dirs: org_agenda_files = {'~/onedrive/org-mode/**/*', '~/my-orgs/**/*'},
			org_agenda_files = { orgfiles .. '/**/*', '~/logseq/**/*' },
			org_default_notes_file = refile,
			org_todo_keywords = { 'TODO(t)', 'NEXT(e)', 'NOW', 'LATER', 'BLOCKED', 'REVIEWING', '|', 'CANCELED', 'DONE(d)' },
			org_capture_templates = {
				a = {
					description = 'Agenda',
					subtemplates = {
						d = {
							description = "default",
							-- Place cursor where meeting title would go
							template = string.format(minutes_template, '%?', ''),
							target = journal_target,
						},
						s = {
							description = "Linux Staff Agenda",
							-- Place cursor in Attendees section
							template = '*** %?\n    %u',
							target = linux_staff_target,
							headline = 'Future Agenda'
						},
					},
				},
				j = {
					description = 'Journal',
					template = '** %?\n   %T\n\n   ',
					target = journal_target,
				},
				m = {
					description = 'Meeting',
					subtemplates = {
						d = {
							description = "default",
							-- Place cursor where meeting title would go
							template = string.format(minutes_template, '%?', ''),
							target = journal_target,
						},
						l = {
							description = "Linux Staff",
							-- Place cursor in Attendees section
							template = string.format(minutes_template, 'Linux Staff', '%?'),
							target = linux_staff_target,
						},
					},
				},
				n = {
					description = 'active Now',
					template = "* NOW P::%? %(return Gitlab_url_to_ref(Register_contents('+'))) \n  SCHEDULED: %t",
					target = status_target,
					headline = 'Active',
				},
				r = {
					description = 'Reviewing',
					template = "* REVIEWING %(return Gitlab_url_to_ref(Register_contents('+'))) %?\n  SCHEDULED: %t",
					target = status_target,
					headline = 'Reviewing',
				},
				s = {
					description = 'Weekly Status Reports',
					template = '** Weekly Status Reports from Staff\n   %U\n\n' .. table.concat(map(linux_staff,
						function(s) return '*** TODO ' .. s .. ' Weekly Status Report\n    SCHEDULED: %t' end
					), '\n'),
					target = journal_target,
				},
				t = {
					description = 'Task',
					template = '* TODO %?\n  SCHEDULED: %t',
					target = refile,
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
