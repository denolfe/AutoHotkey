#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#WinActivateForce
#SingleInstance force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode, RegEx
SetNumlockState, AlwaysOn
SetCapsLockState, AlwaysOff
CoordMode, Mouse, Screen

If FileExist("lib\images\eve.ico")
	Menu, Tray, Icon, lib\images\eve.ico

Menu, Tray, Tip, Work Script

;Menu, Tray, Add, GetLatest, GetLatest


SysGet, MonitorCount, MonitorCount
SysGet, MonitorWorkArea, MonitorWorkArea

SetNumlockState, AlwaysOn

total := 0
IncludedFiles = AppSpecific.ahk|Shortcuts.ahk|SalesPad.ahk|Hotstrings.ahk|Work.ahk|MyMethods.ahk|VolumeControl.A_AhkPath
Loop, Parse, IncludedFiles, |
	total += TF_CountLines(A_LoopField)

Notify(A_ScriptName . " Started!",total . " lines executed",-3,"Style=Mine")

global Editor = "C:\Program Files\Sublime Text 2\sublime_text.exe"

;; Debug
global DebugMsgBox_ShowMessages = false
If DebugMsgBox_ShowMessages
	Notify("Debugging Enabled","",-3,"Style=Alert")
;DebugMsgBox("Debugging Enabled.")

If ! A_IsAdmin
	MsgBox, 0x34,%A_ScriptName%,  Missing Admin Privileges!`n`nWould you like to continue?
	IfMsgBox No
		ExitApp

If A_ComputerName = ELLIOT-PC
{

	Run %A_ScriptDir%\VolumeControl.ahk
	Run %A_ScriptDir%\AutoCorrect.ahk

	+Pause::Suspend

	If ! WinExist("Test Configuration")
	{
		Run %A_ScriptDir%\ConfigTests.ahk
		WinWait, Test Configuration
		WinMinimize, Test Configuration
	}
}

#Include %A_ScriptDir%\MyMethods.ahk
#Include %A_ScriptDir%\Shortcuts.ahk


#Include %A_ScriptDir%\AppSpecific.ahk
#Include %A_ScriptDir%\Hotstrings.ahk
#Include *i %A_ScriptDir%\SalesPad.ahk


^!r::Reload
^!e::Run %editor% %A_ScriptName%
^!t::Run %editor% test.ahk	
^!d::
^NumpadEnter::Run %editor% Shortcuts.ahk
^!h::Run %editor% Hotstrings.ahk
^!a::Run %editor% AppSpecific.ahk
!t::Run C:\Users\elliotd\Dropbox\HomeShare\test.ahk

^!x::AHKPanic(1,0,0,1)

;GetLatest:
	;Run, buildprompt.ahk
;return


#Include %A_ScriptDir%\lib\VA.ahk
#Include %A_ScriptDir%\lib\TF.ahk
#Include %A_ScriptDir%\lib\Notify.ahk
#Include %A_ScriptDir%\lib\Explorer.ahk