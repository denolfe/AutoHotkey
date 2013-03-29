;xsplit script

#NoEnv
#Persistent,On
#SingleInstance,Force
#WinActivateForce
SetWinDelay,0
SetKeyDelay,0
CoordMode,Mouse,Screen

GroupAdd, Game, ahk_class Valve001
GroupAdd, Game, Battlefield
GroupAdd, Game, ahk_class WarsowWndClass


Edge = 1920

Loop
{
	MouseGetPos,mx,my
	IfWinExist XSplit Broadcaster
	{
		If (mx>Edge) && (Mon2Count < 1)
		{
			IfWinNotActive ahk_group Game
			{
				;ControlSend, ahk_parent, ^+{f2}, ahk_class WindowsForms10.Window.8.app.0.3ce0bb8
				Send ^+{f2}		
				Mon1Count = 0
				Mon2Count = 1
			}
		}
		If (mx<Edge) && (Mon1Count < 1)
		{
			;IfWinActive ahk_group Game
			;{
				ControlSend, ahk_parent, ^+{f1}, ahk_class WindowsForms10.Window.8.app.0.3ce0bb8
				Send ^+{f1}
				Mon1Count = 1
				Mon2Count = 0
			;}
		}
    Sleep,1000   ;Checks every second
	}  
 
}

