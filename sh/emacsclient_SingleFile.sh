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

# TODO: when invoked from less, the line number is included in the call
# to EDITOR.  We should really parse that line number.

#MY_EMACS='/usr/bin/emacs-w32'
MY_EMACS='emacs'

# Undocumented behaviour: emacsclient -a /bin/false returns false
# if there is no emacs running, otherwise returns true
# See https://www.emacswiki.org/emacs/EmacsPipe

if ! emacsclient -a /bin/false -e '()' > /dev/null 2>&1; then
    if [ $# -eq 2 ]; then
        # We're assuming the first argument is a line number +...
	    nohup $MY_EMACS "$@" > /dev/null 2>&1 &
    elif [ $# -eq 1 ]; then
        nohup $MY_EMACS "$@" > /dev/null 2>&1 &
    else
        # Unexpected, just pass it on to emacs
        nohup $MY_EMACS "$@" > /dev/null 2>&1 &
    fi
else
    if [ $# -eq 2 ]; then
        # We're assuming the first argument is a line number +...
	    emacsclient -u -c -n "$@"
        nircmd.exe win activate stitle "(GNU Emacs) `basename ${2}`"
    elif [ $# -eq 1 ]; then
	    emacsclient -u -c -n "$@"
        nircmd.exe win activate stitle "(GNU Emacs) `basename ${1}`"
    else
        # Unexpected, just pass it on to emacsclient
        emacsclient -u -c -n "$@"
    fi
fi

