#IfWinActive, ahk_class Chrome_WidgetWin

	^;::
		IfWinActive, New Tab
			Send ^l
		else
			Send ^t
		Send vs{space}		
		Return
	
	F1::
		IfWinActive, New Tab
			Send ^l
		else
			Send ^t
		SendInput chrome`:`/`/chrome`/extensions`/{Enter}
		Return
#IfWinActive