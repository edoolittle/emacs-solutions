(add-to-list 'special-display-regexps ".*\.pdf$") ;; open PDF in separate window

(defun my/pdf-view-set-frame-size (the-frame)
  "Set frame size when opening a PDF."
  (when (eq major-mode 'pdf-view-mode)
    (set-frame-size the-frame 100 32) ;; width x height in chars
    (set-frame-position the-frame 385 40))) ;; x y position in pixels

(add-hook 'after-make-frame-functions #'my/pdf-view-set-frame-size)
