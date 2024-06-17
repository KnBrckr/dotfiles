-- Fold starting with 2nd level headers
vim.opt_local.foldlevel = 0

-- Use Tab/S-Tab to manage folds
vim.keymap.set('n', '<tab>', 'zo', {
	desc = 'Open fold under cursor',
	buffer = true,
})
vim.keymap.set('n', '<s-tab>', 'zc', {
	desc = 'Close fold under cursor',
	buffer = true,
})
