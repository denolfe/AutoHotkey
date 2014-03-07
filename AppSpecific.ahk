
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
GroupAdd, Game, ahk_exe terraria.exe

#If WinActive("ahk_class EVERYTHING") and !GetKeyState("Alt")
	
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

	; CapsLock::
	; 	If (A_PriorHotKey = A_ThisHotKey and A_TimeSincePriorHotkey < 500) 
	; 	{
	; 		Send {F2}^{a}
	; 		Sleep 50
	; 		;clipboard = ; Empty the clipboard
	; 		ClipClear()
	; 		Send ^{c}			
	; 		Send {Esc}
	; 		ClipWait
	; 		Notify("Filename Copied",clipboard,-1,"Style=Mine")
	; 	}
	; Return
#If
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
		Return

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

	^k::
		SetTitleMatchMode, 2
		If WinActive("FogBugz (Case")
		{
			WinGetTitle, Title, A
			RegExMatch(Title, "(?<=\(Case\s)\d+", caseNum)
			Send ^l
			Sleep 100
			Send f{Space}
			Sleep 100
			Send %caseNum%{Enter}
		}
		else
			Send ^k
		Return

	^i::
		SetTitleMatchMode, 2
		WinGetTitle, Title, A
		RegExMatch(Title, "(\d+)((?=:))", caseNum)
		clipboard := "Case " caseNum
		Notify("Clipboard Content",clipboard,-2,"Style=Mine")
		WinActivate, ahk_class Win32UserWindow
		Return

	F1::
		IfWinActive, New Tab
			Send ^l
		else
			Send ^t
		SendInput chrome`:`/`/chrome`/extensions`/{Enter}
		Return

;http://www.autohotkey.com/community/viewtopic.php?t=50364&start=15#p551784
#IfWinActive .*ahk .*
F1::
	ClipClear()
	Send ^c
	ClipWait
	SetTitleMatchMode, RegEx
	Run chrome.exe "http://google.com/search?btnI=1&q=%clipboard%%A_Space%Autohotkey"
	Return

#IfWinActive Microsoft SQL Server Management Studio
	F1::
		ClipSave()
		ClipClear()
		Copy()
		SetTitleMatchMode, RegEx
		Sleep 50
		
		if RegInstr(clipboard, "i)^sop|^pop|^rm|^iv")
			Run chrome.exe "http://www.tealbridge.com/free-resources/dynamics-gp-table-reference/2010/%clipboard%"
		else
			Run chrome.exe "http://google.com/search?btnI=1&q=%clipboard%%A_Space%Transact%A_Space%SQL%A_Space%site:http://msdn.microsoft.com/en-us/library"
		SetTitleMatchMode, 2
		ClipRestore()
		Return

	^l::Send {End}{Shift Down}{Home}{Shift Up}

	+Enter::Send {F5}
	
	^t::Send ^{n}

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
#IfWinActive
