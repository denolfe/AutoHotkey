#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#WinActivateForce
#SingleInstance force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

SetTitleMatchMode, RegEx
SetNumlockState, AlwaysOn
SetCapsLockState, AlwaysOff
CoordMode, Mouse, Screen
DetectHiddenWindows, On
SetScrollLockState, Off

If FileExist("lib\images\eve.ico")
	Menu, Tray, Icon, lib\images\eve.ico

Menu, Tray, Tip, Work Script

SysGet, MonitorCount, MonitorCount
SysGet, MonitorWorkArea, MonitorWorkArea

total := 0
IncludedFiles := "AppSpecific.ahk|Shortcuts.ahk|Hotstrings.ahk|Work.ahk|MyMethods.ahk"
Loop, Parse, IncludedFiles, |
	total += TF_CountLines(A_LoopField)
Notify(A_ScriptName " Started!",total " lines executed",-3,"Style=Mine")

Editor := "..\SublimePortable\sublime_text.exe"
kbdIndex = 0

SetTimer, IntroSound, -1
SetTimer, IntroLights, -1

If ! A_IsAdmin
	MsgBox, 0x34,%A_ScriptName%,  Missing Admin Privileges!`n`nWould you like to continue?
	IfMsgBox No
		ExitApp

Run %A_ScriptDir%\VolumeScroll\VolumeScroll.ahk
Run %A_ScriptDir%\AutoCorrect.ahk
Run %A_ScriptDir%\WindowPadX\WindowPadX.ahk

SplitPath, A_ScriptName, , , , OutNameNoExt 
LinkFile := A_Startup "\" OutNameNoExt ".lnk"
IfNotExist, %LinkFile%
{
	FileCreateShortcut, %A_ScriptFullPath%, %LinkFile%
	Notify("Startup Shortcut Created.","",-3,"Style=Alert")
}
Return ;End Auto-Execute

IntroSound:
	SoundPlay, lib\sounds\signon.wav
	Return

IntroLights:
	Loop, 2 ; Knight Rider KITT cycling all LEDs ;-)
	{
		KeyboardLED(2,"switch", kbdIndex)
		Sleep, 75
		KeyboardLED(4,"switch", kbdIndex)
		Sleep, 75
		KeyboardLED(1,"switch", kbdIndex)
		Sleep, 75
		KeyboardLED(4,"switch", kbdIndex)
		Sleep, 75
	}
	KeyboardLED(0,"off", kbdIndex)
	Return

#Include %A_ScriptDir%\MyMethods.ahk
#Include %A_ScriptDir%\Shortcuts.ahk
#Include %A_ScriptDir%\WinControl.ahk
#Include %A_ScriptDir%\AppSpecific.ahk
#Include %A_ScriptDir%\Hotstrings.ahk
#Include %A_ScriptDir%\CapsNav.ahk
#Include %A_ScriptDir%\Utilities\FormatAHK.ahk
#Include %A_ScriptDir%\TSQLKeywords.ahk

^!r::	Reload
^!e::	SublimeOpen(A_ScriptName, Editor)
^!t::	SublimeOpen("test.ahk", Editor)
^!h::	SublimeOpen("Hotstrings.ahk", Editor)
^!a::	SublimeOpen("AppSpecific.ahk", Editor)
^!m::	SublimeOpen("MyMethods.ahk", Editor)
!t::	Run, Test.ahk

^NumpadEnter::SublimeOpen("Shortcuts.ahk", Editor)

+Pause::Suspend

^!x::AHKPanic(1,0,0,1)

#Include %A_ScriptDir%\lib\VA.ahk
#Include %A_ScriptDir%\lib\TF.ahk
#Include %A_ScriptDir%\lib\Notify.ahk
#Include %A_ScriptDir%\lib\Explorer.ahk
#Include %A_ScriptDir%\lib\Ledcontrol.ahk