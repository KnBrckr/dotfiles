#!/usr/bin/python3
import sys
import re

call_stack=[]

print("digraph {")

for line in sys.stdin:
    line = line.rstrip()
    # Line format {  x}    function() <func(args) at file:line>:
    match = re.search(r"{(.*)}\s*(\w*)\(\) \<", line)
    if match:
        level = int(match.group(1))
        function = match.group(2)

        while (len(call_stack) > level ):
            call_stack.pop()

        if len(call_stack) > 0:
            print(call_stack[len(call_stack)-1],"->",function)

        call_stack.append(function)

print("}")
