
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; App Specific Shortcuts ;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
GroupAdd, FileExplorer, ahk_class EVERYTHING
GroupAdd, FileExplorer, ahk_class CabinetWClass
GroupAdd, FileExplorer, ahk_class #32770
GroupAdd, Editor, Notepad++
GroupAdd, Editor, Microsoft SQL Server Management Studio
GroupAdd, Editor, Report Designer
GroupAdd, Editor, ahk_class PX_WINDOW_CLASS
GroupAdd, Game, ahk_class Valve001
GroupAdd, Game, Battlefield
GroupAdd, Game, ahk_class WarsowWndClass

#IfWinActive ahk_class EVERYTHING
	Tab::Down
	+Tab::Send, {Up}{Shift Up}
	Shift::Return

	+Enter::		
		StatusBarGetText, Title
		Run C:\Program Files\Sublime Text 2\sublime_text.exe "%Title%"
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
			clipboard = ; Empty the clipboard
			Send ^{c}			
			Send {Esc}
			ClipWait
			Notify("Filename Copied",clipboard,-1,"GC=555555 SI=0 SC=0 ST=500 TC=White MC=White")
		}
	Return

#IfWinActive ahk_class CabinetWClass
	Esc::
		If (A_PriorHotKey = A_ThisHotKey and A_TimeSincePriorHotkey < 500)
			WinClose
		Else
			Send, {Esc}
		Return
		
	+Backspace::Send !{Up}

	^k::
		fullfilename := Explorer_GetSelected()
		clipboard := fullfilename
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

	+Enter::
		sel := Explorer_GetSelected()
		Run C:\Program Files\Sublime Text 2\sublime_text.exe "%sel%" 

#IfWinActive ahk_class SearchPane
	Tab::Send {Tab}{Down}{Enter}

#IfWinActive ahk_class FileSearchAppWindowClass

#IfWinActive ahk_class PX_WINDOW_CLASS
	+Enter::
		Send ^s
		SetTitleMatchMode, 2
		sleep, 200
    	IfWinExist, unregistered
			WinClose
		SetTitleMatchMode, RegEx
		WinGetTitle, Title, A
		Title := RegExReplace(Title, "(\s-\s).*", "")
		Run %Title%
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

/*
#If WinActive("ahk_class Chrome_WidgetWin_1") && !FocusOn("Chrome_OmniBoxView1")
	~e::IfNotEqual,A_Cursor,IBeam, Send, ^+{Tab}
	~r::IfNotEqual,A_Cursor,IBeam, Send, ^{Tab}
	~d::IfNotEqual,A_Cursor,IBeam, Send, !{Left}
	~f::IfNotEqual,A_Cursor,IBeam, Send, !{Right}
	~x::IfNotEqual,A_Cursor,IBeam, Send, ^{F4}
	~z::Send ^+t ;undoclosetab
#If
*/


;http://www.autohotkey.com/community/viewtopic.php?t=50364&start=15#p551784
#IfWinActive .*ahk .*
F1::
	clipboard = 
	Send ^c
	ClipWait
	SetTitleMatchMode, RegEx
	;Run C:\Program Files (x86)\KeyTools\KeyHH.exe -MyHelp -#klink "%ClipBoard%" C:\Program Files (x86)\AutoHotkey\AutoHotkey.chm,,Max
	Run chrome.exe "http://google.com/search?btnI=1&q=%clipboard%%A_Space%Autohotkey"
	;SetTitleMatchMode, 2
	Return

#IfWinActive Microsoft SQL Server Management Studio
	F1::
		clipboardsave := clipboard
		clipboard = 
		Send ^c
		ClipWait
		SetTitleMatchMode, RegEx
		Sleep 50
		
		if RegInstr(clipboard, "i)^sop|^pop|^rm|^iv")
			Run chrome.exe "http://www.tealbridge.com/free-resources/dynamics-gp-table-reference/2010/%clipboard%"
		else
			Run chrome.exe "http://google.com/search?btnI=1&q=%clipboard%%A_Space%Transact%A_Space%SQL%A_Space%site:http://msdn.microsoft.com/en-us/library"
		SetTitleMatchMode, 2
		clipboard := clipboardsave
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

#IfWinActive Notepad++
	
	CapsLock & Enter::
		MouseClick, left,  136,  41
		Sleep, 100
		MouseClick, left,  266,  181
		Sleep, 100
		MouseClick, left,  525,  178
		Return
		
	^t::Send ^{n}
		
	;;;http://www.autohotkey.com/forum/topic75978.html  ???
	+Enter::
		Send ^s
		WinGetTitle, Title, A
		StringReplace, Title, Title,  - Notepad++, , All
		Run %Title%
		Notify("File Executed",Title,-2,"GC=555555 TC=White MC=White")
		Return

#IfWinActive ahk_class ConsoleWindowClass
	^V::SendInput {Raw}%clipboard%

#IfWinActive Report Designer
	^Wheelup::Send ^{NumpadAdd}		;Control+WheelUp - Zoom In
	Return
	^Wheeldown::Send ^{NumpadSub}	;Control+WheelDown - Zoom Out
	Return
#IfWinActive

~!PrintScreen::Notify("Screenshot Taken","",-2,"GC=555555 SI=0 SC=0 ST=500 TC=White MC=White")

#IfWinActive, Run
	Tab::Down

#IfWinActive, ahk_class TvnWindowClass
	CapsLock::
		(state:=!state)
		if state 
			MoveTaskbar(3,"right")	
		Else
			MoveTaskbar(3,"bottom")
		WinActivate, ahk_class TvnWindowClass
		Return

	F11::^!+f
#IfWinActive