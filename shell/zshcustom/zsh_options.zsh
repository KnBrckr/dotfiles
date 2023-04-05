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
SAVEHIST=5000

# Increase the maximum number of commands to remember
# (default is 500)
HISTSIZE=2000

# Make some commands not show up in history
HISTORY_IGNORE="(ls|cd|cd -|pwd|exit|date|* --help)"

# Use extended history
setopt EXTENDED_HISTORY
# Share history across multiple zsh sessions
setopt SHARE_HISTORY
# Append to history
setopt APPEND_HISTORY
# adds commands as they are typed, not at shell exit
setopt INC_APPEND_HISTORY
# expire duplicates first
setopt HIST_EXPIRE_DUPS_FIRST 
# do not store duplications
setopt HIST_IGNORE_DUPS
#ignore duplicates when searching
setopt HIST_FIND_NO_DUPS
# removes blank lines from history
setopt HIST_REDUCE_BLANKS
# verify history before entering
setopt HIST_VERIFY

# Set autosuggest color (for zsh-autocomplete plugin)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=fg=10
