Source := "\\draven\Builds\SalesPad4\SalesPad_4_Release\"
Dest := "\\katrina\public\LatestRelease\4.1.3\WithCardControl\"
;Dest := "C:\"
DestWOCC := "\\katrina\public\LatestRelease\4.1.3\WithoutCardControl\"
;DestWOCC := "C:\"
Loop, \\draven\Testing\Logs\Release\*.mht, 0, 0
{

    FileGetTime, Time, %A_LoopFileFullPath%, C
 	If (Time > Time_Orig)
 	{
		FileGetTime, Time, %A_LoopFileFullPath%, C
		If Instr(A_LoopFileName, "SMARTBEAR_Pass")
			LatestPass := A_LoopFileName
	}

}

Version := SubStr(LatestPass, RegExMatch(LatestPass, "P)^[\d.]+", matchlength), matchlength)

If FileExist( Dest . "SalesPad.GP.Setup." Version ".WithCardControl.exe")
{
	msgbox, %Version% has already been moved.
	ExitApp
}


MsgBox, 36, Send Files?, 
( LTrim
	Copy Files to %Dest% ?

	SalesPad.GP.Setup.%Version%.WithCardControl.exe
	SalesPad.GP.Setup.%Version%.WithoutCardControl.exe

	CustomModules_%Version%\

	)
IfMsgBox Yes
{
	FileCopy, %Source%%Version%\*WithCardControl.exe, %Dest%SalesPad.GP.Setup.%Version%.WithCardControl.exe
	FileCopy, %Source%%Version%\*WithoutCardControl.exe, %DestWOCC%SalesPad.GP.Setup.%Version%.WithoutCardControl.exe
	FileCopyDir, %Source%%Version%\CustomModules\, %Dest%CustomModules_%Version%\
	FileCopyDir, %Source%%Version%\CustomModules\, %DestWOCC%CustomModules_%Version%\
}
Else
	ExitApp

Exitapp