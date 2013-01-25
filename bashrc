# exit if not bash
if [ -z $BASH_VERSION ]; then
    exit
fi

# manipulate path
[ -d /usr/local/sbin ]  && export PATH=/usr/local/sbin:"${PATH}"
[ -d /usr/local/bin ]   && export PATH=/usr/local/bin:"${PATH}"
[ -d $HOME/.local/bin ] && export PATH=$HOME/.local/bin:"${PATH}"
[ -d $HOME/bin ]        && export PATH=$HOME/bin:"${PATH}"
[ -d $HOME/.bin ]       && export PATH=$HOME/.bin:"${PATH}"

# upgrade bash if a preferential one exists (THIS IS DANGEROUS TODO: FIX)
if [ ${BASH_VERSINFO[0]} -ne 4 -a -n "$PS1" ]; then
    exec bash --login
fi

# sources

[ -f $HOME/.aliases ] && source $HOME/.aliases

if [ -f /etc/bash_completion ] && ! shopt -oq posix ; then
    source /etc/bash_completion
fi

if [ -n "$(which brew 2> /dev/null)" ]; then
    if [ -f `brew --prefix`/etc/bash_completion ]; then
        source `brew --prefix`/etc/bash_completion
    fi
fi

# so hard to find this freaking thing
if [ -n "$(which git-completion.sh 2> /dev/null)" ]; then
    source git-completion.sh
else
    [ -e /usr/share/git-core/git-completion.bash ] && source /usr/share/git-core/git-completion.bash
    [ -e /usr/share/git-core/contrib/completion/git-prompt.sh ] && source /usr/share/git-core/contrib/completion/git-prompt.sh
fi

[ -n "$(which bash-colors.sh 2> /dev/null)" ]       && source bash-colors.sh
[ -n "$(which git-helpers.sh 2> /dev/null)" ]       && source git-helpers.sh
[ -n "$(which work.sh 2> /dev/null)" ]              && source work.sh

# ancillary paths

[ -d $HOME/work ]       && export CDPATH=$HOME/work

# Python settings
export PYTHONDONTWRITEBYTECODE=1

# vim directories
[ -d ~/.cache/vim ] || mkdir -p ~/.cache/vim/{swap,backup,undo}


# settings

shopt -s histappend
shopt -s checkwinsize       # update window size
shopt -s expand_aliases     # aliases in scripts
shopt -u huponexit          # don't kill children on terminal exit
shopt -s cdspell            # fix typos in cd
shopt -s cdable_vars        # cd to bash variables

# environment

export LC_ALL="en_US.UTF-8"
export TZ="America/Los_Angeles"
export CLICOLOR=1
export CLICOLOR_FORCE=1
export PAGER='less'
export LESS='CMifSR'
export LESSCHARSET='utf-8'
[ -x /usr/bin/lesspipe.sh ] && export LESSOPEN='|/usr/bin/lesspipe.sh %s 2>&-'
[ -x /usr/local/bin/lesspipe.sh ] && export LESSOPEN='|/usr/local/bin/lesspipe.sh %s 2>&-'
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
[ -x /usr/local/bin/lesspipe.sh ] && eval "$(SHELL=/bin/sh lesspipe.sh)"
export EDITOR=vim
export GIT_PAGER=less

# Prompt

function massage_pwd()
{
    :
}

export PROMPT_COMMAND=massage_pwd

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM='auto'
export PS1="${BBlue}\h:${Color_Off}${BGreen}\w${Color_Off} \$(__git_ps1 \"${BPurple}(%s) ${Color_Off}\")${BIYellow}⚡${Color_Off} "

# History

export HISTFILESIZE=50000000
export HISTSIZE=500000
export HISTIGNORE='l:ls:la:ll:cd:w'
export HISTTIMEFORMAT='%Y-%m-%d %H:%M:%S - '
export HISTCONTROL=ignoredups:ignorespace

# SSH/identity/mode/permission/whatnot
umask 002
if [ -d ~/.ssh ]; then
    chmod 700 .ssh 2> /dev/null
    chmod 600 .ssh/* 2> /dev/null
fi

# set up ssh-agent if no identities are available
ssh-add -l &> /dev/null
if [ $? != 0 ]; then
    ssh-add
fi

[ -d /usr/local/lib/python2.7/site-packages ] && export PYTHONPATH=/usr/local/lib/python2.7/site-packages:$PYTHONPATH
