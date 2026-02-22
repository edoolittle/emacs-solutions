#!/bin/bash

EMACS="emacs"
LOG=FALSE
LOGFILE="$HOME/log.txt"

log() {
    if [ "$LOG" = "TRUE" ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - $*" | tee -a "$LOGFILE"
    fi
}

wait() {
    echo "Press Enter to Continue..."
    read
}

# if emacs is not running, my preference is to run in daemon mode
# comment out the lines below if you would rather not
if ! emacsclient -a /bin/false -e '()' > /dev/null 2>&1; then
    log "Starting $EMACS in daemon mode..."
    #$EMACS --daemon
    $EMACS --daemon > /dev/null 2>&1
fi

# wsl distribution name
SELF=$(basename "$(wslpath -m /)" | tr '[:upper:]' '[:lower:]')

# no file provided, just open emacs
if [ $# -eq 0 ]; then
    nohup emacsclient -a "$EMACS" -c -n >/dev/null 2>&1
    exit 0
fi

log "Arguments: $*"

for winpath in "$@"; do
    linuxpath=""
    target="$SELF"

    log "Processing path: $winpath"

    # convert windows path
    if [[ "$winpath" =~ ^[A-Za-z]:\\ ]]; then
        linuxpath=$(wslpath -a "$winpath")
        log "Converted Windows Path to Linux: $linuxpath"
    # convert network path
    elif [[ "$winpath" =~ ^\\\\wsl\.localhost\\([^\\]+)\\(.+) ]]; then
        target=$(echo "${BASH_REMATCH[1]}" | tr '[:upper:]' '[:lower:]')
        linuxpath="/${BASH_REMATCH[2]//\\//}"
        log "Converted WSL UNC Path to Linux: $linuxpath"
    # skip non-wsl network path
    elif [[ "$winpath" =~ ^\\\\[^\\]+\\[^\\]+ ]]; then
        log "Skipping regular UNC path: $winpath"
        wait
        continue
    # assume already linux path
    else
        log "Assumed Linux Path: $linuxpath"
        linuxpath="$winpath"
    fi
    # 
    if [[ "$target" != "$SELF" ]]; then
        log "$linuxpath is from distribution [$target] and cannot be opened on [$SELF]"
        wait
        continue
    fi

    nohup emacsclient -a "$EMACS" -c -n "$linuxpath" >/dev/null 2>&1 

done

log "Finished"
sleep 1
