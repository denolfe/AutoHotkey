VSNamingMode := 0
#IfWinActive Microsoft Visual Studio
	
	^+;::
		SendInput, {End};`n
	Return
	
	;; Naming Mode
	^+u::
		If (VSNamingMode)
		{
			SplashImage,,x0 y0 b fs12, VS Naming Disabled
			SetTimer, VSNamingSplash, -500
			VSNamingMode := 0
		}
		Else
		{
			VSNamingMode := 1
			SplashImage,,x0 y0 b fs12, VS Naming Enabled
		}
	Return

	$Space::
		If (VSNamingMode)
			SendInput, _
		Else 
			SendInput, {Space} 
	Return
#If

#If WinActive("Debugging") and WinActive("Microsoft Visual Studio")

	;; Set Next Statement
	MButton::
		kDown := A_TickCount
		KeyWait, % A_ThisHotkey
		If ((A_TickCount-kDown)>400)
			SendInput, {LButton}^+{F10}
		Else
			SendInput % "{" A_ThisHotkey "}"
		Return

	;; Hold Mouse4 to run to line
	;; Else
	;; Mouse4 -> F10
	XButton1::
		kDown := A_TickCount
		KeyWait, % A_ThisHotkey
		If ((A_TickCount-kDown)>400)
		{
			SendInput, {LButton}{F9}
			Sleep, 300
			SendInput, {F5}
			Sleep, 300
			SendInput, {F9}
		}
		Else
			SendInput, {F10}
		Return
	XButton2::F11 ;Mouse5

	;; Call Stack Navigation
	^XButton1::SendInput !^c{Down}{Enter}
	^XButton2::SendInput !^c{Up}{Enter}

#If

VSNamingSplash:
   SplashImage, off
Return
