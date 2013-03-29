#SingleInstance, force
SetBatchLines, -1

	Run notepad,,,nPID
	WinWait ahk_pid %nPID%
	Dock_HostID := WinExist("ahk_pid " . nPID)

	;Create client 1
	Gui +LastFound +ToolWindow -Caption +Border
	c1 := WinExist()
	Gui, Show, x0 y0 Hide NoActivate

	Dock_OnHostDeath := "OnHostDeath"
	Dock(c1, "w(.2,0) h(.2,0)")
return


OnExit:
	Dock_ShutDown()
	ExitApp
return

OnHostDeath:
	WinClose ahk_pid %nPID%
	gosub OnExit
return

#include Dock.ahk