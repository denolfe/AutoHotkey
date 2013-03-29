#NoEnv
#WinActivateForce
#SingleInstance force
#Notrayicon
SendMode Input
SetWorkingDir %A_ScriptDir%
SetTitleMatchMode, 2

#persistent
#Include MyMethods.ahk

Gui,Add,Picture,x0 y0 Center , AHK-Flat-Wide.png
;Gui, Add, Text,Transparent, Please enter your name:
Gui,Margin,0,0
Gui +LastFound +ToolWindow -Caption -Border
Gui, Show, Autosize Center

FadeIn(ahk_class AutoHotkeyGui)
Sleep 1000
FadeOut(ahk_class AutoHotkeyGui)
Sleep 1000
Exitapp
