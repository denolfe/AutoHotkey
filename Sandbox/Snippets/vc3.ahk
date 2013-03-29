CoordMode,Mouse,Screen
DetectHiddenWindows, On
SetTitleMatchMode, 2

Loop
{
	MouseGetPos,mx,my
	top := (my=0) ? 1 : 0
	Sleep 50
}

MouseIsOver(WinTitle) {
    MouseGetPos,,, Win
    return WinExist(WinTitle . " ahk_id " . Win)
}

#If top or MouseIsOver("ahk_class Shell_TrayWnd")
WheelUp:: Send {Volume_Up}
~WheelDown:: Send {Volume_Down}
#If		