;; Control-z (C-z) in Ubuntu GDK seems to have had an issue for a long time.
;; It iconifies the current emacs frame, but when you reopen the frame it
;; is frozen.  The bug has not been fixed for years, from what I can see.

;; The elisp fragment below installs a new function which works around
;; that problem.  In order for it to work, you need to install xdotool.

(global-set-key (kbd "C-z") 
  (lambda ()
    (interactive)
    (shell-command-to-string "xdotool getactivewindow windowminimize")))

;; I have also added a key definition for s-<down>, which on my keyboard
;; is mapped to "Windows key" + down key, because that combination is
;; used in Windows.  (I have my windows key mapped to super, but in some
;; cases I want it to continue to behave as it does in Windows.

(global-set-key (kbd "s-<down>") 
  (lambda ()
    (interactive)
    (shell-command-to-string "xdotool getactivewindow windowminimize")))

