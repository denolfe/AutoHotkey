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

Menu, Tray, Tip, Work Script

If (FileExist(A_ScriptDir "\lib\images\testing.ico")) 
	Menu, Tray, Icon, % A_ScriptDir "\lib\images\testing.ico"

; Globals
SysGet, MonitorCount, MonitorCount
SysGet, MonitorWorkArea, MonitorWorkArea
EnvGet, Domain, USERDOMAIN
Editor := "C:\Program Files\Sublime Text 3\sublime_text.exe"
kbdIndex := 3

total := 0
IncludedFiles := "AppSpecific.ahk|Shortcuts.ahk|Hotstrings.ahk|Work.ahk|Functions.ahk"
Loop, Parse, IncludedFiles, |
	total += TF_CountLines(A_LoopField)
Loop, AppSpecific\*.ahk
	total += TF_CountLines(A_LoopFileFullPath)
Notify(A_ScriptName " Started!",total " lines executed",-3,"Style=Win10")

SetTimer, IntroSound, -1
SetTimer, IntroLights, -1

If ! A_IsAdmin
{
	MsgBox, 0x34,%A_ScriptName%,  Missing Admin Privileges!`n`nWould you like to continue?
	IfMsgBox No
	{
		SplitPath, A_AhkPath,, A_AhkDir
		Run % A_AhkDir	
		ExitApp
	}
	SplitPath, A_AhkPath,, A_AhkDir
	Run % A_AhkDir
}

RunIfExist(A_ScriptDir "\VolumeScroll\VolumeScroll.ahk")
RunIfExist(A_ScriptDir "\AutoCorrect.ahk")
RunIfExist(A_ScriptDir "\WindowPadX\WindowPadX.ahk")

IfWinNotExist, ahk_exe clipx.exe
	RunProgFiles("ClipX\clipx.exe")

if FileExist(A_ScriptDir "\WindowPadX\WindowPadX-work.ini")
{
	FileCopy, %A_ScriptDir%\WindowPadX\WindowPadX-work.ini, %A_ScriptDir%\WindowPadX\WindowPadX.ini, 1
	Run %A_ScriptDir%\WindowPadX\WindowPadX.ahk
}

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
		Sleep, 100
		KeyboardLED(4,"switch", kbdIndex)
		Sleep, 100
		KeyboardLED(1,"switch", kbdIndex)
		Sleep, 100
		KeyboardLED(4,"switch", kbdIndex)
		Sleep, 100
	}
	KeyboardLED(0,"off", kbdIndex)
	Return

#Include %A_ScriptDir%\Functions.ahk
#Include %A_ScriptDir%\Shortcuts.ahk
#Include %A_ScriptDir%\AppSpecific.ahk
#Include %A_ScriptDir%\Hotstrings.ahk

#Include *i %A_ScriptDir%\CapsNav.ahk
#Include *i %A_ScriptDir%\Utilities\FormatAHK.ahk
#Include *i %A_ScriptDir%\TSQLKeywords.ahk
#Include *i %A_ScriptDir%\WinControl.ahk

^!r::	Reload
^!e::	Edit(A_ScriptName, Editor)
^!t::	Edit("test.ahk", Editor)
^!h::	Edit("Hotstrings.ahk", Editor)
^!a::	Edit("AppSpecific.ahk", Editor)
^!m::	Edit("Functions.ahk", Editor)
!t::	Run, Test.ahk

^NumpadEnter::Edit("Shortcuts.ahk", Editor)

+Pause::Suspend

^!x::AHKPanic(1,0,0,1)

#Include %A_ScriptDir%\lib\VA.ahk
#Include %A_ScriptDir%\lib\TF.ahk
#Include %A_ScriptDir%\lib\Notify.ahk
#Include %A_ScriptDir%\lib\Explorer.ahk
#Include %A_ScriptDir%\lib\Ledcontrol.ahk
