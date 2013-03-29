#Persistent
#SingleInstance force
CoordMode, Mouse, Screen  ; Absolute screen coordinates

SetTimer, MouseCheck, 1000 ;check every 100ms or however often
Return

MouseCheck:
	MouseGetPos, posX, posY ; Get mouse position0

	If (posX = posXbefore) and (posY = posYbefore)
		msgbox, didn't move
	else
	{
		posXbefore := posX
		posYbefore := posY
	}
Return