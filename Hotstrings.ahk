;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; Hotstrings ;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

:*:ahkskel::{#}NoEnv`n{#}WinActivateForce`n{#}SingleInstance force`nSendMode Input`nSetWorkingDir %A_ScriptDir%`nSetTitleMatchMode, 2`n
:*:ahk;::AutoHotkey
:*:now;::
	Send % A_MM "/" A_DD "/" A_YYYY
	Return
:*:comspec;::RunWait, `%comspec`% /c "",, Hide{Ctrl Down}{Left 2}{Ctrl Up}{Right}

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; SQL ;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

:*:findt::select TABLE_NAME from INFORMATION_SCHEMA.TABLES where TABLE_NAME like '`%`%' order by TABLE_NAME{left 22}
:*:findv::select TABLE_NAME from INFORMATION_SCHEMA.VIEWS where TABLE_NAME like '`%`%' order by TABLE_NAME{left 22}
:*:findc::select TABLE_NAME, COLUMN_NAME from INFORMATION_SCHEMA.COLUMNS where COLUMN_NAME like '`%`%' order by TABLE_NAME{left 22}
:*:findp::select SPECIFIC_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME like '%%' order by SPECIFIC_NAME{left 25}
:*:like;::like '`%`%'{left 2}
:*:temp;::If object_id('tempdb..{#}tmp') IS NOT NULL DROP TABLE {#}tmp{Space}
:*:ssf::select * from{Space}
:*:ssi::select * into{Space}
:*:scf::select COUNT(*) from{Space}
:*:sph::sp_help{Space}
:*:ii;::SET IDENTITY_INSERT  ON {Ctrl Down}{Left}{Ctrl Up}{Left}
:*:singleuser::ALTER DATABASE  SET SINGLE_USER WITH ROLLBACK IMMEDIATE{Ctrl Down}{Left 5}{Ctrl Up}{Left}
:*:multiuser::ALTER DATABASE  SET MULTI_USER{Ctrl Down}{Left 2}{Ctrl Up}{Left}
:*:killconn::USE master`n`nGO`n`nDECLARE @dbname sysname`nSET @dbname = 'yourdbname'`nDECLARE @spid int`nSELECT @spid = min(spid) from master.dbo.sysprocesses where dbid = db_id(@dbname)`nWHILE @spid IS NOT NULL`nBEGIN`nEXECUTE ('KILL ' {+} @spid)`nSELECT @spid = min(spid) from master.dbo.sysprocesses where dbid = db_id(@dbname) AND spid > @spid`n`nEND

:*:sdn::Sales_Doc_Num{Space}
:*:dbr;::UPDATE spDatabaseVersion `nSET [Database_Version] = -1`nGO`nUPDATE dwDatabaseVersion `nSET [Database_Version] = -1`n{Backspace}
:*:backup;::BACKUP DATABASE DYNAMICS`nTO DISK = 'C:\.bak'`nWith INIT{Up}{End}{Ctrl Down}{Left 2}{Ctrl Up}{Left}
:*:fresh;::
	Send % "use master `nexec restoreDB 'NEW','NEW', '\\draven\Testing\Database Files\" GetGPVersion() "\NEW.bak'"
:*:rtv;::drop view spvPurchaseReceipt_base`n`ndrop view spvpurchasereceiptlineitem_base
:*:restoretwo::
    RegRead, SQLVersion, HKLM, Software\Microsoft\MSSQLServer\MSSQLServer\CurrentVersion, CurrentVersion
    If RegExMatch(SQLVersion, "P)\d*", matchlength)
        SQLVersion := SubStr(SQLVersion, 1, matchlength)
	Send, USE master`n`nALTER DATABASE TWO`nSET SINGLE_USER`nWITH`nROLLBACK IMMEDIATE`nGO`n`nRESTORE DATABASE TWO`nFROM DISK = '\\draven\Testing\Database Files\GP2010\%SQLVersion%\TWO.bak'`nWITH FILE = 1`n,NOREWIND`n,NOUNLOAD`n,REPLACE`nGO`n`nALTER DATABASE TWO`nSET MULTI_USER`n
	Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; Code ;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

:*:currfmt::{{}0:${#},{#}{#}0.00{}}
:*:datefmt::{{}0:M/d/yyyy{}}
:*:numfmt::{{}0:{#},{#}{#}0.00{}}
:*:msgbox;::Messenger.Show(){Left}
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
	Send % "Passed Testing in Latest " lastbranch " " lastbuild
	return

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
:*:epc;::\\elliot-pc\c$\Users\elliotd\Dropbox\HomeShare\

:*:unc;::
	If ! InStr(clipboard, "C:\")
	{
		msgbox % "Clipboard does not contain a valid file path`n`n" clipboard
		Return
	}
	path := Clipboard
	Send % RegExReplace(path, "(C:\\)", "\\ELLIOT-PC\c$$\")
	return

:*:paste;::   ;works through GoToMeeting    
	StringReplace, clipboard, clipboard, `r`n, `n, All
	Send, {raw}%clipboard%
	Return