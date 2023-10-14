# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Local shell style (https://github.com/Scriptim/bash-prompt-generator)
#PS1='[\u@\h \W]\$ ' # Uncolored
PS1='\[\e[32m\][\[\e[38;5;22m\]\u@\h \[\e[0m\]\w\[\e[32m\]]\[\e[0m\]\$ ' # Green

# Foot compatibility with SSH
export TERM=xterm-256color

# Shell aliases
alias ls="ls --color=auto"
alias grep="grep --color=auto"
alias xrandr_props="perl -E '$_ = qx/xrandr --props/; for (split /^(?!\s)/sm) { chomp; say if /^\S* connected/; }'"
alias amdgpu_top="amdgpu_top --smi"

# Clean MOTD
if [[ "`tty`" = /dev/tty[1-9] && $(ps -o comm= -p $PPID) = login ]]; then
	clear
fi
