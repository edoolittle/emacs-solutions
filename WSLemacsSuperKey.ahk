#Requires AutoHotkey v2
/* See discussion at https://www.autohotkey.com/boards/viewtopic.php?p=555550#p555550 */
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
        if !WinExist("ahk_class RAIL_WINDOW ahk_exe msrdc.exe") || InStr(key, "LWin Up") 
            ih.Stop()
        else Send(UD = "Up" ? key : "{F9}" key)
        /* ControlSend(UD = "Up" ? key : "{Control Down}{x}{Control Up}{Shift Down}{2}{Shift Up}{s}" key) */
    }
}