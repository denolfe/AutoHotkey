;#Hotstring EndChars -()[]{}:;'"/\,.?!`n `t

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; Hotstrings ;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

:*:ahkskel::{#}NoEnv`n{#}WinActivateForce`n{#}SingleInstance force`nSendMode Input`nSetWorkingDir %A_ScriptDir%`nSetTitleMatchMode, 2`n
:*:ahk;::AutoHotkey
:*:date;::
:*:now;::
	SendInput % A_MM "/" A_DD "/" A_YYYY
	Return
:*:comspec;::RunWait, `%comspec`% /c "",, Hide{Ctrl Down}{Left 2}{Ctrl Up}{Right}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; DokuWiki ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

:*:ref;::[([[link|name]])]{Ctrl Down}{Left 2}{Shift Down}{Right}{Shift Up}{Ctrl Up}
:*:refnotes;::~~REFNOTES~~

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; SQL ;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

:*:findt::select TABLE_NAME from INFORMATION_SCHEMA.TABLES where TABLE_NAME like '`%`%' order by TABLE_NAME{left 22}
:*:findv::select TABLE_NAME from INFORMATION_SCHEMA.VIEWS where TABLE_NAME like '`%`%' order by TABLE_NAME{left 22}
:*:findc::select TABLE_NAME, COLUMN_NAME from INFORMATION_SCHEMA.COLUMNS where COLUMN_NAME like '`%`%' order by TABLE_NAME{left 22}
:*:findp::select SPECIFIC_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME like '%%' order by SPECIFIC_NAME{left 25}
:*:like;::like '`%`%'{left 2}
:*:in;::in ('
:*:temp;::If object_id('tempdb..{#}tmp') IS NOT NULL DROP TABLE {#}tmp{Space}
:*:ssf::select * from{Space}
:*:ssi::select * into{Space}
:*:ddf::delete from{Space}
:*:scf::select COUNT(*) from{Space}
:*:sph::sp_help{Space}''{Left}
:*:ii;::SET IDENTITY_INSERT  ON {Ctrl Down}{Left}{Ctrl Up}{Left}
:*:singleuser::ALTER DATABASE  SET SINGLE_USER WITH ROLLBACK IMMEDIATE{Ctrl Down}{Left 5}{Ctrl Up}{Left}
:*:multiuser::ALTER DATABASE  SET MULTI_USER{Ctrl Down}{Left 2}{Ctrl Up}{Left}
:*:killconn::USE master`n`nGO`n`nDECLARE @dbname sysname`nSET @dbname = 'yourdbname'`nDECLARE @spid int`nSELECT @spid = min(spid) from master.dbo.sysprocesses where dbid = db_id(@dbname)`nWHILE @spid IS NOT NULL`nBEGIN`nEXECUTE ('KILL ' {+} @spid)`nSELECT @spid = min(spid) from master.dbo.sysprocesses where dbid = db_id(@dbname) AND spid > @spid`n`nEND
:*:obd::order by date desc

:*:sdn::Sales_Doc_Num{Space}
:*:spvim::spvItemMaster
:*:dbr;::UPDATE spDatabaseVersion `nSET [Database_Version] = -1`nGO`nUPDATE dwDatabaseVersion `nSET [Database_Version] = -1`n{Backspace}
:*:backup;::BACKUP DATABASE DYNAMICS`nTO DISK = 'C:\.bak'`nWith INIT{Up}{End}{Ctrl Down}{Left 2}{Ctrl Up}{Left}
:*:fresh;::
	SendInput % "use master `nexec restoreDB 'NEW','NEW', '\\nasus\Testing\Database Files\" GetGPVersion() "\NEW.bak'"
:*:restoretwo::
    RegRead, SQLVersion, HKLM, Software\Microsoft\MSSQLServer\MSSQLServer\CurrentVersion, CurrentVersion
    If RegExMatch(SQLVersion, "P)\d*", matchlength)
    {
        SQLVersion := SubStr(SQLVersion, 1, matchlength)
		SendInput, USE master`n`nALTER DATABASE TWO`nSET SINGLE_USER`nWITH`nROLLBACK IMMEDIATE`nGO`n`nRESTORE DATABASE TWO`nFROM DISK = '\\nasus\Testing\Database Files\GP2010\%SQLVersion%\TWO.bak'`nWITH FILE = 1`n,NOREWIND`n,NOUNLOAD`n,REPLACE`nGO`n`nALTER DATABASE TWO`nSET MULTI_USER`n
	}		
	Return

:*:sv;::'"  "'{Left 3}
:*:resetmachines::update MachineInfo set locked = 0, currentBranch = '', CurrentTest = '', Time_Started = NULL, testprogress = ''

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; Code ;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

:*:currfmt::{{}0:${#},{#}{#}0.00{}}
:*:datefmt::{{}0:M/d/yyyy{}}
:*:numfmt::{{}0:{#},{#}{#}0.00{}}
:*:sl;::foreach (SalesPad.Bus.SalesLineItem sl in sd.LineItems)`n{{}`n`n{}}{up}{tab}
:*:two;::USE [TWO]`n`n
:*:line;::Convert.ToString(DetailReport.GetCurrentColumnValue("FIELDNAME"))`;{left 4}{Shift Down}{Ctrl Down}{Left}{Shift Up}{Ctrl Up}
:*:forline::foreach (SalesPad.Bus.SalesLineItem sl in sd.LineItems)`n{{}`n

:*:kbd;::
	Output := "<kbd></kbd>"
	Send, %Output%{left 6}
	Keywait, Space, D T5
	If ErrorLevel
		Return
	Send {Backspace}{right 6}{Space}
	Return

:*:+la::(?=){Left}
:*:-la::(?`!){Left}
:*:+lb::(?<=){Left}
:*:-lb::(?<`!){Left}

:*:header;::
	linelen := strlen(clipboard) + 20

	Send, {`; %linelen%}`n
	Send, {`; 9}{Space}
	Send, % clipboard
	Send, {Space}{`; 9}`n
	Send, {`; %linelen%}`n
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; FogBugz ;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
:*:ac;::Status:"Active" OrderBy:LastEdited
:*:fbs;::Found by SmartBear.
:*:is;::Invite sent.
:*:pt;::
	path := ini_load(ini, "Work.ini")
	lastbranch := ini_getValue(ini, "LastInstall", "Branch")
	lastbuild :=  ini_getValue(ini, "LastInstall", "Build")
	SendInput % "Passed Testing in Latest " lastbranch " " lastbuild
	return

:*:nrl;::
	Loop, \\Nasus\Builds\SalesPad4\SalesPad_4_Release\*, 1, 0
	{
	     FileGetTime, FileTime, %A_LoopFileFullPath%, C
	     If (FileTime > Time_Orig) And (FileExist(A_LoopFileFullPath "\*withCardControl.exe"))
	     {
			Time_Orig := FileTime
			File := A_LoopFileName
			Folder := A_LoopFileFullPath
	     }
	}

	RegExMatch(Folder, "(?<=\.)[\d]+$", lastNum)
	RegExMatch(Folder, "(?<=\\)[\d\.]+$", latestVersion) 
	newNum := lastNum + 1
	SendInput % "Fixed in next Release " RegExReplace(latestVersion, "(?<=\.)[\d]+$", newNum)
	Return
:*:lu;:: OrderBy:LastEdited
:*:do;:: OrderBy:Opened
:*:code;::
	Send [code]`n`n[/code]{up}
	Return
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; File Paths ;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

:*:pd;::`%ProgramData`%
:*:ad;::`%AppData`%
:*:epc;::\\elliot-pc\c$\Users\elliotd\Dropbox\
:*:nt;::\\nasus\testing

:*:unc;::
	If ! InStr(clipboard, "C:\")
	{
		msgbox % "Clipboard does not contain a valid file path`n`n" clipboard
		Return
	}
	path := Clipboard
	SendInput % RegExReplace(path, "(C:\\)", "\\ELLIOT-PC\c$$\")
	return

:*:paste;::   ;works through GoToMeeting    
	StringReplace, clipboard, clipboard, `r`n, `n, All
	SendInput, {raw}%clipboard%
	Return