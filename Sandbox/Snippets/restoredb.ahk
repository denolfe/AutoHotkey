restoreDB("TWO")

ExitApp


restoreDB(DBName)
{
	Notify("Restoring " DBName " Database","",-20,"Style=Mine")
	DBLocation := "\\draven\Testing\Database Files\" GetGPVersion() "\TWO.bak"
	msgbox % DBLocation
	string1 := "ALTER DATABASE " DBName " SET SINGLE_USER WITH ROLLBACK IMMEDIATE"
	string2 := "RESTORE DATABASE [" DBName "] FROM DISK = '" DBLocation "' WITH FILE = 1, NOREWIND,  NOUNLOAD , REPLACE"
	string3 := "ALTER DATABASE " DBName " SET MULTI_USER"

	RunWait, %comspec% /c "sqlcmd -U sa -P sa -d master -h -1 -Q "%string1%"",, Hide

	RunWait, %comspec% /c "sqlcmd -U sa -P sa -d master -h -1 -Q "%string2%"",, Hide
	RunWait, %comspec% /c "sqlcmd -U sa -P sa -d master -h -1 -Q "%string3%"",, Hide

}

GetGPVersion()
{
	RegRead, GPVersion1, HKLM, SOFTWARE\Classes\Installer\Products\6A0A09CD09D2E394D8315DA41D329BDF, ProductName
	RegRead, GPVersion2, HKLM, SOFTWARE\Classes\Installer\Products\15C013CBD27B75C4EAE95A280A09C32F, ProductName
	RegRead, GPVersion3, HKLM, SOFTWARE\Classes\Installer\Products\7CCCD69894796DD4ABFE949F9AEC2E59, ProductName
	GPVersion := GPVersion1 . GPVersion2 . GPVersion3

	If RegExMatch(GPVersion, "P)\d+", matchlength)
		GPVersion := "GP" . SubStr(GPVersion, RegExMatch(GPVersion, "P)\d+", matchlength), matchlength)
	return GPVersion
}