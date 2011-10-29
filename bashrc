# aliases
if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# some shell options
shopt -s checkwinsize	# update window size
shopt -s expand_aliases # aliases in scripts

# make less more friendly for non-text input files, see lesspipe(1)
alias more='less'
export PAGER=less
export LESSCHARSET='utf-8'
export LESSOPEN='|/usr/bin/lesspipe.sh %s 2>&-'
#export LESS='-i -N -w  -z-4 -g -e -M -X -F -R -P%t?f%f \
#:stdin .?pb%pb\%:?lbLine %lb:?bbByte %bb:-...'
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable programmable completion features
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
	. /etc/bash_completion
fi

# set PATH so it includes user's private bin if it exists
if [ -d ~/bin ] ; then
	export PATH=~/bin:"${PATH}"
fi

if [ -d ~/.local/bin ] ; then
	export PATH=~/.local/bin:"${PATH}"
fi

if [ -d ~/.bin ] ; then
	export PATH=~/.bin:"${PATH}"
fi

# settings
export TERM="xterm-color"
export TZ="America/Los_Angeles"

# prompt
source git-completion.sh
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM='auto'

source bash-colors.sh
export PS1="${BGreen}\W${Color_Off}\$(__git_ps1 \" ${BPurple}(%s)${Color_Off}\") ${BIYellow}⚡${Color_Off} "
#export PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ 'i
#export PS1="\W$(__git_ps1 "(%s)") ⚡ " # no colors

# history
shopt -s histappend
export HISTFILESIZE=5000000
export HISTSIZE=5000
export HISTIGNORE='l:ls:la:ll:cd'
export HISTTIMEFORMAT='%Y-%m-%d %H:%M:%S - '
export HISTCONTROL=ignoredups:ignorespace

# Find a file with a pattern in name:
function ff() { find . -type f -iname '*'$*'*' -ls ; }

# Find a file with pattern $1 in name and Execute $2 on it:
function fe() { find . -type f -iname '*'${1:-}'*' -exec ${2:-file} {} \;  ; }

# Find a pattern in a set of files and highlight them:
# (needs a recent version of egrep)
function fstr()
{
    OPTIND=1
    local case=""
    local usage="fstr: find string in files.
Usage: fstr [-i] \"pattern\" [\"filename pattern\"] "
    while getopts :it opt
    do
        case "$opt" in
        i) case="-i " ;;
        *) echo "$usage"; return;;
        esac
    done
    shift $(( $OPTIND - 1 ))
    if [ "$#" -lt 1 ]; then
        echo "$usage"
        return;
    fi
    find . -type f -name "${2:-*}" -print0 | \
    xargs -0 egrep --color=always -sn ${case} "$1" 2>&- | more

}

function cuttail() # cut last n lines in file, 10 by default
{
    nlines=${2:-10}
    sed -n -e :a -e "1,${nlines}!{P;N;D;};N;ba" $1
}

function extract()      # Handy Extract Program.
{
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xvjf $1     ;;
             *.tar.gz)    tar xvzf $1     ;;
             *.bz2)       bunzip2 $1      ;;
             *.rar)       unrar x $1      ;;
             *.gz)        gunzip $1       ;;
             *.tar)       tar xvf $1      ;;
             *.tbz2)      tar xvjf $1     ;;
             *.tgz)       tar xvzf $1     ;;
             *.zip)       unzip $1        ;;
             *.Z)         uncompress $1   ;;
             *.7z)        7z x $1         ;;
             *)           echo "'$1' cannot be extracted via >extract<" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

# useful odds and ends
calc() { bc <<< "scale=4; $1"; } # quick bc frontend with 4 decimal precision
title() { echo -ne "\e];$1\007"; } # change terminal/tab title
manopt() { man $1 | sed -n "/^\s\+-\+$2\b/,/^\s*$/p"|sed '$d;'; } # Func to only show part of man page for specified option. Ex: manopt rm I

# find 10 most common bash commands
function cmds ()
{
	# This lets us iterate per line instead of over count then cmd:
	export IFS=$'\n'
	export HISTORY_LENGTH=`history | wc -l`
	export TOP_TEN_CMDS=`history | awk '{print $5}' | sort | uniq -c | sort -nr | head -n 10`
	export START_DATE=`history | awk '{print $2}' | sort | uniq | sort -r | tail -n 1`
	export END_DATE=`history | awk '{print $2}' | sort | uniq | sort | tail -n 1`
	echo -e "\033[34mTop ten most used commands (Count, Command, % of history):\033[0m "
	# Show the 10 most common commands, with percentage of total, in red if 10 chars or more.
	for CMD in $TOP_TEN_CMDS; do
		export CMD_COUNT=`echo $CMD | awk '{print $1}'`
		export CMD_PERCENT=`echo "scale=2; 100 * $CMD_COUNT / $HISTORY_LENGTH" | bc`
		export SHORT_CMD=`echo $CMD | awk '{print $2}'`
		if [ ${#SHORT_CMD} -ge 10 ]; then
			echo -e "\033[31m * $CMD ($CMD_PERCENT%)\033[0m - Length ${#SHORT_CMD}, might want to form an alias for this."
		else
			echo " * $CMD ($CMD_PERCENT%)"
		fi
	done
	echo -e "\033[34m$HISTORY_LENGTH lines in history from $START_DATE to $END_DATE.\033[0m"
	unset IFS
}

# helper for git aliases
function git_current_tracking()
{
  local BRANCH="$(git describe --contains --all HEAD)"
  local REMOTE="$(git config branch.$BRANCH.remote)"
  local MERGE="$(git config branch.$BRANCH.merge)"
  if [ -n "$REMOTE" -a -n "$MERGE" ]
  then
	echo "$REMOTE/$(echo "$MERGE" | sed 's#^refs/heads/##')"
  else
	echo "\"$BRANCH\" is not a tracking branch." >&2
	return 1
  fi
}

# git log patch
function glp()
{
  # don't use the pager if in word-diff mode
  local pager="$(echo "$*" | grep -q -- '--word-diff' && echo --no-pager)"

  # use reverse mode if we have a range
  local reverse="$(echo "$*" | grep -q '\.\.' && echo --reverse)"

  # if we have no non-option args then default to listing unpushed commits in reverse moode
  if ! (for ARG in "$@"; do echo "$ARG" | grep -v '^-'; done) | grep -q . && git_current_tracking > /dev/null 2>&1
  then
	local default_range="$(git_current_tracking)..HEAD"
	local reverse='--reverse'
  else
	local default_range=''
  fi

  git $pager log --patch $reverse "$@" $default_range
}

# git log file
function glf()
{
  git log --format=%H --follow -- "$@" | xargs --no-run-if-empty git show --stat
}

# git log search
function gls()
{
  local phrase="$1"
  shift
  if [[ $# == 0 ]]
  then
	local default_range=HEAD
  fi
  glp --pickaxe-all -S"$phrase" "$@" $default_range
}

function gup
{
  # subshell for `set -e` and `trap`
  (
	set -e

	# use `git-up` if installed
	if type git-up > /dev/null 2>&1
	then
	  exec git-up
	fi

	# fetch upstream changes
	git fetch

	BRANCH=$(git describe --contains --all HEAD)
	if [ -z "$(git config branch.$BRANCH.remote)" -o -z "$(git config branch.$BRANCH.merge)" ]
	then
	  echo "\"$BRANCH\" is not a tracking branch." >&2
	  exit 1
	fi

	# create a temp file for capturing command output
	TEMPFILE="`mktemp -t gup.XXXXXX`"
	trap '{ rm -f "$TEMPFILE"; }' EXIT

	# if we're behind upstream, we need to update
	if git status | grep "# Your branch" > "$TEMPFILE"
	then

	  # extract tracking branch from message
	  UPSTREAM=$(cat "$TEMPFILE" | cut -d "'" -f 2)
	  if [ -z "$UPSTREAM" ]
	  then
		echo Could not detect upstream branch >&2
		exit 1
	  fi

	  # can we fast-forward?
	  CAN_FF=1
	  grep -q "can be fast-forwarded" "$TEMPFILE" || CAN_FF=0

	  # stash any uncommitted changes
	  git stash | tee "$TEMPFILE"
	  [ "${PIPESTATUS[0]}" -eq 0 ] || exit 1

	  # take note if anything was stashed
	  HAVE_STASH=0
	  grep -q "No local changes" "$TEMPFILE" || HAVE_STASH=1

	  if [ "$CAN_FF" -ne 0 ]
	  then
		# if nothing has changed locally, just fast foward.
		git merge --ff "$UPSTREAM"
	  else
		# rebase our changes on top of upstream, but keep any merges
		git rebase -p "$UPSTREAM"
	  fi

	  # restore any stashed changes
	  if [ "$HAVE_STASH" -ne 0 ]
	  then
		git stash pop
	  fi

	fi

  )
}

# rentrak
export SERVER_PORT=8080
export RTK_SUBSYSTEM=vod
export EDITOR=vim
export RENTASK_USER=estrickland
export RENTRAK_EMAIL=estrickland@rentrakmail.com
#export CVSWORK=/home/estrickland/work/ondemand/perl_lib
#ssh-agent $SHELL

cdtr()
{
	pattern=$1
	WORKDIR=$HOME/work

	if [[ -n "$pattern" ]]; then
		if [[ -d "$WORKDIR/$pattern" ]]; then
			work_dir="$WORKDIR/$pattern"
			title $pattern
			cd $work_dir
			export CVSWORK=`pwd`/perl_lib
			export PERL5LIB=`pwd`/perl_lib:$PERL5LIB
			export DOCUMENT_ROOT=`pwd`/web_src/vod/htdocs
			if [[ $work_dir =~ "([0-9]{6})" ]]; then
				task=${BASH_REMATCH[1]}
				rentask_clock.pl in $task
			fi
		else
			for dir in `find $WORKDIR -follow -maxdepth 1 -type d`; do
				branch_name=$(basename "$dir")
				if [[ $branch_name =~ ".*$pattern.*" ]]; then
					work_dir="$WORKDIR/$branch_name"
					title $branch_name
					cd $work_dir
					export CVSWORK=`pwd`/perl_lib
					export PERL5LIB=`pwd`/perl_lib:$PERL5LIB
					export DOCUMENT_ROOT=`pwd`/web_src/vod/htdocs
					if [[ $work_dir =~ "([0-9]{6})" ]]; then
						task=${BASH_REMATCH[1]}
						rentask_clock.pl in $task
					fi
					break
				fi
			done
		fi
	fi
}

