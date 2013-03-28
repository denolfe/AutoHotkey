#SingleInstance force
#NoTrayIcon

#Include lib\Notify.ahk

A_ProgramFiles86 := "C:\Program Files (x86)\"

Menu,Main,Add,AHK Documentation, AHKDocumentation
Menu,Main,Add,
Menu,Main,Add,Clipboard Replace, ClipboardReplace
Menu,Main,Add,Format URL, FormatURL

;Menu,Main,Add,Reference,:Reference
Menu,Main,Add,
Menu,Main,Add,SQL Formatter, SQLFormatter
Menu,Main,Add,Lightning Renamer, LightningRenamer
Menu,Main,Add,KDiff3
Menu,Main,Add,SmartGUI
Menu,Main,Add,Directory Compare, DirectoryCompare
Menu,Main,Add,Ahk2Exe
Menu,Main,Add,Dynamic Function Tester, DynamicFunctionTester


Menu,Main,show

return
;----------labels-----------
LightningRenamer:
Run, Utilities\LightningRenamer.ahk
return
SmartGUI:
Run, Utilities\smartgui\SmartGUI.exe
return
DirectoryCompare:
Run, Utilities\DirectoryCompare.ahk
return
KDiff3:
Run, %A_ProgramFiles86%\KDiff3\kdiff3.exe
return
AHKDocumentation:
Run, chrome.exe http://l.autohotkey.net/docs/
return

Ahk2Exe:
Run, Utilities\Ahk2Exe\Ahk2Exe.exe
return

DynamicFunctionTester:
Run, Utilities\DynamicFunctionTester.ahk
return

ClipboardReplace:
	Run, %A_ScriptDir%\Replace.ahk
return

SQLFormatter:
	clipboard = 
	Send ^x
	ClipWait
	FileDelete, clipboard.sql
	FileAppend, %clipboard%, clipboard.sql
	RunWait, %comspec% /c "sqlformatter.exe clipboard.sql" ,, Hide
	FileRead, clipboard, clipboard.sql
	Send ^v
	FileDelete, clipboard.sql
return

FormatURL:
	If Instr(clipboard, "\\katrina\public\")
	{
		clipboard := RegExReplace(clipboard, "(\\\\katrina\\public\\)", "http://www.salespad.net/public/")
		clipboard := RegExReplace(clipboard, "(\\)", "/")
		Notify("URL Converted",clipboard,-3,"Style=Mine")
	}
	Else
	{
		MsgBox, Clipboard does not contain UNC path!`n`n%clipboard%
	}
Return