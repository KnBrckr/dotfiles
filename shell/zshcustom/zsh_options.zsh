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

# ==================
# = Shell History  =
# ==================

# Increase the maximum number of lines contained in the history file
# (default is 500)
SAVEHIST=100000

# Increase the maximum number of commands to remember
# (default is 500)
HISTSIZE=100000

# Make some commands not show up in history
HISTORY_IGNORE="(ls|ls -l|cd|cd -|cd ..|pwd|exit|date|* --help|vim)"

# Save command start and duration to history
setopt EXTENDED_HISTORY
# Append to history
setopt APPEND_HISTORY
# adds commands as after command is finished, not at shell exit
# Mutually exclisive with SHARE_HISTORY and INC_APPEND_HISTORY
setopt INC_APPEND_HISTORY_TIME
setopt NO_SHARE_HISTORY
# expire duplicates first
setopt HIST_EXPIRE_DUPS_FIRST 
# remove older version of duplicates
setopt HIST_IGNORE_ALL_DUPS
# omit older commands that duplicate new ones when saving hist
setopt HIST_SAVE_NO_DUPS
#ignore duplicates when searching
setopt HIST_FIND_NO_DUPS
# removes superflousous blanks from command to add
setopt HIST_REDUCE_BLANKS
# verify history before entering
setopt HIST_VERIFY

# Set autosuggest color (for zsh-autocomplete plugin)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=fg=10
