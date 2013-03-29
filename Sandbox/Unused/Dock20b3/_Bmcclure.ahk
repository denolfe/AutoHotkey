SetBatchLines, -1	  
DetectHiddenWIndows, on
#SingleInstance, force
CoordMode, mouse, screen
	

	Run, Notepad
	WinWait, Untitled
	Send !Fp
	Send !n
	host := "Print"

	Gui +LastFound +ToolWIndow -Caption
	c1 := WinExist()
	Gui, Add, Button, gOnBtn 0x8000, something
	Gui, Add, Button,gOnBtn x+10 0x8000, something 2
	Gui, Add, Button, gOnBtn x+10 0x8000, %c1%
	Gui, Add, DropDownList, xm gOnBtn  0x8000, 1|2|3|5
	Gui, Add, Text, xm yp+100 gOnBtn  0x8000, Press F12 to toggle dock on/off

	Dock_OnHostDeath := "OnHostDeath"
 	Dock(c1)
return								 

F12::
	if Dock_Toggle()
		DllCall("ShowWindow", "uint", c1, "uint", 4)
	else WinHide, ahk_id %c1%
return


FindTC:
	if Dock_HostID := WinExist(host)
	{
		SetTimer, FindTC, OFF
		ControlGetPos, x,y,w,h,	SysTabControl321, ahk_id %Dock_HostID%
		WinGetPos, wh, wy, ww, wh, ahk_id %Dock_HostID%
		x+=10, y+=25, h-=30,  w-=15 
		def = x(,,%x%) y(,,%y%) w(,%w%) h(,%h%) t
 		Dock( c1, def)
		Dock_Toggle(true)
	}						
return

OnBtn:
;	WinActivate, ahk_id %Dock_HostId%
;	sleep 5
	s := A_GuiControl " "
	Control, EditPaste, %s%, Edit1, ahk_id %Dock_HOstID%

;	Send, %A_GuiControl%
return


OnHostDeath:
	SetTimer, FindTC, 50
return

#include Dock.ahk