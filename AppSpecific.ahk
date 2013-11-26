
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; App Specific Shortcuts ;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		

GroupAdd, FileExplorer, ahk_class CabinetWClass
GroupAdd, FileExplorer, ahk_class ExplorerWClass
GroupAdd, FileExplorer, ahk_class Progman
GroupAdd, FileExplorer, ahk_class #32770
GroupAdd, Editor, Notepad++
GroupAdd, Editor, Microsoft SQL Server Management Studio
GroupAdd, Editor, Report Designer
GroupAdd, Editor, ahk_class PX_WINDOW_CLASS
GroupAdd, Game, ahk_class Valve001
GroupAdd, Game, Battlefield
GroupAdd, Game, ahk_class WarsowWndClass
GroupAdd, Game, ahk_exe terraria.ahk

#IfWinActive ahk_class EVERYTHING
	Tab::Down
	+Tab::Send, {Up}{Shift Up}
	Shift::Return

	+Enter::		
		StatusBarGetText, Title
		Run %Editor% "%Title%"
		WinActivate, ahk_class PX_WINDOW_CLASS
	Return

	^j::
		StatusBarGetText, FullFileName
		SplitPath, FullFileName, name, dir, ext, name_no_ext, drive
		Run, %dir%
		return

	^k::
		StatusBarGetText, FullFileName
		clipboard := FullFileName
		ClipWait
		Notify("Full Filename Copied",clipboard,-1,"Style=Mine")
		return

	^l::
		StatusBarGetText, FullFileName
		SplitPath, FullFileName, name, dir, ext, name_no_ext, drive
		clipboard := dir
		ClipWait
		Notify("File Dir Copied",clipboard,-1,"Style=Mine")
		return

	CapsLock::
		If (A_PriorHotKey = A_ThisHotKey and A_TimeSincePriorHotkey < 500) 
		{
			Send {F2}^{a}
			Sleep 50
			;clipboard = ; Empty the clipboard
			ClipClear()
			Send ^{c}			
			Send {Esc}
			ClipWait
			Notify("Filename Copied",clipboard,-1,"Style=Mine")
		}
	Return

#IfWinActive ahk_class CabinetWClass
	F6::
		;RegWrite, REG_DWORD, HKCU, Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState, FullPath, 1
		WinGetActiveTitle, title
		Run, C:\Program Files (x86)\Everything\Everything.exe -path "%title%"
		WinWaitActive, Everything,, 3
		If Errorlevel
			Return
		Send {End}
	Return

	F7::
		WinGetActiveTitle, title
		Run, C:\Program Files\grepWin\grepWin.exe /searchpath:%title%
		WinActivate, grepWin,, 3
		If ErrorLevel
			Return
	Return

	Esc::
		If (A_PriorHotKey = A_ThisHotKey and A_TimeSincePriorHotkey < 500)
			WinClose
		Else
			Send, {Esc}
		Return
		
	+Backspace::Send !{Up}

	^k::
		clipboard := Explorer_GetSelected()
		ClipWait
		Notify("File Dir Copied",clipboard,-1,"Style=Mine")
		return

	^l::
		dir := Explorer_GetPath()
		clipboard := dir
		ClipWait
		Notify("File Dir Copied",clipboard,-1,"Style=Mine")
		return

	CapsLock::
		If (A_PriorHotKey = A_ThisHotKey and A_TimeSincePriorHotkey < 500) 
		{		
			FullFileName := Explorer_GetSelected()
			SplitPath, FullFileName, name, dir, ext, name_no_ext, drive
			clipboard := name
			ClipWait
			Notify("Filename Copied",clipboard,-1,"Style=Mine")
		}
	Return

	^e::
	+Enter::
		sel := Explorer_GetSelected()
		Run %Editor% "%sel%" 

#IfWinActive ahk_class SearchPane
	Tab::Send {Tab}{Down}{Enter}

#IfWinActive ahk_class FileSearchAppWindowClass

#IfWinActive ahk_class PX_WINDOW_CLASS
	F5::
	+Enter::
		Send ^s
		SetTitleMatchMode, 2
		sleep, 200
    	IfWinExist, unregistered
			WinClose
		SetTitleMatchMode, RegEx
		WinGetTitle, Title, A
		If InStr(Title, ".ahk")
			Run % Substr(Title, RegExMatch(Title, "P).*.ahk", matchlength), matchlength)
		;Else InStr(Title, ".rb")
		;{
		;	FullFile := Substr(Title, RegExMatch(Title, "P).*.*", matchlength), matchlength)
		;	SplitPath, FullFile, name, dir, ext, name_no_ext, drive
		;	Run, cmd /K "cd /d %dir%"
		;}
		Notify("File Executed",Title,-2,"GC=555555 TC=White MC=White")
		Return

	~^s::
		SetTitleMatchMode, 2
		sleep, 200
    	IfWinExist, unregistered
			WinClose
		SetTitleMatchMode, RegEx
		Return

#If MouseIsOver("ahk_class Shell_TrayWnd")
	MButton::
		If (A_PriorHotKey = A_ThisHotKey and A_TimeSincePriorHotkey < 500)
		{	
			Run taskmgr.exe
			WinWait, Task Manager
			WinActivate, Task Manager
		}
#If

#IfWinActive, ahk_class Chrome_WidgetWin_1

	^;::
		IfWinActive, New Tab
			Send ^l
		else
			Send ^t
		Send f{space}		
		Return
	
	^/::
		IfWinActive, New Tab
			Send ^l
		else
			Send ^t
		Send spdocs{space}
		Return

	F1::
		IfWinActive, New Tab
			Send ^l
		else
			Send ^t
		SendInput chrome`:`/`/chrome`/extensions`/{Enter}
		Return

	;^LButton::Send, ^+{Tab} ;Tab Left
	;^RButton::Send, ^{Tab}	;Tab Right

;http://www.autohotkey.com/community/viewtopic.php?t=50364&start=15#p551784
#IfWinActive .*ahk .*
F1::
	ClipClear()
	;clipboard = 
	Send ^c
	ClipWait
	SetTitleMatchMode, RegEx
	;Run Utilities\KeyHH.exe -MyHelp -#klink "%ClipBoard%" Utilities\AutoHotkey.chm,,Max
	Run chrome.exe "http://google.com/search?btnI=1&q=%clipboard%%A_Space%Autohotkey"
	;SetTitleMatchMode, 2
	Return

#IfWinActive Microsoft SQL Server Management Studio
	F1::
		ClipSave()
		ClipClear()
		;clipboardsave := clipboard
		;clipboard = 
		Send ^c
		ClipWait
		SetTitleMatchMode, RegEx
		Sleep 50
		
		if RegInstr(clipboard, "i)^sop|^pop|^rm|^iv")
			Run chrome.exe "http://www.tealbridge.com/free-resources/dynamics-gp-table-reference/2010/%clipboard%"
		else
			Run chrome.exe "http://google.com/search?btnI=1&q=%clipboard%%A_Space%Transact%A_Space%SQL%A_Space%site:http://msdn.microsoft.com/en-us/library"
		SetTitleMatchMode, 2
		;clipboard := clipboardsave
		ClipRestore()
	Return

	^l::Send {End}{Shift Down}{Home}{Shift Up}

	+Enter::Send {F5}
	
	^t::Send ^{n}

#IfWinActive, FogBugz		
	::--::
		Send --`nElliot`nSalesPad`nsupport@salespad.net
		Return

#IfWinActive, ahk_group Editor
	
	CapsLock::
		If (A_PriorHotKey = A_ThisHotKey and A_TimeSincePriorHotkey < 500)
			Send {End}{Shift Down}{Home}{Shift Up}
		Return

#IfWinActive ahk_class ConsoleWindowClass
	^V::SendInput {Raw}%clipboard%

#IfWinActive Report Designer
	^Wheelup::Send ^{NumpadAdd}		;Control+WheelUp - Zoom In
	Return
	^Wheeldown::Send ^{NumpadSub}	;Control+WheelDown - Zoom Out
	Return

~!PrintScreen::Notify("Screenshot Taken","",-2,"GC=555555 SI=0 SC=0 ST=500 TC=White MC=White")

#IfWinActive, ahk_class #32770 Run
	Tab::Down

#IfWinActive, ahk_class TvnWindowClass
	CapsLock::
		(state := !state)
		if state 
			MoveTaskbar(1,"right")	
		Else
			MoveTaskbar(1,"bottom")
		WinActivate, ahk_class TvnWindowClass
		Return

	F11::^!+f


#IfWinActive, ahk_class WindowsForms10.Window.8.app.0.13965fa_r11_ad1
	^!n::
		WinWaitActive, SalesPad, 2
		If ErrorLevel
			Return
		Items := "128 SDRAM|100XLG|WIRE-MCD-0001|ZZ-NI"
		Loop,Parse,Items,|
		{
			Send !n
			Send % A_LoopField
			Send {Tab 2}
			Send 5
		}
	Return

	^n::
		Send !acu
		Send Aaron{Enter}
		Sleep 1000
		Send {Space}
		Send !o
	Return
#If

#If WinActive("ahk_exe terraria.exe") or WinActive("ahk_exe warsow.exe")
	+F12:: ; Toggle Windowed-Borderless
		WinGet, TempWindowID, ID, A
		If (WindowID != TempWindowID)
		{
		  WindowID:=TempWindowID
		  WindowState:=0
		}
		If (WindowState != 1)
		{
		  WinGetPos, WinPosX, WinPosY, WindowWidth, WindowHeight, ahk_id %WindowID%
		  WinSet, Style, ^0xC40000, ahk_id %WindowID%
		  WinMove, ahk_id %WindowID%, , 0, 0, A_ScreenWidth, A_ScreenHeight
		}
		Else
		{
		  WinSet, Style, ^0xC40000, ahk_id %WindowID%
		  WinMove, ahk_id %WindowID%, , WinPosX, WinPosY, WindowWidth, WindowHeight
		}
		WindowState:=!WindowState
	Return
#If

#If WinActive("ahk_exe terraria.exe")

	;$`::Suspend
	$XButton1::SendKey("1")		; Boomerang
	$XButton2::SendKey("6")		; Sword
	$MButton::Gosub, HoldLClick
	$WheelUp::SendKey("4")		; Torch
	$WheelDown::SendKey("3")	; Staff
	$LButton::Gosub, LClick 	; Continuous attack if held
	$RButton::Gosub, Hook 		; Hook
	$f::RButton 				; F is now right click
	 
	LClick:
		SetMouseDelay, 40
		Send, {Click}
		Sleep 100
		While GetKeyState("LButton", "P")
	    {
	    	SendClick()
	    } 
		Return	

	Hook:
		SendKey("e", 100)
		While GetKeyState("RButton", "P")
	    {
	    	SendKey("e", 80)
	    }
		Return

	HoldLClick:
	    Toggle := !Toggle
	    If Toggle
	    {
	    	Send {LButton Down}
	    	SplashImage,,x0 y0 b fs12, Holding Left Click
	    }
	    else
	    {
	    	Send {LButton Up}
	    	SplashImage, off
	    }
		Return

	SendKey(key, delay = 0) ; Terraria does not recognize simple keypresses, must be held
	{
		SendInput % "{" key " down}"
		Sleep 25
		SendInput % "{" key " up}"
		Sleep %delay%
	}

	SendClick(delay = 0)
	{
		Send {Click}
		Sleep %delay%
	}
#If 