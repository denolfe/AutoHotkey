#NoEnv
#WinActivateForce
#SingleInstance force
#Persistent
Sendmode Input
SetWorkingDir %A_ScriptDir%
SetTitleMatchmode, 2
DetectHiddenWindows, On
;#Include Mymethods.ahk
;#Include lib\Notify.ahk
#Include lib\DynamicHotstrings.ahk

hotstrings("email(\w+)\s", "mail")
Return

mail:

SendInput, Hi %$1%,{Enter 2}Sample text.{Enter 2}Thanks,{Enter}Zach

return

/*

Hi Jim,

Sample text.

Thanks,
Zach