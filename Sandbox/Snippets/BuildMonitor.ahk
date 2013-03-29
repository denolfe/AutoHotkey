#NoEnv
#WinActivateForce
#SingleInstance force
SendMode Input
SetWorkingDir %A_ScriptDir%
SetTitleMatchMode, 2
Menu, Tray, Icon, lib\wall-e.ico
Menu, Tray, Tip, Build Monitor

Gui, Add, Radio,vBranch, Release
Gui, Add, Radio,, HotFix
Gui, Add, Radio,, Custom
Gui, Add, Radio,, ServPack
Gui, Add, Radio,, Main
Gui, Add, CheckBox, vAutoRun, AutoRun
Gui, Add, Button, Default, OK


Gui, Show
Return

ButtonOK:
Gui Submit ;, NoHide
if branch = 1
	branch := "Release"
else if branch = 2
	branch := "HotFix"
else if branch = 3
	branch := "Custom"
else if branch = 4
	branch := "ServPack"
else if branch = 5
	branch := "Main"
else
	exitapp

countbefore := countBuilds()
;countbefore := 0 ; testing

Loop
{
	countafter := countBuilds()
	;Notify("Before- " . countbefore . " After- " . countafter,"",-1,"Style=Mine")
	if (countafter > countbefore)
	{
		
		if AutoRun = 1
		{
			Notify("New Build Found","Beginning Tests Now",-10,"Style=Mine BW=2 BC=White GC=Red AC=RunTests")
			RunWait, %comspec% /c "schtasks /run /s testing-pc /tn LaunchTests",, Hide
		}
		else
		{
			Notify("New Build Found","Click to Begin Test",-10,"Style=Mine BW=2 BC=White GC=Red AC=GetLatest")
		}
		break
	}
	Sleep 60000
}
return

GetLatest()
{
	global
	Loop, \\draven\Builds\SalesPad4\SalesPad_4_%branch%\*WithCardControl.exe, 0, 1
	{
		 FileGetTime, Time, %A_LoopFileFullPath%, C
	     If (Time > Time_Orig)
	     {
	          Time_Orig := Time
	          File := A_LoopFileName
	          FullFile := A_LoopFileFullPath
	     }
	}

}

countBuilds()	
{
	global
	count := 0
	Loop, \\draven\Builds\SalesPad4\SalesPad_4_%branch%\*WithCardControl.exe, 0, 1
	{
		count := count+1
		;msgbox % A_LoopFileName
	}
		
	return count
}

Return

;RunTests:
;RunWait, %comspec% /c "schtasks /run /s testing-pc /tn LaunchTests",, Hide
;Return

GetLatest:
Run, Buildprompt.ahk
Return

#NumpadSub::WinShow, Test Configuration