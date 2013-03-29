/*
Name: Mango: Clipboard tools
By: tidbit
Created: Thu May 28, 2009
version: 1.40 (Tue December 13, 2011)

hotkeys::
	Rwin      : main Menu
	ctrl+caps : caps control
	esc       : close caps Control
	xbutton2  : middle mouse   <--- personal mouse remap. find it at bottom.
	Lwin+End  : (try to) force close the current window. incase of hang-up/freeze.
	
*/

#SingleInstance force
; #NoTrayIcon
first:=1
Title=ClipHist
visi:=0
j:=0
am :=0 ; add mode
Hotkey, $^C, addtoclip, off

;OPTIONS SUBMENU
Menu, options, Add, restart Mango., restartMango
Menu, options, Add, Exit Mango., exitscript

;TOP SECTION
Menu, MangoMenu, Add, hide, hide
Menu, MangoMenu, Add, count, count
Menu, MangoMenu, Add, Options:, :options
Menu, MangoMenu, Add,

;RUN SUBMENU
Menu, Submenu1, Add, wordpad, wordpad
Menu, Submenu1, Add, charmap, keymap
Menu, Submenu1, Add, cmd, cmd
Menu, Submenu1, Add,
Menu, Submenu1, Add, explorer, explorer
Menu, Submenu1, Add, volume, volume
Menu, Submenu1, Add, System info, sysinfo
Menu, Submenu1, Add, dxdiag, dxdiag
; ---------- Custom stuff. specific to my PC.
Menu, Submenu1, Add,
Menu, Submenu1, Add, Type and Go, TandG
Menu, Submenu1, Add, notepad++, notepadpp

;VIEW SUBMENU
Menu, Submenu2, Add, C:\, cdrive
Menu, Submenu2, Add, Program Files, progfiles
Menu, Submenu2, Add, My Documents, mydocs
Menu, Submenu2, Add, My Pictures, mypics
Menu, Submenu2, Add, desktop, desktop
Menu, Submenu2, Add, explorer, explorer
Menu, Submenu2, Add, recycler, recycler
; ---------- Custom stuff. specific to my PC.
Menu, Submenu2, Add,
Menu, Submenu2, Add, models, models
Menu, Submenu2, Add, ahk, ahk

;MISC SUBMENU
Menu, Submenu3, Add, ahk Manual, ahkman
Menu, Submenu3, Add, SyncToy 2.1, sync
Menu, Submenu3, Add, Caps Control, CapsControl
Menu, Submenu3, Add, ZoomIt, ZoomIt
Menu, Submenu3, Add, Passwords, Passwords
Menu, Submenu3, Add, gen, gen

;SHUTDOWN SUBMENU
Menu, Submenu5, Add, Shutdown, shtdn
Menu, Submenu5, Add, Stand by, stndby
Menu, Submenu5, Add, Log off, logoff
Menu, Submenu5, Add, restart, restart
Menu, Submenu5, Add,
Menu, Submenu5, Add, Power Down, pwrdwn
Menu, Submenu5, Add, emergency!, emergency


;TOOLS SUBMENU
Menu, tools, Add, -Tools-, disabled
Menu, tools, Add, save to file, save
; Menu, tools, add, Toggle: Add Text to Clipboard, addmode ; doesn't work so well.
Menu, tools, Add, -Case-, disabled
Menu, tools, Add, Uppercase, ucase
Menu, tools, Add, lowercase, lcase
Menu, tools, Add, Sentence case, scase
Menu, tools, Add, Title Case, tcase
Menu, tools, Add, iNVERSE cASE, icase
Menu, tools, Add, -Organization-, disabled
Menu, tools, Add, Sort A-Z, sortaz
Menu, tools, Add, Sort Z-A, sortza
Menu, tools, Add, Sort random, sortrand
Menu, tools, Add, Flip<->pilF, flip
Menu, tools, Add, Spaces-->Tabs, StoT
Menu, tools, Add, Tabs-->Spaces, TtoS
Menu, tools, Add, Remove leading whitespaces, leading
Menu, tools, Add, Remove trailing whitespaces, trailing
Menu, tools, Add, Remove blank lines, doublelines
Menu, tools, Add, Remove doubles, remdbls
Menu, tools, Add, -System-, disabled
Menu, tools, Add, force Close current window, force
Menu, tools, Add, Get window under mouse, window
Menu, tools, Add, -Misc-, disabled
Menu, tools, Add, Google search, google
Menu, tools, Add, Google image search, googleimage
Menu, tools, Add, Run AHK code, runcode

;PLUGINS SUBMENU
Menu, plugins, add, -Plugins-, disabled
Loop, %A_ScriptDir%\Plugins\*.*
{
	if A_LoopFileExt contains ahk,lnk
	Menu, plugins, add, %A_LoopFileName%, plugins
}
;DISABLE THE SEPERATORS
; Menu, submenu1, Disable,     -Custom-
; Menu, submenu2, Disable,     -Custom-
Menu, plugins, Disable,     -Plugins-
Menu, Tools, Disable,     -Tools-
Menu, Tools, Disable,     -Case-
Menu, Tools, Disable,     -Organization-
Menu, Tools, Disable,     -System-
Menu, Tools, Disable,     -Misc-


;;------------------;;
;;----Main View:----;;
;;------------------;;
Menu, MangoMenu, Add, Run: , :Submenu1
Menu, MangoMenu, Add, view: , :Submenu2
Menu, MangoMenu, Add, Misc: , :Submenu3
Menu, MangoMenu, Add,
Menu, MangoMenu, Add, Goodbye  , :Submenu5
Menu, MangoMenu, add,
Menu, MangoMenu, add, &Tools:, :tools
Menu, MangoMenu, add, &plugins:, :plugins
Menu, MangoMenu, add, &History, history
Menu, MangoMenu, Add
Menu, MangoMenu, Add, mspaint, mspaint
Menu, MangoMenu, Add, notepad, notepad
Menu, MangoMenu, Add, calc, calc

menu, MangoMenu, Color, 8d9670

;;-----------------;;
;;----Clip Hist----;;
;;-----------------;;
; gui, 32:Default
; gui, 32: +AlwaysOnTop +Owner
; gui, 32:add, ListView, x6 y6 w400 r11 vhist ghist, Window|Clip
; Lv_ModifyCol(1, 128)
; Lv_ModifyCol(2, 256)
; gui, 32:add, text, x6, Current Clipboard:
; gui, 32:add, edit, x6 h60 w400 vcurclip, %clipboard%
return

RWin::
	winget, pid, PID, A
	winget, wid, ID, A
	WinGetActiveTitle, atitle
	ControlGetFocus, fControl, A
	iniwrite, %pid%, %A_Scriptdir%\Plugins\Window_info.ini, stats, PID
	iniwrite, %wid%, %A_Scriptdir%\Plugins\Window_info.ini, stats, WinID
	iniwrite, %atitle%, %A_Scriptdir%\Plugins\Window_info.ini, stats, Title
	iniwrite, %fControl%, %A_Scriptdir%\Plugins\Window_info.ini, stats, Control
	Menu, MangoMenu, Show
return

Folder:
	Run, %A_ScriptDir%
Return

disabled:
hide:
return

;;-----------------;;
;;----Clip Hist----;;
;;-----------------;;
 history:
	 gui, 32:Default
	visi:=!visi
	if visi=1
	 gui, 32:show, Center , %Title%
	 Else
	 gui, 32:cancel
 Return

 hist:
   gui, 32:Default
  If A_GuiEvent = DoubleClick
   {
     Lv_GetText(text, A_EventInfo, 2)
    clipboard:=text
	 mode=0                                             ; if double clicked on the GUI, mode is set to 0. 	                                                   ;   Stopping the Lv_Add() below.
   }
 Return

 OnClipboardChange:
   gui, 32:Default
   Guicontrol, 32:, curclip, %clipboard%

   If regexmatch(clipboard, "^\s*$")                    ; ignore adding if blank
     Return
   WinGetActiveTitle, activetitle
   if (mode==1)
	 Lv_Add("", activetitle, Clipboard)
   mode=1
 Return

 32guiclose:
	 visi=0
	 gui, 32: cancel
 Return

;;---------------------;;
;;----Caps Control:----;;
;;---------------------;;
~^Capslock::
capscontrol:
Gui, 27: Default
if (first==1)
{
  Gui, 27:Add, CheckBox, x6 y7 w100 h20 cred gcc_preview vtitcase, Title Case.
  Gui, 27:Add, CheckBox, x+3 yp w100 h20 cred gcc_preview vsencase, Sentence case.
  Gui, 27:Add, CheckBox, x+3 yp w100 h20 cred gcc_preview vuppcase, UPPER CASE.
  Gui, 27:Add, CheckBox, x+3 yp w100 h20 cred gcc_preview vlowcase, lower case.

  Gui, 27:Add, CheckBox, x6 y+3 w100 h20 cblue gcc_preview vsort, Sort?
		Gui, 27:Add, CheckBox, x+3 yp w100 h20 cblue +disabled gcc_preview vsortrand, Sort Random.
		Gui, 27:Add, CheckBox, x+3 yp w100 h20 gcc_preview vremblanks, Rem. Blanks?

		Gui, 27:Add, CheckBox, x6 y+3 w100 h20 cblue +disabled gcc_preview vsortza, Sort Z-A
		Gui, 27:Add, CheckBox, x+3 yp w100 h20 cblue +disabled gcc_preview vsortnums, Use Numbers?
		Gui, 27:Add, CheckBox, x+3 yp w100 h20 cblue +disabled gcc_preview vremdbls, Rem. Doubles?

		Gui, 27:Add, CheckBox, x+3 yp-23 w100 h20 cblue gcc_preview vcustdelim, Custom Delim.?
		Gui, 27:Add, Edit, xp y+3 w100 r1 +disabled gcc_preview vuserdelim,`n

  Gui, 27:Add, CheckBox, x6 y+3 w100 h20 cGreen gcc_preview vtohex, To Hex
  Gui, 27:Add, CheckBox, x+3 yp w100 h20 cGreen gcc_preview vtodec, To Ascii
  Gui, 27:Add, CheckBox, x+3 yp w100 h20 cGreen gcc_preview vCleanHTML, Clean HTML
  Gui, 27:Add, CheckBox, x+3 yp w100 h20 cGreen gcc_preview vflip, Flip<-->pilF

	Gui, 27:Add, CheckBox, x6 y+3 w100 h20 cGreen gcc_preview vstot, Spaces-->Tabs
  Gui, 27:Add, CheckBox, x+3 yp w100 h20 cGreen gcc_preview vttos, Tabs-->Spaces
  Gui, 27:Add, CheckBox, x+3 yp w100 h20 cGreen gcc_preview vrlw, No leading
  Gui, 27:Add, CheckBox, x+3 yp w100 h20 cGreen gcc_preview vrtw, No trailing


	Gui, 27:Add, CheckBox, x6 y+3 w100 h20 cPurple gcc_preview vpadding, Padding?
		Gui, 27:Add, CheckBox, xp y+3 w100 h20 cPurple gcc_preview vcounter, Counter?
		Gui, 27:Add, Text, x+3  yp-23  w100 h20 cPurple +disabled gcc_preview vlpaddingtext, Left
		Gui, 27:Add, Edit, xp   y+3    w100 h20 cPurple +disabled wanttab gcc_preview vlpadding,.%A_Space%
		Gui, 27:Add, Text, x+3  yp-23  w100 h20 cPurple +disabled gcc_preview vrpaddingtext, Right
		Gui, 27:Add, Edit, xp   y+3    w100 h20 cPurple +disabled wanttab gcc_preview vrpadding,
		Gui, 27:Add, Text, x+3  yp-23  w100 h20 cPurple gcc_preview vcstarttext, Offset
		Gui, 27:Add, Edit, xp   y+3    w100 h20 cPurple wanttab gcc_preview vcstart, 1

	Gui, 27:Add, CheckBox, x6 y+3 w100 h20 cTeal gcc_preview vtrim, Trim?
		Gui, 27:Add, Text, x+3  yp     w100 h20 cTeal +disabled gcc_preview vltrimtext, Left
		Gui, 27:Add, Edit, xp   y+3    w100 h20 cTeal +disabled +Number gcc_preview vltrim, 1
		Gui, 27:Add, Text, x+3  yp-23  w100 h20 cTeal +disabled gcc_preview vrtrimtext, Right
		Gui, 27:Add, Edit, xp   y+3    w100 h20 cTeal +disabled +Number gcc_preview vrtrim, 1



  Gui, 27: font, s11, Verdana

  Gui, 27:Add, Edit, x6 y+5 w400 h120 -Wrap +hscroll +wanttab gcc_preview vui, %clipboard%
  Gui, 27:Add, Button, x6 y+3 w400 h20 gcc_swap, ^ Swap v
  Gui, 27:Add, Edit, x6 y+3 w400 h120 -Wrap +hscroll +wanttab voutput, Preview

	Gui, 27: font

  Gui, 27:Add, Button, x336 y+3 w70 r2 gcc_copy, Copy
  Gui, 27:Add, Edit, x6 yp w320 r2 +disabled vstats , Characters: `t Lines:
  first:=0
}
Gui, 27:Show, autosize, Caps Control
Gosub, cc_preview
Return

cc_copy:
Gui, 27:submit, nohide
Clipboard:=output
return

cc_swap:
Gui, 27:submit, nohide
cctemp:=ui
GuiControl, 27:, ui, %output%
GuiControl, 27:, output, %cctemp%
cctemp:=
return

cc_preview:
Gui, 27:submit, nohide

/*
	Order of Operations:
	Things grouped may conflict with eachother if multiple are checked.
	In this case, the item lowst in the group has the highest priority.
	Which means it'll try to overwrite the other options.

	Remove Leading

	Remove Trailing

	Remove Html Tags And Entities

	Uppercase
	Lowercase
	Title Case
	Sentence Case

	Flip
	Spaces To Tabs
	Tabs To Spaces

	To Hexadecimal

	To Ascii

	Remove Blanks

	Trim
	
	Sort
		Remove Doubles

		Random
		Z-A Sort
		Sort By Numbers

		Case Sensitive


	Padding
*/

if (rlw==1)
	ui := RegExReplace(ui, "m`n)^[ \t]+", "")
if (rtw==1)
	ui := RegExReplace(ui, "m`n)[ \t]+$","")

if (CleanHTML==1)
{
  ui:=ConvertEntities(ui)
  ui:=unhtm(ui)
}


if (uppcase==1)
  StringUpper, ui, ui
if (lowcase==1)
  StringLower, ui, ui
if (titcase==1)
  StringLower, ui, ui, T
if (sencase==1)
{
  StringLower ui, ui
  ui:=RegExReplace(ui, "([.?\s!]\s\w)|^(\.\s\b\w)|\bi\b|^(.)", "$U0")
}
	
	
if (Flip==1)
  ui:=Flip(ui)

if (StoT==1)
	StringReplace, ui, ui, %A_Space%, %A_Tab%, All
if (TtoS==1)
	StringReplace, ui, ui, %A_Tab%, %A_Space%, All

if (tohex==1)
  ui:=_Hex(ui)
if (todec==1)
  ui:=_Asc(ui)

opt:=
if (custdelim==1)
{
  guicontrol, 27:Enable, userdelim
  opt.="D" userdelim " "
  userdelimpadding:=userdelim
}
else
{
  guicontrol, 27:disable, userdelim
  userdelim:="\n"
  userdelimpadding:="`n"
}

trimmed:=
if (trim==1)
{
  guicontrol, 27:enable, ltrim
  guicontrol, 27:enable, ltrimtext
  guicontrol, 27:enable, rtrim
  guicontrol, 27:enable, rtrimtext
	guicontrol, 27:enable, spos
  guicontrol, 27:enable, spostext

	if (ltrim!="" && rtrim!="")
	{
		loop, parse, ui, %userdelimpadding%
		{
				stuff:=SubStr(A_LoopField, ltrim+1, StrLen(A_LoopField)-(ltrim+rtrim))
				trimmed.=(A_Index!=max) ?  stuff userdelimpadding : stuff
		}
			ui:=trimmed
	}
}
Else
{
  guicontrol, 27:disable, ltrim
  guicontrol, 27:disable, ltrimtext
  guicontrol, 27:disable, rtrim
  guicontrol, 27:disable, rtrimtext
	guicontrol, 27:disable, spos
  guicontrol, 27:disable, spostext

}

if (remblanks==1)
  ui:=regexreplace(ui, "(" userdelim ")+", "$1")

loop, parse, ui, %userdelimpadding%
		max:=A_Index

if (sort==1)
{
  guicontrol, 27:enable, remdbls
  guicontrol, 27:enable, sortrand
  guicontrol, 27:enable, sortza
  guicontrol, 27:enable, sortnum
  guicontrol, 27:enable, casesensitive
  guicontrol, 27:enable, sortnums
  if (remdbls==1)
    opt.="U "
  if (sortrand==1)
    opt.="Random "
  if (sortza==1)
    opt.="R "
  if (sortnums==1)
    opt.="N "
  if (casesensitive==1)
    opt.="C "
  Else
    opt.="CL "

sort, ui, %opt%
dupes:=ErrorLevel
}
Else
{
  guicontrol, 27:disable, remdbls
  guicontrol, 27:disable, sortrand
  guicontrol, 27:disable, sortza
  guicontrol, 27:disable, sortnum
  guicontrol, 27:disable, casesensitive
  guicontrol, 27:disable, sortnums
}


padded:=
if (padding==1)
{
  guicontrol, 27:enable, lpadding
  guicontrol, 27:enable, lpaddingtext
  guicontrol, 27:enable, rpadding
  guicontrol, 27:enable, rpaddingtext
}
Else
{
  guicontrol, 27:disable, lpadding
  guicontrol, 27:disable, lpaddingtext
  guicontrol, 27:disable, rpadding
  guicontrol, 27:disable, rpaddingtext
}

if (counter==1 || padding==1)
{

	if (padding!=1)
	{
		lpadding:=
		rpadding:=
	}
	loop, parse, ui, %userdelimpadding%
	{
		if (A_Index>=cstart)
		{
			count:=(counter==1) ? A_Index-(cstart-1) : ""
			
			stuff:=count lpadding A_LoopField rpadding
			padded.=(A_Index!=max) ?  stuff userdelimpadding : stuff
		}
		Else
			padded.=(A_Index!=max) ?  A_LoopField userdelimpadding : A_LoopField
	}
		ui:=padded
}

ascvalue:=0
totblanks:=0
chars:=strlen(ui)
loop, parse, ui, `n, `r
{
	if (RegExMatch(A_LoopField, "^\s*$"))
		totblanks+=1
	lncnt:=A_Index
}

loop, parse, ui
	ascvalue+=Asc(A_LoopField)

guicontrol, 27:, stats, Characters: %chars% `t Asc value: %ascvalue% `t Lines: %lncnt% `t Blanks: %totblanks% `t Duplicates Removed: %dupes%
guicontrol, 27:, output, %ui%
return

;;------------;;
;;----Run:----;;
;;------------;;
mspaint:
	run, mspaint.exe
return
calc:
	run, calc.exe
return
explorer:
	run, Explorer.exe
return
notepad:
	run, notepad.exe
return
TandG:
	run, "%A_desktop%\New Folder\Programs\typeandrun\TypeandRun.exe"
return
notepadpp:
	run, "C:\Program Files\Notepad++\Notepad++.exe"
return
wordpad:
	run, wordpad.exe
return
keymap:
	run, charmap.exe
return
volume:
	run, sndvol32.exe
return
sysinfo:
	run, msinfo32.exe
return
dxdiag:
	run, dxdiag.exe
return
cmd:
	run, cmd.exe
return

;;-------------;;
;;----View:----;;
;;-------------;;
cdrive:
	run, C:\
return
progfiles:
	run, %A_ProgramFiles%
return
mydocs:
	run, %A_MyDocuments%
return
mypics:
	run, %A_MyDocuments%\My Pictures
return
desktop:
	run, %A_Desktop%
return
models:
	run, %A_MyDocuments%\Models
return
ahk:
	run, %A_MyDocuments%\AutoHotkey
return
recycler:
	run, C:\RECYCLER\S-1-5-21-299502267-630328440-725345543-1004
return

;;-----------------;;
;;----Shutdown:----;;
;;-----------------;;
shtdn:
	shutdown, 1
return
logoff:
	shutdown, 1
return
stndby:
	DllCall("PowrProf\SetSuspendState", "int", 0, "int", 1, "int", 1)
return
restart:
	shutdown, 2
return
; Dialogue:
; PostMessage, 0x111, 402, 0,, ahk_class Shell_TrayWnd ; Toggle "Shutdown dialogue"
; return
emergency:
	shutdown, 1
return
pwrdwn:
	shutdown, 8
return

;;-------------;;
;;----Misc:----;;
;;-------------;;
ahkman:
	SplitPath, A_AhkPath,, OutDir
	run, %OutDir%\AutoHotkey.chm
return
sync:
	run, C:\Program Files\SyncToy 2.1\SyncToy.exe
return
ZoomIt:
	run, %A_Desktop%\New Folder\SysinternalsSuite\SysinternalsSuite\ZoomIt.exe
return
gen:
	run, %A_MyDocuments%\AutoHotkey\My creations\Generate\Generate.ahk
return
Passwords:
	run, %A_MyDocuments%\Security\Passwords\pswds.kdbx
return

;;------------------------;;
;;----Clipboard Count:----;;
;;------------------------;;
count:
	len:=StrLen(Clipboard)
	Spaces:=""
	newline:=""
	chars:=""
	Tabs:=""
	
	Loop, Parse, Clipboard, `n, `r
		newline++
	Loop, Parse, Clipboard
	{
		If A_loopField=%A_Space%
			Spaces++
		If A_loopField=%A_Tab%
			tabs++
	}

	If (tabs=="")
		tabs:=0
	If (Spaces=="")
		Spaces:=0

	chars:= len-Spaces-tabs

	msgbox,4160, Mango,
	(
Length: %len%
Spaces: %spaces%
Tabs: %Tabs%
Characters: %chars%
Lines: %newline%
	)
Return


;;--------------;;
;;----Tools:----;;
;;--------------;;

; ----- Tools -----
save:
	Name:=text := RegExReplace(SubStr(Clipboard, 1, 24), "[=:;&&\,\@""\'\.!#+^\(\){}*\n]", " ")
	Name := RegExReplace(Name, "m)(^[ \t]+)", "") ; Remove leading blanks. if any.
	Name := RegExReplace(Name, "m)([ \t]+$)","") ".txt" ; Remove trailing blanks. if any.
	Fileappend, %Clipboard%`n, %A_scriptdir%\%Name%
	msg= Clipboard saved to: `n%name%
	Toast("savepopupClick", msg, "Clipboard Saved, Click to open.", 0, "Center", "ff4400", 8)
Return

addmode:
	am:=!am
	menu, tools, ToggleCheck, Toggle: Add Text to Clipboard

	If (am==1)
	{
		Hotkey, $^C, addtoclip, on
		clipboard:=
	}
	Else
		Hotkey, $^C, addtoclip, off

Return

addtoclip:
	cliptxt:=Clipboard
	sendinput {ctrl down}c{ctrl up}
	clipwait
	cliptxt.= "`n" clipboard
	Clipboard:=cliptxt
Return


; ----- Case -----
ucase:
	StringUpper, Clipboard, Clipboard
Return
lcase:
	StringLower, Clipboard, Clipboard
Return
scase:
	Clipboard := RegExReplace(Clipboard, "([.?\s!]\s\w)|^(\.\s\b\w)|^(.)", "$U0")
Return
tcase:
	StringUpper, Clipboard, Clipboard, T
Return
icase:
	; Thanks JDN
	Lab_Invert_Char_Out:= ""
	Loop % Strlen(Clipboard) { ;%
		Lab_Invert_Char:= Substr(Clipboard, A_Index, 1)
		If Lab_Invert_Char is Upper
			Lab_Invert_Char_Out:= Lab_Invert_Char_Out Chr(Asc(Lab_Invert_Char) + 32)
		Else If Lab_Invert_Char is Lower
			Lab_Invert_Char_Out:= Lab_Invert_Char_Out Chr(Asc(Lab_Invert_Char) - 32)
		Else
			Lab_Invert_Char_Out:= Lab_Invert_Char_Out Lab_Invert_Char
	}
	Clipboard:=Lab_Invert_Char_Out
Return


; ----- Organization -----
sortaz:
	sort, Clipboard,
Return
sortza:
	sort, Clipboard,  R
Return
sortrand:
	sort, Clipboard,  Random
Return
remdbls:
	sort, Clipboard, U
Return
flip:
	Clipboard:=Flip(Clipboard)
return
StoT:
	StringReplace, Clipboard, Clipboard, %A_Space%, %A_Tab%, All
Return
TtoS:
	StringReplace, Clipboard, Clipboard, %A_Tab%, %A_Space%, All
Return
leading:
	Clipboard := RegExReplace(Clipboard, "m)(^[ \t]+)", "")
Return
trailing:
	Clipboard := RegExReplace(Clipboard, "m)([ \t]+$)","")
Return
doublelines:
	Loop
	{
		StringReplace, Clipboard, Clipboard, `r`n`r`n, `r`n, UseErrorLevel
		If ErrorLevel = 0  ; No more replacements needed.
			break
	}
Return

; ----- System -----
force:
	Process, Close, %pid%
Return
window:
	WinGetTitle, Clipboard , ahk_pid %pid%
Return

; ----- Misc -----
google:
	Run, http://www.google.com/search?source=ig&hl=en&rlz=&q=%Clipboard%&btnG=Google+Search&aq=f
Return
googleimage:
	Run, http://images.google.com/images?um=1&hl=en&newwindow=1&safe=off&client=opera&rls=en&q=%Clipboard%&btnG=Search+Images
Return
runcode:
	FileDelete %A_ScriptDir%\temp.ahk
	FileAppend , #SingleInstance force`n`n%Clipboard%`n`n`n`n ~esc::ExitApp, %A_ScriptDir%\temp.ahk
	Run   %A_ScriptDir%\temp.ahk
	Sleep 5000
Return

; ----- Plugins -----
plugins:
	Run, %A_Scriptdir%\Plugins\%A_Thismenuitem%
Return

savepopupclick:
	run, `"%A_scriptdir%\%name%`"
Return

restartMango:
	reload
return

exitscript:
	ExitApp
Return



;;---------------------;;
;; ---- Functions ---- ;;
;;---------------------;;
Flip(in) {  ; Thanks Lexikos
		VarSetCapacity(out, n:=StrLen(in))
		Loop %n%
			out .= SubStr(in, n--, 1)
		return out
	}

;;---------------------;;
;;----TOASTER POPUP----;;
;;---------------------;;
Toast(goto="", text="", title="", pos=1, align="Left", color="Default", size=11, font="Arial", life=5000, time=10)
	{
		;popup UI
		Gui, 99: Destroy
		Gui, 99: +Owner -SysMenu
		Gui, 99: font, s%size% w600 c%Color%, %font%
		Gui, 99: Add, text, x2  +%align% w222 g%Goto% , %text%
		Gui, 99: Show,x%A_ScreenWidth% y%A_ScreenHeight%, %title%
		Gosub, popup
		Return

popup:
	WinGetPos, , , Width, Height, %title%
	hy:=A_ScreenHeight-22


	If (pos=0)
		wx=0
	If (pos=1)
		wx=% A_ScreenWidth-Width

	SetTimer, life, %life%

	Loop, %time%
	{
		hy-=Height/time
		WinMove, %title%,, %wx%, %hy%
	}
Return

life:
	Gui, 99: Destroy
Return
}

;;------------------;;
;; ---- To Hex ---- ;;
;;------------------;;
_Hex(S) { ; thanks Laszlo! http://www.autohotkey.com/forum/viewtopic.php?p=199220#199220
  Return S="" ? "":Chr((*&S>>4)+48) Chr((x:=*&S&15)+48+(x>9)*7) _Hex(SubStr(S,2)) 
}

;;--------------------;;
;; ---- To Ascii ---- ;;
;;--------------------;;
_Asc(hex) { ; thanks [VxE]! http://www.autohotkey.com/forum/viewtopic.php?p=336913#336913
   VarSetCapacity( string, StrLen( hex ) // 2, 0 ) 
   Loop, Parse, hex 
      If ( A_Index & 1 ) ; if this is an ODD-numbered loop iteration 
         nibble := InStr( "123456789abcdef", A_LoopField ) 
      Else If ( A_LoopField != "x" ) 
         string .= Chr( InStr( "123456789abcdef", A_LoopField ) | nibble << 4 ) 
   Return string 
}

;;----------------------;;
;; ---- Clean HTML ---- ;;
;;----------------------;;
ConvertEntities(HTML) ; thanks Uberi!
{
 static EntityList := "|quot=34|apos=39|amp=38|lt=60|gt=62|nbsp=160|iexcl=161|cent=162|pound=163|curren=164|yen=165|brvbar=166|sect=167|uml=168|copy=169|ordf=170|laquo=171|not=172|shy=173|reg=174|macr=175|deg=176|plusmn=177|sup2=178|sup3=179|acute=180|micro=181|para=182|middot=183|cedil=184|sup1=185|ordm=186|raquo=187|frac14=188|frac12=189|frac34=190|iquest=191|Agrave=192|Aacute=193|Acirc=194|Atilde=195|Auml=196|Aring=197|AElig=198|Ccedil=199|Egrave=200|Eacute=201|Ecirc=202|Euml=203|Igrave=204|Iacute=205|Icirc=206|Iuml=207|ETH=208|Ntilde=209|Ograve=210|Oacute=211|Ocirc=212|Otilde=213|Ouml=214|times=215|Oslash=216|Ugrave=217|Uacute=218|Ucirc=219|Uuml=220|Yacute=221|THORN=222|szlig=223|agrave=224|aacute=225|acirc=226|atilde=227|auml=228|aring=229|aelig=230|ccedil=231|egrave=232|eacute=233|ecirc=234|euml=235|igrave=236|iacute=237|icirc=238|iuml=239|eth=240|ntilde=241|ograve=242|oacute=243|ocirc=244|otilde=245|ouml=246|divide=247|oslash=248|ugrave=249|uacute=250|ucirc=251|uuml=252|yacute=253|thorn=254|yuml=255|OElig=338|oelig=339|Scaron=352|scaron=353|Yuml=376|circ=710|tilde=732|ensp=8194|emsp=8195|thinsp=8201|zwnj=8204|zwj=8205|lrm=8206|rlm=8207|ndash=8211|mdash=8212|lsquo=8216|rsquo=8217|sbquo=8218|ldquo=8220|rdquo=8221|bdquo=8222|dagger=8224|Dagger=8225|hellip=8230|permil=8240|lsaquo=8249|rsaquo=8250|euro=8364|trade=8482|"
 FoundPos = 1
 While, (FoundPos := InStr(HTML,"&",False,FoundPos))
 {
  FoundPos ++, Entity := SubStr(HTML,FoundPos,InStr(HTML,"`;",False,FoundPos) - FoundPos), (SubStr(Entity,1,1) = "#") ? (EntityCode := SubStr(Entity,2)) : (Temp1 := InStr(EntityList,"|" . Entity . "=") + StrLen(Entity) + 2, EntityCode := SubStr(EntityList,Temp1,InStr(EntityList,"|",False,Temp1) - Temp1))
  StringReplace, HTML, HTML, &%Entity%`;, % Chr(EntityCode), All
 }
 Return, HTML
}

; thanks SKAN! http://www.autohotkey.com/forum/viewtopic.php?t=51342&highlight=remove+html
UnHTM( HTM ) {   ; Remove HTML formatting / Convert to ordinary text   by SKAN 19-Nov-2009
 Static HT,C=";" ; Forum Topic: www.autohotkey.com/forum/topic51342.html  Mod: 16-Sep-2010
 IfEqual,HT,,   SetEnv,HT, % "&aacuteá&acircâ&acute´&aeligæ&agraveà&amp&aringå&atildeã&au"
 . "mlä&bdquo„&brvbar¦&bull•&ccedilç&cedil¸&cent¢&circˆ&copy©&curren¤&dagger†&dagger‡&deg"
 . "°&divide÷&eacuteé&ecircê&egraveè&ethð&eumlë&euro€&fnofƒ&frac12½&frac14¼&frac34¾&gt>&h"
 . "ellip…&iacuteí&icircî&iexcl¡&igraveì&iquest¿&iumlï&laquo«&ldquo“&lsaquo‹&lsquo‘&lt<&m"
 . "acr¯&mdash—&microµ&middot·&nbsp &ndash–&not¬&ntildeñ&oacuteó&ocircô&oeligœ&ograveò&or"
 . "dfª&ordmº&oslashø&otildeõ&oumlö&para¶&permil‰&plusmn±&pound£&quot""&raquo»&rdquo”&reg"
 . "®&rsaquo›&rsquo’&sbquo‚&scaronš&sect§&shy &sup1¹&sup2²&sup3³&szligß&thornþ&tilde˜&tim"
 . "es×&trade™&uacuteú&ucircû&ugraveù&uml¨&uumlü&yacuteý&yen¥&yumlÿ"
 $ := RegExReplace( HTM,"<[^>]+>" )               ; Remove all tags between  "<" and ">"
 Loop, Parse, $, &`;                              ; Create a list of special characters
   L := "&" A_LoopField C, R .= (!(A_Index&1)) ? ( (!InStr(R,L,1)) ? L:"" ) : ""
 StringTrimRight, R, R, 1
 Loop, Parse, R , %C%                               ; Parse Special Characters
  If F := InStr( HT, L := A_LoopField )             ; Lookup HT Data
    StringReplace, $,$, %L%%C%, % SubStr( HT,F+StrLen(L), 1 ), All
  Else If ( SubStr( L,2,1)="#" )
    StringReplace, $, $, %L%%C%, % Chr(((SubStr(L,3,1)="x") ? "0" : "" ) SubStr(L,3)), All
Return RegExReplace( $, "(^\s*|\s*$)")            ; Remove leading/trailing white spaces
}
;;---------------------

Lwin & End::
winget, pid, PID, A
Process, Close, %pid%
Return

XButton2::MButton

~esc::
27GuiClose:
Gui, 27:hide
Return

