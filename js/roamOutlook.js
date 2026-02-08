// capture clip from an OWA (Outlook Web) email with correct URL
// Not sure why the double encoding but it works
javascript:location.href =    'org-protocol://roam-ref?template=r&ref=%27 + encodeURIComponent(%27https://outlook.office365.com/owa/?ItemID=%27.concat(encodeURIComponent(window.location.href.split("/id/")[1])).concat(%27&exvsurl=1&viewmodel=ReadMessageItem%27))    + %27&title=%27    + encodeURIComponent(document.title)    + %27&body=%27    + encodeURIComponent(window.getSelection())
