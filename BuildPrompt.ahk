#NoTrayIcon
SetTitleMatchMode, 2
#SingleInstance force

#Include lib\ini.ahk
#Include lib\ShellFileOperation.ahk
			 		 
message = 
	(ltrim 
		1 = Release
		2 = HotFix
		3 = ServPack
		4 = Custom
		5 = CustomRelease
		6 = Ret To Vend
	)

Notify("Choose Build", message,-15,"Style=Mine")

Loop 
	{
		KeyWait, numpad1, D T0.02
		If not ErrorLevel
		{
			build := "Release"
			break
		}	
		KeyWait, numpad2, D T0.02
		If not ErrorLevel 
		{
			build := "HotFix"
			break
		}
		KeyWait, numpad3, D T0.02
		If not ErrorLevel 
		{
			build := "ServPack"
			break
		}
		
		KeyWait, numpad4, D T0.02
		If not ErrorLevel 
		{
			build := "Custom"
			break
		}

		KeyWait, numpad5, D T0.02
		If not ErrorLevel 
		{
			build := "CustomRelease"
			break
		}

		KeyWait, numpad6, D T0.02
		If not ErrorLevel 
		{
			build := "F9_RetToVend"
			break
		}


		Sleep 10

	}


Notify("Getting Latest " build,"",-5,"Style=Mine")

;; Define installer and install dir
setupfile := "C:\SalesPad.Setup.exe"
installpath := "C:\Program Files (x86)\SalesPad.GP\"

;; Find newest installer
Loop, \\draven\Builds\SalesPad4\SalesPad_4_%build%\*, 2, 0

{
     FileGetTime, Time, %A_LoopFileFullPath%, C
     If (Time > Time_Orig)
     {
          Time_Orig := Time
          Folder := A_LoopFileName
     }
}



Loop, \\draven\Builds\SalesPad4\SalesPad_4_%build%\%Folder%\*WithCardControl.exe, 0, 1
{
	FileGetTime, thetime, %A_LoopFileFullPath%, C
	;msgbox % thetime
	;FormatTime, CreateTime,CreateTime, M/d h:mm tt
	File := A_LoopFileName
	FullFile := A_LoopFileFullPath
	FormatTime, CreationDate, %thetime%, ddd, M/dd, h:mm tt
}

build := RegExReplace(build, "F9_", "")

If FileExist("C:\Program Files (x86)\SalesPad.GP " build "\" Folder)
{
	Run % "C:\Program Files (x86)\SalesPad.GP " build "\" Folder "\SalesPad.exe"
	If A_ComputerName = elliot-pc
	{
		path := ini_load(ini, "Work.ini") 
		ini_replaceValue(ini, "LastInstall", "Branch", build)
		ini_replaceValue(ini, "LastInstall", "Build", Folder)
		ini_save(ini, "Work.ini")
	}
	ExitApp
}


MsgBox, 36,SalesPad Download, %build%: %Folder% `n`nCreated: %CreationDate%`n`nDo you want to install it?
IfMsgBox No
{
	Exitapp
}


RunWait, %comspec% /c "sqlcmd -E -d TWI -Q "UPDATE spDatabaseVersion SET [Database_Version] = -1"",, Hide
RunWait, %comspec% /c "sqlcmd -E -d TWI -Q "UPDATE dwDatabaseVersion SET [Database_Version] = -1"",, Hide

;; Remove old install file
if FileExist(setupfile)
	FileDelete,  %setupfile%

;; Copy and rename installer
;FileCopy, %FullFile%, %setupfile%
;Run, C:\Users\elliotd\Dropbox\HomeShare\lib\ShellFileOperation\ShellFileOperation.exe FO_COPY %FullFile%, %setupfile%
ShellFileOperation("FO_COPY", FullFile, setupfile)
WinWaitClose, ahk_class OperationStatusWindow
;; Stop if file was not pulled
if ! FileExist(setupfile)
{
	msgbox,,Install Failed, Install file does not exist
	ExitApp
}
;; Run installer
Run, %setupfile%


WinWaitActive, SalesPad.GP, License Agreement

SetTimer, KeepActive, 50



Send, {Enter}
WinGetTitle, Title, A
StringReplace, Title, Title, SalesPad.GP
StringReplace, Title, Title, Setup
StringReplace, Title, Title, %A_SPACE%,,All
path := "C:\Program Files (x86)\SalesPad.GP " build "\" Title
SendInput % path
Send {Enter}
Sleep 100
Send {Enter}

Loop 
{
	ControlGet, OutputVar, Enabled,, Button2, SalesPad.GP
	;msgbox % OutputVar
	if OutputVar = 1
	  break
	Sleep 500
}
Sleep 500
Send {Enter}
Gosub, logini

RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\SalesPad, Last Connection, TWI
RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\SalesPad, Last User, elliotd
RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\SalesPad, Last Auth Method, True

WinWaitActive, SalesPad ahk_class WindowsForms10.Window.8.app.0.13965fa_r11_ad1, Welcome
Send {Enter}
Loop 50
{

	WinGetText, thetext, SalesPad, Database Update
	if RegExMatch(thetext, "Database Update is Available")
		break
	Sleep 50
}

WinActivate, SalesPad
Send {Enter}
IfWinNotExist, SalesPad, Update is Available
	ExitApp
Sleep 50
Send {Space}{Tab 3}{Space}{Tab 2}{Enter}

Loop {

	WinGetText, thetext, SalesPad, Database Update
	if RegExMatch(thetext, "The Database Update was Successful")
		break
	if RegExMatch(thetext, "NOT")
		return
	Sleep 50
}
Sleep 1000
Send {Enter}

Exitapp

KeepActive:
	WinActivate, SalesPad.GP
	If ! WinExist("SalesPad.GP")
		SetTimer, KeepActive, Off
	return

logini:
If A_ComputerName = elliot-pc
{
	path := ini_load(ini, "Work.ini") 
	ini_replaceValue(ini, "LastInstall", "Branch", build)
	ini_replaceValue(ini, "LastInstall", "Build", Title)
	ini_save(ini, "Work.ini")
}
return

/*
Loop 
{
  WinGetText, VisText, ahk_class WindowsForms10.Window.8.app.0.25bb5ff_r15_ad1
  msgbox % VisText
  If Instr(Vistext, "Welcome to SalesPad")
    break
  Sleep 500 
}
Send {Enter}
*/

/*
Send {Enter}
Sleep 50
Send {Space}
Sleep 50
Send {Tab 3}
Sleep 50
Send {Space}
Sleep 500
Send {Tab 2}
Sleep 50
Send {Space}
*/


	
ExitApp

Numpad1::Return
Numpad2::Return
Numpad3::Return
Numpad4::Return
Numpad5::Return
~Esc::ExitApp