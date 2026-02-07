#Requires AutoHotkey v2
;; This is much simpler than the InputHook version I've been struggling with
;; As I add super key combinations to init.el, I should add them here too.
;; As a bonus, all the unremapped Win key combinations pass through to Windows
;; so I can use Win-<arrow> and Win-D, etc., as normal

;; emacs keys for Windows

;; a wrapper function of "Send"
eSend(str) {
        Send(str)
}

command_simple(str, changes := false, repeatable := 1) {
        loop (repeatable ? repeatable : 1) {
            eSend(str)
        }
}

command_motion(str, repeatable := 1) {
        global searching
        searching := false
        loop (repeatable ? repeatable : 1) {
        eSend(str)
    }
}
global selecting := false
global searching := false

xref_find_references() {
        global selecting
        selecting := false
        command_simple("+{F12}", 0, 1)
}

xref_go_back() {
        global selecting
        selecting := false
        command_simple("{^^-", 0, 1)
}

xref_find_definitions() {
        global selecting
        selecting := false
        command_simple("{F12}", 0, 1)
}

;; ------
;; system
;; ------

set_mark_command() {
        global selecting
        if (selecting) {
                selecting := false
                command_simple("{Shift up}", 0, 1)
        }
        else {
                selecting := true
                command_simple("{Shift down}", 0, 1)
        }
}

quit() {
        global selecting
        selecting := false
        command_simple("{Shift up}", 0, 1)
}

quit_g() {
        global selecting, searching
        selecting := false
        searching := false
        command_simple("{Shift up}{Escape}", 0, 1)
}

;; -----
;; files
;; -----

save_buffer() {
    command_simple("^s", 0, 0)
}

;; ---------------
;; windows, frames
;; ---------------

kill_frame() {
    command_simple("!{F4}", 0, 0)
}

delete_window() {
    command_simple("^{F4}", 0, 1)
}

split_window_vertically() {
    command_simple("^p^3", 0, 1)
}

maximize_window() {
    command_simple("#{Up}", 0, 1)
}

next_window() {
    command_simple("!{Tab}", 0, 1)
}

previous_window() {
    command_simple("!+{Tab}", 0, 1)
}

suspend_frame() {
    command_simple("#{Down}", 0, 0)
}

;; --------
;; motion
;; --------

forward_char() {
    command_motion("{Right}", 1)
}

backward_char() {
    command_motion("{Left}", 1)
}

forward_word() {
    command_motion("^{Right}", 1)
}

backward_word() {
    command_motion("^{Left}", 1)
}

next_line() {
    command_motion("{Down}", 1)
}

next_lines() {
    command_motion("{Down}", 6)
}

previous_line() {
    command_motion("{Up}", 1)
}

previous_lines() {
    command_motion("{Up}", 6)
}

;; --------------
;; jumping around
;; --------------

goto_line() {
        command_simple("^g", 0, 1)
}

scroll_down() {
    command_motion("{PgDn}", 1)
}

scroll_up() {
    command_motion("{PgUp}", 1)
}

move_beginning_of_line() {
    command_motion("{Home}", 0)
}

move_end_of_line() {
    command_motion("{End}", 0)
}

beginning_of_buffer() {
    command_motion("^{Home}", 9)
}

end_of_buffer() {
    command_motion("^{End}", 0)
}

;; ------
;; region
;; ------

select_line() {
    command_simple("{Home}{Shift down}{End}{Shift up}", 1, 0)
}

backward_kill_word() {
    command_simple("^{BS}", 1, 1)
}

mark_whole_buffer() {
        command_simple("^a", 1, 1)
}

kill_ring_save() {
        quit()
        command_simple("^c{Escape}", 1, 1)
}

kill_line() {
    command_simple("{Shift down}{End}{Shift up}^x", 1, 0)
}

yank() {
    command_simple("^v", 1, 1)
}

;; --------
;; deleting
;; --------

delete_char() {
    command_simple("{Del}", 1, 1)
}

;; ------------------
;; newline and indent
;; ------------------

recenter_line() {
    command_simple("^p^l", 1, 1)
}

indent_line() {
    select_line()
    command_simple("^p^f", 1, 1)
    quit_g()
}

;; -------------
;; edit commands
;; -------------

isearch(start_cmd, next_cmd) {
        global searching
        if (!searching) {
                searching := true
                command_simple(start_cmd, 1, 1)
        }
        else {
                command_simple(next_cmd, 1, 1)
        }
}

undo_only() {
    command_simple("^z", 1, 1)
}

;; ---------------
;; inserting pairs
;; ---------------
comment_line(cmd) {
        command_simple(cmd, 1, 1)
}

#HotIf !WinActive("ahk_class RAIL_WINDOW")

;; -----------
;; M- bindings
;; -----------

!b::backward_word()
!f::forward_word()
!v::scroll_up()
!+w::kill_ring_save()
!w::kill_ring_save()
!bs::backward_kill_word()
!<::beginning_of_buffer()
!>::end_of_buffer()
!.::xref_find_definitions()
!,::xref_go_back()
!?::xref_find_references()

;; -----------
;; C- bindings
;; -----------
^b::backward_char()
^n::next_line()
^p::previous_line()
^f::forward_char()
^e::move_end_of_line()
^+e::move_end_of_line()
^a::move_beginning_of_line()
^+a::move_beginning_of_line()
^d::delete_char()
^v::scroll_down()
^y::yank()
^/::undo_only()
^k::kill_line()
^+g::quit_g()
^g::quit_g()
^r::isearch("^f", "{Enter}")
^s::isearch("^f", "{Enter}")
^+space::set_mark_command()
^space::set_mark_command()
^z::suspend_frame()
#HotIf



;; I can also easily add Hyper key combinations to here by remapping CapsLock to F8.

emacsTitle := "GNU Emacs"

SetCapsLockState("AlwaysOff")
+CapsLock::SetCapsLockState !GetKeyState("CapsLock", "T")

;; Super key remappings Winkey -> F9 for emacs
;; Note: #L cannot be remapped ... it is always interpreted by Windows as lock screen

$#i:: ;; win-i
{
    if WinExist("A") && InStr(WinGetTitle("A"), emacsTitle, true)
        Send("{F9}i")
    else Send("#i")
}

$#!i:: ;; alt-win-i
{
    if WinExist("A") && InStr(WinGetTitle("A"), emacsTitle, true)
        Send("{F9}!i") 
    else Send("#!i")
}

;; win-m is bound to minimize window in Windows 11, which I want to keep

;; alt-win-m is permanently bound to gaming console stuff, can't use it

$#^m:: ;; win-ctrl-m
{
    if WinExist("A") && InStr(WinGetTitle("A"), emacsTitle, true)
        Send("{F9}^m") 
    else Send("#^m")
}

$#u:: ;; win-u
{
    if WinExist("A") && InStr(WinGetTitle("A"), emacsTitle, true)
        Send("{F9}u")
    else Send("#u")
}

;; For emoji panel ... Windows emoji panel not available in Ubuntu

$#.::
{
    if WinExist("A") && InStr(WinGetTitle("A"), emacsTitle, true)
        Send("{F9}.")
    else Send("#.")
}



;; Hyper key remappings CapsLock -> F8

;; These can be slightly simpler because there is no need to forward
;; unremapped hyper keys to the operating system ... we don't need $
;; prefix for one thing.

;; However, following the above, we can overload behaviour based on
;; whether emacs is running or not ... possible to do so but maybe
;; not advised.

CapsLock & i::Send("{F8}i")

;; I have reserved some Ctrl+Win+Alt combinations for some Windows
;; programs that appear to tie into the input at a low level, so
;; they don't really get the Hyper key combinations.