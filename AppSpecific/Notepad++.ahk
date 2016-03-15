#IfWinActive ahk_class Notepad++
	F5::
	+Enter::
		Send ^s
		SetTitleMatchMode, RegEx
		WinGetTitle, Title, A
		If InStr(Title, ".ahk")
		{
			Run % Substr(Title, RegExMatch(Title, "P).*.ahk", matchlength), matchlength)
			Notify("File Executed",Title,-2,"GC=555555 TC=White MC=White")
		}
		Return

	^LButton::
		Send {LButton 2}
		Return
		
#IfWinActive