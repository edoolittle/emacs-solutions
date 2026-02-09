#Requires AutoHotkey v2

;; As you add super key combinations to init.el, you should add them here too.
;; As a bonus, all the unremapped Win key combinations pass through to Windows
;; so you can use Win-<arrow> and Win-D, etc., as normal in emacs, if you wish

;; Change your emacs init.el so that an identifier like (GNU Emacs)
;; comes before the file name.  Add the elisp fragment to init.el

; (setq frame-title-format "(GNU Emacs) %b")

;; Then you can identify all emacs windows in AutoHotkey by
; #HotIf WinActive("(GNU Emacs)")

;; Also in your init.el, place

; (define-key function-key-map (kbd "<f9>") 'event-apply-super-modifier)
; (define-key function-key-map (kbd "<f8>") 'event-apply-hyper-modifier)

;; (an alternative to F8 for hyper key is to use Ctrl+Shift+Win+Alt)

;; If F8 and/or F9 are used, consider trying any F5-F9 (reserved for users)
;; or higher Fn (but on my system those high numbers seem to be used by media center)

SetCapsLockState("AlwaysOff")
+CapsLock::SetCapsLockState !GetKeyState("CapsLock", "T")

#HotIf WinActive("(GNU Emacs)")
$#i::Send("{F9}i")    ;; s-i   opens gnome-terminal in current directory in emacs
;; $#l reserved for lock screen, can't be remapped by AHK?
;; $#!m behaving oddly, inserting tabs??
;; $#m reserved for minimze window
;; $!m unmappable -- Windows uses for some gaming panel
$#^m::Send("{F9}^m")  ;; C-s-m removes ^M from emacs buffer
$#u::Send("{F9}u")    ;; s-u   Sudoku in emacs
$#.::Send("{F9}.")    ;; s-.   emoji chooser in emacs
;; example of hyper key h-i combination
CapsLock & i::Send("{F8}i")
#HotIf

