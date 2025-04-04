-- Configure vim navigation interaction with terminal emulator environment

-- Tmux navigation integration
if vim.env.TERM_PROGRAM:find("tmux") then
	return {
		"christoomey/vim-tmux-navigator"
	}
end

-- Enhanced vim navigation in kitty terminals
if vim.env.TERM:find("kitty") then
	return {
		"knubie/vim-kitty-navigator",
		build = {
			"cp get_layout.py ~/.config/kitty/",
			"cp pass_keys.py ~/.config/kitty/",
		},
	}
end

return { }
