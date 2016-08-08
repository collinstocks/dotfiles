#!/bin/bash

# If the current load average is greater than 10, do not customize the prompt.
# Some of the prompt customizations run other programs, and if the load is
# too high, we may never get a prompt in that case.
# Note: The following is done entirely with bash commands, without executing
# any additional processes.
# Read the first number from /proc/loadavg. Handle the following cases:
#  - Stop at the dot. We get an integer.
#  - The dot is missing. Stop after 5 characters, splitting on space. We
#    get an integer.
#  - The load average is greater than five digits. We get some five-digit
#    integer that is certainly greater than 10.
read -d . -n 5 LOAD_1m IGNORED </proc/loadavg
(("$LOAD_1m" > 10)) && return
unset LOAD_1m
unset IGNORED

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

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
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

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

# git
function parse_git_dirty {
[[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working directory clean" ]] && echo "*"
}
function parse_git_branch {
git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)]/"
}

PS1=$BASH_INDENT
if [ "$color_prompt" = yes ]; then
    PS1+='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]-\[\033[1;31m\]$(date +%Y%m%d)\[\033[00m\]:\[\033[01;34m\]\w\[\033[1;33m\]$(parse_git_branch)\[\033[00m\]\$ '
else
    PS1+=':${debian_chroot:+($debian_chroot)}\u@\h-$(date +%Y%m%d):\w$(parse_git_branch)\$ '
fi
unset color_prompt force_color_prompt
export BASH_INDENT="$BASH_INDENT>"

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

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

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


source .env


# Aliases:

alias sts='ssh -l ubuntu -i ~/.ssh/sts-keypair.pem'

alias ack='ack-grep'

alias asdf='setxkbmap -rules evdev -model pc104 -layout "us" -variant "dvorak" -option "grp:alt_caps_toggle"'

alias reset='stty sane && tput reset'

alias androidfox='adb forward tcp:6000 localfilesystem:/data/data/org.mozilla.firefox/firefox-debugger-socket'

alias termchrome=$'kill $(ps -A | grep [Cc]hrome | awk \'{ print $1 }\')'
alias killchrome=$'kill -9 $(ps -A | grep [Cc]hrome | awk \'{ print $1 }\')'

alias gitroot='cd "$(git rev-parse --show-toplevel)"'
alias gr='gitroot'
