StartDBGView()
{
	if(FileExist(A_ScriptDir "\Utilities\DebugView\Dbgview.exe"))
	{
		CoordMode, Mouse, Relative 
		;Debug view
		a_scriptPID := DllCall("GetCurrentProcessId")	; get script's PID
		if(WinExist("ahk_class dbgviewClass")) ; kill it if the debug viewer is running from an older instance
		{
			winactivate, ahk_class dbgviewClass
			Winwaitactive, ahk_class dbgviewClass
			winclose, ahk_class dbgviewClass
			WinWaitNotActive ahk_class dbgviewClass
		}
		Run %A_ScriptDir%\Utilities\DebugView\Dbgview.exe /f,,UseErrorLevel
		winwait, ahk_class dbgviewClass
		winactivate, ahk_class dbgviewClass
		Winwaitactive, ahk_class dbgviewClass
		Send ^l
		winwait, DebugView Filter
		winactivate, DebugView Filter
		Winwaitactive, DebugView Filter
		MouseGetPos, x,y
		mouseclick, left, 125, 85,,0
		MouseMove, x,y,0
		send, [%a_scriptPID%*{Enter}
		;send, !M{Down}{Enter}
		Coordmode, Mouse, Screen
		OutputDebug, DBGView Filtering on %A_ScriptName%
	}
}