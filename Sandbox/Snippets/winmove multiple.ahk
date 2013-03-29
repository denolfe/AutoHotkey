

WinGet, id, list,,, Program Manager
Loop, %id%
{
    this_id := id%A_Index%
	WinGetTitle, this_title, ahk_id %this_id%
	WinGetPos, X, Y, Width, Height, %this_title%
	;msgbox % X
	if (X > 1900 && X < 2350)
	{
		;msgbox % this_title X
		WinMove, %this_title%,, 2350, Y, Width, Height
	}
}

/*

WinGetPos, X, Y, Width, Height, %id%


if (X > 1920)
	WinMove, %id%,, 2400, Y, Width, Height


;WinMove, VLC media player, 2130,112,488,140