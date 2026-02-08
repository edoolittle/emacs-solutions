// click this when an email is open in Outlook for web right pane
// "deep link" will be copied to clipboard
// see https://joshuachini.com/2024/11/09/get-deep-link-to-outlook-email/
javascript:(function() {navigator.clipboard.writeText('https://outlook.office365.com/owa/?ItemID=%27.concat(window.location.href.split("/id/")[1]).concat(%27&exvsurl=1&viewmodel=ReadMessageItem%27));})()
