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

RunIfExist(A_ScriptDir "\VolumeScroll\VolumeScroll.ahk")
RunIfExist(A_ScriptDir "\AutoCorrect.ahk")

FileCopy, %A_ScriptDir%\WindowPadX\WindowPadX-home.ini, %A_ScriptDir%\WindowPadX\WindowPadX.ini, 1
RunIfExist(A_ScriptDir "\AutoCorrect.ahk")

IfWinNotExist, ahk_exe clipx.exe
	RunProgFiles("ClipX\clipx.exe")

Notify(A_ScriptName . " Started!","",-3,"Style=Win10")

Editor := "C:\Program Files\Sublime Text 3\sublime_text.exe"

Menu, Tray, Icon, lib\images\Portal.ico
Menu, Tray, Tip, Home Script
SetTimer, IntroSound, -1
SetTimer, IntroLights, -1000

; Disable Aero
Run, %comspec% /c "net stop uxsms",,Hide

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
	; IfWinNotExist Everything
	; {
		
		Run C:\Program Files (x86)\Everything\Everything.exe
		WinActivate
	; }
	; Else
	; 	WinActivate, ahk_class EVERYTHING
	WinMove, ahk_class EVERYTHING,, 0,A_ScreenHeight*0.66,A_ScreenWidth,A_ScreenHeight - (A_ScreenHeight*0.66)
	Return

#c::Run, C:\
#p::Run, C:\Program Files (x86)\

:*:src;::source /c/Dropbox/HomeShare/cmder/config/.bashrc

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

RCtrl & 1::ShowStart("ahk_class Chrome_WidgetWin_1", "chrome.exe")
CapsLock & SC027::
RCtrl & 2::ShowStart("Cmder", "../cmder/cmder.exe")
RCtrl & 3::ShowStart("ahk_class PX_WINDOW_CLASS", Editor)
RCtrl & 4::ShowStart("- WebStorm", "C:\Program Files (x86)\JetBrains\WebStorm 10.0.1\bin\WebStorm.exe")
RCtrl & 5::ShowDir("C:\Dropbox\HomeShare")
RCtrl & 6::ShowDir("D:\Downloads")
RCtrl & 7::ShowDir("C:\Program Files (x86)\Steam\SteamApps\common\Team Fortress 2\tf")
RCtrl & 8::Return
RCtrl & 9::Return

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

;; Hotstrings

:*:ttv;::http://www.twitch.tv/fathom_
:*:vst;::http://vacstat.us, add me!

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; Folder Shortcuts ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


!1:: ShowDir("C:\Dropbox")
!2:: ShowDir("C:\Dropbox\HomeShare")
!3:: ShowDir("D:\Downloads\")
; !4:: 
!7:: ShowDir("C:\Program Files (x86)\Steam\SteamApps\common\Team Fortress 2\tf")
!0:: ShowDir(A_ScriptDir)

^!r::	Reload
^!e::	Edit(A_ScriptName, Editor)
^!t::	Edit("test.ahk", Editor)
!t:: Run %A_ScriptDir%\test.ahk
^!x::AHKPanic(1,0,0,1)

#IfWinActive, ahk_class Valve001
	#Up::ControlSend, ahk_parent, ^{Up}, ahk_class SpotifyMainWindow
	#Down::ControlSend, ahk_parent, ^{Down}, ahk_class SpotifyMainWindow
	#Left::Send {Media_Play_Pause} ;ControlSend, ahk_parent, ^{Space}, ahk_class SpotifyMainWindow
	#Right::Send {Media_Next} ;ControlSend, ahk_parent, ^{Right}, ahk_class SpotifyMainWindow
#IfWinActive

#Include %A_ScriptDir%\AppSpecific.ahk

#Include Functions.ahk
#Include HotStrings.ahk
#Include CapsNav.ahk
#Include WinControl.ahk
#Include lib\VA.ahk
#Include lib\Notify.ahk
#Include lib\LedControl.ahk
