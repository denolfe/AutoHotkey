#SingleInstance, force
SetBatchLines, -1

	Run notepad,,,nPID
	WinWait ahk_pid %nPID%
	Dock_HostID := WinExist("ahk_pid " . nPID)

	;Create client 1
	Gui +LastFound +ToolWindow -Caption
	c1 := WinExist()
	Gui, Add, Text, x0 y0 , 0000
	Gui, Show, y0 autosize Hide NoActivate

	OnMessage(3, "OnMove")

	;Create client 2
	Gui 2:+LastFound -Caption +ToolWindow 
	c2 := WinExist() 
	Gui, 2:Add, Text, x0 y0, 0000
	Gui, 2:Show, x0 autosize Hide NoActivate

	Dock_OnHostDeath := "OnHostDeath"
	Dock(c1, "x(.5,-.5,0) t")
	Dock(c2, "y(.5,-.5,0) t")
return


OnMove(wparam, lparam, msg, hwnd){
	global 

	WinGetPos, x, y,, , ahk_id %Dock_HostID%
	If (hwnd = c1)
		ControlSetText, Static1, %x%, ahk_Id %c1%

	If (hwnd = c2)
		ControlSetText, Static1, %y%, ahk_Id %c2%	
}


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