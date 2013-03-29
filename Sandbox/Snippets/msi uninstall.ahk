DesiredName := "dotnet"  ; Put here part of the name shown in Add/Remove.
UninstallKey := "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
Loop HKLM, %UninstallKey%, 2
{
    RegRead thisName, HKLM, %UninstallKey%\%A_LoopRegName%, DisplayName
    if InStr(thisName, DesiredName)
    {
        RegRead uninst, HKLM, %UninstallKey%\%A_LoopRegName%, UninstallString
        RegRead quiet, HKLM, %UninstallKey%\%A_LoopRegName%, QuietUninstallString
        if ErrorLevel
            quiet := "(none)"
        MsgBox,
        (LTrim
        Key:`t%A_LoopRegName%
        Name:`t%thisName%
        Uninst:`t%uninst%
        Quiet:`t%quiet%
        )
    }
}

;FYI, MsiExec usually requires the GUID of a package rather than the path of a MSI file. For example, the UninstallString for Windows Live Messenger on my system is:

;MsiExec.exe /X {80956555-A512-4190-9CAD-B000C36D6B6B}

;In this case at least, the registry key name is the same as the GUID:

;HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\[color=darkred]{80956555-A512-4190-9CAD-B000C36D6B6B}[/color]