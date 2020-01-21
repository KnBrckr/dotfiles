# Dragon Theme

# Instructions on Prompt handling:
# http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Prompt-Expansion
# https://scriptingosx.com/2019/07/moving-to-zsh-06-customizing-the-zsh-prompt/
# https://shuheikagawa.com/blog/2019/10/08/migrating-from-bash-to-zsh/
#

set_prompts() {

    local hostStyle=""
    local userStyle=""
	local seperator="$FG[white]|"
	
	# Setup colors - view definitions using spectrum_ls or spectrum_bls
	local host_color=$FG[038]
	local host_colorspecial=$FX[bold]$FG[009]
	local workingdir_color=$FG[002]
	local red=$FG[009]
	local green=$FG[002]

	# Undo system default
	unset update_terminal_cwd
	unset PROMPT_COMMAND

    # build the prompt

    # logged in as root
    if [[ "$USER" == "root" ]]; then
        userStyle="$host_colorspecial"
    else
        userStyle="$host_color"
    fi

    # connected via ssh
    if [[ "$SSH_TTY" ]]; then
        hostStyle="$host_colorspecial"
    else
        hostStyle="$host_color"
    fi

    # set the terminal title to user@host + current working directory
#    PS1="\[\033]0;\u@\h: \w\007\]"

    PS1="$userStyle%n" # username
    PS1+="$hostStyle@%m" # host
    PS1+="${seperator}${workingdir_color}%1~" # working directory
	
	# Prompt indicator
	PS1+=" %(?:${green}⟶ :${red}⊝ )%{$reset_color%}"

    export PS1
}

RPS1='$(git_prompt_info)' # git repository details on the right
PS2='%_⇉ '

set_prompts
unset set_prompts

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"