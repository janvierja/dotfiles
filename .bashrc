# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
	*i*) ;;
	*) return;;
esac

export LANG=en_US.UTF-8

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
	xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
		# We have color support; assume it's compliant with Ecma-48
		# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
		# a case would tend to support setf rather than setaf.)
		color_prompt=yes
	else
		color_prompt=
	fi
fi

if [ "$color_prompt" = yes ]; then
	PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
	PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
# unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
	xterm*|rxvt*)
		PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
		;;
	*)
		;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto'
	#alias dir='dir --color=auto'
	#alias vdir='vdir --color=auto'

	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lt='ls --human-readable --size -1 -S --classify'
alias ltr='ls -ltrF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

if [ -f ~/.bash_functions ]; then
	. ~/.bash_functions
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

# remove duplicate path entries
export PATH=$(echo $PATH | awk -F: '
{ for (i = 1; i <= NF; i++) arr[$i]; }
END { for (i in arr) printf "%s:" , i; printf "\n"; } ')

# autocomplete ssh commands
complete -W "$(echo `cat ~/.bash_history | egrep '^ssh ' | sort | uniq | sed 's/^ssh //'`;)" ssh

# terminal colors
if tput setaf 1 &> /dev/null; then
	tput sgr0 # reset colors
	bold=$(tput bold)
	blink=$(tput blink) # blinking
	reverse=$(tput rev) # reverse video
	begin_u=$(tput smul) # start underline
	end_u=$(tput rmul) # end underline
	begin_h=$(tput smso) # start highlight
	begin_h=$(tput rmso) # end highlight

	reset=$(tput sgr0)

	# Solarized colors; taken from http://git.io/solarized-colors
	black=$(tput setaf 0)
	blue=$(tput setaf 153)
	green=$(tput setaf 71)
	orange=$(tput setaf 166)
	red=$(tput setaf 167)
	white=$(tput setaf 15)
	yellow=$(tput setaf 228)

	# gruvbox dark colors; taken from https://github.com/morhetz/gruvbox
	#black=$(tput setaf 235)
	#blue=$(tput setaf 109)
	#green=$(tput setaf 106)
	#orange=$(tput setaf 166)
	#red=$(tput setaf 167)
	#white=$(tput setaf 15)
	#yellow=$(tput setaf 214)
else
	reset='\e[0m'		# reset colors
	black='\e[0;30m'	# black
	red='\e[0;31m'		# red
	green='\e[0;32m'	# green
	yellow='\e[0;33m'	# yellow
	blue='\e[0;34m'		# blue
	purple='\e[0;35m'	# purple
	cyan='\e[0;36m'		# cyan
	white='\e[0;37m'	# white

	# bold
	bblack='\e[1;30m'	# black
	bred='\e[1;31m'		# red
	bgreen='\e[1;32m'	# green
	byellow='\e[1;33m'	# yellow
	bblue='\e[1;34m'	# blue
	bpurple='\e[1;35m'	# purple
	bcyan='\e[1;36m'	# cyan
	bwhite='\e[1;37m'	# white

	# underline
	ublack='\e[4;30m'       # black
	ured='\e[4;31m'         # red
	ugreen='\e[4;32m'       # green
	uyellow='\e[4;33m'      # yellow
	ublue='\e[4;34m'        # blue
	upurple='\e[4;35m'      # purple
	ucyan='\e[4;36m'        # cyan
	uwhite='\e[4;37m'       # white

	# background
	on_black='\e[40m'       # black
	on_red='\e[41m'         # red
	on_green='\e[42m'       # green
	on_yellow='\e[43m'      # yellow
	on_blue='\e[44m'        # blue
	on_purple='\e[45m'      # purple
	on_cyan='\e[46m'        # cyan
	on_white='\e[47m'       # white

	# high intensity
	iblack='\e[0;90m'       # black
	ired='\e[0;91m'         # red
	igreen='\e[0;92m'       # green
	iyellow='\e[0;93m'      # yellow
	iblue='\e[0;94m'        # blue
	ipurple='\e[0;95m'      # purple
	icyan='\e[0;96m'        # cyan
	iwhite='\e[0;97m'       # white

	# bold high intensity
	biblack='\e[1;90m'      # black
	bired='\e[1;91m'        # red
	bigreen='\e[1;92m'      # green
	biyellow='\e[1;93m'     # yellow
	biblue='\e[1;94m'       # blue
	bipurple='\e[1;95m'     # purple
	bicyan='\e[1;96m'       # cyan
	biwhite='\e[1;97m'      # white

	# high intensity backgrounds
	on_iblack='\e[0;100m'   # black
	on_ired='\e[0;101m'     # red
	on_igreen='\e[0;102m'   # green
	on_iyellow='\e[0;103m'  # yellow
	on_iblue='\e[0;104m'    # blue
	on_ipurple='\e[0;105m'  # purple
	on_icyan='\e[0;106m'    # cyan
	on_iwhite='\e[0;107m'   # white
fi


# Source other bash stuff
# Below taken from https://github.com/git/git contrib/completion dir
# git-prompt.sh has been customized to enable GIT_PS1_DECLARATIVE
source ~/dotfiles/git-completion.bash
source ~/dotfiles/git-prompt.sh

# When using gruvbox vim colorscheme, overload system-default 256-color palette
source ~/.vim/bundle/gruvbox/gruvbox_256palette.sh



# Setup prompts
if [ "$color_prompt" = yes ]; then

	GIT_PS1_SHOWDIRTYSTATE=1
	GIT_PS1_SHOWTRACKEDFILES=1
	GIT_PS1_SHOWUPSTREAM=verbose
	GIT_PS1_SHOWCOLORHINTS=1
	GIT_PS1_STATESEPARATOR=''
	GIT_PS1_SHOWSTASHSTATE=1
	GIT_PS1_DECLARATIVE=1

	PROMPT_COMMAND='__git_ps1 '
	PROMPT_COMMAND+='\\n"\[$green\]\u$reset at '
	PROMPT_COMMAND+='\[$yellow\]\h$reset in '
	PROMPT_COMMAND+='$blue\W$reset" '
	PROMPT_COMMAND+='"\n→  "'
	export PROMPT_COMMAND
fi

