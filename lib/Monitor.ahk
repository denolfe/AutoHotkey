; Code expanded from http://www.autohotkey.com/board/topic/69464-how-to-determine-a-window-is-in-which-monitor/

; Returns Key-Value array containing:
; MonitorInfo.Index
; MonitorInfo.Left
; MonitorInfo.Right
; MonitorInfo.Top
; MonitorInfo.Bottom
; MonitorInfo.Width
; MonitorInfo.Height
Monitor_Get(windowHandle)
{

	VarSetCapacity(monitorInfo, 40)
	NumPut(40, monitorInfo)
	
	if (monitorHandle := DllCall("MonitorFromWindow", "uint", windowHandle, "uint", 0x2)) 
		&& DllCall("GetMonitorInfo", "uint", monitorHandle, "uint", &monitorInfo) 
	{
		monitorLeft   := NumGet(monitorInfo,  4, "Int")
		monitorTop    := NumGet(monitorInfo,  8, "Int")
		monitorRight  := NumGet(monitorInfo, 12, "Int")
		monitorBottom := NumGet(monitorInfo, 16, "Int")
		workLeft      := NumGet(monitorInfo, 20, "Int")
		workTop       := NumGet(monitorInfo, 24, "Int")
		workRight     := NumGet(monitorInfo, 28, "Int")
		workBottom    := NumGet(monitorInfo, 32, "Int")
		isPrimary     := NumGet(monitorInfo, 36, "Int") & 1

		SysGet, monitorCount, MonitorCount

		Loop, %monitorCount%
		{
			SysGet, tempMon, Monitor, %A_Index%

			; Compare location to determine the monitor index.
			if ((monitorLeft = tempMonLeft) and (monitorTop = tempMonTop)
				and (monitorRight = tempMonRight) and (monitorBottom = tempMonBottom))
			{
				monitorIndex := A_Index
				monitorLeft := tempMonLeft
				monitorRight := tempMonRight
				monitorTop := tempMonTop
				monitorBottom := tempMonBottom
				break
			}
		}
	}
	
	MonitorInfo := []
	MonitorInfo.Insert("Index", monitorIndex)
	MonitorInfo.Insert("Left", monitorLeft)
	MonitorInfo.Insert("Right", monitorRight)
	MonitorInfo.Insert("Top", monitorTop)
	MonitorInfo.Insert("Bottom", monitorBottom)
	MonitorInfo.Insert("Width", (monitorRight - monitorLeft))
	MonitorInfo.Insert("Height", (monitorBottom - monitorTop))

	return MonitorInfo
}

; Resize and center window
Monitor_MoveOptimal(percentOfScreen = 0.90)
{
	WinGetActiveStats, A, Width, Height, X, Y
	WinGet, this_window, ID, A
	MonitorInfo := Monitor_Get(this_window)

	moderateX := MonitorInfo.Left + (MonitorInfo.Width * ((1 - percentOfScreen) / 2))
	moderateY := MonitorInfo.Top + (MonitorInfo.Height * ((1 - percentOfScreen) / 2))
	moderateW := MonitorInfo.Width * percentOfScreen
	moderateH := MonitorInfo.Height * percentOfScreen

	WinMove, A,, % moderateX, % moderateY, % moderateW, % moderateH 
}
