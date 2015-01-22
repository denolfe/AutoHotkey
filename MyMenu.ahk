#SingleInstance force
#NoTrayIcon

#Include lib\Notify.ahk
#Include lib\HttpQueryInfo.ahk
#Include Functions.ahk

A_ProgramFiles86 := "C:\Program Files (x86)\"

Menu,AutoHotkey,Add,Ahk2Exe
Menu,AutoHotkey,Add,SmartGUI
Menu,AutoHotkey,Add,Dynamic Function Tester, DynamicFunctionTester
Menu,AutoHotkey,Add,AHK Documentation, AHKDocumentation

Menu,Main,Add,Clipboard Replace, ClipboardReplace
Menu,Main,Add,SQL Formatter, SQLFormatter
Menu,Main,Add,
Menu,Main,Add,Lightning Renamer, LightningRenamer
Menu,Main,Add,Directory Compare, DirectoryCompare
Menu,Main,Add,KDiff3
Menu,Main,Add,Colorette, Colorette
Menu,Main,Add,
Menu,Main,Add, AutoHotkey, :AutoHotkey
Menu,Main,Add,
Menu,Main,Add, Path Editor, PathEditor


Menu,Main,show

Return
;----------labels-----------
LightningRenamer:
	Run, Utilities\LightningRenamer.ahk
	Return
SmartGUI:
	Run, Utilities\smartgui\SmartGUI.exe
	Return
DirectoryCompare:
	Run, Utilities\DirectoryCompare.ahk
	Return
KDiff3:
	Run, %A_ProgramFiles86%\KDiff3\kdiff3.exe
	Return
AHKDocumentation:
	Run, chrome.exe http://l.autohotkey.net/docs/
	Return

Ahk2Exe:
	Run, Utilities\Ahk2Exe\Ahk2Exe.exe
	Return

DynamicFunctionTester:
	Run, Utilities\DynamicFunctionTester.ahk
	Return

Colorette:
	Run, Utilities\Colorette.ahk
	Return

PathEditor:
	Run, Utilities\PathEditor.exe
	Return

ClipboardReplace:
	Run, Utilities\Replace.ahk
	Return

SQLFormatter:
	ClipSave()
	;clipboard = 
	ClipClear()
	Send ^x
	ClipWait
	FileDelete, Utilities\clipboard.sql
	FileAppend, %clipboard%, Utilities\clipboard.sql
	RunWait, %comspec% /c "Utilities\sqlformatter.exe Utilities\clipboard.sql" ,, Hide
	FileRead, clipboard, Utilities\clipboard.sql
	Send ^v
	;FileDelete, Utilities\clipboard.sql
	;FileDelete, Utilities\clipboard.sql.bak
	ClipRestore()
	Return
	