#NoEnv
#WinActivateForce
#SingleInstance force
SendMode Input
SetWorkingDir %A_ScriptDir%
SetTitleMatchMode, 2
#Include MyMethods.ahk

#InstallKeybdHook
#SingleInstance force

;http://www.autohotkey.com/forum/topic8434.html

sleep 1000

MouseGetPos, ClickX, ClickY, WindowUnderMouseID
msgbox % WindowUnderMouseID