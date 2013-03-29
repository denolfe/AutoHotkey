#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#WinActivateForce
#SingleInstance force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode, 2

;#Include lib\ini.ahk
;;http://www.autohotkey.com/forum/topic46226.html

;ini_load(ini)

;value := ini_getKey(ini, "Tip", "TimeStamp")


;msgbox % value

#NoTrayIcon
Gui, +AlwaysOnTop +LastFound +Owner
Gui, Add, Picture, x0 y0 w200 h200, splash.jpg
Gui, -Caption 
Gui, Show, x3575 y825, Test
;WinSet, TransColor, %CustomColor% 150
Sleep 3000

Exitapp

