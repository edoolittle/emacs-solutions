#!/bin/bash

# To get the most of this script, add the following lines to init.el
#
#  (defun split-window-2-files (f1 f2) 
#    (find-file f1)
#    (find-file-other-window f2))
#
# (without the shell comment symbols # of course) and check that
# your emacs app is in the list in the if statement immediately
# below

#MY_EMACS='/usr/bin/emacs-w32'
#MY_EMACSCLIENT='/usr/bin/emacsclient"
MY_EMACS='emacs'
MY_EMACSCLIENT='emacsclient'

# Determine whether we're running in an SSH session, in which case
# emacsclient should start with -t option for text terminal
is_ssh() {
    # Detect if running over SSH
    if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
        return 0
    else
        return 1
    fi
}

# Undocumented behaviour: emacsclient -a /bin/false returns false
# if there is no emacs running, otherwise returns true
# See https://www.emacswiki.org/emacs/EmacsPipe
if ! $MY_EMACSCLIENT -a /bin/false -e '()' > /dev/null 2>&1; then
    #$MY_EMACS --daemon > /dev/null 2>&1
    $MY_EMACS --daemon
fi

# Command line switches for emacsclient
if is_ssh; then
    EMC_NOWAIT="-t"
    EMC_WAIT="-t"
else
    EMC_NOWAIT="-u -c -n"
    EMC_WAIT="-u -c"
fi

if [[ "$1" == "-" ]]; then
    TMP="$(mktemp /tmp/emacsstdinXXX)";
    cat >"$TMP";
    $MY_EMACSCLIENT $EMC_NOWAIT -e "(let ((b (create-file-buffer \"*stdin*\"))) (switch-to-buffer b) (insert-file-contents \"${TMP}\") (delete-file \"${TMP}\"))"
elif [ $# -eq 2 ]; then
    $MY_EMACSCLIENT $EMC_NOWAIT -e "(split-window-2-files \"$1\" \"$2\")"
elif [ $# -eq 1 ]; then
    $MY_EMACSCLIENT $EMC_NOWAIT "$1"
elif [ $# -eq 0 ]; then
    $MY_EMACSCLIENT $EMC_NOWAIT 
else
    # when opening a bunch of files with emacsclient don't -n;
    # wait until each file is marked as done with C-x #
	$MY_EMACSCLIENT $EMC_WAIT "$@"
fi

