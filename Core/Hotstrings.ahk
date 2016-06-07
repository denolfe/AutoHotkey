;#Hotstring EndChars -()[]{}:;'"/\,.?!`n `t

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; Hotstrings ;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

:*:ahkskel::{#}NoEnv`n{#}WinActivateForce`n{#}SingleInstance force`nSendMode Input`nSetWorkingDir %A_ScriptDir%`nSetTitleMatchMode, 2`n
:*:ahk;::AutoHotkey
:*:st;::Sublime Text
:*:js;::javascript
:*:date;::
	FormatTime, now, A_Now, M/d/yyyy
	SendInput % now
	Return
:*:comspec;::RunWait, `%comspec`% /c "",, Hide{Ctrl Down}{Left 2}{Ctrl Up}{Right}

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; SQL ;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

#If WinActive("SQL Server Management Studio") or WinActive("ahk_exe sqldeveloper64W.exe") or WinActive("ahk_exe SQLyogCommunity.exe")
	:*:findt::SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME LIKE '`%`%' ORDER BY TABLE_NAME{left 22}
	:*:findv::SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS WHERE TABLE_NAME LIKE '`%`%' ORDER BY TABLE_NAME{left 22}
	:*:findc::SELECT TABLE_NAME, COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME LIKE '`%`%' ORDER BY TABLE_NAME{left 22}
	:*:findp::SELECT SPECIFIC_NAME FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME LIKE '%%' ORDER BY SPECIFIC_NAME{left 25}
	:*:like;::LIKE '`%`%'{left 2}
	:*:in;::IN ('){left}
	:*:temp;::If object_id('tempdb..{#}tmp') IS NOT NULL DROP TABLE {#}tmp{Space}
	:*:ssf::SELECT *{Space}FROM{Space}
	:*:sff::SELECT *{Enter}FROM{Space}
	:*:ssi::SELECT * into{Space}
	:*:ddf::DELETE FROM{Space}
	:*:scf::SELECT COUNT(*) FROM{Space}
	:*:sph;::sp_help{Space}''{Left}
	:*:ii;::SET IDENTITY_INSERT TABLENAME ON {Ctrl Down}{Left 2}{Shift Down}{Right}{Shift Up}{Ctrl Up}
	:*:singleuser::ALTER DATABASE DBNAME SET SINGLE_USER WITH ROLLBACK IMMEDIATE{Ctrl Down}{Left 6}{Shift Down}{Right}{Ctrl Up}{Shift Up}
	:*:multiuser::ALTER DATABASE DBNAME SET MULTI_USER{Ctrl Down}{Left 3}{Shift Down}{Right}{Ctrl Up}{Shift Up}
	:*:killconn::USE master`n`nGO`n`nDECLARE @dbname SYSNAME`nSET @dbname = 'yourdbname'`nDECLARE @spid INT`nSELECT @spid = min(spid) FROM master.dbo.sysprocesses where dbid = db_id(@dbname)`nWHILE @spid IS NOT NULL`nBEGIN`nEXECUTE ('KILL ' {+} @spid)`nSELECT @spid = min(spid) from master.dbo.sysprocesses where dbid = db_id(@dbname) AND spid > @spid`n`nEND
	:*:obd::ORDER BY date desc
	:*:sv;::'"  "'{Left 3}
	:*:st1::SELECT TOP 10 * FROM{Space}
	:*:st2::SELECT TOP 100 * FROM{Space}
	:*:bt;::BEGIN TRANSACTION{Enter}
	:*:rb;::ROLLBACK
	:*:btrb;::BEGIN TRANSACTION{Enter 2}ROLLBACK{Up}{Tab}
#If

#IfWinActive, Windows Security
	:*:adm;::Administrator{Tab}
#IfWinActive

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; Code ;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

#IfWinActive, Microsoft Visual Studio

	;; String.Format

	:*:0;;::'{{}0{}}'
	:*:1;;::'{{}1{}}'
	:*:2;;::'{{}2{}}'
	:*:3;;::'{{}3{}}'
	:*:4;;::'{{}4{}}'
	:*:5;;::'{{}5{}}'
	:*:6;;::'{{}6{}}'
	:*:7;;::'{{}7{}}'
	:*:8;;::'{{}8{}}'
	:*:9;;::'{{}9{}}'

	:*:0:;::{{}0{}}
	:*:1:;::{{}1{}}
	:*:2:;::{{}2{}}
	:*:3:;::{{}3{}}
	:*:4:;::{{}4{}}
	:*:5:;::{{}5{}}
	:*:6:;::{{}6{}}
	:*:7:;::{{}7{}}
	:*:8:;::{{}8{}}
	:*:9:;::{{}9{}}

#IfWinActive

:*:+la;::(?=){Left}
:*:-la;::(?{!}){Left}
:*:+lb;::(?<=){Left}
:*:-lb;::(?<{!}){Left}

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


;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; URLS ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;

