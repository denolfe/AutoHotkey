DetectHiddenWindows, on
SetBatchLines, -1
#SingleInstance, force

	Run notepad,,,nPID
	WinWait ahk_pid %nPID%
	Dock_HostID := WinExist("ahk_pid " . nPID)

	;Create client 0
	Run calc,,,nPID
	WinWait, ahk_pid %nPID%
	c0 := WinExist("ahk_pid " . nPID) + 0
	WinSetTitle, Docked Calculator
;	WinSet, ExStyle, ^0x80				;set toolwindow 
;	WinSet, Style, -0x20000 -0x80000	;remove minimize button and system commands

	;Create client 1
	Gui +LastFound +ToolWindow +Border +Resize 	-Caption
	c1 := WinExist() + 0

	Gui, Font, , WingDings 2
	Gui Add, Button, 0x8000 gOnPin, ²
	Gui, Font
	Gui Add, Text, y+50 ,Width and position are changable.`n`nClick the button to pin/unpin the client.`n`nThis is topmost client.`nYou can put it over Notepad.
	Gui, Show, autosize Hide 
	
	;Create client 2
	Gui 2:+LastFound -Caption +ToolWindow +Border
	c2 := WinExist() + 0
		Gui 2:Add, Text,,F12 - Toggle docking for this client`nF11 - Shutdown dock module (unload module and clean)`nF10 - Activate dock module (load module)`nF09 - Enable/Disable dock module (temporary disable dock)`nF5 - Hide Notepad   F4 - Show Notepad

	;Create client 3
	Gui 3:+LastFound -Caption +ToolWindow +Border
	c3 := WinExist() + 0
	Gui 3:Add, Text,, 3

	pin := F12 := 1
	Dock_OnHostDeath := "OnHostDeath"

	Dock(c0, "x(1,,10) y() t")					;calculator can't be created hiden so "+" isn't used. Also, don't change its width & height
	Dock(c1, "x(,,10) y(1,-1,-10) w(.4) h(.5) t")
	Dock(c2, "x() y(,-1,-5) w(1) h(,80)")
	Dock(c3, "x(.5,-.5) y(1,,10) w(.5,130) h(,100)")

return


F5::
	WinHide, Untitled
return

F4:: 
    WinShow, Untitled
return

F12::
	F12 := !F12	
	if !F12
		  Dock(c2, "-")
	else  Dock(c2, "x(0,0,0) y(0,-1,-5) w(1,0) h(0,80)")
return
																													
F11::
	Dock_ShutDown()
return

F10::											 ;windows are visible here so don't use +
	Dock(c0, "x(1,0,10) y(0,0,0)")
	Dock(c1, "x(0,-1,-10) y(0,0,0) h(1,0)")		
	If F12
		Dock(c2, "x(0,0,0) y(0,-1,-5) w(1,0) h(0,80)")
	Dock(c3, "x(.5,-.5,0) y(1,0,10) w(.5,130) h(0,100)")
return

F9::
	Dock_Toggle()
return

OnPin:
	WinSet, Style, ^0xC00000, A
	pin := !pin
	If Pin
		 ControlSetText, Button1, ²
	else ControlSetText, Button1, ¯

	if pin
		 Dock(c1) 
	else Dock(c1, "-")
return

OnExit:
	Dock_ShutDown()
	ExitApp
return

OnHostDeath:
	WinClose ahk_pid %nPID%
	MsgBox Notepad died, exiting app
	gosub OnExit
return

#include Dock.ahk