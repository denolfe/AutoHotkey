SetBatchLines, -1	  
DetectHiddenWIndows, on
#SingleInstance, force
CoordMode, mouse, screen
	run notepad.exe
	host := "ahk_class Notepad"
	clientNo := 5
	loop, %clientNo%
	{
		Gui,%A_Index%:Font, s8, Arial
		Gui %A_Index%:+LastFound +ToolWIndow +Border -Caption
		Gui,%A_Index%:Add, Button, gOnBtn x0 y0 h14 0x8000, %A_INdex%

		c%A_Index% := WinExist()
		
		deltaX := -80 - (A_Index-1)*22 
		Dock( c%A_Index%, "x(1,0," deltax ") y(0,0,5) w(0,20) h(0,15) t")
	}
																											
	clientNo++
	Gui %clientNo%:+LastFound +ToolWIndow +Border -Caption
	Gui,%clientNo%:Add, Text, x0 y0 0x8000, %clientNo%
	c%clientNo% := WinExist()
	Dock(c%clientNo%, "x(1,0,20) y(0,0,0) w(0,50) h(0,35)")

	clientNo++
	Gui %clientNo%:+LastFound +ToolWIndow +Border -Caption
	Gui,%clientNo%:Add, Edit, x0 y0 w50 0x8000, %clientNo%
	c%clientNo% := WinExist()
	Dock( c%clientNo%, "x(1,0,20) y(0,0,40) w(0,50) h(0,20)")

	Dock_OnHostDeath := "OnHostDeath"
return		


OnBtn:
	msgbox % A_GUI
return


FindTC:
	if Dock_HostID := WinExist(host)
	{
;		WInset, Topmost, on, ahk_id %Dock_HostId%
		SetTimer, FindTC, OFF
	;    loop, %clientNo%															
	;	{
	;   DllCall("ShowWindow", "uint", c%A_Index%, "uint", 4) 	 
	;	}

		Dock_Toggle(true)
	}
return

														 

OnHostDeath:
	SetTimer, FindTC, 100
return

#include Dock.ahk