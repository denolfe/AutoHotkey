#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#WinActivateForce
#SingleInstance force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;Menu, Tray, Icon, lib\phone.ico

Menu, Tray, NoStandard
Menu, Tray, Add, Log Call, Log
Menu, Tray, Default, Log Call
Menu, Tray, Add, View Log, View
Menu, Tray, Add
Menu, Tray, Add, Exit, ExitMenu
Menu, Tray, Tip, Call Logger
Return

Log:
	
	
		Gui, Add, Edit, x22 y30 w90 h20 vWHO
		Gui, Add, Edit, x132 y30 w100 h20 vFROM
		Gui, Add, Edit, x22 y60 w210 h60 vWHAT
		Gui, Add, Button, x22 y130 w210 h50 Default vBUTTON gSUBMIT, Submit
		Gui, Add, Text, x22 y10 w90 h20 , Name:
		Gui, Add, Text, x132 y10 w90 h20 , Company:
		Gui, Show, x720 y400 h197 w250, Call Logger
		;Gui, Show, x-1915 y5 h197 w250, Call Logger
			
		callStart := A_TickCount
		
		Return
		
	SUBMIT:
		{
			Gui, Submit,
			FormatTime, current, , M/d [h:mm
			callTime := Round(((A_TickCount - callStart) / 60000))
			;msgBox, %callTime%			
			FileAppend, %current%`, %callTime%m]:%A_Tab%%who% @ %from% - %what%`n, calllog.txt
			TrayTip,Call Logged, %who% @ %from%`, %callTime% mins, 1
			SetTimer, RemoveTrayTip, 5000
			Gui, Destroy
		}
		Return
	
	return

RemoveTrayTip:
	SetTimer, RemoveTrayTip, Off
	TrayTip
	Return

View: 
	Run calllog.txt
	return
	
GuiClose:
	Gui, Destroy
	return
	
ExitMenu:
	ExitApp
	