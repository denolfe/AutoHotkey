Gui, Add, CheckBox, x12 y10 w100 h30 , Always On Top
Gui, Add, CheckBox, x12 y40 w100 h30 , Clickthrough
Gui, Add, Slider, x12 y90 w100 h30 vTrans , 100
; Generated using SmartGUI Creator 4.0
Gui, Show, x-1102 y304 h134 w127, Window Control
Return

GuiClose:
ExitApp


!a::
WinGet, currentWindow, ID, A
WinGet, ExStyle, ExStyle, ahk_id %currentWindow%
if (ExStyle & 0x8)  ; 0x8 is WS_EX_TOPMOST.
{
   Winset, AlwaysOnTop, off, ahk_id %currentWindow%
   SplashImage,, x0 y0 b fs12, OFF always on top.
   Sleep, 1500
   SplashImage, Off
}
else
{
   WinSet, AlwaysOnTop, on, ahk_id %currentWindow%
   SplashImage,,x0 y0 b fs12, ON always on top.
   Sleep, 1500
   SplashImage, Off
}
return

!x::
WinGet, currentWindow, ID, A
WinSet, ExStyle, +0x80020, ahk_id %currentWindow%
return

!z::
MouseGetPos,,, MouseWin ; Gets the unique ID of the window under the mouse
WinSet, ExStyle, -0x80020, ahk_id %currentWindow%
Return

