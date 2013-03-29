;;;;SHIPTOOOOOO ;;;;
buildsdir := "\\draven\Builds\Fw4\ShipTo\"
from := "C:\Users\Admin\AppData\Local\Temp\"
to := "\\draven\testing\Logs\ShipTo\"

;Uncomment after install process is fixed
Notify("Uninstalling .NET 4.0","",-10,"Style=Mine")
RunWait, C:\cleanup_tool.exe /q:a /c:"cleanup.exe /p .NET Framework 4 /u"


If FileExist("C:\Program Files (x86)\ShipTo\uninst.exe")
{
	Runwait, C:\Program Files (x86)\ShipTo\uninst.exe
	WinWait, Uninstall
	Send !{Y}
	Sleep 3000
	Send {Enter}
}

Notify("Uninstalling ACE","",-2,"Style=Mine")
RunWait, MsiExec.exe /x {90140000-00D1-0409-0000-0000000FF1CE} /passive /quiet

;; Restore Fresh DB
;Notify("Restoring Database","",-30,"Style=Mine")
;restoreStringTWO := "exec restoreDB 'TWO','TWO', '\\draven\Testing\Database Files\ShipToTesting\TWO.bak'"
;RunWait, %comspec% /c "sqlcmd -U sa -P sa -d master -h -1 -Q "%restoreStringTWO%"",, Hide

;Loop, \\draven\Builds\Fw4\ShipTo.Internal\ShipTo*.exe, 0, 1

Loop, %buildsdir%ShipTo.Setup*.exe, 0, 1
{
    FileGetTime, Time, %A_LoopFileFullPath%, C
    If (Time > Time_Orig)
    {
        Time_Orig := Time
        FileName := A_LoopFileName
        FullFileName := A_LoopFileFullPath
    }
    
}

Version := RegExReplace(FileName, "(ShipTo.Setup.|.exe)", "")

Run % FullFileName