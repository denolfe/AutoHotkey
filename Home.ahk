#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#WinActivateForce
#SingleInstance force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode, RegEx
;SetNumlockState, AlwaysOn
DetectHiddenWindows, On 
;KeyboardLED(2,"off")
SetCapsLockState, AlwaysOff

Run AutoCorrect.ahk
Run VolumeControl.ahk

total := 0
IncludedFiles := "Home.ahk|MyMethods.ahk|AppSpecific.ahk|VolumeControl.ahk"
Loop, Parse, IncludedFiles, |
	total += TF_CountLines(A_LoopField)
Notify(A_ScriptName . " Started!",total . " lines executed",-3,"Style=Mine")

global Editor := "D:\Dropbox\HomeShare\SublimePortable\sublime_text.exe"

Menu, Tray, Icon, lib\images\Portal.ico
Menu, Tray, Tip, Home Script
SoundPlay, lib\sounds\load.wav

^!s::
	IfWinNotExist Everything
	{
		Run C:\Program Files (x86)\Everything\Everything.exe
		WinActivate
	}
	Else
	{
		WinActivate ahk_class EVERYTHING
		WinWaitActive ahk_class EVERYTHING
	}
	WinWaitActive ahk_class EVERYTHING
	WinMove, ahk_class EVERYTHING,, A_ScreenWidth,432,A_ScreenWidth/1.45,A_ScreenHeight - 432
	WinWaitNotActive
	WinMove, ahk_class EVERYTHING,, A_ScreenWidth, 716, A_ScreenWidth/1.45, A_ScreenHeight - 716

Return

#c::Run, C:\
#p::Run, C:\Program Files (x86)\

#l::
	Run,%A_WinDir%\System32\rundll32.exe user32.dll`,LockWorkStation
	Sleep 1000
	SendMessage, 0x112, 0xF170, 2,, Program Manager
	Return

ScrollLock:: ;ShowStart("Spotify", A_Appdata . "\Spotify\spotify.exe", 1)
	WinGetClass, this_class, A
	If (RegExMatch(this_class, "Spotify")) ; Toggle
		WinMinimize, ahk_class SpotifyMainWindow
	Else
	{
		If WinExist("Spotify")
			WinActivate, % "Spotify"
		else
		{
        	Run, %  A_Appdata . "\Spotify\spotify.exe", UseErrorLevel
            If ErrorLevel
            {
                Notify("File not found", title,-3,"Style=Mine")
                Return
            }
            WinActivate
		}
	}
Return

;; CapsLock Shortcuts

CapsLock:: 
	Caps := 1
	SetNumLockState, On
	Return
CapsLock Up:: 
	Caps := 0
	SetNumLockState, Off
	Return
+CapsLock::CapsLock

#If Caps
	NumpadDot::ShowStart("ahk_class Chrome_WidgetWin_1", "chrome.exe")
	Numpad0::Return
	Numpad1::Return
	Numpad2::Return
	Numpad3::ShowStart("ahk_class PX_WINDOW_CLASS", Editor)
	Numpad4::ShowStart("ahk_class Framework::CFrame", "C:\Program Files\Microsoft Office 15\root\office15\onenote.exe?")	
	Numpad5::Return
	Numpad6::Return
	Numpad7::ShowStart("Inbox", "chrome.exe www.gmail.com")
	Numpad8::ShowStart("Google Calendar", "chrome.exe calendar.google.com")
	Numpad9::Return

	;;;;; CapsNav ;;;;;;;

	h::CapsNav("Left")
	j::CapsNav("Down")
	k::CapsNav("Up")
	l::CapsNav("Right")

	n::CapsNav("Home")
	p::CapsNav("End")

	o::
	.::CapsNav("Right", "!")
	m::CapsNav("Left", "!")

	u::
	`;::
	,::
	i::
	Return
#If

#NumpadEnter::
	loop
	{
		WinClose, ahk_class CabinetWClass
		IfWinNotExist, ahk_class CabinetWClass
			break
	}
	WinClose ahk_class EVERYTHING
	Notify("Windows Purged","",-2,"GC=555555 TC=White MC=White")
	Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; Folder Shortcuts ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


!Numpad1:: ShowDir("D:\Dropbox")
!Numpad2:: ShowDir("D:\Dropbox\HomeShare")
!Numpad3:: ShowDir("D:\")
!Numpad7:: ShowDir("C:\Program Files (x86)\Steam\SteamApps\common\Team Fortress 2\tf")
!Numpad0:: ShowDir(A_ScriptDir)
!NumpadDot:: ShowDir("D:\Downloads\")

^!r::Reload	
^!e::Run %Editor% %A_ScriptName%
^!t::Run %Editor% Test.ahk
!t::Run %A_ScriptDir%\Test.ahk
^!x::AHKPanic(1,0,0,1)

#IfWinActive, ahk_class Valve001
	#Up::ControlSend, ahk_parent, ^{Up}, ahk_class SpotifyMainWindow 
	#Down::ControlSend, ahk_parent, ^{Down}, ahk_class SpotifyMainWindow
	#Left::Send {Media_Play_Pause} ;ControlSend, ahk_parent, ^{Space}, ahk_class SpotifyMainWindow 
	#Right::Send {Media_Next} ;ControlSend, ahk_parent, ^{Right}, ahk_class SpotifyMainWindow 
#IfWinActive

;; Quickfire TK - Enable NumLock
*RCtrl::SetNumLockState, On
*RCtrl Up::SetNumLockState, Off

#Include Appspecific.ahk
#Include MyMethods.ahk
#Include Hotstrings.ahk
#Include lib\VA.ahk
#Include lib\Notify.ahk
;#Include lib\LedControl.ahk
#Include lib\ini.ahk
