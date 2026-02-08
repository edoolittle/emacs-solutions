  (require 'org-roam-protocol)
;; see https://merrick.luois.me/posts/web-clipping-with-org-roam
;; the r capture grabs the current selection and references the URL
;; the w capture grabs the whole page nicely formatted  and references the URL
  (use-package org-web-tools
    :commands org-web-tools--url-as-readable-org)
  (setq org-roam-capture-ref-templates
    '(("r" "ref" plain
       ;;"* ${Topic}\n%i\n\n%?"
       "\n%i\n\n%?"
       :target
       (file+head "web/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+created: %T\n")
       :unnarrowed t)
      ("w" "ref" plain "%(org-web-tools--url-as-readable-org \"${ref}\")"
       :target (file+head "clips/${slug}.org" "#+title: ${title}\n")
       :unnarrowed t)
      )
    )
