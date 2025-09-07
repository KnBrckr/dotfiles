-- LuaSnip
return {
	'saadparwaiz1/cmp_luasnip',
	enabled = false,
	dependencies = {
		{
			"L3MON4D3/LuaSnip",
			-- follow latest release.
			version = "1.*",
			-- install jsregexp (optional!).
			build = "make install_jsregexp",
			dependencies = {
				"rafamadriz/friendly-snippets",
			},
			config = function()
				local ls = require('luasnip')
				require('luasnip.loaders.from_lua').load({ paths = "~/.config/nvim/snippets" })
				require('luasnip.loaders.from_vscode').lazy_load()
				ls.config.set_config({
					history = true, -- keep last snippet local to jump back
					updateevents = 'TextChanged,TextChangedI', -- update changes as you type
					enable_autosnippets = true,
					ext_opts = {
						[require("luasnip.util.types").choiceNode] = {
							active = {
								virt_text = { { "●", "Orange" } },
							},
						},
					},
				})

				-- Expand
				vim.keymap.set({ "i", "s" }, "<a-p>", function()
					if ls.expand_or_jumpable() then
						ls.expand()
					end
				end)

				-- Jumping
				vim.keymap.set({ "i", "s" }, "<a-k>", function()
					if ls.jumpable(1) then
						ls.jump(1)
					end
				end)
				vim.keymap.set({ "i", "s" }, "<a-j>", function()
					if ls.jumpable(-1) then
						ls.jump(-1)
					end
				end)
				-- Cycle through choices
				vim.keymap.set({ "i", "s" }, "<a-l>", function()
					if ls.choice_active() then
						ls.change_choice(1)
					end
				end)
				vim.keymap.set({ "i", "s" }, "<a-h>", function()
					if ls.choice_active() then
						ls.change_choice(-1)
					end
				end)


			end,
		},
	},
}
