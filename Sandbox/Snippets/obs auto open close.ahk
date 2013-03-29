WinExist(title)
{
	return WinExist(%title%)
}

/*
SetTimer, OBS, 1000
return

OBS: 
	WinWait, ahk_class Notepad
	SetTimer, OBS, off
	Run, SpotifyOBS.ahk
	Loop
	{
		IfWinExist, ahk_class Notepad
		{
			continue
		}
		else
		{
			WinClose, SpotifyOBS.ahk ahk_class AutoHotkey
			SetTimer, OBS, On
			msgbox, done
			break
		}	
	}	
Return