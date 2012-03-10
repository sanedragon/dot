# Bring in aliases

[ -f $HOME/.aliases ] && source $HOME/.aliases

# Enable programmable completion features

if [ -f /etc/bash_completion ] && ! shopt -oq posix ; then
	source /etc/bash_completion
fi

# Paths

[ -d $HOME/.local/bin ] && export PATH=~/.local/bin:"${PATH}"
[ -d $HOME/bin ] && export PATH=~/bin:"${PATH}"
[ -d $HOME/.bin ] && export PATH=~/.bin:"${PATH}"

# Settings

export LANGUAGE="en"
export LC_MESSAGES="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export TERM="xterm-color"
export TZ="America/Los_Angeles"
shopt -s checkwinsize		# update window size
shopt -s expand_aliases		# aliases in scripts
export PAGER='less -S'
export LESSCHARSET='utf-8'
export LESSOPEN='|/usr/bin/lesspipe.sh %s 2>&-'
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
umask 002
ssh-add &> /dev/null
if [ -d /digi/vod/VOD_TMP ] ; then
	export TMPDIR=/digi/vod/VOD_TMP
fi
export RTK_POST_TEST_HOOK=/home/estrickland/work/game/game.pl

# Prompt

. git-completion.sh
. bash-colors.sh
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM='auto'
export PS1="${BBlue}\h:${Color_Off}${BGreen}\w${Color_Off} \$(__git_ps1 \"${BPurple}(%s)${Color_Off}\")\n${BIYellow}⚡${Color_Off} "

# History
shopt -s histappend
export HISTFILESIZE=5000000
export HISTSIZE=5000
export HISTIGNORE='l:ls:la:ll:cd:w'
export HISTTIMEFORMAT='%Y-%m-%d %H:%M:%S - '
export HISTCONTROL=ignoredups:ignorespace

# Helper functions

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

function extract()
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

calc() { bc <<< "scale=4; $@"; } # quick bc frontend with 4 decimal precision
title() { echo -ne "\e];$@\007"; } # change terminal/tab title
manopt() { man $1 | sed -n "/^\s\+-\+$2\b/,/^\s*$/p"|sed '$d;'; } # only show part of man page for specified option. Ex: manopt rm I

# find 10 most common bash commands
function cmds ()
{
	export IFS=$'\n'
	export HISTORY_LENGTH=`history | wc -l`
	export TOP_TEN_CMDS=`history | awk '{print $5}' | sort | uniq -c | sort -nr | head -n 10`
	export START_DATE=`history | awk '{print $2}' | sort | uniq | sort -r | tail -n 1`
	export END_DATE=`history | awk '{print $2}' | sort | uniq | sort | tail -n 1`
	echo -e "\033[34mTop ten most used commands (Count, Command, % of history):\033[0m "
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

# nice git helper functions
. git-helpers.sh

# helpful stuff for work
. rtk-helpers.sh
