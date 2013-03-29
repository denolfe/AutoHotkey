;Volume Control v1.10 for Windows7
;by Filipe Novais

;====================================================================================================================
;Options ============================================================================================================
;====================================================================================================================
Volume_Increments_general = 2		;Volume increments for keyboard default "Vol+" "Vol-" keys
Volume_Increments_mouse = 3		;Volume increments for mouse wheel gestures "up" "down"
Visible_Duration = 800			;Duration of Volume Control display (milliseconds)



;====================================================================================================================
;Startup ============================================================================================================
;====================================================================================================================
#Include *i VA.ahk
Volume_Increments = %Volume_Increments_general%
OnMessage(0x1001,"VC_ReceiveMessage")
	Gui 29: show, hide, Volume Control - message receiver
Menu, Tray, Icon, Shell32.dll, 169 				; Square Speaker Icon
;Menu, Tray, Icon, %SystemRoot%\system32\Mmsys.cpl,1   	 	; Standard Speaker Icon



;====================================================================================================================
;Volume OSD Background ==============================================================================================
;====================================================================================================================
Gui, 27: +AlwaysOnTop +ToolWindow -caption +LastFound
WinSet, Region, 0-0 W602 H59
Gui, 27: Color, FFFF00
Gui, 27: Add, Picture, w602 h59 x0 y0, %A_ScriptDir%\Pictures\Background.png
WinSet, TransColor, FFFF00 255



;====================================================================================================================
;Volume OSD Bars and Speakers =======================================================================================
;====================================================================================================================
Gui, 28: +AlwaysOnTop +ToolWindow -caption +LastFound
WinSet, Region, 0-0 W602 H59
Gui, 28: Color, FFFF00
WinSet, TransColor, FFFF00 255
Gui, 28: Add, Picture, w81 h59 x0 y0 gMute_On_Off vMuteOff, %A_ScriptDir%\Pictures\SpeakerSound.png
Gui, 28: Add, Picture, w81 h59 x0 y0 gMute_On_Off vMuteOn, %A_ScriptDir%\Pictures\SpeakerMute.png
startp = 83
Loop 100
	{
	Gui, 28: Add, Picture, vBF%A_Index% w5 h29 x%startp% y15 gVolume_Bar_Click, %A_ScriptDir%\Pictures\Full.png
	Gui, 28: Add, Picture, vBE%A_Index% w5 h29 x%startp% y15 gVolume_Bar_Click, %A_ScriptDir%\Pictures\Empty.png
	startp += 5
	}
return


;====================================================================================================================
;Hotkeys ============================================================================================================
;====================================================================================================================

						
$Volume_Up::					;Keyboard default "Vol+" key
Gosub, Up_Volume 
return

$Volume_down::					;Keyboard default "Vol-" key
Gosub, Down_Volume
return

$Volume_Mute::					;Keyboard default Mute/Unmute key
Gosub, Mute_On_Off
return


;====================================================================================================================
;Labels =============================================================================================================
;====================================================================================================================


Up_Volume:
volume_level := VA_GetMasterVolume()
volume_level += %Volume_Increments%
VA_SetMasterVolume(volume_level)
Gosub, Volume_Bar_Update
return


Down_Volume:
volume_level := VA_GetMasterVolume()
volume_level -= %Volume_Increments%
VA_SetMasterVolume(volume_level)
Gosub, Volume_Bar_Update
return


Volume_Bar_Update:
If WinActive("FullScreenBottomLayout")
fullscreen=1
volume_level := VA_GetMasterVolume()
SetTimer, Volume_Bar_Hide, off
Loop %volume_level%
	{
	GuiControl,28: Hide, BE%A_Index%
	GuiCOntrol,28: Show, BF%A_Index%
	}
volume_level2 := 100 - volume_level
Loop %volume_level2%
	{
	index := 101 - A_Index
	GuiCOntrol,28: Hide, BF%index%
	GuiControl,28: Show, BE%index%
	}
Volume_Bar_Update2:
if VA_GetMasterMute()
	{
	GuiControl,28: Show, MuteOn
	GuiCOntrol,28: Hide, MuteOff
	}
else
	{
	GuiControl,28: Show, MuteOff
	GuiCOntrol,28: Hide, MuteOn
	}
gosub, Show_Background
Gui, 28: Show, xCenter yCenter w602 h95
SetTimer, Volume_Bar_Hide, %Visible_Duration%
return


Volume_Bar_Hide:
SetTimer, Volume_Bar_Hide, off
Gui, 28: Hide
Gui, 27: Hide
Background_Vis=0
if fullscreen=1
	{
	sleep 300
	fullscreen=0
	WinActivate, Windows Media Player
	send, !{ENTER}
	}
return


Show_Background:
If %Background_Vis%
return
Gui, 27: Show, xCenter yCenter w602 h95
Background_Vis=1
return


Volume_Bar_Click:
Gui_Bar_To_Volume=% A_GuiControl
StringTrimLeft, volume_level, Gui_Bar_To_Volume, 2
VA_SetMasterVolume(volume_level)
Gosub, Volume_Bar_Update
return


Mute_On_Off:
if VA_GetMasterMute()
	{
	VA_SetMasterMute(false)
	Gosub, Volume_Bar_Update2
	}
else
	{
	VA_SetMasterMute(true)
	Gosub, Volume_Bar_Update2
	}
return


Volume_Mouse_on:
Volume_Increments = %Volume_Increments_mouse%
return


Volume_Mouse_off:
Volume_Increments = %Volume_Increments_general%
return


;====================================================================================================================
;Messages ===========================================================================================================
;====================================================================================================================


VC_ReceiveMessage(Message) 
	{
	if Message = 01				; Volume increase with mouse wheel gesture
		{
		Gosub, Volume_Mouse_on
		Gosub, Up_Volume
		Gosub, Volume_Mouse_off
		return
		}

	else if Message = 02			; Volume decrease with mouse wheel gesture
		{
		Gosub, Volume_Mouse_on
		Gosub, Down_Volume
		Gosub, Volume_Mouse_off
		return
		}

	else if Message = 03    		; Mute/Unmute
		Gosub, Mute_On_Off

	else if Message = 04    		; show Volume Control
		Gosub, Volume_Bar_Update

	else if Message = 05     		; Volume Control Reload script   
		Reload
	}
return


;====================================================================================================================
;====================================================================================================================
;================================================== Control Example =================================================
;====================================================================================================================
;====================================================================================================================


MButton::
If WinActive("Volume Control.ahk")
	{
	PostMessage("Volume Control - message receiver",03)
	return
	}
StartTime := A_TickCount
KeyWait, MButton
if (A_TickCount - StartTime < 500)
	{
	MouseGetPos, xpos, ypos
	MouseClick, Middle,  xpos, ypos
	return
	}
else
	{
	PostMessage("Volume Control - message receiver",04)
	return
	}
return


wheelup::
If WinActive("Volume Control.ahk")
	{
	PostMessage("Volume Control - message receiver",01)
	return
	}
send {wheelup}
return 


wheeldown::  
If WinActive("Volume Control.ahk")
	{
	PostMessage("Volume Control - message receiver",02)
	return
	}
send {wheelDown}
return


PostMessage(Receiver,Message) {
	oldTMM := A_TitleMatchMode
	oldDHW := A_DetectHiddenWindows
	SetTitleMatchMode, 3
	DetectHiddenWindows, on
	PostMessage, 0x1001,%Message%,,,%Receiver% ahk_class AutoHotkeyGUI
	SetTitleMatchMode, %oldTMM%
	DetectHiddenWindows, %oldDHW%
}
return
