#!/bin/zsh
# zsh_options

# Allow automatic cd to a directory
setopt AUTO_CD

# Case-insensitive globbing (used in pathname expansion)
setopt NO_CASE_GLOB

# Enable shell correction for commands, but *not* for arguments!
# Autocorrect does not understand such things as custom git commands making
# it very annoying indeed.
setopt CORRECT
unsetopt CORRECT_ALL
