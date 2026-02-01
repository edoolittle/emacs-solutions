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

$#u::
{
    if WinExist("A") && InStr(WinGetTitle("A"), emacsTitle, true)
        Send("{F9}u")
    else Send("#u")
}

;; Hyper key remappings CapsLock -> F8
;; These can be slightly simpler because there is no need to forward
;; unremapped hyper keys to the operating system ... we don't need $
;; prefix for one thing.
;; However, following the above, we can overload behaviour based on
;; whether emacs is running or not ... possible to do so but maybe
;; not advised.

CapsLock & i::Send("{F8}i")