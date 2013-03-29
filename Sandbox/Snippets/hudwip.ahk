#NoEnv
#WinActivateForce
#SingleInstance force
SendMode Input
SetWorkingDir %A_ScriptDir%
SetTitleMatchMode, 2
#Include MyMethods.ahk
#Include lib\tf.ahk
Settitlematchmode, 2

CoordMode,Mouse,Screen
MouseGetPos,mx,my
mousepos := mx+my


Gui, 1: Default

Gui, Color, 0x000000 ; Color to black
Gui, +LastFound +AlwaysOnTop -Caption +E0x20 ; Click through GUI always on top.
WinSet, Transparent, 100 ; Set intensity first based on the time of dday
Gui, 1: +owner
Gui, Show, center w400 h200

FadeIn(ahk_class AutoHotkeyGui,1000,100)
Sleep 2000
FadeOut(ahk_class AutoHotkeyGui, 1000)