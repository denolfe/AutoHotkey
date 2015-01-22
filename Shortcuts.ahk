;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Folder Shortcuts ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

!Numpad0::		ShowDir("C:\Users\elliotdenolf\Dropbox\HomeShare\AutoHotkey")
!NumpadDot:: 	ShowDir("C:\Users\elliotdenolf\Downloads")
!Numpad1:: 		ShowDir("C:\Users\elliotdenolf\Dropbox")
!Numpad2:: 		ShowDir("C:\Users\elliotdenolf\Dropbox\HomeShare")
!Numpad3:: 		ShowDir("C:\Users\elliotdenolf\Pictures")
!Numpad4:: 		ShowDir("C:\tfs\main\FinFolio")
; !Numpad5:: 		ShowDir("")
; !Numpad6:: 		ShowDir("")
; !Numpad7:: 		ShowDir("")
; !Numpad8:: 		ShowDir("")
; !Numpad9:: 		ShowDir("")

#c::			ShowDir("C:\")
#p::			ShowDir("C:\Program Files (x86)\")

; !#NumpadDot::		ShowDir("")
; !#Numpad1::		ShowDir("")
; !#NumPad2::		ShowDir("")
; !#NumPad3::		ShowDir("")
; !#Numpad4::		ShowDir("")
; !#Numpad5::		ShowDir("")
; !#Numpad6::		ShowDir("")

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;; Misc Shortcuts ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

#If GetKeyState("AppsKey", "p")
	w::Up
	a::Left
	s::Down
	d::Right
#If

#l::
	Run, %A_WinDir%\System32\rundll32.exe user32.dll`, LockWorkStation
	Sleep 1000
	SendMessage, 0x112, 0xF170, 2,, Program Manager
	Return
	
RCtrl & Enter:: Gosub, Spotify ;ShowStart("Spotify", A_Appdata . "\Spotify\spotify.exe", 1)

#WheelDown::	Send {WheelRight 5}
#WheelUp::		Send {WheelLeft 5}

^+F5::^!CtrlBreak


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; Window Manipulation ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#XButton1::Send #{Left}
#XButton2::Send #{Right}
#MButton::
	WinGet, isMaxed, MinMax, A
	If (isMaxed)
		Send #{Down}
	Else
		Send #{Up}
	Return
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; Launcher ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

^!s::		Gosub, Everything
^!q::		Gosub, AgentRansack
; ^NumPad0::	Gosub, RearrangeWindows
^NumpadDot::ShowStart("Google Chrome", "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe")
; ^Numpad1::	Gosub, SalesPad
^Numpad2::	ShowStart("Cmder", "../cmder/cmder.exe")
#s::
^Numpad3::	GoSub, SublimeText
; ^Numpad4::	ShowStart("ahk_class Framework::CFrame", "C:\Program Files\Microsoft Office\Office15\ONENOTE.EXE")	
^Numpad5::	ShowStart("- Microsoft Visual Studio", "C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\IDE\devenv.exe")
^Numpad6::	ShowStart("Microsoft SQL Server Management Studio", "C:\Program Files (x86)\Microsoft SQL Server\120\Tools\Binn\ManagementStudio\Ssms.exe")
; ^Numpad7::	ShowStart("Inbox", "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe www.gmail.com")
; ^Numpad8::	ShowStart("Calendar", "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe  --app=https://www.google.com/calendar/render?pli=1")

^!NumpadEnter::	Gosub, PurgeWindows
; ^!NumpadEnter::	Run, Utilities\ViewScriptProcesses.ahk
; #NumpadAdd::	Gosub, ResetDB
; ^!NumpadAdd::	Run, WorkScripts\BuildPrompt.ahk

; ScrollLock::	ShowStart("Test Configuration", "WorkScripts\ConfigTests.ahk", 1)

Spotify:
	WinGetClass, this_class, A
	If (RegExMatch(this_class, "Spotify")) ; Toggle
	{
		Send, !{Tab}
		WinMinimize, ahk_class SpotifyMainWindow
	}
	Else
	{
		SetTitleMatchMode, RegEx
		If WinExist("^Spotify")
			WinActivate
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
		SetTitleMatchMode, 2
	}
Return

Everything:
	;DetectHiddenWindows, Off
	; Enable setting to focus search field in Everything
	DetectHiddenWindows, Off
	If WinExist("ahk_class EVERYTHING")
		WinActivate, ahk_class EVERYTHING
	Else
		Run, C:\Program Files (x86)\Everything\Everything.exe -admin
	WinWait, ahk_class EVERYTHING,, 2
	WinMove, ahk_class EVERYTHING,, 0,A_ScreenHeight*0.66,A_ScreenWidth-62,A_ScreenHeight - (A_ScreenHeight*0.66)
	Return

AgentRansack:
	DetectHiddenWindows, Off
	If WinExist("Search:")
		WinActivate
	Else
	{
		Run, C:\Program Files\Mythicsoft\Agent Ransack\AgentRansack.exe
		WinActivate, Search:
	}
	WinWait, Search:,, 2
	WinMove, Search:,, 0, 0, A_ScreenWidth-62, (A_ScreenHeight*0.66)
	ControlFocus, Edit2, Search:
	Return

SublimeText:
	ShowStart("ahk_class PX_WINDOW_CLASS", Editor)
	WinWaitActive ahk_class PX_WINDOW_CLASS
	; WinMove, ahk_class PX_WINDOW_CLASS,, 1920, 0, 1317, A_ScreenHeight
	Return
		
PurgeWindows:
	loop
	{
		WinClose, ahk_class CabinetWClass
		IfWinNotExist, ahk_class CabinetWClass
			break
	}
	WinClose ahk_class EVERYTHING
	Notify("Windows Purged","",-1,"GC=555555 TC=White MC=White")
	Return
	
; ResetDB:
; 	MsgBox, 36, Reset DB, Reset the database version?
; 	IfMsgBox Yes
; 	{
; 		RunWait, %comspec% /c "sqlcmd -E -d TWI -Q "UPDATE spDatabaseVersion SET [Database_Version] = -1"",, Hide
; 		RunWait, %comspec% /c "sqlcmd -E -d TWI -Q "UPDATE dwDatabaseVersion SET [Database_Version] = -1"",, Hide
; 	}
; 	Return


;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; Misc ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;


#g::
	if RegExMatch(clipboard, ".+(.com|.net|.co.uk)")
		Run, chrome.exe %clipboard%
	Return
	
^!g::ShowStart("grepWin", "C:\Program Files\grepWin\grepWin.exe /searchpath:D:\Dropbox\")

; Append to clipboard
^+c::
	bak = %clipboard%
	Send, ^c
	Sleep, 50
	clipboard = %bak%`r`n%clipboard%
	Notify("Appended to Clipboard",clipboard,-1,"Style=Mine")
Return

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

#pgup::
	DetectHiddenWindows, On 
	ControlSend, ahk_parent, ^{Right}, ahk_class SpotifyMainWindow 
	DetectHiddenWindows, Off 
	Return 

#pgdn::
	DetectHiddenWindows, On 
	ControlSend, ahk_parent, ^{Down}, ahk_class SpotifyMainWindow 
	DetectHiddenWindows, Off 
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