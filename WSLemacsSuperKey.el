;; emacs support to complement WSLemacsSuperKey.ahk
;; add this fragment to init.el

(setq frame-title-format "%b (GNU Emacs)")
(define-key function-key-map (kbd "<f9>") 'event-apply-super-modifier)

;; example application of super key to simulate LWin downarrow which
;; in Windows has the effect of minimizing a window; requires xdotool

(global-set-key (kbd "s-<down>") 
  (lambda ()
    (interactive)
    (shell-command-to-string "xdotool getactivewindow windowminimize")))
;; xdotool miscalculates height (by the height of the Windows title bar, I think)
(global-set-key (kbd "s-<up>") 
  (lambda ()
    (interactive)
    (shell-command-to-string "xdotool getactivewindow windowsize 100% 97% windowmove 0 0")))
(global-set-key (kbd "s-<left>") 
  (lambda ()
    (interactive)
    (shell-command-to-string "xdotool getactivewindow windowsize 50% 97% windowmove 0 0")))
(global-set-key (kbd "s-<right>") 
  (lambda ()
    (interactive)
    (shell-command-to-string "xdotool getactivewindow windowsize 50% 97% windowmove 50% 0%")))
(global-set-key (kbd "s-<right>") 
  (lambda ()
    (interactive)
    (shell-command-to-string "xdotool getactivewindow windowsize 50% 97% windowmove 50% 0%")))
