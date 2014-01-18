;http://www.autohotkey.com/board/topic/42578-lib-ini-v10-basic-ini-string-functions/
;http://www.autohotkey.com/board/topic/76802-embedded-parsing-loop-and-listview/
;http://www.autohotkey.com/board/topic/63764-load-an-ini-file-in-listview-gui-control-in-autohotkey/
;http://www.autohotkey.com/board/topic/64658-listview-checkboxes/

#NoEnv 
#Singleinstance force
SendMode Input 
SetWorkingDir %A_ScriptDir%
OnExit, ExitSub

#Include lib\Notify.ahk
#Include lib\TF.ahk
#Include lib\adosql.ahk
#Include lib\ini.ahk

global Debug := 0

global Editor := "D:\Dropbox\HomeShare\Sublime-Portable\sublime_text.exe"

global RunNum := 1
global DebugFile := "\\Nasus\Testing\debug.csv"
global DebugHistFile := "\\Nasus\Testing\debughist.log"
;global Testsini := "\\Nasus\Testing\TestComplete\TestComplete.ini"
global TCFile := "\\TESTING-PC\C$\TestComplete\Scripts\TestComplete.ahk"

global DebugLog := 0
global Testing := "\\Nasus\Testing\"

global TestingResults_db := "Driver={" . GetSQLDriver() . "};Server=URGOT;Database=TestingResults;Uid=sa;Pwd=sa"

Begin:

Menu, Tray, NoStandard

if ! A_IsCompiled
	Menu, Tray, Icon, lib\images\testing.ico


{   ;; Menu
	Menu, Tray, Tip, Test Config
	Menu, Tray, Add, Load GUI, Load
	Menu, Tray, Add, Always On Top, OnTop
	Menu, Tray, Add, Debug, DebugToggle
	Menu, Tray, Default, Load gui
	Menu, Tray, Add
	Menu, Tray, Add, Edit Script, EditScript
	Menu, Tray, Add, Debug Lines, DebugLines
	Menu, Tray, Add, Reload, ReloadMenu
	Menu, Tray, Add, Exit, ExitMenu

	Menu, FileMenu, Add, &Edit, EditScript
	Menu, FileMenu, Add, &Reload , ReloadMenu  ; See remarks below about Ctrl+O.
	Menu, FileMenu, Add, &Debug Lines, DebugLines
	Menu, FileMenu, Add
	Menu, FileMenu, Add, E&xit, ExitMenu
	Menu, ScriptMenu, Add, &TestComplete.ahk, TCFileMenu
	Menu, Scriptmenu, Add, Open &Debug, DebugFileMenu
	Menu, Scriptmenu, Add, &Clear Debug, ClearDebugFileMenu
	;Menu, ScriptMenu, Add, Tests.&ini, TestsiniMenu
	Menu, TestMenu, Add, Force Pass, ForcePass
	menu, TestMenu, Add, Force Fail, ForceFail
	Menu, TestMenu, Add, Clear Job Queue, ClearJobQueue
	Menu, TestMenu, Add, Run Sprint, StartSprint
	Menu, TestMenu, Add, Run Bin Test, StartBinTest
	Menu, MyMenuBar, Add, &File, :FileMenu
	Menu, MyMenuBar, Add, &Scripts, :ScriptMenu
	Menu, MyMenuBar, Add, &Tests, :TestMenu
	Gui, Menu, MyMenuBar
}
Loading_Notification := Notify("Loading Test Config","",-1,"GC=555555 TC=White MC=White Style=Mine")


{   ;; Construct GUI
	;Gui, Tab, 1
	Gui, Add, ListView, x10 y10 w150 h173 r20 hwndHLV vBuildsLV Checked NoSort, Branch

	Gui, Add, Checkbox, x180 y25 w80 h20 vGP2010, TESTING
	Gui, Add, Checkbox, x180 y45 w70 h20 vGP2010_2, GP 2010
	Gui, Add, CheckBox, x180 y65 w70 h20 vGP2013, GP 2013
	Gui, Add, Checkbox, x180 y85 w70 h20 vGP10, GP 10
	Gui, Add, Checkbox, x180 y105 w80 h20 vGP2010_MB, GP2010 MB
	Gui, Add, Checkbox, x180 y125 w80 h20 vSpanishSQL, Spanish
	;Gui, Add, Button, x170 y160 w65 h25 vSubmit Default, Submit
	;If !(A_UserName = "elliotd")
	;	GuiControl, Disable, Submit
	Gui, Add, Button, x170 y160 w65 h25 gStart, Queue Job
	Gui, Add, GroupBox, x170 y5 w140 h150 , Testing Machines
	Gui, Add, GroupBox, x10 y295 w300 h50 , Notify Next Build
	Gui, Add, DDL, x22 y315 w100 vNextBranch gRunNext, HotFix|Custom|ServPack
	Gui, Add, Checkbox, x140 y315 w70 h20 vAutoRun, AutoRun?

	
}

{   ;; Get Testing Machine statuses and populate ListView

	Gui, Font, w600

	If GetStatus("SMARTBEAR")
		;Guicontrol,, GP2010, 1
	Gui, Add, Text, c%statuscolor% x262 y28 w40 h22 gTest, % statusname
	GuiControl, Disable, GP2010
	If GetStatus("SMARTBEAR")
	   Guicontrol,, GP2010_2, 1
	Gui, Add, Text, c%statuscolor% x262 y48 w40 h22 , % statusname
	
	If GetStatus("SQL2005")
	   ; Guicontrol,, GP10, 1
	Gui, Add, Text, c%statuscolor% x262 y88 w40 h22 , % statusname
	
	If GetStatus("TESTING4")
	   ; Guicontrol,, GP2013, 1
	Gui, Add, Text, c%statuscolor% x262 y68 w40 h20 , % statusname

	If GetStatus("TESTING3")
	   ; Guicontrol,, GP2013, 1
	Gui, Add, Text, c%statuscolor% x262 y108 w40 h20 , % statusname

	;If GetStatus("SPANISHSQL")
	;	; Guicontrol,, GP2013, 1
	;Gui, Add, Text, c%statuscolor% x262 y128 w40 h20 , % statusname

	PopulateBuilds()

	Gui, Font, w400
}



{   ;;; Monitor
	;Gui, Add, GroupBox, x10 y155 w300 h50 , Monitor
	;Gui, Add, DDL, x22 y172 w100 h200 Choose1 vBranch, Release|HotFix|Custom|CustomRelease|ServPack
	;Gui, Add, Checkbox, x140 y172 w70 h20 vAutoRun, AutoRun?
	;Gui, Add, Button, x220 y172 w80 h20 gMonitor, Start Monitor
}

{   ;;; Latest Builds ;;;
	Gui, Add, GroupBox, x10 y190 w300 h100 , Builds

	Gui, Add, Text, x20 y210 gReleaseClick, Release: 
	Gui, Add, Text, x20 y230 gHotfixClick, HotFix: 
	Gui, Add, Text, x20 y250 gCustomClick, Custom: 
	Gui, Add, Text, x20 y270 gServPackClick, ServPack: 

	Gui, Font, w600
	Gui, Add, Text, x90 y210 w100 vLatestRelease, 
	Gui, Add, Text, x90 y230 w100 vLatestHotFix, 
	Gui, Add, Text, x90 y250 w100 vLatestCustom, 
	Gui, Add, Text, x90 y270 w100 vLatestServPack, 
	Gui, Font, w400
	Gui, Add, Text, x180 y210 w100 vLatestReleaseDate
	Gui, Add, Text, x180 y230 w100 vLatestHotFixDate
	Gui, Add, Text, x180 y250 w100 vLatestCustomDate
	Gui, Add, Text, x180 y270 w100 vLatestServPackDate
}

;; findlatest was here

Gui, Add, Tab2, x315 y9 w815 h440 0x2000 , Console|Status

{   ;;; Console ;;;
	Gui, Tab, 1
	Gui, Add, ListView, x322 y39 w390 h250 vConsoleLV gConsoleClick Grid, Date|Machine|Build|ID
	GoSub, Console
	SetTimer, Console, 2000
}

{   ;;; Results ;;;

	;Gui, Tab, 2
	Gui, Add, ListView, x322 y295 w800 h150 vResultsLV Grid, Branch|Result|Test Progress|Current Test|Run Time|Latest Tested|Latest Passed|Finished
	GoSub, Results
	SetTimer, Results, 5000
}

{   ;;; Queue ;;;
	
	Gui, Tab, 2
	Gui, Add, ListView, x322 y39 w800 h200 vQueueLV Grid, Branch|GP|SQL|MB|Date
	GoSub, Queue
	SetTimer, Queue, 5000   
}
{   ;;; MachineInfo ;;;
	
	Gui, Tab, 1
	Gui, Add, ListView, x722 y39 w400 h250 vMachineInfoLV gOpenMachine Grid, Machine_Name|Locked|CurrentBranch
	GoSub, MachineInfo
	SetTimer, MachineInfo, 5000
}

;;; Gui Setup ;;;
Gui, Color, White
;WinSet, Transparent, 0 , Test Configuration

;; Get window position from last run
If ! A_IsCompiled
{
	path := ini_load(config, "Work.ini")
	Xpos := ini_getValue(config, ConfigTests, "Xpos")
	Ypos := ini_getValue(config, ConfigTests, "Ypos")
	Gui, Show, x%XPos% y%yPos% AutoSize, Test Configuration
}
Else
	Gui, Show, AutoSize, Test Configuration 

FadeIn("Test Configuration", 500)
;Winset, AlwaysOnTop, on, Test Configuration

If ! Debug
{
	Gosub, FindLatest
	SetTimer, FindLatest, 300000
}

Return

;;;;;; End Main Prog ;;;;;;

Start:
	Gui, Submit, NoHide
	Gui, ListView, BuildsLV
	;path := ini_load(ini2, "\\Nasus\Testing\TestComplete\Scheduled-SMARTBEAR.ini")
	Loop, % LV_GetCount()
	{
		LV_GetText(Branch, A_Index)
		If LV_IsRowChecked(HLV, A_Index)
		{                  
			if GP10 = 1
				AddJob(Branch, "SQL2005")
			if GP2013 = 1
				AddJob(Branch, "TESTING4")
			if GP2010_MB = 1
				AddJob(Branch, "TESTING3")
			if GP2010_2 = 1
				AddJob(Branch, "SMARTBEAR")
			if SpanishSQL = 1
				AddJob(Branch, "SPANISHSQL")
		}
	}    

	;PopulateBuilds()
Return

StartSprint:
	Gui, Submit, NoHide
	Gui, ListView, BuildsLV
	Loop, % LV_GetCount()
	{
		LV_GetText(Branch, A_Index)
		If LV_IsRowChecked(HLV, A_Index)
		{ 
			if GP10 = 1
				AddJob(Branch, "SQL2005", "Sprint")
			if GP2013 = 1
				AddJob(Branch, "TESTING4", "Sprint")
			if GP2010_MB = 1
				AddJob(Branch, "TESTING3", "Sprint")
			if GP2010_2 = 1
				AddJob(Branch, "TESTING1", "Sprint")
			if SpanishSQL = 1
				AddJob(Branch, "SPANISHSQL", "Sprint")
		}
	}
Return

StartBinTest:
	AddJob("Bin", "TESTING1", "Bin")
Return

RunNext:
	Gui, Submit, NoHide
	Notify("Monitoring: " NextBranch,"",-10,"Style=Mine")
    Menu, Tray, Tip, Monitoring: %NextBranch% ; Auto: %AutoRun% 
    countbefore := countSingleBuild(NextBranch)
    SetTimer, CheckSingleBuild, 15000
    ;countbefore := 0 ; testing

    CheckSingleBuild:
        countafter := countSingleBuild(NextBranch)
        if (countafter > countbefore)
        {

            Notify("New " NextBranch " Build Found","AutoRun: " AutoRun,-0,"Style=Mine BW=0 BC=White GC=Red AC=RunTests")
            if AutoRun = 1
            	AddJob(NextBranch, "SMARTBEAR")
            Loop 2
            {
                SoundPlay, lib\sounds\meta-online.wav
                Sleep 1000
            }           
            SetTimer, CheckSingleBuild, Off
            SetTimer, RunNext, Off
            Menu, Tray, Tip, Testing Config
            GuiControl,,NextBranch, Hotfix|ServPack|Release
        }
        ;else
            ;Notify("Before- " . countbefore . " After- " . countafter,"",-1,"Style=Mine")
return

;Buttonsubmit:
;
;	Gui, Submit, NoHide
;	Gui, ListView, BuildsLV
;
;	Loop, % LV_GetCount()
;	{
;		LV_GetText(Branch, A_Index)
;		If LV_IsRowChecked(HLV, A_Index)
;		{
;			BranchesChecked .= "'" Branch "',"
;		}
;		Else
;		{
;			BranchesUnchecked .= "'" Branch "',"
;		}
;	}
;
;	BranchesChecked := RTrim(BranchesChecked, ",")
;	BranchesUnchecked := RTrim(BranchesUnchecked, ",")
;
;	If Strlen(BranchesChecked) > 0
;	{
;		test_branch_update := "Update TestBranches Set Run = 1 where Branch in (" BranchesChecked ")"
;		ADOSQL(TestingResults_db, test_branch_update)
;	}
;		
;	If Strlen(BranchesUnchecked) > 0
;	{
;		test_branch_update := "Update TestBranches Set Run = 0 where Branch in (" BranchesUnchecked ")"
;		ADOSQL(TestingResults_db, test_branch_update)
;	}
;	test_branch_update := ""
;	
;	BranchesChecked := ""
;	BranchesUnchecked := ""
;
;Return

Load:
	Gui, Destroy
	GoSub, Begin
Return

OnTop:

	WinGet, appWindow, ID, Test Configuration
	WinGet, ExStyle, ExStyle, ahk_id %appWindow%
	if (ExStyle & 0x8)  ; 0x8 is WS_EX_TOPMOST.
	{
	   Winset, AlwaysOnTop, off, ahk_id %appWindow%
	   Menu, Tray, Uncheck, Always On Top
	   SplashImage,, x0 y0 b fs12, OFF always on top.
	   Sleep, 500
	   SplashImage, Off
	}
	else
	{
	   WinSet, AlwaysOnTop, on, ahk_id %appWindow%
	   Menu, Tray, Check, Always On Top
	   SplashImage,,x0 y0 b fs12, ON always on top.
	   Sleep, 500
	   SplashImage, Off
	}
Return

LV_IsRowChecked(HLV, Row) {
   ; HLV  HWND of the ListView control
   ; Row  One-based row number
   Static LVIS_STATEIMAGEMASK := 0xF000   ; http://www.autohotkey.com/community/viewtopic.php?p=530415#p530415
   Static LVM_GETITEMSTATE  := 0x102C   ; http://msdn.microsoft.com/en-us/library/bb761053(VS.85).aspx
   SendMessage, LVM_GETITEMSTATE, Row - 1, LVIS_STATEIMAGEMASK, , ahk_id %HLV%
   Return (((ErrorLevel & LVIS_STATEIMAGEMASK) >> 12) = 2) ? True : False
}

AddJob(branch, machine, runtype = "Full")
{
	;FormatTime, Now, A_Now, M/d/yyyy hh:mm:ss tt
	;insert_query := "INSERT INTO JOBQUEUE VALUES ('" branch "'," priority "," GetSQLVersion() ",'" GetGPVersion() "',0,'" Now "')"
	;insert_query := "INSERT INTO JOBQUEUE VALUES ('" branch "'," priority ",CAST((SELECT SQL FROM Machineinfo WHERE machine_name = '" machine "') AS VARCHAR(2)), (SELECT GP FROM Machineinfo WHERE machine_name = '" machine "'), (SELECT MB FROM Machineinfo WHERE machine_name = '" machine "'), '" Now "')"
	
	insert_query := "exec AddJob '" branch "', 5, '" machine "','" runtype "'"
	;msgbox % insert_query
	ADOSQL(TestingResults_db, insert_query)
}

AddMachineConfig()
{
	insert_query := "INSERT INTO MACHINEINFO VALUES ('" A_ComputerName "'," GetSQLVersion() ",'" GetGPVersion() "',0,0,'')"
	msgbox % insert_query
	;clipboard := insert_query
	ADOSQL(TestingResults_db, insert_query)
}

GetStatus(machine)
{
  global

  IfExist, \\%machine%\c$
  {
	statusname = Online
	statuscolor = green
	return 1
  }
  else
  {
	statusname = Offline
	statuscolor = red
	return 0
  }
   
}



GetSQLVersion()
{
	RegRead, SQLVersion, HKLM, Software\Microsoft\MSSQLServer\MSSQLServer\CurrentVersion, CurrentVersion
	If RegExMatch(SQLVersion, "P)\d*", matchlength)
		Return % SubStr(SQLVersion, 1, matchlength) ;Returns 9, 10, or 11
	Else
		Log("Unable to get SQL Version")
}

GetGPVersion()
{

	RegRead, GPVersion1, HKLM, SOFTWARE\Classes\Installer\Products\6A0A09CD09D2E394D8315DA41D329BDF, ProductName
	RegRead, GPVersion2, HKLM, SOFTWARE\Classes\Installer\Products\15C013CBD27B75C4EAE95A280A09C32F, ProductName
	RegRead, GPVersion3, HKLM, SOFTWARE\Classes\Installer\Products\7CCCD69894796DD4ABFE949F9AEC2E59, ProductName
	;; Spanish
	RegRead, GPVersionSpan, HKLM, SOFTWARE\Classes\Installer\Products\7C2554F0E4E82C84689AE7086A8B1E8E, ProductName
	GPVersion := GPVersion1 . GPVersion2 . GPVersion3 . GpVersionSpan

	If RegExMatch(GPVersion, "P)\d+", matchlength)
		GPVersion := "GP" . SubStr(GPVersion, RegExMatch(GPVersion, "P)\d+", matchlength), matchlength)
	Return GPVersion

}

Console:

	Gui, Listview, ConsoleLV
	connection_string := "Driver={" . GetSQLDriver() . "};Server=urgot;Database=TestingResults;Uid=sa;Pwd=sa"
	;select Top 16 CAST(Date AS Time(7)) as 'Time', Computer_Name, Text from Audit order by date desc
	resultset := ADOSQL( connection_string ";coldelim=`t", "
	(
		
SELECT TOP 16 CAST(DATEPART(MM, DATE) AS VARCHAR) + '/' + cast(datepart(DD, DATE) AS VARCHAR) + ' ' + CAST(DATEPART(HH, DATE) AS VARCHAR) + ':' + RIGHT('00' + CAST(DATEPART(mi, DATE) AS VARCHAR), 2)
	,Computer_Name
	,TEXT
	,JobId
FROM Audit
ORDER BY DATE DESC


	)")
	if StrLen(adosql_lasterror) > 0
		msgbox % adosql_lasterror



	if (RegExReplace(resultset, "\s", "") == RegExReplace(oldresultset, "\s", ""))
	{
		;clipboard := RegExReplace(resultset, "\s", "") "`n`n" RegExReplace(resultset, "\s", "")
		Return
	}
	else
		oldresultset := resultset

	;
	LV_Delete() ;remove columns for update
	Loop, Parse, resultset, `n ; parse each line
	{
		If A_Index = 1
			continue

		StringSplit, f, A_LoopField, `t
		LV_Add("",f1,f2,f3,f4)  ; and more if neccesarry
		Loop % f0               ; clear
		{
			f%A_Index% := ""
		}
	}

	LV_ModifyCol(1, "75")
	LV_ModifyCol(2, "100")
	LV_ModifyCol(3, "175")
Return

Results:
	
	connection_string := "Driver={" . GetSQLDriver() . "};Server=urgot;Database=TestingResults;Uid=sa;Pwd=sa"

	resultset := ADOSQL( connection_string ";coldelim=`t", "
	(
		select res.Branch, res.Result, res.TestProgress, (select top 1 CurrentTest from MachineInfo m where m.CurrentBranch = res.Branch), res.Run_Time, res.Latest_Version, res.Latest_Passed, res.Finished from vResults as res order by res.Branch ASC
		/*
		select res.Branch, res.Result, res.TestProgress, m.CurrentTest, res.Run_Time, res.Latest_Version, res.Latest_Passed, res.Finished from vResults as res
		left join MachineInfo as m on res.Branch = m.CurrentBranch
		Order by Branch ASC */
	)")
	if StrLen(adosql_lasterror) > 0
		msgbox % adosql_lasterror

	if (resultset = oldresultset)
		Return

	Gui, Listview, ResultsLV
	LV_Delete() ;remove columns for update
	Loop, Parse, resultset, `n ; parse each line
	{
		If A_Index = 1
			continue

		StringSplit, f, A_LoopField, `t

		;clipboard := A_Loopfield
		LV_Add("",f1,f2,f3,f4,f5,f6,f7,f8)  ; and more if neccesarry
		;msgbox % f6
		Loop % f0               ; clear
		{  
			f%A_Index% := ""
		}
	}

	Loop, 6
	{
		LV_ModifyCol(A_Index, "100")
		;LVX_SetColour(2, "0xff0000")
	}
	oldresultset := resultset
return

ReleaseClick:
	If A_GuiEvent = DoubleClick
		Run, \\Nasus\Testing\Logs\Release
Return

HotFixClick:
	If A_GuiEvent = DoubleClick
		Run, \\Nasus\Testing\Logs\Hotfix
Return

ServPackClick:
	If A_GuiEvent = DoubleClick
		Run, \\Nasus\Testing\Logs\ServPack
Return

CustomClick:
	If A_GuiEvent = DoubleClick
		Run, \\Nasus\Testing\Logs\Custom
Return

Test:
	If A_GuiEvent = DoubleClick
		msgbox % A_ThisLabel
Return

Queue:
	connection_string := "Driver={" . GetSQLDriver() . "};Server=urgot;Database=TestingResults;Uid=sa;Pwd=sa"

	resultset := ADOSQL( connection_string ";coldelim=`t", "
	(
		Select Branch, GP, SQL, MB = LEFT(ABS(MB),1), Date from JobQueue Order by Date asc
	)")
	if StrLen(adosql_lasterror) > 0
		msgbox % adosql_lasterror
	;msgbox % resultset

	Gui, Listview, QueueLV
	LV_Delete() ;remove columns for update
	Loop, Parse, resultset, `n ; parse each line
	{
		If A_Index = 1
			continue

		StringSplit, f, A_LoopField, `t
		LV_Add("",f1,f2,f3,f4,f5)  ; and more if neccesarry
		Loop % f0               ; clear
		{  
			f%A_Index% := ""
		}
	}

	Loop, 6
	{
		LV_ModifyCol(A_Index, "125")
		;LVX_SetColour(2, "0xff0000")
	}
Return

MachineInfo:

	Gui, Listview, MachineInfoLV

	connection_string := "Driver={" . GetSQLDriver() . "};Server=urgot;Database=TestingResults;Uid=sa;Pwd=sa"

	resultset := ADOSQL( connection_string ";coldelim=`t", "
	(
		select Machine_Name, Locked, CurrentBranch from vMachineInfo order by Locked desc

	)")
	if StrLen(adosql_lasterror) > 0
		msgbox % adosql_lasterror
	;msgbox % resultset

	;
	LV_Delete() ;remove columns for update
	Loop, Parse, resultset, `n ; parse each line
	{
		If A_Index = 1
			continue

		StringSplit, f, A_LoopField, `t
		LV_Add("",f1,f2,f3)  ; and more if neccesarry
		Loop % f0               ; clear
		{
			f%A_Index% := ""
		}
	}

	Loop, 8
	{
		LV_ModifyCol(A_Index, "110")
	}
Return

OpenMachine:
if A_GuiEvent = DoubleClick
{
    LV_GetText(RowText, A_EventInfo)  ; Get the text from the row's first field.
    ToolTip You double-clicked row number %A_EventInfo%. Text: "%RowText%"
}

Return

DebugToggle:
	If (DebugLog := !DebugLog)
		Notify("Debugging Enabled","",-2,"Style=Alert")
	else
		Notify("Debugging Disabled","",-2,"Style=Alert")
	Menu, Tray, ToggleCheck, Debug
Return

EditScript:
	Run %Editor% %A_ScriptFullPath%
return

DebugLines:
	ListLines
Return

ReloadMenu:
	Reload
Return

ExitMenu:
	ExitApp
Return

TCFileMenu:
	Run %Editor% %TCFile% 
Return

DebugFileMenu:
	Run %Editor% %DebugFile%
Return

ClearDebugFileMenu:
	FileDelete, \\Nasus\Testing\debughist.csv
	FileCopy, % DebugFile, \\Nasus\Testing\debughist.csv, 1
	FileDelete, %DebugFile%
	FileAppend,,%DebugFile%
	UpdateConsole()
return

ForcePass:
	Force("Pass")
Return

ForceFail:
	Force("Fail")
Return

ClearJobQueue:
	ADOSQL( TestingResults_db, "
	(
		Delete from JobQueue
	)")
	Gosub, Queue
Return

ConsoleClick:
	
	If A_GuiEvent = DoubleClick
	{
		LV_GetText(Machine, A_EventInfo, 1) ; Get the text of the first field.
		LV_GetText(JobID, A_EventInfo, 1) ; Get the text of the first field.
	}
return

CheckBuilds:

	countafterRelease := countBuilds("Release")
	countafterHotFix := countBuilds("HotFix")
	countafterServPack := countBuilds("ServPack")
	countafterCustom := countBuilds("Custom")

	if (countafterRelease > countbeforeRelease)
		Found("New Release Build - ", "Release")
	if (countafterHotFix > countbeforeHotFix)
		Found("New HotFix Build - ", "HotFix")
	if (countafterServPack > countbeforeServPack)
		Found("New ServPack Build - ", "ServPack")
	if (countafterCustom > countbeforeCustom)
		Found("New Custom Build - ", "Custom")
return

FindLatestFirst:
	FindLatest("Release", 0)
	FindLatest("HotFix", 0)
	FindLatest("Custom", 0)
	FindLatest("ServPack", 0)
	;FindLatest("Main", 0)
Return

FindLatest:
	FindLatest("Release")
	FindLatest("HotFix")
	FindLatest("Custom")
	FindLatest("ServPack")
	;FindLatest("Main")
Return

ExitSub:
	If ! A_IsCompiled
	{
		WinGetPos, Xpos, Ypos,,,Test Configuration
		if (Xpos < 0) or (Ypos < 0)
			ExitApp
		path := ini_load(config, "Work.ini")
		ini_replaceValue(config, "ConfigTests", "Xpos", Xpos)
		ini_replaceValue(config, "ConfigTests", "Ypos", Ypos)
		ini_save(config, "Work.ini")
	}
	FadeOut("Test Configuration", 500)
	ExitApp
Return

FindLatest(build, run = 1)
{

	Loop, \\Nasus\Builds\SalesPad4\SalesPad_4_%build%\*, 1, 0
	{
		 FileGetTime, Time, %A_LoopFileFullPath%, C
		 If (Time > Time_Orig) And (FileExist(A_LoopFileFullPath "\*withCardControl.exe"))
		 {
			Time_Orig := Time
			File := A_LoopFileName
			Folder := A_LoopFileFullPath
		 }
	}
	Loop, %Folder%\*WithCardControl.exe, 0 , 0
	{
		FileGetTime, Time, %A_LoopFileFullPath%, C
		File := A_LoopFileName
		FullFile := A_LoopFileFullPath
	}


	FormatTime, CreationDate,%Time%, M/dd h:mm
	FormatTime, CreationDay,%Time%, M/dd
	FormatTime, Today, A_Now, M/dd
	;Version := RegExReplace(File, "(SalesPad.GP.Setup.|.WithCardControl.exe)", "")
	RegExMatch(File, "\d+\.\d+\.\d*\.\d+", Version)
	if (CreationDay = Today)
	{
		Gui, Font, cGreen Bold
		GuiControl, Font, Latest%build%
		GuiControl, Font, Latest%build%Date
		GuiControl,,Latest%build%, % Version
		GuiControl,,Latest%build%Date, % CreationDate

		Gui, Font, cBlack w400
	}        
	Else
	{
		Gui, Font, cBlack w400
		GuiControl, Font, Latest%build%
		GuiControl, Font, Latest%build%Date
		GuiControl,,Latest%build%, % Version
		GuiControl,,Latest%build%Date, % CreationDate
	}
}

countBuilds(branch)   
{
	global
	count := 0
	;Loop, C:\Builds\SalesPad4\SalesPad_4_%branch%\*WithCardControl.exe, 0, 1
	Loop, \\Nasus\Builds\SalesPad4\SalesPad_4_%branch%\*WithCardControl.exe, 0, 1
	{
		count := count+1
		;msgbox % A_LoopFileName
	}
		
	return count
}

Found(text, build)
{
	global

	Loop, \\Nasus\Builds\SalesPad4\SalesPad_4_%build%\*, 2, 0
	{
		FileGetTime, Time, %A_LoopFileFullPath%, C
		If (Time > Time_Orig)
		{
			Time_Orig := Time
			Version := A_LoopFileName
		}
	}
	; Version := RegExReplace(Version, "(SalesPad.GP.Setup.|.WithCardControl.exe)", "")
	RegExMatch(Version, "\d+\.\d+\.\d*\.\d+", Version)

	FormatTime, Now,, M/dd [h:mm]
	FileAppend, %Now%`t%text%%Version%`n, \\Nasus\Testing\debug.csv
	countbefore%build% := countBuilds(build)
	Notify("New " build " Build",Version,-15,"Style=Mine BW=2 BC=White GC=Red")
}

DebugLog(text)
{
	global
	If DebugLog
	{
		FormatTime, Now,, M/dd [h:mm]
		FileAppend, %Now%`tDEBUG: %text%`n, %Testing%debug.csv
	}
}

GetLatest(branch)
{
	global
	Loop, \\Nasus\Builds\SalesPad4\SalesPad_4_%branch%\*, 1, 0
	{
		 FileGetTime, Time, %A_LoopFileFullPath%, C
		 If (Time > Time_Orig)
		 {
			  Time_Orig := Time
			  File := A_LoopFileName
			  Folder := A_LoopFileFullPath
		 }
	}

	Loop, %Folder%\*WithCardControl.exe, 0 , 0
	{
		File := A_LoopFileName
		FullFile := A_LoopFileFullPath
	}
	return % FullFile
}

GetSQLDriver()
{
	RegRead, SQLVersion, HKLM, Software\Microsoft\MSSQLServer\MSSQLServer\CurrentVersion, CurrentVersion
	If RegExMatch(SQLVersion, "P)\d*", matchlength)
		SQLVersion := SubStr(SQLVersion, 1, matchlength)

	If (SQLVersion = "9") 
		return "SQL Native Client"      ;SQL 2005
	Else If (SQLVersion = "10")
		return "SQL Server Native Client 10.0"  ;SQL 2008
	Else If (SQLVersion = "11") 
		return "SQL Server Native Client 11.0"  ;SQL 2012
}

UpdateConsole()
{
		Gui, Listview, ConsoleLV
		LV_Delete() ;remove columns for update
		DebugContents := TF_ReadLines(DebugFile)
		Loop, Parse, DebugContents, `n ; parse each line
		{
			;If A_Index = 1
			;    continue
			StringSplit, f, A_LoopField, `,
			LV_Add("",f1,f2,f3,f4,f5,f6)  ; and more if neccesarry
			Loop % f0               ; clear
			{  
				f%A_Index% := ""
			}
		}
		Loop, 6
			LV_ModifyCol(A_Index, "100")
}

countSingleBuild(branch)   
{
	count := 0
	Loop, \\Nasus\Builds\SalesPad4\SalesPad_4_%branch%\*WithCardControl.exe, 0, 1
	{
		count := count+1
		;msgbox % A_LoopFileName
	}
		
	return count
}

FadeIn(window = "A", TotalTime = 500, transfinal = 255)
{
	StartTime := A_TickCount
	Loop
	{
	   Trans := Round(((A_TickCount-StartTime)/TotalTime)*transfinal)
	   WinSet, Transparent, %Trans%, %window%
	   if (Trans >= transfinal)
		  break
	   Sleep, 10
	}
}

FadeOut(window = "A", TotalTime = 500)
{
	StartTime := A_TickCount
	Loop
	{
	   Trans := ((TimeElapsed := A_TickCount-StartTime) < TotalTime) ? 100*(1-(TimeElapsed/TotalTime)) : 0
	   WinSet, Transparent, %Trans%, %window%
	   if (Trans = 0)
		  break
	   Sleep, 10
	}
}

PopulateBuilds()
{
	Gui, Listview, BuildsLV
	LV_Delete()
	resultset := ADOSQL( TestingResults_db ";coldelim=`t", "
	(
		Select Branch, LEFT(ABS(Run),1) from TestBranches WHERE Visible = 1 ORDER BY Priority
	)")
	if StrLen(adosql_lasterror) > 0
		msgbox % adosql_lasterror


	Loop, Parse, resultset, `n ; parse each line
	{
		If A_Index = 1
			continue
		StringSplit, f, A_LoopField, `t
		;LV_Add("Check" f2, f1)
		LV_Add("Check" 0, f1)
	}

return

}

Force(result)
{
	static ForceBranch, force_query, local_result
	local_result := result
	;Gui, Add, Radio, x22 y29 w90 h20 Checked , Keyword Test
	Gui, 2: Add, DDL, x22 y29 w120 h200 vForceBranch, Release|HotFix|Custom|ServPack
	Gui, 2: Add, GroupBox, x10 y9 w150 h50 , Update Branch
	Gui, 2: Add, Button, x9 y70 w150 h30 Default g2Submit, Force!
	Gui, 2: Show, AutoSize, Update Results
	Return

	2GuiClose:
		Gui, 2: Destroy
		Return


	2Submit:
		Gui, 2: Submit
		force_query := "Update Results Set Result = '" local_result "' "
				 . "where version = (select top 1 Version from Results where Branch = '" ForceBranch "' and Computer_Name in ('SMARTBEAR','TESTING1','TESTING3') order by date desc)"   
		ADOSQL(TestingResults_db, force_query)
		Gui, 2: Destroy

		Return
}

GuiClose:
WinMinimize

Return


#If !(A_UserName = "elliotd")
	#Numpad1::ShowStart("(testing1).+(TightVNC Viewer)", "C:\Program Files\TightVNC\tvnviewer.exe testing1")
	#NumPad2::ShowStart("(smartbear).+(TightVNC Viewer)", "C:\Program Files\TightVNC\tvnviewer.exe smartbear")
	#NumPad3::ShowStart("(testing3).+(TightVNC Viewer)", "C:\Program Files\TightVNC\tvnviewer.exe testing3")
	#Numpad4::ShowStart("(testing4).+(TightVNC Viewer)", "C:\Program Files\TightVNC\tvnviewer.exe testing4")
	#Numpad5::ShowStart("(sql2005).+(TightVNC Viewer)", "C:\Program Files\TightVNC\tvnviewer.exe sql2005")
#If

ShowStart(title, exe, toggle = 0)
{
	If WinActive(title) and toggle
		WinMinimize %title%
	Else
	{
		IfWinExist, %title%
			WinActivate
		else
		{
        	Run, %exe%,, UseErrorLevel
            If ErrorLevel
            {
                msgbox, Executable not found!
                Return
            }
            WinActivate
		}
	}
}