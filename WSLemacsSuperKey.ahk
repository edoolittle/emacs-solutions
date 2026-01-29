#Requires AutoHotkey v2

/*

This script enables a super key by mapping the Windows key (between
left control and left alt on my keyboard) to F9 when in emacs.  Then
emacs needs to be configured to interpret F9 as super (see related .el
fragment).  Higher F keys up through F24 seem to be in use in my
system.

Based on the answer at
https://www.autohotkey.com/boards/viewtopic.php?p=555550#p555550 with
small modifications.

It seems that only the left key between control and alt can be
remapped.  The FN key on the right can't be remapped in software, from
what I understand.  So I only use key combinations in emacs of
super-right hand key like super-i and super-downarrow, but not super-e
or super-w.

TODO: add hyper key support (have to use another F key, probably in range
	F5-F8 which is apparently reserved for users.

TODO: key chords like meta-super-i and ctrl-super-i

*/

/* set this variable to a string common to all windows in which
 * you want to remap the Window key, or set to "" for all windows
 */

*LWin::
*LWin Up:: 
emacs_OnSuper(ThisHotkey, options := "I1 L0 *")
{
    static ih := ""

    if !ih {
        ih               := InputHook(options)
        ih.NotifyNonText := !(ih.VisibleNonText := false)
        ih.OnKeyDown     := OnKey.Bind(, , , "Down")
        ih.OnKeyUp       := OnKey.Bind(, , , "Up")
        ih.KeyOpt("{All}", "N S")
    }
    if ThisHotkey = '*LWin' 
        ih.Start()
    else ih.Stop()

    OnKey(ih, VK, SC, UD)
    {
        Critical()
	key := Format("{{1} {2}}", GetKeyName(Format("vk{:x}sc{:x}", VK, SC)), UD)
	if !WinExist("ahk_class RAIL_WINDOW ahk_exe msrdc.exe") ||  InStr(key, "LWin Up")
           ih.Stop()
        wgt := ""
        if WinExist("A")
	    wgt := WinGetTitle("A")
        else ih.Stop()
	/* change the string below to identifier found in all windows in which
           the remapping should occur, or to "" for all winwdows */
        if !InStr(wgt, "GNU Emacs")
            {
	    Send(UD = "Up" ? key : "{LWin down}" key "{LWin up}")
	    /* ih.Stop() */
	    }
        else Send(UD = "Up" ? key : "{F9}" key)
    }
}
