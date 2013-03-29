#NoEnv
#WinActivateForce
#SingleInstance force
SendMode Input
SetWorkingDir %A_ScriptDir%
SetTitleMatchMode, 2
#Include MyMethods.ahk

#InstallKeybdHook
#SingleInstance force

a::
	WinGetActiveTitle, title
	WinGetClass, class, A
	WinGetPos, X, Y, W, H, %title%
	clipboard = WinMove, ahk_class %class%%A_Space%%title%,, %X%,%Y%,%W%,%H%
	msgbox % clipboard

Exitapp