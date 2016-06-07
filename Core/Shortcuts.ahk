;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Folder Shortcuts ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

!Numpad0::		Show_Dir(A_ScriptDir)
!NumpadDot:: 	Show_Dir("C:\Users\QIDX\Downloads")
!Numpad1:: 		Show_Dir("C:\Users\QIDX\Documents")
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

; Launchy
CapsLock & Space::Send, !{Space}

~Media_Next::
	KeyboardLED(7,"off", kbdIndex)
	Sleep, 50
	KeyboardLED(2,"switch", kbdIndex)
	Sleep, 75
	KeyboardLED(4,"switch", kbdIndex)
	Sleep, 75
	KeyboardLED(1,"switch", kbdIndex)
	Sleep, 75
	KeyboardLED(0,"off", kbdIndex)
Return

~Media_Play_Pause::
	Loop, 2 ; flash all LEDs
	{
		KeyboardLED(7,"on", kbdIndex)
		Sleep, 100
		KeyboardLED(7,"off", kbdIndex)
		Sleep, 100
	}
	KeyboardLED(0,"off", kbdIndex)
Return

+AppsKey::Run, MyMenu.ahk

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
LCtrl & RCtrl::
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
^!q::			Gosub, AgentRansack

RCtrl & Enter::
NumLock::		Gosub, Spotify

^NumPad0::		Gosub, RearrangeWindows
RCtrl & 1::
CapsLock & /::
^NumpadDot::	Show_Start("- Google Chrome", "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe")
^Numpad1::		Show_Start("HipChat","C:\Program Files (x86)\Atlassian\HipChat\hipchat.exe")
RCtrl & 2::
CapsLock & SC027::
^Numpad2::		Show_Start("Cmder", "../cmder/cmder.exe")
RCtrl & 3::
CapsLock & "::
^Numpad3::		GoSub, SublimeText
^Numpad4::		Show_Start(" - Git Extensions","C:\Program Files (x86)\GitExtensions\GitExtensions.exe")
^Numpad5::		Show_Start("- Microsoft Visual Studio", "C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\IDE\devenv.exe")
^Numpad6::		Show_Start("First Data Evolve","C:\Reach\Prpro.exe NRDUQ")
^Numpad7::		Show_Start("- Outlook", "C:\Program Files (x86)\Microsoft Office\Office15\OUTLOOK.EXE")
^Numpad8::		Show_Start("ZUI Application Client","C:\Program Files (x86)\Zoot\Kairos-Client-1.1.0.35\java\bin\javaw.exe", "-Xmx512m -Dzui.plugin.location=""C:\Users\QIDX\.zui-client-plugin-cache"" -jar ""C:\Program Files (x86)\Zoot\Kairos-Client-1.1.0.35\zui-client-1.1.0.35-bin.jar""", 0)
^Numpad9::		Show_Start("Scope Classic","C:\Program Files (x86)\zScope\Classic v6.5\zClassic.exe")

^!Enter::
^!NumpadEnter::		Gosub, PurgeWindows
; ^!NumpadEnter::	Show_Start("","")
; #NumpadAdd::		Show_Start("","")
; ^!NumpadAdd::		Show_Start("","")

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

SublimeText:
	Show_Start("ahk_class PX_WINDOW_CLASS", Editor)
	WinWaitActive ahk_class PX_WINDOW_CLASS
	; WinMove, ahk_class PX_WINDOW_CLASS,, 1920, 0, 1317, A_ScreenHeight
	Return
	
Npp:
	Show_Start("ahk_class Notepad++", Editor)
	WinWaitActive ahk_class Notepad++
	; WinMove, ahk_class Notepad++,, 1920, 0, 1317, A_ScreenHeight
	Return
		
PurgeWindows:
	While (WinExist("ahk_class CabinetWClass"))	
		WinClose, ahk_class CabinetWClass
	WinClose ahk_class EVERYTHING
	Notify("Windows Purged","",-1,"GC=555555 TC=White MC=White")
	Return

RearrangeWindows:
	if (MonitorCount = 3)
	{
		WinMove, ahk_class Qt5QWindowIcon,, -1600, 300, 800, 900
		WinActivate, Cmder
		WinMove, Cmder,, -800, 300, 800, 900
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
	; WinGetClass, this_class, A
	; If (IfWinA) ; Toggle
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
	newGuid := GUID(3)
	SendInput % newGuid
	if (!FileExist("logs\"))
		FileCreateDir, logs\
	FileAppend, % newGuid "`n", logs\used_guids.txt
	Return

; Iso8601 Time
#t:: 
	FormatTime, IsoTime,, yyyy-MM-ddThh:mm:ssZ
	SendInput % IsoTime
	Return

	
; Append to clipboard
^+c::
	bak = %clipboard%
	Send, ^c
	Sleep, 50
	clipboard = %bak%`r`n%clipboard%
	Notify("Appended to Clipboard",clipboard,-1,"Style=Fast")
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

^!F5::
	ControlSend, ahk_parent, ^{1}, ahk_class Chrome_WidgetWin_1
	WinMinimize, Chrome
	
	Loop 
	{
		ControlGetText, url, Chrome_OmniboxView1, ahk_class Chrome_WidgetWin_1
		if (url == first_url)
			break
		if A_Index = 1
			first_url := url
		ControlSend, ahk_parent, ^{tab}, ahk_class Chrome_WidgetWin_1
		url_list .= url . " "
	}
	Sleep, 500
	WinClose, ahk_class Chrome_WidgetWin_1
	Sleep, 500
	Run, Chrome.exe %url_list%
	url_list = ;empty
	return

^!+F5::
	Notify("Running Clipboard",,-2,"Style=Mine")
	DynaRun(clipboard, "Clipboard Run")
	Return

^!+End::
	WinGet, pid, PID, A
	Process, Close, %pid%
Return

^!d::
	;RegWrite, REG_DWORD, HKCU, Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState, FullPath, 1
	wikiPath := "D:\Dropbox\HomeShare\DokuWikiStick\dokuwiki\data\pages"
	Run, C:\Program Files (x86)\Everything\Everything.exe -path "%wikiPath%"
	WinWaitActive, Everything,, 3
	If Errorlevel
		Return
	Send {End}
Return
