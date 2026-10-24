#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# Unlimited & lossless bash history
HISTSIZE=-1
HISTFILESIZE=-1
HISTCONTROL=
shopt -s histappend
PROMPT_COMMAND="history -a${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

# Added by Antigravity CLI installer
export PATH="/home/maviles/.local/bin:$PATH"

# Dotfiles na home com Git bare
alias dotfiles-config='git --git-dir="$HOME/.dotfiles" --work-tree="$HOME"'
