If ! A_IsAdmin
{
	MsgBox, 0x34,%A_ScriptName%,  Missing Admin Privileges!`n`nWould you like to continue?
	IfMsgBox No
	{
		SplitPath, A_AhkPath,, A_AhkDir
		Run % A_AhkDir
		ExitApp
	}
	SplitPath, A_AhkPath,, A_AhkDir

	Run % A_AhkDir
}