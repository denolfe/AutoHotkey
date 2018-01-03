#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#InstallKeybdHook
#UseHook, On
#WinActivateForce
#SingleInstance force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode, RegEx
DetectHiddenWindows, On
SetCapsLockState, AlwaysOff

RunIfExist(A_ScriptDir "\Utilities\VolumeScroll\VolumeScroll.ahk")
RunIfExist(A_ScriptDir "\Core\AutoCorrect.ahk")
Run, %A_ScriptDir%\Utilities\WindowPadX\WindowPadX.ahk %A_ScriptDir%\WindowPadX.Custom.ini

IfWinNotExist, ahk_exe clipx.exe
	RunProgFiles("ClipX\clipx.exe")

Notify(A_ScriptName . " Started!","",-3,"Style=Win10")

Editor := "C:\Program Files (x86)\Microsoft VS Code\Code.exe"
UserDir := "C:\Users\" A_UserName

Menu, Tray, Icon, lib\images\Portal.ico
Menu, Tray, Tip, Home Script
SetTimer, IntroSound, -1
SetTimer, IntroLights, -1000

; Disable Aero
Run, %comspec% /c "net stop uxsms",,Hide

TaskBar_SetAttr(2)

SplitPath, A_ScriptName, , , , OutNameNoExt
LinkFile := A_Startup "\" OutNameNoExt ".lnk"
IfNotExist, %LinkFile%
{
	FileCreateShortcut, %A_ScriptFullPath%, %LinkFile%
	Notify("Startup Shortcut Created.","",-3,"Style=Alert")
}
Return

IntroSound:
	SoundPlay, lib\sounds\load.wav
	Return

IntroLights:
	kbdIndex := 1
	Loop, 4 ; flash all LEDs
	 {
	 KeyboardLED(4,"on", kbdIndex)
	 Sleep, 75
	 KeyboardLED(4,"off", kbdIndex)
	 Sleep, 75
	 }
	KeyboardLED(0,"off", kbdIndex)
	Return

^!s::
	RunProgFiles("Everything\Everything.exe")
	WinActivate
	WinMove, ahk_class EVERYTHING,, 1920,735,1280,705
	Return

; Rearrange windows
^!0::
	WinMove, Friends,, 4723,-307,269,1698
	WinMove, - Discord,, 1920,-307,1536,1698
	Return

; Toggle Audio Device
^!Ins::
	AudioIniFile := "AudioDevices.ini"
	IfNotExist, %AudioIniFile%
	FileAppend, [AudioDevices], %AudioIniFile%
	IniRead, DefaultDevice, AudioDevices.ini, AudioDevices, DefaultDevice
	If (DefaultDevice != "G933")
	{
		NewDevice := "G933"
		IniWrite, "G933", AudioDevices.ini, AudioDevices, DefaultDevice
	}
	Else 
	{
		NewDevice := "YU3"
		IniWrite, "YU3", AudioDevices.ini, AudioDevices, DefaultDevice
	}
	Run, Utilities\nircmd.exe setdefaultsounddevice %NewDevice%
	Notify("New Audio Device:" NewDevice,"",-1,"Style=Win10")
	Return

#c::Run, C:\
#p::Run, C:\Program Files (x86)\

:*:src;::source /c/Dropbox/cmder/config/.bashrc

:*:pd;::
	SendInput, playdemo picks\%clipboard%{Enter}
	Return

#l::
	Run,%A_WinDir%\System32\rundll32.exe user32.dll`,LockWorkStation
	Sleep 1000
	SendMessage, 0x112, 0xF170, 2,, Program Manager
	Return

Spotify:
	WinGetClass, this_class, A
	If (RegExMatch(this_class, "Spotify")) ; Toggle
		WinMinimize, ahk_class SpotifyMainWindow
	Else
	{
		If WinExist("ahk_class SpotifyMainWindow")
			WinActivate, % "ahk_class SpotifyMainWindow"
		else
		{
        	Run, %  A_Appdata . "\Spotify\spotify.exe", UseErrorLevel
            If ErrorLevel
            {
                Notify("File not found", title,-3,"Style=Win10")
                Return
            }
            WinActivate
		}
	}
	Return

RCtrl & Del::Show_Start("- Google Chrome", "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe")
CapsLock & SC027::
RCtrl & End::Show_Start("Cmder", "../cmder/cmder.exe")
RCtrl & PgDn::Show_Start("- Visual Studio Code", "C:\Program Files (x86)\Microsoft VS Code\Code.exe")
RCtrl & PgUp::Show_Start(" - Discord", UserDir "\AppData\Local\Discord\app-0.0.299\Discord.exe")
; RCtrl & 5::Return
; RCtrl & 6::Return
; RCtrl & 7::Return
; RCtrl & 8::Return
; RCtrl & 9::Return

RCtrl & Enter::Gosub, Spotify

RCtrl & ]::SendInput, {Media_Play_Pause}
RCtrl & |::SendInput, {Media_Next}

^!Enter::
	loop
	{
		WinClose, ahk_class CabinetWClass
		IfWinNotExist, ahk_class CabinetWClass
			break
	}
	WinClose ahk_class EVERYTHING
	Notify("Windows Purged","",-2,"GC=555555 TC=White MC=White")
	Return

~*LWin::
	Sleep, 200
	TaskBar_SetAttr(2)
	Return

;; Hotstrings

:*:ttv;::http://www.twitch.tv/fathom_
:*:vst;::http://vacstat.us, add me!

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; Folder Shortcuts ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; !1:: Show_Dir("C:\Dropbox")
; !2:: Show_Dir("C:\Dropbox\HomeShare")
!3:: Show_Dir("D:\Downloads\")
; !4::
!7:: Show_Dir("C:\Program Files (x86)\Steam\SteamApps\common\Team Fortress 2\tf")
!0:: Show_Dir(A_ScriptDir)

^!r::	Reload
^!e::	Edit(A_ScriptName, Editor)
^!t::	Edit("test.ahk", Editor)
!t:: Run %A_ScriptDir%\test.ahk
^!x::AHKPanic(1,0,0,1)

#Include %A_ScriptDir%\Core\AppSpecific.ahk
#Include %A_ScriptDir%\Core\Functions.ahk
#Include %A_ScriptDir%\Core\HotStrings.ahk
#Include %A_ScriptDir%\Core\CapsNav.ahk
#Include %A_ScriptDir%\Core\Keypad.ahk
#Include %A_ScriptDir%\Core\WinControl.ahk
#Include lib\VA.ahk
#Include lib\Notify.ahk
#Include lib\LedControl.ahk
#Include lib\TaskBar_SetAttr.ahk
