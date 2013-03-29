#Persistent
if ! Instr(A_ComputerName, "ELLIOT")
{
	FileCreateShortcut, \\elliot-pc\c$\Users\elliotd\Dropbox\HomeShare\Work.ahk, %A_Desktop%\Work.lnk, C:\, "%A_ScriptFullPath%", Work Script
	FileCreateShortcut, \\elliot-pc\c$\Users\elliotd\Dropbox\HomeShare\Test.ahk, %A_Desktop%\Test.lnk, C:\, "%A_ScriptFullPath%", Test Script
	FileCreateShortcut, \\Draven\Testing\,  %A_Desktop%\Testing.lnk, "%A_ScriptFullPath%", Testing Folder
	FileCreateShortcut, \\draven\Builds\SalesPad4,  %A_Desktop%\Builds.lnk, "%A_ScriptFullPath%", Builds Folder
}

OnExit, ExitSub

Return

ExitSub:
FileDelete, %A_Desktop%\Work.lnk
FileDelete, %A_Desktop%\Test.lnk
FileDelete, %A_Desktop%\Testing.lnk
FileDelete, %A_Desktop%\Builds.lnk
ExitApp