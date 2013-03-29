
FarRight := -50

SysGet, FarRight2, 76
msgbox % FarRight2	

/*SysGet, MonitorCount, MonitorCount
Loop, %MonitorCount%
{
	SysGet, Monitor, Monitor, %A_Index%
    if (MonitorRight > FarRight)
		FarRight := MonitorRight
}*/

SetTimer, CheckMouse, 3000
Return

CheckMouse:
	MouseGetPos,mx,my
	side := (mx > 3800) ? 1 : 0
	msgbox % mx	
Return