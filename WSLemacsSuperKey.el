;; emacs support to complement WSLemacSuperKey.ahk
;; add this fragment to init.el

(setq frame-title-format "%b (GNU Emacs)")
(define-key function-key-map (kbd "<f9>") 'event-apply-super-modifier)

;; example application of super key to simulate LWin downarrow which
;; in Windows has the effect of minimizing a window; requires xdotool

(global-set-key (kbd "s-<down>") 
  (lambda ()
    (interactive)
    (shell-command-to-string "xdotool getactivewindow windowminimize")))
(global-set-key (kbd "s-<up>") 
  (lambda ()
    (interactive)
    (shell-command-to-string "xdotool getactivewindow windowsize 100% 100% && xdotool getactivewindow windowmove 0 0")))
;; xdotool sometimes errs in the height of a window (by the height of the
;; Windows 11 title bar, perhaps) ... 97% below compensates on my system
(global-set-key (kbd "s-<left>") 
  (lambda ()
    (interactive)
    (shell-command-to-string "xdotool getactivewindow windowsize 50% 97% && xdotool getactivewindow windowmove 0 0")))
(global-set-key (kbd "s-<right>") 
  (lambda ()
    (interactive)
    (shell-command-to-string "xdotool getactivewindow windowsize 50% 97% && xdotool getactivewindow windowmove 50% 0")))
