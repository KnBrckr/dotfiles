-- Hex to decimal and decimal to hex functions

local function hex2dec(hex)
  return tonumber(hex, 16)
end

local function dec2hex(dec)
  return string.format("%#x", dec)
end

vim.api.nvim_create_user_command(
	'Hex2dec',
	function(opts)
		print(string.format("%s = %s", opts.args, hex2dec(opts.args)))
	end,
	{ nargs = 1 }
)

vim.api.nvim_create_user_command(
	'Dec2hex',
	function(opts)
		print(string.format("%s = %s", opts.args, dec2hex(opts.args)))
	end,
	{ nargs = 1 }
)
