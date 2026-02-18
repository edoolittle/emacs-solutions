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

#MY_EMACS="/Applications/MacPorts/EmacsMac.app/Contents/MacOS/Emacs"
MY_EMACS="/Applications/Emacs.app/Contents/MacOS/Emacs"
MY_EMACSCLIENT="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient"
#MACOS_EMACS=yes


# Undocumented behaviour: emacsclient -a /bin/false returns false
# if there is no emacs running, otherwise returns true
# See https://www.emacswiki.org/emacs/EmacsPipe

if ! $MY_EMACSCLIENT -a /bin/false -e '()' > /dev/null 2>&1; then
    $MY_EMACS --daemon > /dev/null 2>&1
fi

# We don't need to make all these distinctions if we're indiscriminantly
# all the emacs windows with the apple script below

if [ $# -eq 2 ]; then
    # We're assuming the first argument is a line number +...
	$MY_EMACSCLIENT -u -c -n "$@"
    #$RAISE_CMD "(GNU Emacs) `basename ${2}`" > /dev/null 2>&1 
elif [ $# -eq 1 ]; then
	$MY_EMACSCLIENT -u -c -n "$@"
    #$RAISE_CMD "(GNU Emacs) `basename ${1}`" > /dev/null 2>&1
else
    # Unexpected, just pass it on to emacsclient
    $MY_EMACSCLIENT -u -c -n "$@"
fi

osascript -e 'tell application "System Events" to click UI element "Emacs" of list 1 of application process "Dock"' > /dev/null 2>&1

