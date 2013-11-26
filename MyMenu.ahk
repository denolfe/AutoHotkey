#SingleInstance force
#NoTrayIcon

#Include lib\Notify.ahk
#Include lib\HttpQueryInfo.ahk
#Include MyMethods.ahk

A_ProgramFiles86 := "C:\Program Files (x86)\"

Menu,AutoHotkey,Add,Ahk2Exe
Menu,AutoHotkey,Add,SmartGUI
Menu,AutoHotkey,Add,Dynamic Function Tester, DynamicFunctionTester
Menu,AutoHotkey,Add,AHK Documentation, AHKDocumentation

Menu,Main,Add,Clipboard Replace, ClipboardReplace
Menu,Main,Add, UNC to URL, FormatURL
Menu,Main,Add,SQL Formatter, SQLFormatter
Menu,Main,Add,GP Lookup, GPLookup
Menu,Main,Add,
Menu,Main,Add,Lightning Renamer, LightningRenamer
Menu,Main,Add,Directory Compare, DirectoryCompare
Menu,Main,Add,KDiff3
Menu,Main,Add,Colorette, Colorette
Menu,Main,Add,
Menu,Main,Add, AutoHotkey, :AutoHotkey


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

FormatURL:
	If Instr(clipboard, "\\katrina\public\")
	{
		clipboard := RegExReplace(clipboard, "(\\\\katrina\\public\\)", "http://www.salespad.net/public/")
		clipboard := RegExReplace(clipboard, "(\\)", "/")

		res := HttpQueryInfo(clipboard)
		if InStr(res, "200 OK")
  			Notify("URL Converted",clipboard,-3,"Style=Mine")
		else
  			msgbox, URL is not valid.`n`n%clipboard%
  	}
	Else
	{
		MsgBox, Clipboard does not contain UNC path!`n`n%clipboard%
	}
Return

GPLookup:
	clipboardsave := clipboard
	clipboard = 
	Send ^c
	ClipWait
	Sleep 50
	If Instr(RegExReplace(clipboard, "i)^AA|^AF|^AHR|^ASI|^BM|^CM|^DD|^DTA|^ERB|^EXT|^EXT|^FA|^GL|^HR|^IV|^IVC|^LK|^MC|^ME|^PA|^PM|^POP|^RM|^SLB|^SOP|^SVC|^SY|^UPR|^WDC", "foundit!"), "foundit!")
		Run chrome.exe "http://www.tealbridge.com/free-resources/dynamics-gp-table-reference/2010/%clipboard%"
	else
		Run chrome.exe "http://google.com/search?btnI=1&q=%clipboard%%A_Space%Transact%A_Space%SQL%A_Space%site:http://msdn.microsoft.com/en-us/library"
	clipboard := clipboardsave
Return