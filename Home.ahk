#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#WinActivateForce
#SingleInstance force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode, RegEx
SetNumlockState, AlwaysOn
DetectHiddenWindows, On 
KeyboardLED(2,"off")

Run AutoCorrect.ahk
Run VolumeControl.ahk

total := 0
IncludedFiles = Home.ahk|MyMethods.ahk|VolumeControl.ahk
Loop, Parse, IncludedFiles, |
	total += TF_CountLines(A_LoopField)
Notify(A_ScriptName . " Started!",total . " lines executed",-3,"Style=Mine")

Menu, Tray, Icon, lib\images\Portal.ico
Menu, Tray, Tip, Home Script
SoundPlay, lib\sounds\load.wav
#Include lib\VA.ahk
#Include lib\Notify.ahk
#Include lib\LedControl.ahk
#Include lib\ini.ahk
#Include MyMethods.ahk
#Include AppSpecific.ahk
#Include Hotstrings.ahk

^!s::
	IfWinNotExist Everything
	{
		Run C:\Program Files (x86)\Everything\Everything.exe
	}
	Else
	{
		WinActivate ahk_class EVERYTHING
		WinWaitActive ahk_class EVERYTHING
		ControlFocus, Edit1
		Send, {Shift Down}{Home}{Shift Up}
	}
	WinWaitActive ahk_class EVERYTHING
	WinMove,ahk_class EVERYTHING,, 0,(A_ScreenHeight/1.5),A_ScreenWidth, A_ScreenHeight - (A_ScreenHeight/1.5)
	Return


#c::Run, C:\
#p::Run, C:\Program Files (x86)\

#l::
	Run,%A_WinDir%\System32\rundll32.exe user32.dll`,LockWorkStation
	Sleep 1000
	SendMessage, 0x112, 0xF170, 2,, Program Manager
	Return

NumLock::
	ShowStart("ahk_class SpotifyMainWindow", A_Appdata . "\Spotify\spotify.exe", 1)
	KeyboardLED(2,"off")
	Return

~RCtrl::
	If (A_PriorHotKey = A_ThisHotKey and A_TimeSincePriorHotkey < 500)
	  Run C:\Program Files (x86)\Steam\steamapps\nitroboard99@epals.com\team fortress 2\tf\
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

^NumpadDot::ShowStart("ahk_class Chrome_WidgetWin_1", "chrome.exe")

^Numpad3::ShowStart("ahk_class PX_WINDOW_CLASS", "C:\Program Files\Sublime Text 2\sublime_text.exe")
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Folder Shortcuts ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

!Numpad1:: Run B:\Dropbox
!Numpad2:: Run %A_ScriptDir%
!NumpadDot:: Run B:\Downloads\

^!r::Reload	
^!e::Run C:\Program Files\Sublime Text 2\sublime_text.exe %A_ScriptName%
^!t::Run C:\Program Files\Sublime Text 2\sublime_text.exe test.ahk
!t::Run %A_ScriptDir%\test.ahk
^!x::AHKPanic(1,0,0,1)

