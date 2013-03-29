;http://www.autohotkey.com/community/viewtopic.php?f=2&t=89143
^Space::WinSet, Transparent, 75 , A
^Space UP::WinSet, Transparent, OFF, A

!Space::

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
Return