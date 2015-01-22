#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#WinActivateForce
#SingleInstance force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode, RegEx
DetectHiddenWindows, On
SetCapsLockState, AlwaysOff

Run, AutoCorrect.ahk
Run, %A_ScriptDir%\VolumeScroll\VolumeScroll.ahk

total := 0
IncludedFiles := "Home.ahk|Functions.ahk|AppSpecific.ahk|VolumeControl.ahk"
Loop, Parse, IncludedFiles, |
	total += TF_CountLines(A_LoopField)
Notify(A_ScriptName . " Started!",total . " lines executed",-3,"Style=Mine")

global Editor := "D:\Dropbox\HomeShare\SublimePortable\sublime_text.exe"

Menu, Tray, Icon, lib\images\Portal.ico
Menu, Tray, Tip, Home Script
SetTimer, IntroSound, -1
SetTimer, IntroLights, -1000

FileCopy, %A_ScriptDir%\WindowPadX\WindowPadX-home.ini, %A_ScriptDir%\WindowPadX\WindowPadX.ini, 1
Run, WindowPadX\WindowPadX.ahk

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
	IfWinNotExist Everything
	{
		Run C:\Program Files (x86)\Everything\Everything.exe
		WinActivate
	}
	Else
		WinActivate, ahk_class EVERYTHING
	WinMove, ahk_class EVERYTHING,, 0,A_ScreenHeight*0.66,A_ScreenWidth,A_ScreenHeight - (A_ScreenHeight*0.66)
	Return

#c::Run, C:\
#p::Run, C:\Program Files (x86)\

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

RCtrl & 1::ShowStart("ahk_class Chrome_WidgetWin_1", "chrome.exe")
RCtrl & 2::ShowStart("Cmder", "../cmder/cmder.exe")
RCtrl & 3::ShowStart("ahk_class PX_WINDOW_CLASS", Editor)
RCtrl & 4::ShowDir("D:\Dropbox\")
RCtrl & 5::ShowDir("D:\Dropbox\HomeShare")
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; Folder Shortcuts ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


!1:: ShowDir("D:\Dropbox")
!2:: ShowDir("D:\Dropbox\HomeShare")
!3:: ShowDir("D:\Downloads\")
!4:: ShowDir("D:\")
!7:: ShowDir("C:\Program Files (x86)\Steam\SteamApps\common\Team Fortress 2\tf")
!0:: ShowDir(A_ScriptDir)

^!r::Reload
^!e::Run %Editor% %A_ScriptName%
^!t::Run %Editor% Test.ahk
!t:: Run %A_ScriptDir%\Test.ahk
^!x::AHKPanic(1,0,0,1)

#IfWinActive, ahk_class Valve001
	#Up::ControlSend, ahk_parent, ^{Up}, ahk_class SpotifyMainWindow
	#Down::ControlSend, ahk_parent, ^{Down}, ahk_class SpotifyMainWindow
	#Left::Send {Media_Play_Pause} ;ControlSend, ahk_parent, ^{Space}, ahk_class SpotifyMainWindow
	#Right::Send {Media_Next} ;ControlSend, ahk_parent, ^{Right}, ahk_class SpotifyMainWindow
#IfWinActive

#Include %A_ScriptDir%\AppSpecific\Everything.ahk
#Include %A_ScriptDir%\AppSpecific\SublimeText.ahk
#Include %A_ScriptDir%\AppSpecific\WindowsExplorer.ahk

#Include Functions.ahk
#Include CapsNav.ahk
#Include lib\VA.ahk
#Include lib\Notify.ahk
#Include lib\LedControl.ahk
