; http://www.autohotkey.com/forum/topic9422.html
; http://www.autohotkey.com/forum/topic70531.html

;THIS OnE!
;http://www.autohotkey.com/forum/topic11204.html


#Persistent
SetTimer, CheckIfActive, 10000
return

CheckIfActive:
WinGet, id, list, , , Program Manager
Loop, %id%
{
    StringTrimRight, this_id, id%a_index%, 0
    WinGetTitle, title, ahk_id %this_id%
	WinGetClass, class, A
	WinGet, id_min, ID, ahk_id %this_id%
    WinGet, minim , MinMax, ahk_id %this_id%
	match = 0
	
	; if minimized, restart on new app
    If minim = -1
        continue
	;If wininactive%ID_min% < 60
	;	continue
	IfInString, title, Note
	{
        match = 1
    }
	IfInString, title, Everything
	{
        match = 1
    }
	IfInString, class, icoAstra
	{
        match = 1
    }
	If match
		WinMinimize, %title%
}
return 