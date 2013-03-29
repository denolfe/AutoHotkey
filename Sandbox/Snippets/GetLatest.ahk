#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#WinActivateForce
#SingleInstance force
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

if ! A_IsCompiled
	Menu, Tray, Icon, lib\sp_icon.ico


Process,Close,SalesPad.exe 

Loop, %0%  ; For each parameter:
{
    build := %A_Index%  ;Fetch the contents of the variable whose name is contained in A_Index.
}

if (StrLen(build) == 0)
	build := "Release"
if Instr(build, "Move")
{
	Move := 1
	StringReplace, build, build, Move,,All
}

;; Define installer and install dir
setupfile := "C:\SalesPad.Setup.exe"
installpath := "C:\Program Files (x86)\SalesPad.GP\"
builds := "\\draven\Builds\SalesPad4\SalesPad_4_"

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

;msgbox % FullFile

if (Move == 1)
	Goto, Move

path := ini_load(ini, "\\draven\Testing\TestComplete\TestComplete.ini")
ini_replaceValue(ini, build, LastBuild, File)

	
If A_ComputerName = ELLIOT-PC   ;added for functionality in testing environment
{
	MsgBox, 36,SalesPad Download, Install %File%?
	IfMsgBox No
	{
		Exitapp
	}		
}
;msgbox % File . "`n" . FullFile

If A_IsCompiled
{
	;Write install file to ini
	path := ini_load(ini, "\\draven\Testing\TestComplete\TestComplete.ini")
	;File := RegExReplace(File, "[a-zA-Z]", "")
	;StringTrimLeft, File, File, 3
	;StringTrimRight, File, File, 2
	ini_replaceValue(ini, build, "LastBuildPath", FullFile)
	path := ini_save(ini, "\\draven\Testing\TestComplete\TestComplete.ini")
}


;; Remove old install file
if FileExist(setupfile)
	FileDelete,  %setupfile%

;; Copy and rename installer
FileCopy, %FullFile%, %setupfile%
;; Stop if file was not pulled
if ! FileExist(setupfile)
{
	msgbox,,Install Failed, Install file does not exist
	ExitApp
}

;; Remove old SalesPad directory
if FileExist("C:\Program Files (x86)\SalesPad.GP\uninst.exe")
	FileRemoveDir, %installpath%, 1


;; Run installer
Run, %setupfile%
ExitApp

Move:
	FileCopy, %FullFile%, \\katrina\public\LatestRelease\4.1.2\Passed SmartBear\%File%
	ExitApp

