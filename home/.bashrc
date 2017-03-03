# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# if zsh exists use it
which zsh >/dev/null&& [ -z "$FORCE" ] && exec zsh

# Modify PATH
PATH="$PATH:/usr/local/sbin/:/sbin:/usr/sbin"
[ -d /usr/lib/ccache ] && PATH=/usr/lib/ccache:"${PATH}"
[ -d ~/bin ] && PATH=~/bin:"${PATH}"
export PATH

HISTDIR="$HOME/.local/share/history"
[ -d "$HISTDIR" ] || mkdir -p "$HISTDIR"

# Export some variables
export DEBFULLNAME="Alexander GQ Gerasiov"
export DEBEMAIL="gq@debian.org"

export SHELL=$(which bash)

TZ="Europe/Moscow"

which less > /dev/null && export PAGER='less'
which vim > /dev/null && export EDITOR='vim'
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;32'
export LESS='-R -M --shift 5'
export LESSHISTFILE="$HISTDIR/less"

which lesspipe > /dev/null && eval $(lesspipe)
which dircolors > /dev/null && eval $(dircolors)


# Control history
# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoreboth
export HISTIGNORE="[bf]g:exit:popd:ls:cd:cd -"
export HISTFILE="$HISTDIR/bash"

#append history to file on every command
PROMPT_COMMAND='history -a'

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# append history to file, not overwrite
shopt -s histappend

#euristic cd command
shopt -s cdspell

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(</etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm)
    PS1='${debian_chroot:+($debian_chroot)}(bash)[\[\033[01;34m\]\u\[\033[00m\]@\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;31m\]\w\[\033[00m\]]\$ '
    ;;
*)
    PS1='${debian_chroot:+($debian_chroot)}(bash)\u@\h:\w\$ '
    ;;
esac

# prefix mc sessions
test "$MC_SID" && PS1="(mc)$PS1"


# Comment in the above and uncomment this below for a color prompt
#PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'";$PROMPT_COMMAND"
    ;;
screen)
    PROMPT_COMMAND='echo -ne "\033k${USER}@${HOSTNAME}: ${PWD/$HOME/~}\033\\"'";$PROMPT_COMMAND"
    ;;
*)
    ;;
esac

## Aliases
#{{{

alias ls='ls --color=auto '
alias 2koi8r='export LANG=ru_RU.KOI8-R'
alias 2utf8='export LANG=ru_RU.UTF-8'

if which grc >/dev/null; then
  alias ping="grc --colour=auto ping"
  alias traceroute="grc --colour=auto traceroute"
  alias make="grc --colour=auto make"
  alias diff="grc --colour=auto diff"
  alias cvs="grc --colour=auto cvs"
  alias netstat="grc --colour=auto netstat"
fi

#}}}

## Functions
#{{{
mvln () {
	if [ $# -ne 2 ];then
		echo "Usage: mvln source destination" >&2
		return 1
	fi

	local SOURCE="$1"
	local TARGET="$2"

	if [ -d "$TARGET" ];then
		TARGET="$TARGET"/"$(basename "$SOURCE")"
	fi

	mv "$SOURCE" "$TARGET"||return 1
	ln -s "$TARGET" "$SOURCE"||return 1
}

#}}}

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

if [ -f ~/.bash_completion ]; then
    . ~/.bash_completion
fi

# If there are running screens info on them
if which screen > /dev/null; then
	ZSHRC_SCREENLIST=$(screen -ls | awk '/^[\t ]/ { ORS=" "; gsub(/\..*/,""); print $1}')
	if [ "$ZSHRC_SCREENLIST" ]; then
		echo "There are screens running: $ZSHRC_SCREENLIST"
	fi
fi

