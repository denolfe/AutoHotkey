#NoTrayIcon
SetTitleMatchMode, 2
#SingleInstance force

#Include lib\ini.ahk
#Include lib\ShellFileOperation.ahk

Choosing := 1

message = 
	(ltrim 
		1 = Release
		2 = HotFix
		3 = ServPack
		4 = Custom
		5 = CustomRelease
		6 = GLC
		7 = Main
		8 = Tapco
		9 = CardControl
	)


Choose_Build := Notify("Choose Build", message,-15,"Style=Mine")

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
			build := "Custom"
			special := "CRM"
			break
		}

		KeyWait, numpad7, D T0.02
		If not ErrorLevel 
		{
			build := "Main"
			break
		}

		KeyWait, numpad8, D T0.02
		If not ErrorLevel 
		{
			build := "Custom" ;Tapco dlls
			special := "Tapco"
			break
		}

		KeyWait, numpad9, D T0.02
		If not ErrorLevel 
		{
			build := "CC"
			break
		}

		KeyWait, numpad0, D T0.02
		If not ErrorLevel 
		{
			build := "Custom"
			break
		}

		Sleep 10

	}

Notify("","",-0,"Wait=" Choose_Build)
Choosing := 0
Notify("Getting Latest " build,"",-5,"Style=Mine")

;; Define installer and install dir
setupfile := "C:\SalesPad.Setup.exe"
;installpath := "C:\Program Files (x86)\SalesPad.GP\"

    Loop, \\Nasus\Builds\SalesPad4\SalesPad_4_%build%\*, 1, 0
    {
         FileGetTime, FileTime, %A_LoopFileFullPath%, C
         If (FileTime > Time_Orig) And (FileExist(A_LoopFileFullPath "\*withCardControl.exe"))
         {
			Time_Orig := FileTime
			File := A_LoopFileName
			Folder := A_LoopFileFullPath
         }
    }
    Loop, %Folder%\*WithCardControl.exe, 0 , 0
    {
    	File := A_LoopFileName
    	FullFile := A_LoopFileFullPath
    	FormatTime, CreationDate, %Time_Orig%, ddd, M/dd, h:mm tt
    }

SplitPath, FullFile, name, dir, ext, name_no_ext, drive
Folder := Substr(dir, RegExMatch(dir, "P)(?<=\\)[\d\.]+$", matchlength), matchlength)

;build := RegExReplace(build, "F9_", "")

installpath := "C:\Program Files (x86)\SalesPad.GP " build "\" Folder

If FileExist(installpath) ; and (NeedsModule = 0)
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
WinWaitClose, ahk_class OperationStatusWindow, 10
If ErrorLevel
{
	msgbox, File copy is taking too long. Press Ok to Exit
	ExitApp
}
;; Stop if file was not pulled
if ! FileExist(setupfile)
{
	msgbox,,Install Failed, Install file does not exist
	ExitApp
}
;; Run installer
path := "C:\Program Files (x86)\SalesPad.GP " build "\" Folder
RunWait, %setupfile% /S /D=%path%

if (special = "Tapco") && (build = "Custom")
{
	GetDll("BusinessRules", dir, installpath)
	GetDll("Tapco", dir, installpath)		
}
if (special = "CRM") && (build = "Custom")
{
	GetDll("CRM", dir, installpath)
}


Run, %path%\SalesPad.exe

RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\SalesPad, Last Connection, TWI
RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\SalesPad, Last User, elliotd
RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\SalesPad, Last Auth Method, True

WinWaitActive, SalesPad ahk_class WindowsForms10.Window.8.app.0.30495d1_r11_ad1, Welcome to SalesPad, 4
Sleep 1000
Send {Enter}
Sleep 1000
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

Send {Space}{Tab}{Space}{Tab 3}{Space}{Tab 2}{Enter}

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

GetDLL(dllname, buildpath, installpath)
{
	Notify(dllname " module added.", message,-15,"Style=Mine")
	Loop, %buildpath%\CustomModules\WithCardControl\*%dllname%*zip, 0, 1
		ModulePath := A_LoopFileFullPath
	Unz(ModulePath, installpath)
}

;; http://www.autohotkey.com/board/topic/60706-native-zip-and-unzip-xpvista7-ahk-l/
Unz(sZip, sUnz)
{
    fso := ComObjCreate("Scripting.FileSystemObject")
    If Not fso.FolderExists(sUnz)  ;http://www.autohotkey.com/forum/viewtopic.php?p=402574
       fso.CreateFolder(sUnz)
    psh  := ComObjCreate("Shell.Application")
    zippedItems := psh.Namespace( sZip ).items().count
    psh.Namespace( sUnz ).CopyHere( psh.Namespace( sZip ).items, 4|16 )
}

ExitApp

~Esc::ExitApp

#If Choosing
	Numpad1::Return
	Numpad2::Return
	Numpad3::Return
	Numpad4::Return
	Numpad5::Return
	Numpad6::Return
	Numpad7::Return
	Numpad8::Return
	Numpad9::Return
	Numpad0::Return
#If