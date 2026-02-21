#!/bin/bash

#MY_EMACS='/usr/bin/emacs-w32'
#MY_EMACSCLIENT='/usr/bin/emacsclient"
MY_EMACS='emacs'
MY_EMACSCLIENT='emacsclient'

# Determine whether we're running in an SSH session, in which case
# emacsclient should start with -t option for text terminal
is_ssh() {
    if [[ -n "$SSH_CONNECTION" ]] || [[ -n "$SSH_CLIENT" ]] || [[ -n "$IS_SSH" ]]; then
        return 0
    else
        return 1
    fi
}

# Command line switches for emacsclient
if is_ssh; then
    EMC_NOWAIT="-t"
    EMC_WAIT="-t"
else
    EMC_NOWAIT="-u -c -n"
    EMC_WAIT="-u -c"
fi

# Undocumented behaviour: emacsclient -a /bin/false returns false
# if there is no emacs running, otherwise returns true
# See https://www.emacswiki.org/emacs/EmacsPipe
if ! $MY_EMACSCLIENT -a /bin/false -e '()' > /dev/null 2>&1; then
    $MY_EMACS --daemon > /dev/null 2>&1
fi

$MY_EMACSCLIENT $EMC_WAIT "$@"

