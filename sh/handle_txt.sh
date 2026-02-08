#!/bin/bash

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

# wsl distribution name
SELF=$(basename "$(wslpath -m /)" | tr '[:upper:]' '[:lower:]')

# no file provided, just open emacs
if [ $# -eq 0 ]; then
    nohup emacsclient -a /usr/bin/emacs -c -n >/dev/null 2>&1 &
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

    nohup emacsclient -a /usr/bin/emacs -c -n "$linuxpath" >/dev/null 2>&1 &

done

log "Finished"
sleep 1
