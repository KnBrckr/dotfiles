# Put your custom themes in this folder.
# Example:

set_prompts() {

    local hostStyle=""
    local userStyle=""
	local seperator="%{$fg[white]%}|%{$reset_color%}"
	
	# Undo system default
	unset update_terminal_cwd
	unset PROMPT_COMMAND

    # build the prompt

    # logged in as root
    if [[ "$USER" == "root" ]]; then
        userStyle="%{$fg_bold$fg[red]%}"
    else
        userStyle="%{$fg[cyan]%}"
    fi

    # connected via ssh
    if [[ "$SSH_TTY" ]]; then
        hostStyle="%{$fg_bold$fg[red]%}"
    else
        hostStyle="%{$fg[cyan]%}"
    fi

    # set the terminal title to user@host + current working directory
#    PS1="\[\033]0;\u@\h: \w\007\]"

	PS1=""

    PS1+="$userStyle%n" # username
    PS1+="$hostStyle@%m" # host
    PS1+="$seperator%{$fg[green]%}%1~$seperator" # working directory
	
    PS1+='$(git_prompt_info)' # git repository details
	PS1+="%(?:%{$fg_bold[green]%}√ :%{$fg_bold[red]%}⊝ )%{$reset_color%}"

    export PS1
}

set_prompts
unset set_prompts

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"