// use this as a bookmarklet in your browser to forward a text
// selection to emacs org-roam .  Emacs must be running and the
// appropriate org-roam capture must be set up
javascript:location.href =
    'org-protocol://roam-ref?template=r&ref='
    + encodeURIComponent(location.href)
    + '&title='
    + encodeURIComponent(document.title)
    + '&body='
    + encodeURIComponent(window.getSelection())
