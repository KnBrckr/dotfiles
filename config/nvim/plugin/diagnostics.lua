-- Configure display of diagnostics
vim.diagnostic.config({
	-- Diagnostic virtual text became opt-in in neovim 0.11
	virtual_text = true,
	-- Sort diagnostic messages
	severity_sort = true,
	-- Setup diagnostic gutter signs
	signs = {
		text = {
			[vim.diagnostic.severity.HINT]  = "💡",
			[vim.diagnostic.severity.ERROR] = "☢️", -- alt "✘" "☢"
			[vim.diagnostic.severity.INFO]  = "ℹ️", -- alt "◉"
			[vim.diagnostic.severity.WARN]  = "⚠️", -- alt "" "⚠"
		}
	}
})
