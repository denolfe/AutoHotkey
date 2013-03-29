#NoEnv
#WinActivateForce
#SingleInstance force
SendMode Input
SetWorkingDir %A_ScriptDir%
SetTitleMatchMode, 2
#Include MyMethods.ahk

#Persistent

;WinGet, active_id, ID, A
WinGetTitle, now_playing, ahk_class SpotifyMainWindow
StringTrimLeft, playing, now_playing, 10
WinSet, Transparent, 0, ahk_class AutoHotkeyGUI
Gui,+AlwaysOnTop +ToolWindow +E0x20 +E0x08000000 -Caption -Border 

Gui, Add, Text,BackgroundTrans vVar, %playing%
Gui, Show,,No Activation
DetectHiddenWindows, Off



Loop
{
WinGetTitle, now_playing, ahk_class SpotifyMainWindow
StringTrimLeft, playing, now_playing, 10
GuiControl,,Var, %playing%
Sleep 5000
}