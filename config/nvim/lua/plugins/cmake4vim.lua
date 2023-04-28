-- Cmake support
return {
	"ilyachur/cmake4vim",
	dependencies = {
		"tpope/vim-dispatch",
	},
	config = function()
		-- Save files and build (Make)
		vim.keymap.set('n', '<leader>m', function()
			vim.cmd([[wa]])
			vim.cmd([[CMakeBuild]])
		end)

		-- Redefine CTest command to include --output-on-failure
		vim.api.nvim_create_user_command("Ctest",
			"call cmake4vim#CTest('--output-on-failure', <f-args>)",
			{ force = true }
		)

		-- Quickfix not parsing cmake error:
		--   CMake Error at <file>:<line> (add_library)
		--     Cannot file source file:
		--
		--     <missing-file>
		vim.cmd([[set errorformat^=CMake\ Error\ at\ %f:%l\ (%m):]])

		-- Quickfix list error format for ctest errors using CMocka environment
		--
		-- General assertion failure:
		--   [  ERROR   ] --- <error text>
		--   [   LINE   ] --- <file>:<line>: error: Failure!
		vim.cmd([[set errorformat^=%E[\ \ %tRROR\ \ \ ]\ ---\ %m,%Z[\ \ \ LINE\ \ \ ]\ ---\ %f:%l:\ error:\ Failure!]])
		-- fail() Error format:
		--   [ ERROR ] --- [   LINE   ] --- <file>|<line>| error: <error text>
		vim.cmd([[set errorformat^=[\ \ %tRROR\ \ \ ]\ ---\ [\ \ \ LINE\ \ \ ]\ ---\ %f:%l:\ error:\ %m]])
		-- Cmock test setup failure:
		--   [   LINE   ] --- <file>:<line>: error: <error text>
		vim.cmd([[set errorformat^=[\ \ \ LINE\ \ \ ]\ ---\ %f:%l:\ %trror:\ %m]])
	end,
}
