#SingleInstance force
#NoTrayIcon

#Include lib\Notify.ahk
#Include lib\HttpQueryInfo.ahk

A_ProgramFiles86 := "C:\Program Files (x86)\"

Menu,AutoHotkey,Add,AHK Documentation, AHKDocumentation
Menu,AutoHotkey,Add,Ahk2Exe
Menu,AutoHotkey,Add,SmartGUI
Menu,AutoHotkey,Add,Dynamic Function Tester, DynamicFunctionTester

Menu,Main,Add,Clipboard Replace, ClipboardReplace
Menu,Main,Add,Format URL, FormatURL
Menu,Main,Add,SQL Formatter, SQLFormatter
Menu,Main,Add,
Menu,Main,Add,Lightning Renamer, LightningRenamer
Menu,Main,Add,Directory Compare, DirectoryCompare
Menu,Main,Add,KDiff3
Menu,Main,Add,Colorette, Colorette
Menu,Main,Add,
Menu,Main,Add, AutoHotkey, :AutoHotkey


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

Colorette:
Run, Utilities\Colorette.ahk
return

ClipboardReplace:
	Run, %A_ScriptDir%\Replace.ahk
return

SQLFormatter:
	clipboard = 
	Send ^x
	ClipWait
	FileDelete, Utilities\clipboard.sql
	FileAppend, %clipboard%, Utilities\clipboard.sql
	RunWait, %comspec% /c "Utilities\sqlformatter.exe Utilities\clipboard.sql" ,, Hide
	FileRead, clipboard, Utilities\clipboard.sql
	Send ^v
	FileDelete, Utilities\clipboard.sql
	FileDelete, Utilities\clipboard.sql.bak
return

FormatURL:
	If Instr(clipboard, "\\katrina\public\")
	{
		clipboard := RegExReplace(clipboard, "(\\\\katrina\\public\\)", "http://www.salespad.net/public/")
		clipboard := RegExReplace(clipboard, "(\\)", "/")

		res := HttpQueryInfo(clipboard)
		if InStr(res, "200 OK")
  			Notify("URL Converted",clipboard,-3,"Style=Mine")
		else
  			msgbox, URL is not valid.
  	}
	Else
	{
		MsgBox, Clipboard does not contain UNC path!`n`n%clipboard%
	}
Return