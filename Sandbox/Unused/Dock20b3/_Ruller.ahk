#SingleInstance, force
SetBatchLines, -1

	Run notepad,,,nPID
	WinWait ahk_pid %nPID%
	Dock_HostID := WinExist("ahk_pid " . nPID)

	Gui, 1:margin, 0, 0
	Gui, 2:margin, 0, 0
	Gui, 1:+ToolWindow -Caption	
	Gui, 2:-Caption ToolWindow
	Gui, 1:Add, Picture, , rulerh.jpg
	Gui, 2:Add, Picture, , rulerv.jpg
	Gui, 1:Show, x0 y0 autosize NoActivate
	Gui, 2:Show, x0 y0 autosize NoActivate


	Gui, 3:-Caption ToolWindow LastFound
	ch := WinExist()
	Gui, 3:Color, 800000 
	WinSet, Transparent, 200

	Gui, 4:-Caption ToolWindow LastFound
	cv := WinExist()
	Gui, 4:Color, 800000 
	WinSet, Transparent, 200

	Gui, 5:-Caption ToolWindow LastFound
	v1 := WinExist()
	WinSet, Transparent, 200

	Gui, 6:-Caption ToolWindow LastFound
	v2 := WinExist()
	WinSet, Transparent, 200

	Gui, 7:-Caption ToolWindow LastFound
	h1 := WinExist()
	WinSet, Transparent, 200

	Gui, 8:-Caption ToolWindow LastFound
	h2 := WinExist()
	WinSet, Transparent, 200

	OnMessage(3, "OnMove")
	Dock_OnHostDeath := "OnHostDeath" 
	Dock(ch, "x() w(1) h(,20) t")
	Dock(cv, "y() h(1) w(,20) t")
	Dock(v1, "x(,-1) y() h(,1) w(,2000)")
	Dock(v2, "x(,-1) y(1) h(,1) w(,2000)")
	Dock(h1, "y(,-1) x() w(,1) h(,2000)")
	Dock(h2, "y(,-1) x(1) w(,1) h(,2000)")
return


OnMove(wparam, lparam, msg, hwnd){
	global 

	WinGetPos, , ,w,h, ahk_id %Dock_HostID%
	If (hwnd = c1)
		ControlSetText, Static1, %w%, ahk_Id %c1%

	If (hwnd = c2)
		ControlSetText, Static1, %h%, ahk_Id %c2%	
}


OnExit:
	Dock_ShutDown()
	ExitApp
return

OnHostDeath:
	WinClose ahk_pid %nPID%
	gosub OnExit
return

#include Dock.ahk