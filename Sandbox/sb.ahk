#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Recommended for catching common errors.
#Persistent
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode, 2

;; Define installer and install dir
setupfile := "C:\SalesPad.SB.Setup.exe"
;installpath := "C:\Program Files (x86)\SalesPad.GP\"

;; Find newest installer
Time_Orig := 0
Loop, \\draven\builds\Ares\SalesPad.SB.Development\*, 2, 0
{
     FileGetTime, Time, %A_LoopFileFullPath%, C
     If (Time > Time_Orig)
     {
          Time_Orig := Time
          Folder := A_LoopFileName
     }
}

Loop, \\draven\builds\Ares\SalesPad.SB.Development\%Folder%\*.exe, 0, 1
{
     FileGetTime, thetime, %A_LoopFileFullPath%, C
     File := A_LoopFileName
     FullFile := A_LoopFileFullPath
     FormatTime, CreationDate, %thetime%, ddd, M/dd, h:mm tt
}

FileCopy, %FullFile%, %setupfile%, 1
Run, %setupfile%
WinWaitActive, Setup
Send {Enter}

Sleep 100
Send {Enter}
Sleep 100
Send {Enter}
Sleep 100
Send {Enter}
WinWaitActive, InstallShield,, 5
IfWinActive, InstallShield
{
     Loop 50
     {
          WinGetText, thetext, QBFC, InstallShield
          if RegExMatch(thetext, "successfully")
               break
          Sleep 50
     }
     Send {Enter}
}
Loop 50
{
     WinGetText, thetext, SalesPad
     if RegExMatch(thetext, "installed")
          break
     Sleep 50
}
Send {Enter}


Exitapp