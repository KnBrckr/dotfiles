#!/usr/bin/python3
#
# Usage:
# cflow -b --print-level <src-files> 2> /dev/null | python3 cflow2dot.py > tcp.dot

import sys
import re

call_stack=[]

print("digraph {")

for line in sys.stdin:
    # Line format: {  n}    function() <func(args) at file:line>:
    match = re.search(r"{(.*)}\s*(\w*)\(\) \<", line)
    if match:
        level = int(match.group(1))
        function = match.group(2)

        # Cleanup call stack so top is caller of this function
        while (len(call_stack) > level ):
            call_stack.pop()

        if len(call_stack) > 0:
            print(call_stack[len(call_stack)-1],"->",function)

        # Add function to stack
        call_stack.append(function)

print("}")
