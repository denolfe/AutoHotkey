ShowStart(title, exe, params = "", toggle = 0)
{
	If WinActive(title) and toggle
    {
        Send, !{Tab}
		WinMinimize %title%
    }
	Else
	{
		IfWinExist, %title%
		{
			WinGet, winCount, Count, % title
		    If winCount > 1
		        WinActivateBottom, % title
		    Else
		        WinActivate, % title
		}
		Else
		{
        	Run, %exe% %params%,, UseErrorLevel
            If ErrorLevel
            {
                Notify("Executable not found", title,-3,"Style=Mine")
                Return
            }
            WinActivate
		}
	}
}

ShowDir(title)
{
    ;RegWrite, REG_DWORD, HKCU, Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState , FullPath, 1
	SetTitleMatchMode, 3
	IfWinExist, %title% ahk_class CabinetWClass
		WinActivate
	Else
	{
		Run, %title%
		WinActivate
	}
	SetTitleMatchMode, 2
}