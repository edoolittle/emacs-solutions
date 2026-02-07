;; AI generated code
;; has yet to be debugged
;; Interacts in a bad way with file name issues in WSL
;; Seems base directory is wrong somehow when emacsclient -e in a script??
;; Definitely needs work.

(defun my-make-frame-and-focus-hybrid-find-file (f1 f2)
  "Create a new frame and give it focus if in a GUI.
 Works safely in   both GUI and terminal emacsclient sessions."
  (interactive)
  (let ((new-frame (make-frame)))
    ;; Always select the new frame in Emacs
    ;;(select-frame-set-input-focus new-frame)
    (with-selected-frame new-frame
      (select-frame-set-input-focus new-frame)
      (find-file f1)
      (find-file-other-window f2))
    ;; Only try OS-level focus if in a graphical environment
    (when (and (display-graphic-p new-frame)
               (fboundp 'x-focus-frame))
      ;; Small delay helps some window managers honor the focus request
      (run-with-timer 0.05 nil #'x-focus-frame new-frame))))
  
