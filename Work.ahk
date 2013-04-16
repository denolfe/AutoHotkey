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

If FileExist("lib\images\eve.ico")
	Menu, Tray, Icon, lib\images\eve.ico

Menu, Tray, Tip, Work Script

SysGet, MonitorCount, MonitorCount
SysGet, MonitorWorkArea, MonitorWorkArea

total := 0
IncludedFiles := "AppSpecific.ahk|Shortcuts.ahk|SalesPad.ahk|Hotstrings.ahk|Work.ahk|MyMethods.ahk|VolumeControl.ahk"
Loop, Parse, IncludedFiles, |
	total += TF_CountLines(A_LoopField)
Notify(A_ScriptName " Started!",total " lines executed",-3,"Style=Mine")

global Editor = "C:\Users\elliotd\Dropbox\HomeShare\Sublime-Portable\sublime_text.exe"

If ! A_IsAdmin
	MsgBox, 0x34,%A_ScriptName%,  Missing Admin Privileges!`n`nWould you like to continue?
	IfMsgBox No
		ExitApp

If A_ComputerName = ELLIOT-PC
{
	Run %A_ScriptDir%\VolumeControl.ahk
	Run %A_ScriptDir%\AutoCorrect.ahk

	IfWinNotExist, Test Configuration
	{
		Run %A_ScriptDir%\ConfigTests.ahk
		WinWait, Test Configuration
		WinMinimize, Test Configuration
	}
	
	+Pause::Suspend
}

#Include %A_ScriptDir%\MyMethods.ahk
#Include %A_ScriptDir%\Shortcuts.ahk
#Include %A_ScriptDir%\WinControl.ahk
#Include %A_ScriptDir%\AppSpecific.ahk
#Include %A_ScriptDir%\Hotstrings.ahk
#Include *i %A_ScriptDir%\SalesPad.ahk


^!r::Reload
^!e::Run %Editor% %A_ScriptName%
^!t::Run %Editor% test.ahk	
^!d::
^NumpadEnter::Run %Editor% Shortcuts.ahk
^!h::Run %Editor% Hotstrings.ahk
^!a::Run %Editor% AppSpecific.ahk
!t::Run Test.ahk

^!x::AHKPanic(1,0,0,1)

#Include %A_ScriptDir%\lib\VA.ahk
#Include %A_ScriptDir%\lib\TF.ahk
#Include %A_ScriptDir%\lib\Notify.ahk
#Include %A_ScriptDir%\lib\Explorer.ahk