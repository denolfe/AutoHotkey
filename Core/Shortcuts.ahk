#Include %A_ScriptDir%\Shortcuts\Media.ahk
#Include %A_ScriptDir%\Shortcuts\CapsNav.ahk
#Include %A_ScriptDir%\Shortcuts\Keypad.ahk

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Folder Shortcuts ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

!Numpad0::		Show_Dir(A_ScriptDir)
!NumpadDot:: 	Show_Dir(UserDir "\Downloads")
!Numpad1:: 		Show_Dir(UserDir "\Documents")
; !Numpad2:: 		Show_Dir("")
; !Numpad3:: 		Show_Dir("")
; !Numpad4:: 		Show_Dir("")
; !Numpad5:: 		Show_Dir("")
; !Numpad6:: 		Show_Dir("")
; !Numpad7:: 		Show_Dir("")
; !Numpad8:: 		Show_Dir("")
; !Numpad9:: 		Show_Dir("")

#c::			Show_Dir("C:\")
#p::			Show_Dir("C:\Program Files (x86)\")

; !#NumpadDot::		Show_Dir("")
; !#Numpad1::		Show_Dir("")
; !#NumPad2::		Show_Dir("")
; !#NumPad3::		Show_Dir("")
; !#Numpad4::		Show_Dir("")
; !#Numpad5::		Show_Dir("")
; !#Numpad6::		Show_Dir("")

;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; Remaps ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;

; `::Esc
; #`::`

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;; Misc Shortcuts ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

AppsKey::RWin ; GMMK Keyboard

#WheelDown::	Send {WheelRight 2}
#WheelUp::		Send {WheelLeft 2}

^+F5::^!CtrlBreak

;; Cancel Laptop screen flipping
^!Left::
^!Right::
^!Up::
^!Down::
	Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; Window Manipulation ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#XButton1::Send #{Left}
#XButton2::Send #{Right}

^MButton::
CapsLock & w::
	Send, {LButton}
	WinGet, isMaxed, MinMax, A
	If (isMaxed)
	{
		Send #{Down}
		Monitor_MoveOptimal()
	}
	Else
		Monitor_MoveOptimal()
	Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; Launcher ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

^!s::			Gosub, Everything

RCtrl & Enter::
PrintScreen::		Gosub, Spotify

RCtrl & Esc:: ; 60% keyboard
RCtrl & Delete::	Show_Start("- Google Chrome", "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe")

RCtrl & 1::
RCtrl & Insert::Show_Start("- Outlook", "C:\Program Files (x86)\Microsoft Office\root\Office16\OUTLOOK.EXE")

RCtrl & 2::
RCtrl & End::
CapsLock & SC027::Show_Start("Cmder", UserDir "\cmder\Cmder.exe")

RCtrl & 3::
RCtrl & PgDn::
CapsLock & /::Show_Start("- Visual Studio Code", "C:\Program Files\Microsoft VS Code\Code.exe")

RCtrl & Home::Show_Start("- Microsoft Visual Studio", "C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\Common7\IDE\devenv.exe")

RCtrl & PgUp::Show_Start("Slack -", UserDir "\AppData\Local\slack\slack.exe")

^!Enter::Gosub, PurgeWindows
^!0::Gosub, RearrangeWindows

; ScrollLock::		Show_Start("","")


Everything:
	;DetectHiddenWindows, Off
	; Enable setting to focus search field in Everything
	DetectHiddenWindows, Off
	If WinExist("ahk_class EVERYTHING")
		WinActivate, ahk_class EVERYTHING
	Else
		RunProgFiles("Everything\Everything.exe")
	WinWait, ahk_class EVERYTHING,, 2
	WinMove, ahk_class EVERYTHING,, 0,A_ScreenHeight*0.66,A_ScreenWidth-62,(A_ScreenHeight-40) - (A_ScreenHeight*0.66)
	Return

AgentRansack:
	DetectHiddenWindows, Off
	If WinExist("Agent Ransack")
		WinActivate
	Else
	{
		Run, C:\Program Files\Mythicsoft\Agent Ransack\AgentRansack.exe
		WinActivate, Agent Ransack
	}
	WinWait, Search:,, 2
	WinMove, Search:,, 0, 0, A_ScreenWidth-62, (A_ScreenHeight*0.66)
	ControlFocus, Edit2, Search:
	Return

PurgeWindows:
	While (WinExist("ahk_class CabinetWClass"))
		WinClose, ahk_class CabinetWClass
	WinClose ahk_class EVERYTHING
	Notify("Windows Purged","",-1,"Style=Win10")
	Return

RearrangeWindows:
	if (MonitorCount = 3)
	{
		WinMove, Cmder,, -960, 0, 966, 600
		WinMove, Slack -,, 1912, 119, 1920, 1080
		WinMove, Inbox -,, -1928, -8, 1920, 1200
	}
	else if (MonitorCount = 2)
	{
		WinActivate, Cmder
		WinMove, Cmder,, 1920, 0, 900, 1200
	}
	else
	{
		WinActivate, Cmder
	}
	Return

Spotify:
	If WinActive("ahk_class SpotifyMainWindow")
	{
		Send, !{Tab}
		WinMinimize, ahk_class SpotifyMainWindow
	}
	Else
	{
		If WinExist("ahk_class SpotifyMainWindow")
			WinActivate
		else
		{
        	Run, % A_Appdata . "\Spotify\spotify.exe", UseErrorLevel
            If ErrorLevel
            {
                Notify("Spotify.exe not found", title,-3,"Style=Error")
                Return
            }
            WinActivate
		}
		SetTitleMatchMode, 2
	}
Return

;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; Misc ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;

#g::Run, chrome.exe %clipboard%

; Guid without formatting ie. cb2d322ee97f4a69a0e5d1cfba11aa5c
^+g::
	newGuid := GUID(2)
	SendInput % newGuid
	if (!FileExist("logs\"))
		FileCreateDir, logs\
	FileAppend, % newGuid "`n", logs\used_guids.txt
	Return

; Append to clipboard
^+c::
	bak = %clipboard%
	Send, ^c
	Sleep, 50
	clipboard = %bak%`r`n%clipboard%
	Notify("Appended to Clipboard",clipboard,-1,"Style=Fast")
Return

^+!c::
	bak = %clipboard%
	Send, ^c
	Sleep, 50
	clipboard = %clipboard%`r`n%bak%
	Notify("Prepended to Clipboard",clipboard,-1,"Style=Fast")
Return

; Fast minimize
!`::
	aDown := A_TickCount
	Keywait ``
	If ((A_TickCount-aDown) < 200)
	{
		WinGet, last_id, ID, A
		WinMinimize, A
	}
	else
		WinActivate, ahk_id %last_id%
	Return

^!+End::
	WinGet, pid, PID, A
	Process, Close, %pid%
Return
