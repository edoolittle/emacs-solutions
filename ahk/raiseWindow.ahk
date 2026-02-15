; raiseWindow.ahk
; activates the window on the command line

if A_Args.Length > 0 {
    if WinExist(A_Args[1]) {
        WinActivate(A_Args[1])
    }
}

