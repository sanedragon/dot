# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
umask 022
ssh-add &> /dev/null

export LANGUAGE="en"
export LC_MESSAGES="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

## RTK
if $(hostname | grep -q dev) ; then
  workdir=/data_storage/work/$(whoami)
  if [ ! -d $workdir ]; then
  	mkdir $workdir
  fi

  if [ ! -h ~/work ]; then
	ln  -s $workdir ~/work
  fi
  if [ -f ~/.cvswork ]; then
	chmod 777 ~/.cvswork
  fi
fi

