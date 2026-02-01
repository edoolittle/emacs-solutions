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


if [ -e '/Applications/MacPorts/EmacsMac.app' ]; then
    MY_EMACS="/Applications/MacPorts/EmacsMac.app/Contents/MacOS/Emacs"
    MACOS_EMACS=yes
elif [ -e '/usr/bin/emacs-w32' ]; then
    MY_EMACS='/usr/bin/emacs-w32'
else
    MY_EMACS='emacs'
fi


# Undocumented behaviour: emacsclient -a /bin/false returns false
# if there is no emacs running, otherwise returns true
# See https://www.emacswiki.org/emacs/EmacsPipe
if ! emacsclient -a /bin/false -e '()' > /dev/null 2>&1; then
    if [[ "$1" == "-" ]]; then
        TMP="$(mktemp /tmp/emacsstdinXXX)";
        cat >"$TMP";
       	$MY_EMACS --eval "(let ((b (create-file-buffer \"*stdin*\"))) (switch-to-buffer b) (insert-file-contents \"${TMP}\") (delete-file \"${TMP}\"))" &
    elif [ $# -eq 2 ]; then
	# for the following to work, add this function to init.el
	# (defun split-window-2-files (f1 f2) 
	#   (find-file f1)
	#   (find-file-other-window f2))
	$MY_EMACS -e "(split-window-2-files \"$1\" \"$2\")" > /dev/null 2>&1 
    else 
	$MY_EMACS "$@" &
    fi
    if [[ "$MACOS_EMACS" == "yes" ]]; then
	# Emacs seems to take some time to get into the dock on MacOS
	sleep 2
	osascript -e 'tell application "System Events" to click UI element "EmacsMac" of list 1 of application process "Dock"' > /dev/null 2>&1
    fi
else
    # emacs is running; connect with emacsclient
    if [[ "$1" == "-" ]]; then
        TMP="$(mktemp /tmp/emacsstdinXXX)";
        cat >"$TMP";
        emacsclient -c -e "(let ((b (create-file-buffer \"*stdin*\"))) (switch-to-buffer b) (insert-file-contents \"${TMP}\") (delete-file \"${TMP}\"))"  > /dev/null 2>&1
    elif [ $# -eq 2 ]; then
	emacsclient -r -n -e "(make-frame '((width . 100)))" > /dev/null 2>&1
	# for the following to work, add this function to init.el
	# (defun split-window-2-files (f1 f2) 
	#   (find-file f1)
	#   (find-file-other-window f2))
	emacsclient -r -n -e "(split-window-2-files \"$1\" \"$2\")" > /dev/null 2>&1 
    elif [ $# -ne 0 ]; then   
	emacsclient -r -n -e "(make-frame '((width . 100)))" > /dev/null 2>&1 
	emacsclient -r -n "$@"
    fi
    emacsclient -c -n -e '(raise-frame)' '(x-focus-frame nil)' > /dev/null 2>&1
    if [[ "$MACOS_EMACS" == "yes" ]]; then
	osascript -e 'tell application "System Events" to click UI element "EmacsMac" of list 1 of application process "Dock"' > /dev/null 2>&1
    fi
fi


