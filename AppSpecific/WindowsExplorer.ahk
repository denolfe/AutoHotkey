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
		Notify("File Dir Copied",clipboard,-1,"Style=Win10")
		return

	^l::
		dir := Explorer_GetPath()
		clipboard := dir
		ClipWait
		Notify("File Dir Copied",clipboard,-1,"Style=Win10")
		return

	CapsLock::
		If (A_PriorHotKey = A_ThisHotKey and A_TimeSincePriorHotkey < 500)
		{
			FullFileName := Explorer_GetSelected()
			SplitPath, FullFileName, name, dir, ext, name_no_ext, drive
			clipboard := name
			ClipWait
			Notify("Filename Copied",clipboard,-1,"Style=Win10")
		}
	Return

	^e::
	+Enter::
		sel := Explorer_GetSelected()
		Run %Editor% "%sel%"
		Return
#IfWinActive

#IfWinActive ahk_class SearchPane
	Tab::Send {Tab}{Down}{Enter}
#IfWinActive

#If MouseIsOver("ahk_class Shell_TrayWnd")
	MButton::
		If (A_PriorHotKey = A_ThisHotKey and A_TimeSincePriorHotkey < 500)
		{
			Run taskmgr.exe
			WinWait, Task Manager
			WinActivate, Task Manager
		}
#If

#IfWinActive, ahk_class #32770 Run
	Tab::Down
#IfWinActive

#IfWinActive ahk_class ConsoleWindowClass
	^V::SendInput {Raw}%clipboard%
	^L::SendInput, {Esc}cls{Enter}
#IfWinActive
