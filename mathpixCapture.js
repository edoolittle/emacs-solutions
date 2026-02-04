javascript:(function(){
    beginText = "#+BEGIN_SRC\n";
    endText = "\n#+END_SRC\n";
    navigator.clipboard.readText()
        .then(text => {
            location.href =    'org-protocol://roam-ref?template=r&ref=%27
+ encodeURIComponent(location.href)
+ %27&title=%27
+ encodeURIComponent(document.title)
+ %27&body=%27
+ encodeURIComponent(beginText)
+ encodeURIComponent(text)
+ encodeURIComponent(endText) })
})();
