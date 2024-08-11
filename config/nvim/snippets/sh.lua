local ls = require("luasnip") -- {{{
local s = ls.s -- Snippet
local i = ls.i -- insert node
local t = ls.t -- text node

local d = ls.dynamic_node
local c = ls.choice_node
local f = ls.function_node
local sn = ls.snippet_node

local fmt = require("luasnip.extras.fmt").fmt

local snippets, autosnippets = {}, {}

local current_file = function(_, snip)
	return snip.env.TM_FILENAME
end

local year = function()
	return os.date("%Y")
end
-- }}}

-- Start of snippets

local getopts = s("getops", fmt([=[
#!/bin/bash
#
# File: {}
# Description: {}
#
# More safety, by turning some bugs into errors.
# Without `errexit` you don’t need ! and can replace
# PIPESTATUS with a simple $?, but that's not done here.
set -o errexit -o pipefail -o noclobber -o nounset

# glob patterns matching no files expands to null string vs themselves
shopt -s nullglob

# glob patterns that fail result in expansion error
# set -s failglob

# -allow a command to fail with !’s side effect on errexit
# -use return value from ${{PIPESTATUS[0]}}, because ! hosed $?
! getopt --test > /dev/null
if [[ ${{PIPESTATUS[0]}} -ne 4 ]]; then
    echo "Sorry, 'getopt --test' failed in this environment."
    exit 1
fi

OPTIONS=dfo:v
LONGOPTS=debug,force,output:,verbose

# -regarding ! and PIPESTATUS see above
# -temporarily store output to be able to check for errors
# -activate quoting/enhanced mode (e.g. by writing out “--options”)
# -pass arguments only via   -- "$@"   to separate them correctly
! PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@")
if [[ ${{PIPESTATUS[0]}} -ne 0 ]]; then
    # e.g. return value is 1
    #  then getopt has complained about wrong arguments to stdout
    exit 2
fi
# read getopt’s output this way to handle the quoting right:
eval set -- "$PARSED"

d=n f=n v=n outFile=-
# now enjoy the options in order and nicely split until we see --
while true; do
    case "$1" in
        -d|--debug)
            d=y
            shift
            ;;
        -f|--force)
            f=y
            shift
            ;;
        -v|--verbose)
            v=y
            shift
            ;;
        -o|--output)
            outFile="$2"
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Programming error"
            exit 3
            ;;
    esac
done

# handle non-option arguments
if [[ $# -ne 1 ]]; then
    echo "$0: A single input file is required."
    exit 4
fi

echo "verbose: $v, force: $f, debug: $d, in: $1, out: $outFile"
]=], {
		f(current_file),
		i(1, "Description"),
}))
table.insert(snippets, getopts)

-- header: File header {{{
local header = s("header", fmt([[
#!/bin/bash
#
# File: {}
# Description: {}
#
# - CONFIDENTIAL -
#
# Copyright (c) {} International Lottery & Totalizator Systems, Inc.
# All Rights Reserved www.ilts.com
#

]], {
		f(current_file),
		i(1, "Description"),
		f(year),
}))
table.insert(snippets, header)
-- }}}

-- End of snippets

return snippets, autosnippets
