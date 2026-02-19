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

# TODO: when invoked from less, the line number is included in the call
# to EDITOR.  We should really parse that line number.


#MY_EMACS="/Applications/MacPorts/EmacsMac.app/Contents/MacOS/Emacs"
MY_EMACS="/Applications/Emacs.app/Contents/MacOS/Emacs"
#MY_EMACSCLIENT="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient"
#MACOS_EMACS=yes

is_graphical() {
    [[ -n "$DISPLAY" ]] && return 0
    [[ -n "$WAYLAND_DISPLAY" ]] && return 0
    [[ -n "$XDG_CURRENT_DESKTOP" ]] && return 0
    [[ -n "$DESKTOP_SESSION" ]] && return 0
    return 1
}

is_ssh() {
    # Detect if running over SSH
    if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
        return 1
    else
        return 0
    fi
}

# Undocumented behaviour: emacsclient -a /bin/false returns false
# if there is no emacs running, otherwise returns true
# See https://www.emacswiki.org/emacs/EmacsPipe

if ! /Applications/Emacs.app/Contents/MacOS/bin/emacsclient -a /bin/false -e '()' > /dev/null 2>&1; then
    $MY_EMACS --daemon > /dev/null 2>&1
fi

if is_ssh; then
    MY_EMACSCLIENT="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient -t"
    MY_EMACSCLIENT_WAIT="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient -t"
else
    MY_EMACSCLIENT="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient -c -n"
    MY_EMACSCLIENT_WAIT="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient -c"
fi

if [[ "$1" == "-" ]]; then
    TMP="$(mktemp /tmp/emacsstdinXXX)";
    cat >"$TMP";
    $MY_EMACSCLIENT -u -e "(let ((b (create-file-buffer \"*stdin*\"))) (switch-to-buffer b) (insert-file-contents \"${TMP}\") (delete-file \"${TMP}\"))"
    #$RAISE_CMD "\*stdin\*"
elif [ $# -eq 2 ]; then
    $MY_EMACSCLIENT -u -e "(split-window-2-files \"$1\" \"$2\")"
    #$RAISE_CMD "(GNU Emacs) `basename ${2}`" > /dev/null 2>&1
elif [ $# -eq 1 ]; then
	$MY_EMACSCLIENT -u  "$1"
    #$RAISE_CMD "(GNU Emacs) `basename ${1}`" > /dev/null 2>&1
elif [ $# -eq 0 ]; then
    $MY_EMACSCLIENT -u 
else
    # when opening a bunch of files with emacsclient don't -n;
    # wait until each file is marked as done with C-x #
	$MY_EMACSCLIENT_WAIT -u "$@"
fi

if is_ssh; then
    : # NOP
else
    osascript -e 'tell application "System Events" to click UI element "Emacs" of list 1 of application process "Dock"' > /dev/null 2>&1
fi



# if ! emacsclient -a /bin/false -e '()' > /dev/null 2>&1; then
#     if [[ "$1" == "-" ]]; then
#         TMP="$(mktemp /tmp/emacsstdinXXX)";
#         cat >"$TMP";
#        	nohup $MY_EMACS --eval "(let ((b (create-file-buffer \"*stdin*\"))) (switch-to-buffer b) (insert-file-contents \"${TMP}\") (delete-file \"${TMP}\"))" > /dev/null 2>&1 &
#     elif [ $# -eq 2 ]; then
# 	    nohup $MY_EMACS --eval "(split-window-2-files \"$1\" \"$2\")" > /dev/null 2>&1 &
#     else
# 	    nohup $MY_EMACS "$@" > /dev/null 2>&1 &
#     fi
# 	sleep 2
# 	osascript -e 'tell application "System Events" to click UI element "EmacsMac" of list 1 of application process "Dock"' > /dev/null 2>&1
# else
#     if [[ "$1" == "-" ]]; then
#         TMP="$(mktemp /tmp/emacsstdinXXX)";
#         cat >"$TMP";
#         emacsclient -u -c -n -e "(let ((b (create-file-buffer \"*stdin*\"))) (switch-to-buffer b) (insert-file-contents \"${TMP}\") (delete-file \"${TMP}\"))"
#     elif [ $# -eq 2 ]; then
#  	    emacsclient -u -c -n -e "(split-window-2-files \"$1\" \"$2\")"
#     elif [ $# -eq 1 ]; then
# 	    emacsclient -u -c -n "$1"
#     else
#         # when opening a bunch of files with emacsclient don't -n;
#         # wait until each file is marked as done with C-x #
# 	    emacsclient -u -c "$@"
#     fi
# 	osascript -e 'tell application "System Events" to click UI element "EmacsMac" of list 1 of application process "Dock"' > /dev/null 2>&1
# fi

