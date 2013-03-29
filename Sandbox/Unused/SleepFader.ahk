; Origin  http://www.autohotkey.com/forum/topic57844.html

; Requires:
; COM.ahk - http://www.autohotkey.com/forum/viewtopic.php?t=22923
; VA.ahk - http://www.autohotkey.com/forum/viewtopic.php?t=23792

SetnumlockState, Off

waitMins = 50 ; wait before fadeout (minutes)
fadeMins = 10 ; fade out time (minutes)
doStop = 1 ; stop media player when done and set the volume back to original (1 = yes, 0 = no)
doSuspend = 0 ; suspend computer when all is done  (1 = yes, 0 = no)

Menu, Tray, Icon, Shell32.dll, 169

;if not using standard lib, add include lines
#include lib\COM.ahk
#include lib\VA.ahk

COM_CoInitialize()

Gui, Add, Text, x12 y10 w80 h20 , Wait Time
Gui, Add, Edit, x12 y30 w50 h20 vWAITTIME Left, %waitMins%
Gui, Add, Edit, x102 y30 w50 h20 vFADETIME Left, %fadeMins%
Gui, Add, Button, x12 y60 w150 h30 Default vMYBUTTON gGO, Sleep!
Gui, Add, Text, x102 y10 w60 h20 , Fade Time
; Generated using SmartGUI Creator 4.0
Gui, Show, x232 y208 h105 w176, SleepFade
Sleep 50
ControlFocus, Edit1, ahk_class AutoHotkeyGUI
Send {Shift Down}{End}{Shift Up}
Return




GuiClose:
ExitApp

GO:
{
	Gui, Submit,
	waitMins := WAITTIME
	fadeMins := FADETIME
	;msgbox,,Result, The result is %waitMins% %fadeMins%


	waitSecs := waitMins * 60000
	fadeSecs := fadeMins * 60
	origVol = 0

	TrayTip, , Time left: %waitMins% min, 1
	sleep %waitSecs%

	origVol := VA_GetMasterVolume()
	TrayTip, , Start %fadeMins% min fadeout, 1
	if origVol > 0
	{
	   loop %fadeSecs% {
		  mult := (( fadeSecs - A_Index) / fadeSecs)
		  curVol := origVol * mult
		  VA_SetMasterVolume(curVol)
		  sleep 1000
	   }
	}

	if doStop {
		SetTitleMatchMode, 2
		ControlSend, ahk_parent, {Space}, ahk_class SpotifyMainWindow
		WinClose, ahk_class iTunes
		Sleep 5000
	   VA_SetMasterVolume(origVol)
	}

	if doSuspend
	   DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)

	ExitApp

}