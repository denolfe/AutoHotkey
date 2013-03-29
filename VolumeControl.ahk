#NoEnv
#Persistent, On
#SingleInstance, Force
#WinActivateForce
#NoTrayIcon
SetWinDelay,0
SetKeyDelay,0

#Include lib\Notify-old.ahk ;Cannot get to work with newer versions of lib

CoordMode,Mouse,Screen
DetectHiddenWindows, On
SetTitleMatchMode, 2

; Modeled after Volume Control from 7plus: https://code.google.com/p/7plus/ and http://www.autohotkey.com/forum/topic56419-15.html  
; Customized to use top of screen and taskbar instead of hotkey 

Edge := 0  ;Top of Screen

Inc := (A_Username = "elliotd") ? 1 : 3

SetTimer, CheckMouse, 50
Return

CheckMouse:
  MouseGetPos,mx,my
  top := (my = Edge) ? 1 : 0
Return

MouseIsOver(WinTitle) 
{
    MouseGetPos,,, Win
    return WinExist(WinTitle . " ahk_id " . Win)
}

#If top or MouseIsOver("ahk_class Shell_TrayWnd")
  WheelUp:: 
    Volume := (VA_GetMasterVolume() + Inc)  
    VA_SetMasterVolume(Volume)
        
    if(Volume < 1)
        VolumeNotifyID := Notify("Volume","",-2,"PG=100 PW=250 GC=555555 SI=0 SC=0 ST=0 TC=White MC=White AC=ToggleMute", 220)
    else
        VolumeNotifyID := Notify("Volume","",-2,"PG=100 PW=250 GC=555555 SI=0 SC=0 ST=0 TC=White MC=White AC=ToggleMute", 169)
      
    Notify("","",VA_GetMasterVolume(),"Progress",VolumeNotifyID)
    Return

  ~WheelDown:: 
    Volume := (VA_GetMasterVolume() - Inc)
    VA_SetMasterVolume(Volume)
    
    if(Volume < 1)
        VolumeNotifyID := Notify("Volume","",-2,"PG=100 PW=250 GC=555555 SI=0 SC=0 ST=0 TC=White MC=White AC=ToggleMute", 220)
    else
        VolumeNotifyID := Notify("Volume","",-2,"PG=100 PW=250 GC=555555 SI=0 SC=0 ST=0 TC=White MC=White AC=ToggleMute", 169)
      
    Notify("","",VA_GetMasterVolume(),"Progress",VolumeNotifyID)
    Return
#If   