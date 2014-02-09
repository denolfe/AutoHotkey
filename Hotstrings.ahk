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

:*:sv;::'"  "'{Left 3}

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; Code ;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
:*:-lb::(?<{!}){Left}

:*:header;::
	linelen := strlen(clipboard) + 20

	Send, {`; %linelen%}`n
	Send, {`; 9}{Space}
	Send, % clipboard
	Send, {Space}{`; 9}`n
	Send, {`; %linelen%}`n
Return


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; File Paths ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

:*:pd;::`%ProgramData`%
:*:ad;::`%AppData`%