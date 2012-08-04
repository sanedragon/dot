# if running bash
if [ -n "$BASH_VERSION" ]; then
    if [ ${BASH_VERSINFO[0]} -ne 4 -a -e $HOME/.local/bin ] ; then
        [ -d $HOME/.local/bin ]	&& export PATH=$HOME/.local/bin:"${PATH}"
        bash --login
        exit
    fi

    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
    fi
fi

