; Media Shortcuts

CapsLock & [::SendInput, {Media_Prev}

ScrollLock::
CapsLock & ]::SendInput, {Media_Next}

Pause::
CapsLock & |::SendInput, {Media_Play_Pause}

CapsLock & PgUp::SendInput, {Volume_Up}
CapsLock & PgDn::SendInput, {Volume_Down}

RCtrl & Enter::
PrintScreen::		Gosub, Spotify

Spotify:
	If WinActive("ahk_class SpotifyMainWindow")
	{
		Send, !{Tab}
		WinMinimize, ahk_class SpotifyMainWindow
	}
	Else
	{
		If WinExist("ahk_class SpotifyMainWindow")
			WinActivate
		else
		{
        	Run, % A_Appdata . "\Spotify\spotify.exe", UseErrorLevel
            If ErrorLevel
            {
                Notify("Spotify.exe not found", title,-3,"Style=Error")
                Return
            }
            WinActivate
		}
		SetTitleMatchMode, 2
	}
Return