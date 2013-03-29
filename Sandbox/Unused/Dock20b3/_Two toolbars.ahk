SetBatchLines, -1	  
DetectHiddenWIndows, on
#SingleInstance, force
CoordMode, mouse, screen
	
	host := "ahk_class Notepad"
	Dock_hostId := WinExist(host)

	Gui +LastFound +ToolWIndow +Border -Caption 
	c1 := WinExist()
	Gui, Add, Button, gOnBtn 0x8000, something
	Gui, Add, Button,gOnBtn x+10 0x8000, something 2
	Gui, Add, Button, gOnBtn x+10 0x8000, %c1%
	Gui, Add, DropDownList, gOnBtn x+10 0x8000, 1|2|3|5
	WinSet, Transparent, 150

	Gui, 2:+LastFound +ToolWIndow +Border -Caption 
	c2 := WinExist()
	Gui, 2:Add, Button, gOnBtn 0x8000, s 1
	Gui, 2:Add, Button, gOnBtn 0x8000, s 2
	Gui, 2:Add, Button, gOnBtn 0x8000, s 3
	Gui, 2:Add, Edit,	gOnBtn 0x8000, s 3
	WinSet, Transparent, 150

	Dock_OnHostDeath := "OnHostDeath"
	Dock( c1, "x(0,.040,0) y(1,-1,-40) w(.9,0) h(0,32) t")
	Dock( c2, "x(1,-2,20)  y(0,0,50)   w(0,45) h(.5,0) t")
return								 


FindTC:
	if Dock_HostID := WinExist(host)
	{
		SetTimer, FindTC, OFF
		Dock_Toggle(true)
	}						
return

OnBtn:
	s := A_GuiControl " "
	Control, EditPaste, %s%, Edit1, ahk_id %Dock_HOstID%
return


OnHostDeath:
	SetTimer, FindTC, 50
return

#include Dock.ahk