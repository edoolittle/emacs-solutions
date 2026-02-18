#!/bin/bash

ahk_file=$(mktemp -t XXXXX.ahk)

tee $ahk_file <<EOF > /dev/null
SetTitleMatchMode 2

ActivateAllReversed(pattern := "") {
    hwnds := WinGetList(pattern)

    for index, hwnd in hwnds {
        try WinActivate(hwnds[hwnds.Length-index+1])
        Sleep(100) ; delay in milliseconds
    }
}

if A_Args.Length > 0 {
   if WinExist(A_Args[1]) {
       ActivateAllReversed(A_Args[1])
   }
} else {
   ActivateAllReversed()
}
EOF

cmd.exe /c `wslpath -w $ahk_file` $1 > /dev/null 2>&1 

rm $ahk_file

