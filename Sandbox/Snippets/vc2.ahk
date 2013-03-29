#NoEnv
#Persistent
#SingleInstance,Force
#WinActivateForce
#NoTrayIcon
SetWinDelay,0
SetKeyDelay,0
#Include lib\Notify-0.4991.ahk

CoordMode,Mouse,Screen
DetectHiddenWindows, On
SetTitleMatchMode, 2

; Volume Control from 7plus: http://www.autohotkey.com/forum/topic56419-15.html

Edge = 0	;Top of Screen
Inc := 1

Loop
{
	MouseGetPos,mx,my
	top := If (my=Edge) ? 1 : 0
	Sleep , 50
}

MouseIsOver(WinTitle) {
    MouseGetPos,,, Win
    return WinExist(WinTitle . " ahk_id " . Win)
}

#If top or MouseIsOver("ahk_class Shell_TrayWnd")
WheelUp:: 
	Volume := (VA_GetMasterVolume() + Inc)
	VA_SetMasterVolume(Volume)
	VolumeNotifyID := Notify("Volume","",-3,"PG=100 PW=250 GC=555555 SI=0 SC=0 ST=0 TC=White MC=White BW=0 Image=169")
	Notify("","",VA_GetMasterVolume(),"Update=" VolumeNotifyID)
	Notify("","",-1,"Wait=" VolumeNotifyID)
	Return

~WheelDown:: 
	Volume := (VA_GetMasterVolume() - Inc)
	VA_SetMasterVolume(Volume)
	;VolumeNotifyID := Notify("Volume","",-3,"PG=100 PW=250 GC=555555 SI=0 SC=0 ST=0 TC=White MC=White BW=0 Image=169")
	;Notify("","",VA_GetMasterVolume(),"Update=" VolumeNotifyID)
	;Notify("","",-1,"Wait=" VolumeNotifyID)

	VolumeNotifyID := Notify("Volume","",VA_GetMasterVolume(),"PG=100 PW=250 GC=555555 SI=0 SC=0 ST=0 TC=White MC=White BW=0 Image=169")
	Notify("Volume","",VA_GetMasterVolume(),"Update=" VolumeNotifyID)
	Notify("","",-1,"Wait=" VolumeNotifyID)


	Return
#If		