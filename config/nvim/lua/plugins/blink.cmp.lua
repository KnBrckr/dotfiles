-- blink completion manager
-- https://cmp.saghen.dev/installation.html
return {
	'saghen/blink.cmp',
	-- use a release tag to download pre-built binaries
	enabled = true,
	version = '1.*',
	-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
	-- build = 'cargo build --release',
	-- If you use nix, you can build from source using latest nightly rust with:
	-- build = 'nix run .#build-plugin',

	-- optional: provides snippets for the snippet source
	dependencies = {
		'rafamadriz/friendly-snippets',
	},

	---@module 'blink.cmp'
	---@type blink.cmp.config
	opts = {
		-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
		-- 'super-tab' for mappings similar to vscode (tab to accept)
		-- 'enter' for enter to accept
		-- 'none' for no mappings
		--
		-- All presets have the following mappings:
		-- C-space: Open menu or open docs if already open
		-- C-n/C-p or Up/Down: Select next/previous item
		-- C-e: Hide menu
		-- C-k: Toggle signature help (if signature.enabled = true)
		--
		-- See :h blink-cmp-config-keymap for defining your own keymap
		keymap = {
			preset = 'default',
			['<C-k>'] = {}, -- Let ctrl-k work for digraphs
			['<C-/>'] = { 'show_signature', 'hide_signature', 'fallback' },
		},

		completion = {
			-- (Default) Only show the documentation popup when manually triggered
			documentation = { auto_show = true }
		},

		-- function signature disabled by default
		signature = { enabled = true },

		-- Default list of enabled providers defined so that you can extend it
		-- elsewhere in your config, without redefining it, due to `opts_extend`
		sources = {
			default = { 'lsp', 'path', 'snippets', 'buffer' },

			-- Add orgmode completion
			per_filetype = {
				org = { 'orgmode' }
			},
			providers = {
				orgmode = {
					name = 'Orgmode',
					module = 'orgmode.org.autocompletion.blink',
					fallbacks = { 'buffer' },
				},
			},
		},

		-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
		-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
		-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
		--
		-- See the fuzzy documentation for more information
		fuzzy = { implementation = "prefer_rust_with_warning" }
	},
	opts_extend = { "sources.default" }
}
