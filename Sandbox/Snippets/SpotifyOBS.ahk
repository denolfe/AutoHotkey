#NoEnv
#Singleinstance force
#Persistent
SetTitleMatchMode, 2

file := "nowplaying.txt"
scroll_space := 
was_playing := ""
needs_refresh := 0


SetTimer, CheckSong, 1000

Gui Add, Edit, w250 vVar ReadOnly
Gui Add, Edit, w250 vPrefix
Gui Add, Checkbox, vScrolling, Scrolling
Gui Add, Button, x10 y+10 h25 w126 gSave Default,OK
Gui Show,h131 w290, Spotify Playing


return 

CheckSong:

WinGetTitle, playing, ahk_class SpotifyMainWindow
StringTrimLeft, playing, playing, 10
if (was_playing != playing) or needs_refresh
{
	;Traytip, Song Changed, %playing%, 1
	was_playing := playing

	playing_formatted := scroll_space . Prefix . playing
	FileDelete %file%
	FileAppend, %playing_formatted%, %file%, UTF-8
	needs_refresh := 0
}
GuiControl,,Var,%playing_formatted%

Return

Save:

Gui, Submit, NoHide

scroll_space := (scrolling) ? "       " : ""
needs_refresh := 1
Return