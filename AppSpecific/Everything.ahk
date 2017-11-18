#If WinActive("ahk_class EVERYTHING") and !GetKeyState("Alt")
	
	; Needs Everything version 1.3.4.686
	; Statusbar does not show full filename in later verions

	Tab::Down
	+Tab::Send, {Up}{Shift Up}
	Shift::Return

	; Open file/folder
	+Enter::		
		StatusBarGetText, FullFileName
		Run %Editor% "%FullFileName%"
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
