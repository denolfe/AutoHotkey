#If WinActive("ahk_class EVERYTHING") and !GetKeyState("Alt")
	
	Tab::Down
	+Tab::Send, {Up}{Shift Up}
	Shift::Return

	; Open file/folder
	+Enter::		
		StatusBarGetText, Title
		Run %Editor% "%Title%"
		WinActivate, ahk_class PX_WINDOW_CLASS
		Return

	; Add folder to existing instance
	^+Enter::
		StatusBarGetText, Title
		Run, %Editor% "%Title%" -a
		WinActivate, ahk_class PX_WINDOW_CLASS
		Return

	^j::
		StatusBarGetText, FullFileName
		SplitPath, FullFileName, name, dir, ext, name_no_ext, drive
		Run, "%dir%"
		Return

	^k::
		StatusBarGetText, FullFileName
		clipboard := FullFileName
		ClipWait
		Notify("Full Filename Copied",clipboard,-1,"Style=Mine")
		Return

	^l::
		StatusBarGetText, FullFileName
		SplitPath, FullFileName, name, dir, ext, name_no_ext, drive
		clipboard := dir
		ClipWait
		Notify("File Dir Copied",clipboard,-1,"Style=Mine")
		Return
#If
