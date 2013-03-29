#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#WinActivateForce
#SingleInstance force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode, 2

; using Loop (files & folders) to create one quickly if you want to merge all TXT files for example:
Loop, C:\Users\elliotd\Dropbox\Scripts\Presave-Onload\*.cs
  FileList .= A_LoopFileFullPath "`n"
TF_Merge(FileList) ; will create merged.txt, you can use ! to overwrite an excisting file if you want