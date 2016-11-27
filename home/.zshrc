## Creating history and cache dirs
HISTDIR="$HOME/.local/share/history"
[ -d "$HISTDIR" ] || mkdir -p "$HISTDIR"
CACHEDIR="$HOME/.cache/zsh"
[ -d "$CACHEDIR" ] || mkdir -p "$CACHEDIR"

## Changing Directories
setopt AUTO_CD			# use /dir instead of cd /dir
setopt AUTO_PUSHD		# cd = pushd
#setopt CDABLE_VARS		# cd user = cd ~user
setopt PUSHD_SILENT		# silent pushd
#setopt PUSHD_IGNORE_DUPS	# may be turn it on in interactive shell?

## Expansion and Globbing
#GLOB_DOTS
#setopt EXTENDED_GLOB		# Turn if off, cause it uses special meaning for ^
setopt NOMATCH			# print shell on ls a* if there are no a*
setopt NUMERIC_GLOB_SORT	# sort filenames numerically
setopt BRACECCL			# {1-3}=1 2 3

## Input/Output
setopt NOCLOBBER		# don’t write over existing files with >, use >! instead
setopt HASH_CMDS		# hash commands
setopt HASH_DIRS		# hash directories
setopt PRINT_EXIT_VALUE		# print exit value on error
setopt MULTIOS			# allow echo a >file1 >file2
#MAIL_WARNING

## History
#{{{
setopt APPEND_HISTORY		# append, not overwrite
setopt EXTENDED_HISTORY		# add timestamps to history
setopt HIST_EXPIRE_DUPS_FIRST	# on expire, first expire dupes
setopt HIST_IGNORE_DUPS		# forget sequence dupes
setopt HIST_IGNORE_SPACE	# forget commands begins with space
setopt HIST_REDUCE_BLANKS	# reduce blanks in history
setopt INC_APPEND_HISTORY	# append history after every one command
setopt HIST_NO_STORE		# do not store "fc -l" in history
HISTFILE="$HISTDIR/zsh"
HISTSIZE=25000
SAVEHIST=25000
HISTORY_IGNORE='(ls|bg|fg|cd *|run-help *|popd)'

#}}}

## ZLE magic and key bindings
#{{{
bindkey -e				# OMG! Emacs mode rule, vi mode suxx!

setopt interactive_comments		# Allow comments in interactive mode

#bindkey '^fi' push-line					# Push line into buffer until next <CR>
bindkey "^[[5~" history-beginning-search-backward	# PgUp for history search
bindkey '^[[6~' history-beginning-search-forward	# PgDown for history search
#bindkey -s '^B' " &\n"					# run in background
bindkey -s '^Z' "fg\n"					# fetch background job into foreground

# Predictable input, may be I'll use it?
#autoload predict-on
#zle -N predict-on
#zle -N predict-off
#bindkey '^X^Z' predict-on
#bindkey '^X^X' predict-off

# Help on help command or ^[h
autoload run-help
autoload run-help-git
autoload run-help-svn
alias help=run-help

if [ "$TERM" = "screen" ];then
  bindkey '^@' backward-delete-char
  bindkey '^[^@' backward-kill-word
  unsetopt BEEP
fi
 
#}}}

## Correction system
#{{{
setopt CORRECT			# use correction
setopt CORRECT_ALL		# correct arguments
CORRECT_IGNORE_FILE='.*'
SPROMPT='zsh: correct '%R' to '%r' ? [yes/No/edit/abort] '
#}}}

## Job Control
#{{{
setopt AUTO_CONTINUE		# auto cotinue disowned jobs
setopt CHECK_JOBS		# report jobs status when exiting shell
setopt LONG_LIST_JOBS		# long jobs list format
setopt NOTIFY			# report status now, not waiting for prompt
#AUTO_RESUME
setopt NO_BG_NICE		# Don’t nice background processes
#}}}

## Various builtins
#{{{

autoload zcalc		# nice commandline calc
autoload zmv zcp zln	# powerfull mv, cp, lv analogs with glob support: zmv '(*).lis' '$1.txt'
autoload zargs		# something like zargs -- **/*(.) -- ls -l

#zmodload zsh/files	# builtin chown, mv, rm etc
zmodload zsh/sched	# builtin at replacement

# Autoload zsh modules when they are referenced
#zmodload -a zsh/stat stat
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof
zmodload -a zsh/mapfile mapfile

#}}}


## Various exports
#{{{

setopt ALL_EXPORT

DEBFULLNAME="Alexander GQ Gerasiov"
DEBEMAIL="gq@debian.org"

PATH="$PATH:/usr/local/sbin/:/sbin:/usr/sbin"
[ -d /usr/lib/ccache ] && PATH=/usr/lib/ccache:"${PATH}"
[ -d ~/bin ] && PATH=~/bin:"${PATH}"
typeset -U path				# remove duplicates

SHELL=$(which zsh)

TZ="Europe/Moscow"
which less > /dev/null && PAGER='less'
which vim > /dev/null && EDITOR='vim'
alias grep='grep --color=auto'
GREP_COLORS='1;32'
LESS='-R -M --shift 5'
LESSHISTFILE="$HISTDIR/less"

which lesspipe > /dev/null && eval $(lesspipe)
which dircolors > /dev/null && eval $(dircolors)
#ZLS_COLORS=LS_COLORS

unsetopt ALL_EXPORT
#}}}

## Prompting
#{{{

setopt PROMPT_CR PROMPT_SP 	# Some magic. It's on by default, so doesn't matter

autoload colors zsh/terminfo

if [[ "$terminfo[colors]" -ge 8 ]]; then
	colors
fi

for color in BLACK RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
	eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
	eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
	(( count = $count + 1 ))
done

PR_NO_COLOR="%{$terminfo[sgr0]%}"

setopt ALL_EXPORT
PS1="[$PR_BLUE%n$PR_NO_COLOR@$PR_GREEN%U%m%u$PR_NO_COLOR:$PR_RED%~$PR_NO_COLOR]%(!.#.$) "
test "$MC_SID" && PS1="(mc)$PS1"
unsetopt ALL_EXPORT

#}}}

## Header function
#{{{
case "$TERM" in
  xterm*|rxvt)
    setxtermheader() { print -Pn "\e]0;$*\a" }
    ;;
  screen)
    setxtermheader() { print -Pn "\ek$*\e\\" }
    ;;
  *)
    setxtermheader() { ; }
esac
#}}}

## Hook functions
#{{{
precmd () { setxtermheader "%n@%m: %~" }
preexec () { setxtermheader "%n@%m: ${1//\%/\%\%}" }
#chpwd () { }

#}}}

## Aliases
#{{{

alias ls='ls --color=auto '
alias 2koi8r='export LANG=ru_RU.KOI8-R'
alias 2utf8='export LANG=ru_RU.UTF-8'

if which grc >/dev/null; then
  for COMMAND in \
	  ping traceroute netstat ifconfig \
	  mount df \
	  configure make gcc g++ \
	  diff wdiff \
	  cvs;
  do
    alias ${COMMAND}="grc --colour=auto $COMMAND"
  done
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

## Completion
#{{{
#ALWAYS_TO_END AUTO_LIST
setopt AUTO_MENU		# menu-completion on by default
setopt LIST_TYPES		# add file-type mark at the end of filename
setopt HASH_LIST_ALL		# 
setopt LIST_BEEP		# beep when list appears

autoload -U compinit
compinit -d "$CACHEDIR/zcompdump"

zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "$CACHEDIR/zcomphost-$HOST"
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' menu select=1 _complete _ignored _approximate
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/2 )) numeric )'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'

#zstyle ':completion:*' completer \
#	_complete _correct _approximate
#zstyle ':completion:incremental:*' completer \
#	_complete _correct
#zstyle ':completion:predict:*' completer \
#	_complete

# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

zmodload zsh/complist

# command for process lists, the local web server details and host completion
# on processes completion complete all user processes
zstyle ':completion:*:processes' command 'ps -au$USER'

## add colors to processes for kill completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

zstyle ':completion:*:processes' command 'ps ax -o pid,s,nice,stime,args'
zstyle ':completion:*:*:kill:*:processes' command 'ps --forest -A -o pid,user,cmd'
zstyle ':completion:*:processes-names' command 'ps axho command' 

# ignore completion functions (until the _ignored completer)
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:*:*:users' ignored-patterns `cat /etc/passwd | awk -F ":" '{ if($3<1000 || $3==65534) print $1 }'`
#}}}

# Add host-specific zshrc
if [ -f $HOME/.zshrc-$HOST ]
then
    . $HOME/.zshrc-$HOST
fi

# If there are running screens info on them
if which screen > /dev/null; then
	ZSHRC_SCREENLIST=(${${(M)${(f)"$(screen -ls)"}:#(#s)[[:space:]]##([0-9]##).*}/(#b)[[:space:]]#([0-9]##).*/$match[1]})
	if [ $#ZSHRC_SCREENLIST -ge 1 ]; then
		echo "There are $#ZSHRC_SCREENLIST screens running. $ZSHRC_SCREENLIST"
	fi
fi

# Keep .zshrc compiled %)
#autoload -U zrecompile
#[ -f ~/.zshrc ] && zrecompile -p ~/.zshrc && rm -f ~/.zshrc.zwc.old

