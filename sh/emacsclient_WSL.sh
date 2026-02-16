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
#
# Also, install nircmd.exe in your path and
# Adjust the stitle strings below, OR (better) add this fragment
# to your init.el file:
# (setq frame-title-format "(GNU Emacs) %b")
# You want it to be the other way around if your unique filenames start
# with dir/filename instead of the default filename<dir>
# WARNING: if there are multiple files open in emacs with the same name
# nircmd may pick the wrong one!  This is mitigated by putting the
# filename second, so nircmd opens raises every window with the same name.
# We should keep looking for a better solution to this problem.

# TODO This script assumes line numbers are not on the command line

#MY_EMACS='/usr/bin/emacs-w32'
MY_EMACS='emacs'
#RAISE_CMD='nircmd.exe win activate stitle'
RAISE_CMD='cmd.exe /c raiseWindow.ahk'

# Undocumented behaviour: emacsclient -a /bin/false returns false
# if there is no emacs running, otherwise returns true
# See https://www.emacswiki.org/emacs/EmacsPipe

if ! emacsclient -a /bin/false -e '()' > /dev/null 2>&1; then
    if [[ "$1" == "-" ]]; then
        TMP="$(mktemp /tmp/emacsstdinXXX)";
        cat >"$TMP";
       	nohup $MY_EMACS --eval "(let ((b (create-file-buffer \"*stdin*\"))) (switch-to-buffer b) (insert-file-contents \"${TMP}\") (delete-file \"${TMP}\"))" > /dev/null 2>&1 &
    elif [ $# -eq 2 ]; then
	    nohup $MY_EMACS --eval "(split-window-2-files \"$1\" \"$2\")" > /dev/null 2>&1 &
    else
	    nohup $MY_EMACS "$@" > /dev/null 2>&1 &
    fi
else
    if [[ "$1" == "-" ]]; then
        TMP="$(mktemp /tmp/emacsstdinXXX)";
        cat >"$TMP";
        emacsclient -u -c -n -e "(let ((b (create-file-buffer \"*stdin*\"))) (switch-to-buffer b) (insert-file-contents \"${TMP}\") (delete-file \"${TMP}\"))"
        $RAISE_CMD "\*stdin\*"
    elif [ $# -eq 2 ]; then
        emacsclient -u -c -n -e "(split-window-2-files \"$1\" \"$2\")"
        $RAISE_CMD "(GNU Emacs) `basename ${2}`" > /dev/null 2>&1 
    elif [ $# -eq 1 ]; then
	    emacsclient -u -c -n "$1"
        $RAISE_CMD "(GNU Emacs) `basename ${1}`" > /dev/null 2>&1
    elif [ $# -eq 0 ]; then
        emacsclient -u -c -n
    else
        # when opening a bunch of files with emacsclient don't -n;
        # wait until each file is marked as done with C-x #
	    emacsclient -u -c "$@"
    fi
fi

