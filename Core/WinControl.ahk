/*
http://www.autohotkey.com/forum/viewtopic.php?t=70259
http://www.autohotkey.com/forum/topic57583.html
Hotkeys:

CapsLock-A: make window always on top

CapsLock-W: make window less transparent
CapsLock-S: make window more transparent

CapsLock-X: make window clickthoughable
CapsLock-Z: make window under mouse unclickthroughable
*/

;; Always On Top Toggle
CapsLock & a::
   WinGet, currentWindow, ID, A
   WinGetTitle, title, A
   WinGet, ExStyle, ExStyle, ahk_id %currentWindow%
   SetTimer, Blink, -200
   If (ExStyle & 0x8)  ; 0x8 is WS_EX_TOPMOST.
   {
      Winset, AlwaysOnTop, off, ahk_id %currentWindow%
      SplashImage,, x0 y0 b fs12, OFF always on top.
   }
   Else
   {
      WinSet, AlwaysOnTop, on, ahk_id %currentWindow%
      SplashImage,,x0 y0 b fs12, ON always on top.
   }
   
   SetTimer, TurnOffSI, 1000, On
Return

;; Less Transparent
CapsLock & w::
   WinGet, currentWindow, ID, A
   If not (%currentWindow%)
   {
      %currentWindow% := 255
   }
   If (%currentWindow% != 255)
   {
      %currentWindow% += 5
      WinSet, Transparent, % %currentWindow%, ahk_id %currentWindow%
   }
   SplashImage,,w100 x0 y0 b fs12, % %currentWindow%
   SetTimer, TurnOffSI, 1000, On
Return

;; More Transparent
CapsLock & s::
   SplashImage, Off
   WinGet, currentWindow, ID, A
   If not (%currentWindow%)
   {
      %currentWindow% := 255
   }
   If (%currentWindow% != 5)
   {
      %currentWindow% -= 5
      WinSet, Transparent, % %currentWindow%, ahk_id %currentWindow%
   }
   SplashImage,, w100 x0 y0 b fs12, % %currentWindow%
   SetTimer, TurnOffSI, 1000, On
Return

;; Make Window Clickthrough
CapsLock & x::
   WinGet, currentWindow, ID, A
   WinGetTitle, title, A
   SetTimer, Blink, -200
   WinSet, ExStyle, +0x80020, ahk_id %currentWindow%
   SplashImage,,x0 y0 b fs12, Clickthrough Enabled.
   SetTimer, TurnOffSI, 1000, On
   Return

;; Make Window Clickable
CapsLock & z::
   MouseGetPos,,, MouseWin ; Gets the unique ID of the window under the mouse
   WinGetTitle, title, %currentwindow%
   SetTimer, Blink, -200
   WinSet, ExStyle, -0x80020, ahk_id %currentWindow%
   SplashImage,,x0 y0 b fs12, Clickthrough Enabled.
   SetTimer, TurnOffSI, 1000, On
Return

CapsLock & b::
   WinSet, Style, -0xC00000,a ; remove the titlebar and border(s) 
Return

TurnOffSI:
   SplashImage, off
   SetTimer, TurnOffSI, 1000, Off
Return



Blink:
   Loop, 2
   {
      WinSet, Transparent, 175 , %title%
      Sleep, 100
      WinSet, Transparent, OFF, %title%
      Sleep 100
   }
Return