#Requires AutoHotkey v2
;; This is much simpler than the InputHook version I've been struggling with
;; As I add super key combinations to init.el, I should add them here too.
;; As a bonus, all the unremapped Win key combinations pass through to Windows
;; so I can use Win-<arrow> and Win-D, etc., as normal

;; I can also easily add Hyper key combinations to here by remapping CapsLock to F8.

emacsTitle := "GNU Emacs"

SetCapsLockState("AlwaysOff")
+CapsLock::SetCapsLockState !GetKeyState("CapsLock", "T")

;; Super key remappings Winkey -> F9 for emacs
;; Note: #L cannot be remapped ... it is always interpreted by Windows as lock screen

$#i:: ;; win-i
{
    if WinExist("A") && InStr(WinGetTitle("A"), emacsTitle, true)
        Send("{F9}i")
    else Send("#i")
}

$#!i:: ;; alt-win-i
{
    if WinExist("A") && InStr(WinGetTitle("A"), emacsTitle, true)
        Send("{F9}!i") 
    else Send("#!i")
}

;; win-m is bound to minimize window in Windows 11, which I want to keep

;; alt-win-m is permanently bound to gaming console stuff, can't use it

$#^m:: ;; win-ctrl-m
{
    if WinExist("A") && InStr(WinGetTitle("A"), emacsTitle, true)
        Send("{F9}^m") 
    else Send("#^m")
}

$#u:: ;; win-u
{
    if WinExist("A") && InStr(WinGetTitle("A"), emacsTitle, true)
        Send("{F9}u")
    else Send("#u")
}

;; For emoji panel ... Windows emoji panel not available in Ubuntu

$#.::
{
    if WinExist("A") && InStr(WinGetTitle("A"), emacsTitle, true)
        Send("{F9}.")
    else Send("#.")
}



;; Hyper key remappings CapsLock -> F8

;; These can be slightly simpler because there is no need to forward
;; unremapped hyper keys to the operating system ... we don't need $
;; prefix for one thing.

;; However, following the above, we can overload behaviour based on
;; whether emacs is running or not ... possible to do so but maybe
;; not advised.

CapsLock & i::Send("{F8}i")

;; I have reserved some Ctrl+Win+Alt combinations for some Windows
;; programs that appear to tie into the input at a low level, so
;; they don't really get the Hyper key combinations.