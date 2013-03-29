Gui, +AlwaysOnTop
Gui, add, edit, vedit1 w400 h300 ;Remember asigning the variable
Gui, show
gosub, refresh
Settimer, refresh, 1000
return

refresh:
	Settimer, refresh, off
	Runwait %comspec% /c ping www.autohotkey.com >ping.txt,,hide
	FileRead, file, ping.txt
	FormatTime, now, , HH:mm:ss
	GuiControl,,edit1,%now%`n%file%
	Settimer, refresh, 1000
return
ExitApp
esc::ExitApp
