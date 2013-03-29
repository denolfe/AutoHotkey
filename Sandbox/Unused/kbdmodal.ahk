;; Source: http://www.autohotkey.com/community/viewtopic.php?t=14428
Menu, Tray, Icon, lib\keyboard.ico

;; :encoding=utf-8:
;;
;; kbdmodal.ahk
;;
;; Author: Marko Mahnič
;; Description:
;;      Keyboard remapper with 3 modes of operation: Write, Command and
;;      Keypad. To enter the command mode press CapsLock. To enter
;;      the Kepyad mode press Alt-CapsLock. To toggle the CapsLock state
;;      press Shift-CapsLock.
;;
;;      Command mode (on english keyboard)
;;         - ijkl   Send up/left/down/right
;;         - um     Send home/end
;;         - o.     Send page up/down
;;         - xcv    Send Ctrl-X/Ctrl-C/Ctrl-V (clipboard cut/copy/paste)
;;         - w      Select the write mode (also active in KP mode)
;;         - qa     Prefix next character with Ctrl/Alt
;;         - s      Popup the select menu
;;         - Ctrl-S Send Ctrl-S (usually save)
;;         - d      Send Delete
;;         - Ctrl-Z Send Ctrl-Z (usually undo)
;;         - 0..9   Prefix argument (max 3 digits; Esc to cancel)
;;
;;      The current mode is displayed in a semi-transparent window.
;;      The prefix argument works with all movement commands and with
;;      the commands: v, w, s, d. It also works with arrow keys and
;;      the numeric keypad (NumLock Off).
;;
;; History:
;;    2006-08-19 First version
;;      - CapsLock cycles thru modes: Normal, Move, KP
;;      - Alt-CapsLock toggles CapsLock state
;;      - ijkl for arrows, np for page operations, xcv for clipboard,
;;        be for home/end
;;      - Ctrl-Z, Ctrl-S undo/save
;;      - d delete
;;    2006-09-10 Marko Mahnič
;;      - status blinks when mode is not Normal
;;      - fadeout window with mode-change info added
;;      - keyboard changes: O. page; im home/end (similar to keypad layout)
;;      - CapsLock switches between Move and KP; a returns to Normal
;;    2006-10-20 Marko Mahnič
;;      - modes renamed: Write, Command(CMD) and KP
;;      - w (write) changes to normal, key a unassigned
;;      - s (select) pops up a selection menu (select words, lines, bol, eol)
;;      - q (quick?) waits for char input and sends ctrl-char
;;      - PREFIX argument in CMD mode for repeated keypress
;;        (type 55w# to insert 55 characters #)
;;    2006-11-19 Marko Mahnič
;;      - Suspend the script for certain windows.
;;        VMWare virtual machine doesn't recieve translated keypresses
;;        so the outer instance of the script should be suspended and
;;        a new instance should be running inside the VM.
;;    2006-11-23 Marko Mahnič
;;      - mode window in the titlebar (when not in write mode)
;;      - CapsLock -> CMD; Alt-CapsLock -> KP; Shift-CapsLock -> toggle
;;      - a waits for char input and sends ctrl-char
;;      - code cleanup

opt_auto_reset_mode := false
opt_wmode_position := "WTC"
opt_window_suspend := "InVitro:"

blink_enabled := 1
blink_timeout := 500
blink_state := 0
;; dblcaps_timeout := 500

trans_blink_on := 255
trans_blink_off := 64
trans_default := 192

status_title:= "Keymode-Status"
mode_capsel := "CapsLock: SELECT"

;; If you change these also change the #ifwinexist commands !
win_title   := "Modal Keyboard"
mode_normal := "Mode: write"
mode_move   := "Mode: CMD"
mode_keypad := "Mode: KP"

;; Some system have multi-press home/end behaviour
;; jEdit: beg_of_nonwhite, bol, beg_of_screen
;; MSVC: beg_of_nonwhite, bol
;; NetBeans: beg_of_nonwhite, bol
keyseq_bol:="{Home}{Home}"
keyseq_eol:="{End}{End}"
keyseq_bol_select:="+{Home}+{Home}"
keyseq_eol_select:="+{End}+{End}"

rgui_w:=70
rgui_w2:=108
rgui_h:=16
rfade_w:=140
rfade_h:=24

make_windows()
make_selection_menu()
modewin_update_position()
MainLoop()

return

repeat_count := "" ; prefix argument for some commands
gid_active_window := 0
gid_win_mode := 0
gid_win_status := 0
gid_mnu_selection := 0

make_windows()
{
   global gid_win_mode, gid_win_status
   global rgui_w, rgui_w2, rgui_h
   global rfade_w, rfade_h
   global win_title, status_title, mode_normal
   global ctrl_mode, ctrl_change, repeat_display
   global trans_default
   
   SysGet,rect_workarea,MonitorWorkArea
   
   rgui_top:=rect_workareaBottom - rgui_h
   rgui_left:=rect_workareaRight - rgui_w
   rmid_left:=rgui_left / 2
   rmid_top:=rgui_top / 2
   
   Gui, -Caption +Border +AlwaysOnTop +ToolWindow
   Gui, Add, Text, cRed x1 y1 w70 vctrl_mode, %mode_normal%
   Gui, Add, Text, cBlue x70 y1 w70 vrepeat_display,R:888 
   Gui, Show, NA w70 h16 x0 y0,%win_title%
   WinGet,gid_win_mode,ID,%win_title%, %mode_normal%
   WinSet,Transparent,%trans_default%,ahk_id %gid_win_mode%
   
   Gui, 2:-Caption +Border +AlwaysOnTop +ToolWindow
   Gui, 2:Font, s12 w700
   Gui, 2:Add, Text, cGreen x1 y1 w%rfade_w% vctrl_change,Status
   Gui, 2:Show, NA w%rfade_w% h%rfade_h% x0 y0,%status_title%
   WinGet,gid_win_status,ID,%status_title%,Status
   Gui, 2:Hide
}

what_mode()
{
   global ctrl_mode
   GuiControlGet,curmode,,ctrl_mode,Text
   return curmode
}

do_modewin_update_position()
{
   global gid_win_mode, mode_normal
   global rgui_w, rgui_h, rgui_w2
   global repeat_count
   global opt_wmode_position
   global active_x,active_y,active_w,active_h
   
   SetTimer,lab_tm_update_position,Off
   
   hh := rgui_h
   ww := rgui_w
   if (repeat_count != "")
      ww := rgui_w2

   curmode := what_mode()
   
   ;; Bottom Right
   SysGet,rect_workarea,MonitorWorkArea
   xx:=rect_workareaRight - ww
   yy:=rect_workareaBottom - hh
   if (curmode != mode_normal)
   {
      if (opt_wmode_position == "WTC")
      {
         ;; Window titlw center
         xx := active_x + (active_w - ww) / 2
         yy := active_y + 8
      }
      else
         xx:=xx / 2 ;; Horizontal Center
   }

   WinMove,ahk_id %gid_win_mode%,,%xx%,%yy%,%ww%,%hh%
}

lab_tm_update_position:
{
   SetTimer,lab_tm_update_position,Off
   do_modewin_update_position()
   return
}

modewin_update_position()
{
   SetTimer,lab_tm_update_position,10
}


capslock_toggle()
{
   global mode_normal
   st := GetKeyState("CapsLock", "T") 
   if (st)
   {
      SetCapsLockState, Off
      capsel_setmode(mode_normal, "CapsLock Off")
   }
   else
   {
      SetCapsLockState, On
      capsel_setmode(mode_normal, "CAPSLOCK ON")
   }
}


;; TODO: auto mode switcher 
;;   - some windows switch to edit on activate
;;   - some switch to normal on activate
;;   - if option set, always switch to user-defined mode on select
check_window_noreset()
{
   global opt_auto_reset_mode
   
   if (not opt_auto_reset_mode) 
      return 1
      
   IfWinActive,Total Commander
      return 1
   IfWinActive,Lister 
      return 1
      
   return 0
}

;; ---------------------------------------------
;; Periodic checks
;; ---------------------------------------------
check_reset_mode()
{
   global gid_active_window, mode_normal, win_title, gid_win_mode
   WinGet, active_id, ID, A

   if (active_id != gid_active_window)
   {
      if not (WinExist(win_title, mode_normal))
      {
         if (not check_window_noreset())
            capsel_setmode(mode_normal)
      }
      gid_active_window := active_id
      do_modewin_update_position()
   }
}

check_suspend_script()
{
   global mode_normal,opt_window_suspend
   If WinActive(opt_window_suspend)
   {
      Suspend,On
      capsel_setmode(mode_normal)
      WinWaitNotActive,%opt_window_suspend%
      Suspend,Off
   }
}

perform_periodic_checks()
{
   global active_x,active_y,active_w,active_h

   x := active_x
   y := active_y
   WinGet, active_id, ID, A
   WinGetPos,active_x,active_y,active_w,active_h,ahk_id %active_id%
   
   if (x != active_x or y != active_y)
   {
      do_modewin_update_position()
   }

   if true
   {
      check_reset_mode()
      check_suspend_script()
   }
}

MainLoop()
{
   Loop
   {
      perform_periodic_checks()
      Sleep,40
   }
}

;; ---------------------------------------------
;; Blink functions
;; ---------------------------------------------
blink_begin()
{
   global gid_win_mode, win_title, mode_normal, blink_enabled, blink_timeout, blink_state
   blink_state := 0
   If (WinExist(win_title, mode_normal))
   {
      blink_end()
      return
   }
   if (not blink_enabled)
   {
      blink_end()
      return
   }
     
   SetTimer,lab_tm_blink,%blink_timeout%
}

blink_end()
{
   global gid_win_mode
   global trans_blink_on, trans_blink_off, trans_default
   SetTimer,lab_tm_blink,Off
   WinSet,Transparent,%trans_default%,ahk_id %gid_win_mode%
}

blink_toggle()
{
   global gid_win_mode, blink_state
   global trans_blink_on, trans_blink_off, trans_default
   
   blink_state := 1 - blink_state
   if (blink_state)
      WinSet,Transparent,%trans_blink_on%,ahk_id %gid_win_mode%
   else
      WinSet,Transparent,%trans_blink_off%,ahk_id %gid_win_mode%
}

lab_tm_blink:
{
   if (blink_enabled)
      blink_toggle()
   
   return
}

;; ---------------------------------------------
;; CapSel functions
;; ---------------------------------------------
do_capsel_fadeout_begin(fcount, fadeout_label)
{
   global gid_win_status, rfade_w, rfade_h
   global active_x,active_y,active_w,active_h
   global tm_fadeout_count
   SetTimer,lab_tm_fadeout,Off
   tm_fadeout_count := fcount
   Gui, 2:Show, NA,CapsStatusChanging
   GuiControl,2:Text,ctrl_change,%fadeout_label%
   
   rmid_left := active_x + (active_w - rfade_w) / 2
   rmid_top  := active_y + (active_h - rfade_h) / 2
   WinMove,ahk_id %gid_win_status%,,%rmid_left%,%rmid_top%
   WinSet,Transparent,220,ahk_id %gid_win_status%
   SetTimer,lab_tm_fadeout,50
}

gpar_fadeout_count:=0
gpar_fadeout_label:="..."
capsel_fadeout_begin(fcount, fadeout_label)
{
   global gpar_fadeout_count, gpar_fadeout_label
   gpar_fadeout_count := fcount
   gpar_fadeout_label := fadeout_label
   SetTimer,lab_tm_install_fadeout,100
}

lab_tm_install_fadeout:
{
   SetTimer,lab_tm_install_fadeout,Off
   do_capsel_fadeout_begin(gpar_fadeout_count, gpar_fadeout_label)
   return
}

capsel_fadeout_end()
{
   global gid_win_status
   SetTimer,lab_tm_install_fadeout,Off
   SetTimer,lab_tm_fadeout,Off
   WinHide,ahk_id %gid_win_status%
}

lab_tm_fadeout:
{
    tm_fadeout_count := tm_fadeout_count - 1
    if tm_fadeout_count < 1
    {
       capsel_fadeout_end()
       return
    }
    if (tm_fadeout_count <= 10)
    {
       n_trans := 220 - (10 - tm_fadeout_count) * 20
       WinSet,Transparent,%n_trans%,ahk_id %gid_win_status%
    }
    return
}

capsel_setmode(new_mode, fadeout_label=0)
{
   global ctrl_mode, ctrl_change, tm_capsel_count, mode_normal
   global gid_win_mode, trans_default   
   SetTimer,lab_tm_fadeout,Off
   SetTimer,lab_tm_blink,Off
   GuiControl,Text,ctrl_mode,%new_mode%
   if (fadeout_label = 0)
      fadeout_label := new_mode

   if (new_mode == mode_normal)
      WinSet,Transparent,%trans_default%,ahk_id %gid_win_mode%
   else
      WinSet,Transparent,255,ahk_id %gid_win_mode%
   
   ClearPrefixArg()
   blink_begin()
   capsel_fadeout_begin(15,fadeout_label)
   modewin_update_position()
}

MyMapKey(key)
{
   SendInput {blind}%key%
}

MyMapKey_repeat(pfx, key)
{
   global repeat_count
   
   capsel_fadeout_end()
   
   if (repeat_count == "")
      SendInput {blind}%pfx%{%key%}
   else
   {
      SendInput {blind}%pfx%{%key% %repeat_count%}
      ClearPrefixArg()
   }
}

ClearPrefixArg()
{
   global repeat_count, repeat_display
   if (repeat_count == "") 
      return
   repeat_count := ""
   GuiControl,Text,repeat_display,
   modewin_update_position()
}

AddPrefixArg(key)
{
   global repeat_count, repeat_display
   if (StrLen(repeat_count) > 2)
   {
      ClearPrefixArg()
      return
   }

   repeat_count=%repeat_count%%key%
   GuiControl,Text,repeat_display,R:%repeat_count%
   modewin_update_position()
   a=Count: %repeat_count%
   capsel_fadeout_begin(15, a)
}

;; ---------------------------------------------
;; Permanent keymappings
;; Should not be present in any other section
;; ---------------------------------------------

;; Moving with keypad - repeated keypress
*NumpadHome::MyMapKey_repeat("", "Home")
*NumpadUp::MyMapKey_repeat("", "Up")
*NumpadPgUp::MyMapKey_repeat("", "PgUp")
*NumpadLeft::MyMapKey_repeat("", "Left")
*NumpadClear::MyMapKey_repeat("", "Down")
*NumpadRight::MyMapKey_repeat("", "Right")
*NumpadEnd::MyMapKey_repeat("", "End")
*NumpadDown::MyMapKey_repeat("", "Down")
*NumpadPgDn::MyMapKey_repeat("", "PgDn")
*NumpadIns::Ins
*NumpadDel::MyMapKey_repeat("", "Del")

*Home::MyMapKey_repeat("", "Home")
*Up::MyMapKey_repeat("", "Up")
*PgUp::MyMapKey_repeat("", "PgUp")
*Left::MyMapKey_repeat("", "Left")
*Right::MyMapKey_repeat("", "Right")
*End::MyMapKey_repeat("", "End")
*Down::MyMapKey_repeat("", "Down")
*PgDn::MyMapKey_repeat("", "PgDn")
*Del::MyMapKey_repeat("", "Del")

;; ---------------------------------------------
;; Nonmapped mode
;; ---------------------------------------------
#ifwinexist Modal Keyboard, Mode: write
*CapsLock::
{
   if (getKeyState("Shift"))
      capslock_toggle()
   else if (getKeyState("Alt"))
      capsel_setmode(mode_keypad)
   else
      capsel_setmode(mode_move)
}
return

*SC029::MyMapKey("{Esc}") ;; Cedilla, left of '1'
return

;; ---------------------------------------------
;; Numeric keypad emulation (notebook style)
;; ---------------------------------------------
#ifwinexist Modal Keyboard, Mode: KP
;; 7890 defined twice to fix the cinflict with prefix key ( see forward )
*7::
7::MyMapKey("{Numpad7}")
*8::
8::MyMapKey("{Numpad8}")
*9::
9::MyMapKey("{Numpad9}")
*0::
0::MyMapKey("{NumpadMult}")
*p::MyMapKey("{NumpadSub}")
*u::MyMapKey("{Numpad4}")
*i::MyMapKey("{Numpad5}")
*o::MyMapKey("{Numpad6}")
*j::MyMapKey("{Numpad1}")
*k::MyMapKey("{Numpad2}")
*l::MyMapKey("{Numpad3}")
*m::MyMapKey("{Numpad0}")
*SC027::MyMapKey("{NumpadAdd}")    ;semicolon    jkl(;)
*SC035::MyMapKey("{NumpadDiv}")    ;slash        nm,.(/) 
*SC029::MyMapKey("{Esc}") ;; Cedilla, left of '1'
return

*CapsLock::
{
   if (getKeyState("Shift"))
      capslock_toggle()
   else ;; if A_TimeSincePriorHotkey > %dblcaps_timeout%
      capsel_setmode(mode_move)
}
return

*w::
{
   capsel_setmode(mode_normal)
}
return

;; ---------------------------------------------
;; Movement block emulation (jkl)
;; ---------------------------------------------
#ifwinexist Modal Keyboard, Mode: CMD
; disable unused keys
*q::
;*w::
*e::
*r::
*t::
*z::  ; y
;*u::
;*i::
;*o::
*p::
*SC01A::         ; left bracket    ([)
*SC01B::         ; right bracket   (])
*a::
*s::
;*d::
*f::
*g::
;*h::
;*j::
;*k::
;*l::
;*SC027::        ; semicolon        (;)
*SC028::        ; single quote     (') 
*SC02B::        ; backslash        (\)
*y::  ; z
;*x::
;*c::
;*v::
*b::
*n::
;*m::
*SC033::        ; period
;*SC034::        ; comma
return

;; Prefix argument
;; First we define each key to remap to itself
;; Then we add special behaviour for non-modified keypress
;; This way we resolve conflicts with KP mode (7890)
*1::1
1::AddPrefixArg("1")
*2::2
2::AddPrefixArg("2")
*3::3
3::AddPrefixArg("3")
*4::4
4::AddPrefixArg("4")
*5::5
5::AddPrefixArg("5")
*6::6
6::AddPrefixArg("6")
*7::7
7::AddPrefixArg("7")
*8::8
8::AddPrefixArg("8")
*9::9
9::AddPrefixArg("9")
*0::0
0::AddPrefixArg("0")

*SC029:: ;; Cedilla, left of '1'
Esc::
{
   if (repeat_count != "" )
      ClearPrefixArg()
   else
      MyMapKey("{Esc}")
   return
}

; The movement block
*j::MyMapKey_repeat("", "Left")
*k::MyMapKey_repeat("", "Down")
*i::MyMapKey_repeat("", "Up")
*l::MyMapKey_repeat("", "Right")
*u::MyMapKey_repeat("", "Home")
*m::MyMapKey_repeat("", "End")
*o::MyMapKey_repeat("", "PgUp")
*h::MyMapKey_repeat("^", "Left")
*SC027::MyMapKey_repeat("^", "Right")   ;semicolon   (;)
*SC034::MyMapKey_repeat("", "PgDn")  ;period  nm,(.)/ 

; Clipboard shortcuts
*x::MyMapKey("^x")
*c::MyMapKey("^c")
*v::MyMapKey_repeat("^", "v")
^z::MyMapKey("^z")
*d::MyMapKey_repeat("", "Del") ;; Erase (character or selection)
*Del::MyMapKey_repeat("", "Del")
*Backspace::MyMapKey_repeat("", "Backspace")
s:: 
{
   Suspend,On
   CoordMode,Menu,Screen
   Menu,gid_mnu_selection,Show,%rmid_left%,%rmid_top%
   CoordMode,Menu,Relative
   Suspend,Off
   return
   
   ;; Delete (D ...) could be implemented in a similar fashion.
   ;; I consider it safer to just (S ...) select and (D) delete. 
   ;; This way one can see what is going to be deleted.
}
^s::MyMapKey("^s")

lab_selection_line_up:
{
   ;; 1. goto BOL - some editors remeber the current column if I just go down
   ;;    if the next line is empty, the remembered column might not change
   ;; 2. go down - some editors might go to eol on last line without line-break
   ;; 3. goto BOL - reason: see 2.
   SendInput %keyseq_bol%{Down}%keyseq_bol%
   MyMapKey_repeat("+", "Up")
   return
}
lab_selection_line_down:
{
   SendInput %keyseq_bol%
   MyMapKey_repeat("+", "Down")
   return
}
lab_selection_char_forward:
{
   MyMapKey_repeat("+", "Right")
   ClearPrefixArg()
   return
}
lab_selection_char_back:
{
   MyMapKey_repeat("+", "Left")
   ClearPrefixArg()
   return
}
lab_selection_word_forward:
{
   MyMapKey_repeat("^+", "Right")
   ClearPrefixArg()
   return
}
lab_selection_word_back:
{
   MyMapKey_repeat("^+", "Left")
   ClearPrefixArg()
   return
}
lab_selection_bol:
{
   SendInput %keyseq_bol_select%
   ClearPrefixArg()
   return
}
lab_selection_eol:
{
   SendInput %keyseq_eol_select%
   ClearPrefixArg()
   return
}

make_selection_menu()
{
   global gid_mnu_selection
   Menu,gid_mnu_selection,Add,Select,lab_selection_line_down
   Menu,gid_mnu_selection,Default,Select
   Menu,gid_mnu_selection,Add,&I lines up,lab_selection_line_up
   Menu,gid_mnu_selection,Add,&K lines down,lab_selection_line_down
   Menu,gid_mnu_selection,Add,&S lines down,lab_selection_line_down
   Menu,gid_mnu_selection,Add,&L words,lab_selection_word_forward
   Menu,gid_mnu_selection,Add,&J words back,lab_selection_word_back
   Menu,gid_mnu_selection,Add,&U to strat of line,lab_selection_bol
   Menu,gid_mnu_selection,Add,&M to end of line,lab_selection_eol
}

*CapsLock::
{
   if (getKeyState("Shift"))
      capslock_toggle()
   ;; else if A_TimeSincePriorHotkey > %dblcaps_timeout%
   ;;else if (getKeyState("Alt"))
   else if (what_mode() == mode_normal)
	    capsel_setmode(mode_move)
	else
		capsel_setmode(mode_normal)
}
return

*w::
{
   if (repeat_count != "")
   {
      Suspend,On
      capsel_fadeout_begin(32, "Repeat char...")
      Input,ch,L1 T2
      capsel_fadeout_end()
      Suspend,Off
      if (StrLen(ch) > 0 && (ch >= " " || ch == Chr(9) ))
      {
         if (ch == " ")
            ch := "Space"
         if (ch == Chr(9))
            ch := "Tab"
         SendInput {%ch% %repeat_count%}
         ClearPrefixArg()
         return
      }
   }
   capsel_setmode(mode_normal)
}
return

;; Translate next character into control keypress
q::
{
   Suspend,On
   capsel_fadeout_begin(32, "Control char...")
   Input,ch,L1 T2
   capsel_fadeout_end()
   if (StrLen(ch) > 0 && (ch >= " " ))
   {
      if (ch == " ")
      ch := "Space"
      SendInput ^{%ch%}
      capsel_setmode(mode_move)
   }
   Suspend,Off
   return
}

;; Translate next character into alt keypress
a::
{
   Suspend,On
   capsel_fadeout_begin(32, "Alt char...")
   Input,ch,L1 T2
   capsel_fadeout_end()
   if (StrLen(ch) > 0 && (ch >= " " ))
   {
      if (ch == " ")
      ch := "Space"
      SendInput !{%ch%}
      capsel_setmode(mode_move)
   }
   Suspend,Off
   return
}


