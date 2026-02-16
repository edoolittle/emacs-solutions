; raiseWindow.ahk
; activates the windows matching ^A_Args[1] in z-order

SetTitleMatchMode 1 ; to emulate the behaviour of nircmd ... stitle ...

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




