


~LButton::

	If (( A_PriorHotKey = A_ThisHotKey && A_TimeSincePriorHotkey < 200 ) && MouseIsOver("ahk_class Shell_TrayWnd"))
	{
		Send #d
	}
Return


;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Folder Shortcuts ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

!Numpad0:: 

aDown:=A_TickCount
	Keywait Numpad0
	If ((A_TickCount-aDown)<400)
	{
		ShowDir("C:\Users\elliotd\Dropbox\Ss")
	}
	If ((A_TickCount-aDown)>400) and ((A_TickCount-aDown)<1000)
	{
		Loop, C:\Users\elliotd\Dropbox\Ss\*.png
		{
			FileGetTime, Time, %A_LoopFileFullPath%, C
			If (Time > Time_Orig)
			{
				Time_Orig := Time
				File := A_LoopFileFullPath
			}
		}
	Run, %File%
	}
	Return



!NumpadDot:: ShowDir("C:\Users\elliotd\Downloads")
!Numpad1:: ShowDir("C:\Users\elliotd\Dropbox")
!Numpad2:: ShowDir("C:\Users\elliotd\Dropbox\HomeShare")
!Numpad3:: ShowDir("C:\Users\elliotd\Dropbox\Scripts")
!Numpad4:: ShowDir("\\katrina\public\LatestRelease\")
!Numpad5:: ShowDir("\\draven\Builds\SalesPad4")
!Numpad6:: ShowDir("C:\Users\elliotd\Dropbox\Reports")
!Numpad7:: 
	aDown:=A_TickCount
	Keywait Numpad7
	If ((A_TickCount-aDown)<400)
	{
		ShowDir("\\draven\Testing\TestComplete")
		Return
	}
	If ((A_TickCount-aDown)>400) and ((A_TickCount-aDown)<1500)
	{
		Run, C:\Program Files\Sublime Text 2\sublime_text.exe "\\draven\testing\testcomplete\TestComplete.ahk"
		Return
	}
Return

!Numpad8:: ShowDir("\\draven\Shared Folders")
!Numpad9:: ShowDir("\\draven\Testing\Logs")

#c::Run, C:\
#p::Run, C:\Program Files (x86)\

#NumPad1::ShowStart("(testing-pc).+(TightVNC Viewer)", "C:\Program Files\TightVNC\tvnviewer.exe 10.23.0.147")
#Numpad2::ShowStart("(gp2013).+(TightVNC Viewer)", "C:\Program Files\TightVNC\tvnviewer.exe 10.23.0.113")
#Numpad3::ShowStart("(sql2005).+(TightVNC Viewer)", "C:\Program Files\TightVNC\tvnviewer.exe sql2005")
#NumPad4::ShowStart("(smartbear).+(TightVNC Viewer)", "C:\Program Files\TightVNC\tvnviewer.exe 10.23.0.164")
#NumPad5::ShowStart("(testingmultibin).+(TightVNC Viewer)", "C:\Program Files\TightVNC\tvnviewer.exe 10.23.0.157")
#NumPad6::ShowStart("(ShipToTesting).+(TightVNC Viewer)", "C:\Program Files\TightVNC\tvnviewer.exe 10.23.0.99")


;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;; Misc Shortcuts ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;s

AppsKey::Run, MyMenu.ahk
+AppsKey::AppsKey

+CapsLock::CapsLock

#l::
	Run,%A_WinDir%\System32\rundll32.exe user32.dll`,LockWorkStation
	Sleep 1000
	SendMessage, 0x112, 0xF170, 2,, Program Manager
	Return
	
NumLock::ShowStart("Spotify", A_Appdata . "\Spotify\spotify.exe", 1) ;


/*~CapsLock::
*ScrollLock::
	KeyboardLED(2,"off")
	Return
	*/
	
	
#WheelDown::Send {WheelRight 5}
#WheelUp::Send {WheelLeft 5}

XButton1 & RButton::Send {Enter}
*XButton1::XButton1

;;;;; CapsNav ;;;;;;;
/*
CapsLock & i::
       if getkeystate("alt") = 0
               Send,{Up}
       else
               Send,+{Up}
Return

CapsLock & l::
       if getkeystate("alt") = 0
               Send,{Right}
       else
               Send,+{Right}
Return

CapsLock & j::
       if getkeystate("alt") = 0
               Send,{Left}
       else
               Send,+{Left}
Return

CapsLock & k::
       if getkeystate("alt") = 0
               Send,{Down}
       else
               Send,+{Down}
Return

CapsLock & n::
   if getkeystate("alt") = 0
               Send,{Home}
       else
               Send,+{Home}
Return

CapsLock & p::
   if getkeystate("alt") = 0
           Send,{End}
   else
           Send,+{End}
Return

CapsLock & o::
   if getkeystate("alt") = 0
           Send,^{Right}
   else
           Send,+^{Right}
Return
CapsLock & m::
   if getkeystate("alt") = 0
           Send,^{Left}
   else
           Send,+^{Left}
Return

CapsLock & u::
CapsLock & h::
CapsLock & `;::
CapsLock & ,::
	Return
*/
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;; Launcher ;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
		;ControlFocus, Edit1
		;Send, {Shift Down}{Home}{Shift Up}
	}
	WinWaitActive ahk_class EVERYTHING
	if MonitorCount = 1
	{
		WinMove, ahk_class EVERYTHING,, 0,432,A_ScreenWidth/1.45,MonitorWorkAreaBottom - 432 ;can't get to re-expand when reselected
		WinWaitNotActive
		WinMove, ahk_class EVERYTHING,, 0, 716, A_ScreenWidth/1.45, MonitorWorkAreaBottom - 716
	}
	Else
	{
		WinMove, ahk_class EVERYTHING,, A_ScreenWidth,432,A_ScreenWidth/1.45,A_ScreenHeight - 432  ;can't get to re-expand when reselected
		WinWaitNotActive
		WinMove, ahk_class EVERYTHING,, A_ScreenWidth, 716, A_ScreenWidth/1.45, A_ScreenHeight - 716
	}
	
	Return

^NumPad0::
	/*IfWinExist ahk_class icoTrilly
		WinActivate
	else
		WinShow ahk_class icoTrilly
		WinMove, ahk_class icoTrilly,, 3649,0,191,416
	*/

	IfWinExist Buddy List
		WinActivate Buddy List
	else
		WinShow Buddy List
	WinMove, Buddy List,, 3605,0,234,1080
	Return
	
^NumpadDot::ShowStart("Google Chrome", "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe")
	
^Numpad1::
	aDown:=A_TickCount
	Keywait Numpad1
	If ((A_TickCount-aDown)<400)
	{
		;msgbox % (A_TickCount-adown)
		IfWinExist, ahk_class WindowsForms10.Window.8.app.0.13965fa_r11_ad1
		{
			WinActivate SalesPad
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
				 If (Time > Time_Orig)
				 {
					  Time_Orig := Time
					  exe := A_LoopFileFullPath
				 }
			}
	}
	Run %exe%
	Return

	

^Numpad2::ShowStart("SPLLC", "C:\Program Files (x86)\SalesPad.QBC\SalesPad.QBC.exe")
^Numpad3::
	ShowStart("ahk_class PX_WINDOW_CLASS", "C:\Program Files\Sublime Text 2\sublime_text.exe")
	WinWaitActive ahk_class PX_WINDOW_CLASS
	WinMove, ahk_class PX_WINDOW_CLASS,, 1920,0,1317,1073
	Return
^Numpad4::ShowStart("ahk_class Framework::CFrame", "C:\Program Files\Microsoft Office 15\root\office15\onenote.exe")	
^Numpad5::ShowStart("Microsoft Visual Studio", "C:\Dev\SalesPad4\ServPack\source\SalesPad\SalesPad.sln")

^Numpad6::
	aDown:=A_TickCount
	Keywait Numpad6
	If ((A_TickCount-aDown)<400)
		ShowStart("Microsoft SQL Server Management Studio", "C:\Program Files (x86)\Microsoft SQL Server\110\Tools\Binn\ManagementStudio\Ssms.exe")
	If ((A_TickCount-aDown)>400) and ((A_TickCount-aDown)<800)
		Run, "C:\Users\elliotd\Dropbox\Scripts\SQL\sandbox.sql"
	Return
	
^Numpad7::ShowStart("Inbox", "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe www.gmail.com")
^Numpad8::ShowStart("Calendar", "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe  --app=https://www.google.com/calendar/render?pli=1")
^Numpad9::Run, Replace.ahk

^NumpadSub::
	WinWaitActive, TWI, 2
	If ErrorLevel
		Return
	Items=128 SDRAM|100XLG|WIRE-MCD-0001|WIRE-SCD-0001|PHON-BUS-1250|ZZ-NI
	Loop,Parse,Items,|
	{
		Send !n
		Send % A_LoopField
		Send {Tab 2}
		Send 5
	}
Return



#NumpadEnter::
	loop
	{
		WinClose, ahk_class CabinetWClass
		IfWinNotExist, ahk_class CabinetWClass
			break
	}
	loop
	{
		WinClose, Greenshot image editor
		IfWinExist, Save image?
		{
			WinActivate
			Send {Enter}
		}
		IfWinNotExist, Greenshot image editor
			break
	}
	WinClose ahk_class EVERYTHING
	Notify("Windows Purged","",-1,"GC=555555 TC=White MC=White")
	Return
	
^!NumpadEnter::
	Run, Utilities\ViewScriptProcesses.ahk
	Return
	
#NumpadAdd::
	MsgBox, 36, Reset DB, Reset the database version?
	IfMsgBox Yes
	{
		RunWait, %comspec% /c "sqlcmd -E -d TWI -Q "UPDATE spDatabaseVersion SET [Database_Version] = -1"",, Hide
		RunWait, %comspec% /c "sqlcmd -E -d TWI -Q "UPDATE dwDatabaseVersion SET [Database_Version] = -1"",, Hide
	}
	Return

^!NumpadAdd::
	Run, buildprompt.ahk
	Return

^g::
	if RegExMatch(clipboard, ".+(.com|.net|.co.uk)")
		Run, chrome.exe %clipboard%
	Return

^!g::ShowStart("ahk_class #32770 grepWin", "C:\Program Files\grepWin\grepWin.exe")

; Append to clipboard
^+c::
   bak = %clipboard%
   Send, ^c
   Notify("Appended to Clipboard",clipboard,-1,"GC=555555 TC=White MC=White")
   clipboard = %bak%`r`n%clipboard%
	Return

!`::
	aDown:=A_TickCount
	Keywait ``
	If ((A_TickCount-aDown)<200)
	{
		WinGet, last_id, ID, A
		WinMinimize, A
	}		
	else
		WinActivate, ahk_id %last_id%
	Return

;!Wheelup::Win__Fling("M", false, -1)
;!WheelDown::Win__Fling("M", false, 1)

#pgup::
	DetectHiddenWindows, On 
	ControlSend, ahk_parent, ^{Up}, ahk_class SpotifyMainWindow 
	DetectHiddenWindows, Off 
	Return 

+pgdn::
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
	Sleep, 2000
	WinClose, ahk_class Chrome_WidgetWin_1
	Sleep, 2000
	Run, Chrome.exe %url_list%
	url_list = ;empty
	return