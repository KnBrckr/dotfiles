#!/bin/zsh
# zsh_history
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

setopt EXTENDED_HISTORY       # Save command start and duration to history
setopt APPEND_HISTORY         # Append to history
setopt HIST_EXPIRE_DUPS_FIRST # expire duplicates first
setopt HIST_IGNORE_ALL_DUPS   # remove older version of duplicates
setopt HIST_REDUCE_BLANKS     # removes superflousous blanks from command to add
setopt HIST_SAVE_NO_DUPS      # omit older commands that duplicate new ones when saving hist
setopt HIST_FIND_NO_DUPS      #ignore duplicates when searching
setopt HIST_VERIFY            # verify history before entering

# adds commands as after command is finished, not at shell exit
# Mutually exclusive with SHARE_HISTORY and INC_APPEND_HISTORY
#
# History can be reloaded in a shell using `fc -RI`
setopt INC_APPEND_HISTORY_TIME
setopt NO_SHARE_HISTORY
setopt NO_INC_APPEND_HISTORY

alias reload_hist="fc -RI"
