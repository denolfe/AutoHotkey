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

global Editor := "D:\Dropbox\HomeShare\Sublime-Portable\sublime_text.exe"

Menu, Tray, Icon, lib\images\Portal.ico
Menu, Tray, Tip, Home Script
SoundPlay, lib\sounds\load.wav

^!b::Run, D:\Downloads\warsow_1.02_sdk\source\Debug\x86\warsow_x86.exe +set fs_cdpath "C:\Program Files (x86)\Warsow 1.02\" +set fs_basepath "$(TargetDir)" +devmap wdm1

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

:*:gsauth;::/authserv auth fathom 1030rJyY
:*:irc;::Team EAT{Tab}1337-347150-2012

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

~RCtrl::
	If (A_PriorHotKey = A_ThisHotKey and A_TimeSincePriorHotkey < 500)
	  Run C:\Program Files (x86)\Steam\SteamApps\common\Team Fortress 2\tf
	return

;; SOUND DEVICE TOGGLE ;;
+ScrollLock::
	path := ini_load(ini, "Home.ini") 
	device := ini_getValue(ini, SoundDevices, "Playback")

	if device = Headphones
	{
		ini_replaceValue(ini, SoundDevices, "Playback", "Speakers")
		Run, Utilities\nircmd.exe setdefaultsounddevice Speakers
	}
	else
	{
		ini_replaceValue(ini, SoundDevices, "Playback", "Headphones")
		Run, Utilities\nircmd.exe setdefaultsounddevice Headphones
	}
	Notify(ini_getValue(ini, SoundDevices, "Playback"),"Sound Device Changed",-1,"Style=Mine")
	path := ini_save(ini, "Home.ini")
	SoundPlay, lib\sounds\meta-online.wav
	Return
	
	+Pause::
		aero:=!aero
		if aero
			RunWait, %comspec% /c "net stop uxsms",, Hide
		else
			RunWait, %comspec% /c "net start uxsms",, Hide
	Return

~NumLock::
	Sleep 100
	if GetKeyState("NumLock", "T")
	{
		SoundBeep, 500, 100
		SoundBeep, 700, 100
		SoundBeep, 900, 100
	}
	else
	{
		SoundBeep, 900, 100
		SoundBeep, 700, 100
		SoundBeep, 500, 100
	}
Return


^NumpadDot::ShowStart("ahk_class Chrome_WidgetWin_1", "chrome.exe")

^Numpad3::ShowStart("ahk_class PX_WINDOW_CLASS", Editor)
^Numpad4::ShowStart("ahk_class Framework::CFrame", "C:\Program Files\Microsoft Office 15\root\office15\onenote.exe?")	
^Numpad5::Run, C:\Dev\adt-bundle-windows-x86_64\eclipse\eclipse.exe
^Numpad7::ShowStart("Inbox", "chrome.exe www.gmail.com")
^Numpad8::ShowStart("Google Calendar", "chrome.exe calendar.google.com")

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


!Numpad1:: Run D:\Dropbox
!Numpad2:: Run D:\Dropbox\HomeShare
!Numpad3:: Run D:\ 
!Numpad7:: ShowDir("C:\Program Files (x86)\Steam\SteamApps\common\Team Fortress 2\tf")
!Numpad0:: Run %A_ScriptDir%
!NumpadDot:: Run D:\Downloads\

CapsLock::Return
+CapsLock::CapsLock
;;;;; CapsNav ;;;;;;;

CapsLock & h::CapsNav("Left")
CapsLock & j::CapsNav("Down")
CapsLock & k::CapsNav("Up")
CapsLock & l::CapsNav("Right")

CapsLock & n::CapsNav("Home")
CapsLock & p::CapsNav("End")

CapsLock & o::
CapsLock & .::CapsNav("Right", "!")
CapsLock & m::CapsNav("Left", "!")

CapsLock & u::
CapsLock & `;::
CapsLock & ,::
CapsLock & i::
Return







;; Media Keys
;+F5::F5
;+F6::F6
;+F7::F7
;F5::Send {Media_Prev}
;F6::Send {Media_Play_Pause}
;F7::Send {Media_Next}

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

;#Include Terraria.ahk

#Include Appspecific.ahk
#Include MyMethods.ahk
#Include Hotstrings.ahk
#Include lib\VA.ahk
#Include lib\Notify.ahk
;#Include lib\LedControl.ahk
#Include lib\ini.ahk