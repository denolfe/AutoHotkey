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
		7 = Main
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

		KeyWait, numpad7, D T0.02
		If not ErrorLevel 
		{
			build := "Main"
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
ShellFileOperation("FO_COPY", FullFile, setupfile)
WinWaitClose, ahk_class OperationStatusWindow
;; Stop if file was not pulled
if ! FileExist(setupfile)
{
	msgbox,,Install Failed, Install file does not exist
	ExitApp
}
;; Run installer
path := "C:\Program Files (x86)\SalesPad.GP " build "\" Folder
RunWait, %setupfile% /S /D=%path%
Run, %path%\SalesPad.exe

SetTimer, KeepActive, 50

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

if (build = "Main") or (build = "HotFix") or (build = "Custom")
	Send {Space}{Tab 4}{Space}{Tab 2}{Enter}
Else
	Send {Space}{Tab 3}{Space}{Tab 2}{Enter}

Loop {

	WinGetText, thetext, SalesPad, Database Update
	if RegExMatch(thetext, "The Database Update was Successful")
		break
	if RegExMatch(thetext, "NOT")
		Return
	Sleep 50
}
Sleep 1000
Send {Enter}
Gosub, logini
Exitapp

KeepActive:
	WinActivate, Setup,,ahk_class CabinetWClass
	If ! WinExist("Setup")
		SetTimer, KeepActive, Off
	Return

logini:
If A_ComputerName = elliot-pc
{
	path := ini_load(ini, "Work.ini") 
	ini_replaceValue(ini, "LastInstall", "Branch", build)
	ini_replaceValue(ini, "LastInstall", "Build", Folder)
	ini_save(ini, "Work.ini")
}
Return

ExitApp

Numpad1::Return
Numpad2::Return
Numpad3::Return
Numpad4::Return
Numpad5::Return
Numpad6::Return
Numpad7::Return
Numpad8::Return
~Esc::ExitApp