#IfWinActive ahk_class PX_WINDOW_CLASS
	+Enter::
		Send ^s
		SetTitleMatchMode, 2
		Sleep, 200
    	IfWinExist, unregistered
			WinClose
		SetTitleMatchMode, RegEx
		WinGetTitle, Title, A
		If InStr(Title, ".ahk")
		{
			Run % Substr(Title, RegExMatch(Title, "P).*.ahk", matchlength), matchlength)
			Notify("File Executed",Title,-2,"GC=555555 TC=White MC=White")
		}
		Return

	~^s::
		SetTitleMatchMode, 2
		Sleep, 200
    	IfWinExist, unregistered
			WinClose
		SetTitleMatchMode, RegEx
		Return

	!LButton::
		Send {LButton 2}
		Return

#IfWinActive

;http://www.autohotkey.com/community/viewtopic.php?t=50364&start=15#p551784
#IfWinActive .*ahk .*
F1::
	ClipClear()
	Send ^c
	ClipWait
	SetTitleMatchMode, RegEx
	Run chrome.exe "http://google.com/search?btnI=1&q=%clipboard%%A_Space%Autohotkey"
	Return
#IfWinActive