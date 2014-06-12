;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Folder Shortcuts ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

!Numpad0::		ShowDir("D:\Dropbox\HomeShare\AutoHotkey")
!NumpadDot:: 	ShowDir("D:\Downloads")
!Numpad1:: 		ShowDir("D:\Dropbox")
!Numpad2:: 		ShowDir("D:\Dropbox\HomeShare")
!Numpad3:: 		ShowDir("D:\Dropbox\ScreenShots")
!Numpad4:: 		ShowDir("\\katrina\public\LatestRelease\")
!Numpad5:: 		ShowDir("\\Nasus\Builds\SalesPad.GP")
!Numpad6:: 		ShowDir("\\Karma\Team QA\Database Files\")
!Numpad7:: 		ShowDir("\\Karma\Team QA")
!Numpad8:: 		ShowDir("\\Nasus\Shared Folders")
!Numpad9:: 		ShowDir("\\Karma\Team QA\Logs")

#c::			ShowDir("C:\")
#p::			ShowDir("C:\Program Files (x86)\")

#NumpadDot::ShowStart("Remote Desktop Connection Manager", "C:\Program Files (x86)\Remote Desktop Connection Manager\RDCMan.exe")
#Numpad1::	ShowStart("(testing1).+(TightVNC Viewer)", "C:\Program Files\TightVNC\tvnviewer.exe testing1")
#NumPad2::	ShowStart("(smartbear).+(TightVNC Viewer)", "C:\Program Files\TightVNC\tvnviewer.exe smartbear")
#NumPad3::	ShowStart("(testing3).+(TightVNC Viewer)", "C:\Program Files\TightVNC\tvnviewer.exe testing3")
#Numpad4::	ShowStart("(testing4).+(TightVNC Viewer)", "C:\Program Files\TightVNC\tvnviewer.exe testing4")
#Numpad5::	ShowStart("(sql2005).+(TightVNC Viewer)", "C:\Program Files\TightVNC\tvnviewer.exe sql2005")

!#NumpadDot::	ShowDir("\\Testing-PC\c$")
!#Numpad1::		ShowDir("\\testing1\c$")
!#NumPad2::		ShowDir("\\smartbear\c$")
!#NumPad3::		ShowDir("\\testing3\c$")
!#Numpad4::		ShowDir("\\testing4\c$")
!#Numpad5::		ShowDir("\\sql2005\c$")

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

AppsKey::Run, MyMenu.ahk
+AppsKey::AppsKey

#l::
	Run, %A_WinDir%\System32\rundll32.exe user32.dll`, LockWorkStation
	Sleep 1000
	SendMessage, 0x112, 0xF170, 2,, Program Manager
	Return
	
NumLock:: ;ShowStart("Spotify", A_Appdata . "\Spotify\spotify.exe", 1)
	WinGetClass, this_class, A
	If (RegExMatch(this_class, "Spotify")) ; Toggle
		WinMinimize, ahk_class SpotifyMainWindow
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

#WheelDown::	Send {WheelRight 5}
#WheelUp::		Send {WheelLeft 5}
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;; Launcher ;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;

^!s::Gosub, Everything
^NumPad0::Gosub, RearrangeWindows
^NumpadDot::ShowStart("Google Chrome", "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe")
^Numpad1::Gosub, SalesPad
^Numpad2::ShowStart("Cmder", "../cmder/cmder.exe")
#s::
^Numpad3::GoSub, SublimeText
^Numpad4::ShowStart("ahk_class Framework::CFrame", "C:\Program Files\Microsoft Office\Office15\ONENOTE.EXE")	
^Numpad5::ShowStart("Microsoft Visual Studio", "C:\Program Files (x86)\Microsoft Visual Studio 11.0\Common7\IDE\devenv.exe")
^Numpad6::Gosub, SSMS
^Numpad7::ShowStart("Inbox", "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe www.gmail.com")
^Numpad8::ShowStart("Calendar", "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe  --app=https://www.google.com/calendar/render?pli=1")

#NumpadEnter::Gosub, PurgeWindows
^!NumpadEnter::Run, Utilities\ViewScriptProcesses.ahk
#NumpadAdd::Gosub, ResetDB
^!NumpadAdd::Run, WorkScripts\BuildPrompt.ahk

ScrollLock::ShowStart("Test Configuration", "WorkScripts\ConfigTests.ahk", 1)

Everything:
	;DetectHiddenWindows, Off
	; Enable setting to focus search field in Everything
	DetectHiddenWindows, Off
	If WinExist("ahk_class EVERYTHING")
		WinActivate, ahk_class EVERYTHING
	Else
		Run, C:\Program Files\Everything\Everything.exe -admin
	
	WinWaitActive, ahk_class EVERYTHING,, 2
	WinMove, ahk_class EVERYTHING,, A_ScreenWidth,A_ScreenHeight*0.4,A_ScreenWidth*0.7,A_ScreenHeight*0.6
	WinWaitNotActive
	WinMove, ahk_class EVERYTHING,, A_ScreenWidth, A_ScreenHeight*0.65, A_ScreenWidth*0.7, A_ScreenHeight*0.35
	DetectHiddenWindows, On
	Return

RearrangeWindows:
	WinMove, ahk_class Win32UserWindow,, 1920,0,334,1080
	WinActivate, ahk_class Win32UserWindow

	IfWinExist Buddy List
		WinActivate Buddy List
	else
		WinShow Buddy List
	WinMove, Buddy List,, 3605,0,234,1080
	Return
	
SalesPad:
	aDown := A_TickCount
	Keywait Numpad1
	If ((A_TickCount-aDown) < 400)
	{
		IfWinExist,  - SalesPad
		{
			WinActivate, - SalesPad
			Return
		}
		else
		{
			Loop, C:\Program Files (x86)\SalesPad.GP HotFix\Sales*.exe, 0, 1
			{
				 FileGetTime, Time, %A_LoopFileFullPath%, C
				 If (Time > Time_Orig)
				 {
					  Time_Orig := Time
					  exe := A_LoopFileFullPath
				 }
			}
		}
		
	}
	If ((A_TickCount-aDown)>400) and ((A_TickCount-aDown)<1500)
	{
		Loop, C:\Program Files (x86)\SalesPad.GP Release\Sales*.exe, 0, 1
			{
				 FileGetTime, Time, %A_LoopFileFullPath%, C
				 If (Time > Time_Orig) and !(Instr(A_LoopFileName, "uninst"))
				 {
					  Time_Orig := Time
					  exe := A_LoopFileFullPath
				 }
			}
	}
	Run %exe%
	Return

SublimeText:
	ShowStart("ahk_class PX_WINDOW_CLASS", Editor)
	WinWaitActive ahk_class PX_WINDOW_CLASS
	WinMove, ahk_class PX_WINDOW_CLASS,, 1920, 0, 1317, A_ScreenHeight
	Return

SSMS:
	aDown:=A_TickCount
	Keywait Numpad6
	If ((A_TickCount-aDown)<400)
		ShowStart("Microsoft SQL Server Management Studio", "C:\Program Files (x86)\Microsoft SQL Server\110\Tools\Binn\ManagementStudio\Ssms.exe")
	If ((A_TickCount-aDown)>400) and ((A_TickCount-aDown)<3000)
		Run, "D:\Dropbox\Scripts\SQL\sandbox.sql"
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
	
ResetDB:
	MsgBox, 36, Reset DB, Reset the database version?
	IfMsgBox Yes
	{
		RunWait, %comspec% /c "sqlcmd -E -d TWI -Q "UPDATE spDatabaseVersion SET [Database_Version] = -1"",, Hide
		RunWait, %comspec% /c "sqlcmd -E -d TWI -Q "UPDATE dwDatabaseVersion SET [Database_Version] = -1"",, Hide
	}
	Return


;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; Misc ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;


#g::
	if RegExMatch(clipboard, ".+(.com|.net|.co.uk)")
		Run, chrome.exe %clipboard%
	Return
	
^!g::ShowStart("grepWin", "C:\Program Files\grepWin\grepWin.exe /searchpath:D:\Dropbox\")
^!i::ShowStart("MINGW32", """C:\Program Files (x86)\Git\bin\sh.exe"" --login -i")

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