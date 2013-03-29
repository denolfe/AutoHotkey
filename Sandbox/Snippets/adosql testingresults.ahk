#NoEnv
#WinActivateForce
#SingleInstance force
#Persistent
Sendmode Input
SetWorkingDir %A_ScriptDir%
SetTitleMatchmode, 2
DetectHiddenWindows, On
;#Include Mymethods.ahk
;#Include lib\Notify.ahk
#Include lib\adosql.ahk



/*
connection_string := "Driver={" . GetSQLDriver() . "};Server=urgot;Database=TestingResults;Uid=sa;Pwd=sa"

;query := "INSERT INTO [dbo].[Results] VALUES ('" EndTime "', '" branch "', '" version "', '" GetResult(LogFile) "', '" A_ComputerName "')"

resultset := ADOSQL( connection_string ";coldelim=|", "
(
	Select DISTINCT Branch
	,Latest = (select top 1 Version from URGOT.TestingResults.dbo.Results as b where a.Branch = b.Branch AND Computer_Name = 'SMARTBEAR' order by Date desc)
	  ,Result = (select top 1 Result from URGOT.TestingResults.dbo.Results as b where a.Branch = b.Branch AND Computer_Name = 'SMARTBEAR' order by Date desc)
	  ,Latest_Passed = (select top 1 Version from URGOT.TestingResults.dbo.Results as b where Result = 'Pass' and a.Branch = b.Branch AND Computer_Name = 'SMARTBEAR' order by Date desc)
	  ,Finished = CONVERT(VARCHAR(19), (Select top 1 Date from URGOT.TestingResults.dbo.Results as b where a.Branch = b.Branch AND Computer_Name = 'SMARTBEAR' order by Date desc), 120)
	  from URGOT.TestingResults.dbo.Results as a
	Where Branch in ('Release','Hotfix','Custom','CustomRelease','ServPack') AND Result in ('Pass','Fail')
	AND Computer_Name = 'SMARTBEAR'
	Order by Branch ASC
)")


StringSplit, Results, resultset, `n

;msgbox % Results0
Release := Results1
HotFix := Results2
Custom := Results3
CustomRelease := Results4





Loop, 6
{
	msgbox % Results%a_index%
Loop % Results%a_index%
{
	If RegexMatch(Results%a_index%, "Release*")
		Release := Results%a_index%
	Else If RegexMatch(Results%a_index%, "HotFix*")
		HotFix := Results%a_index%
	Else IF RegexMatch(Results%a_index%, "Custom*")
		Custom := Results%a_index%
	Else If RegexMatch(Results%a_index%, "CustomRelease*")
		CustomRelease := Results%a_index%
	Else If RegexMatch(Results%a_index%, "ServPack*")
		ServPack := Results%a_index%
}
}

msgbox % Release

Loop, Parse, Release, |
	msgbox % A_LoopField


;MsgBox % ADOSQL( connection_string ";coldelim=   `t", "
;(
;	Select DISTINCT Branch = Case Branch 
;	  When 'HotFix' THEN Branch + ' - Internal'
;	  When 'Custom' THEN Branch + ' - Internal'
;	  When 'CustomRelease' THEN 'Custom Release'
;	  Else Branch
;	  END
;	,Latest_Version = (select top 1 Version from URGOT.TestingResults.dbo.Results as b where a.Branch = b.Branch AND Computer_Name = 'SMARTBEAR' order by Date desc)
;	  ,Result = (select top 1 Result from URGOT.TestingResults.dbo.Results as b where a.Branch = b.Branch AND Computer_Name = 'SMARTBEAR' order by Date desc)
;	  ,Latest_Passed = (select top 1 Version from URGOT.TestingResults.dbo.Results as b where Result = 'Pass' and a.Branch = b.Branch AND Computer_Name = 'SMARTBEAR' order by Date desc)
;	  ,Finished = CONVERT(VARCHAR(19), (Select top 1 Date from URGOT.TestingResults.dbo.Results as b where a.Branch = b.Branch AND Computer_Name = 'SMARTBEAR' order by Date desc), 120)
;	  from URGOT.TestingResults.dbo.Results as a
;	Where Branch in ('Release','Hotfix','Custom','CustomRelease','ServPack') AND Result in ('Pass','Fail')
;	AND Computer_Name = 'SMARTBEAR'
;	Order by Branch ASC
;)")










;ADOSQL(connection_string, query)

GetSQLDriver()
{
	RegRead, SQLVersion, HKLM, Software\Microsoft\MSSQLServer\MSSQLServer\CurrentVersion, CurrentVersion
	If RegExMatch(SQLVersion, "P)\d*", matchlength)
		SQLVersion := SubStr(SQLVersion, 1, matchlength)

	If (SQLVersion = "9") 
		return "SQL Native Client"		;SQL 2005
	Else If (SQLVersion = "10")
		return "SQL Server Native Client 10.0" 	;SQL 2008
	Else If (SQLVersion = "11") 
		return "SQL Server Native Client 11.0"	;SQL 2012
}

/*

restoreDB("TWO")
Exitapp

restoreDB(DBName)
{
	;Notify("Restoring " DBName " Database","",-20,"Style=Mine")

	If ! InStr(A_ComputerName, "MULTIBIN")
		DBLocation := "\\draven\Testing\Database Files\" GetGPVersion() "\" DBName ".bak"
	Else
		DBLocation := "\\draven\Testing\Database Files\" GetGPVersion() "\MB\" DBName ".bak"
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


/*


buildsdir := "\\draven\Builds\Fw4\ShipTo\"
from := "C:\Users\Admin\AppData\Local\Temp\"
to := "\\draven\testing\Logs\ShipTo\"

path := ini_load(ini, "\\draven\Testing\TestComplete\ShipToTesting.ini") 
value := ini_getValue(ini, "LastInstall", "File")
msgbox % value

SetTimer, CheckFiles, 15000


CheckFiles:

Loop, %buildsdir%*.exe, 0, 1
{

    FileGetTime, Time, %A_LoopFileFullPath%, C
    If (Time > Time_Orig)
    {
    	If ! (A_LoopFileFullPath = value)
    	{
    		Time_Orig := Time
    		FullFilePath := A_LoopFileFullPath
    	}
    }
}

msgbox % FullFilePath

If ! (FullFilePath = value)
{
	msgbox % FullFilePath "`n`n" value
	value := ini_replaceValue(ini, "LastInstall", "File", FullFilePath)
	ini_save(ini, "\\draven\Testing\TestComplete\ShipToTesting.ini")
	Goto, StartTest	
}

Return


StartTest:

msgbox, new!!




/*

WinWaitActive, TWI
Items=128 SDRAM|100XLG|WIRE-MCD-0001|WIRE-SCD-0001|PHON-BUS-1250|ZZ-NI
Loop 2
{
	Loop,Parse,Items,|
	{
		Send !n
		Send % A_LoopField
		Send {Tab 2}
		Send 5
	}
}


ExitApp

/*
