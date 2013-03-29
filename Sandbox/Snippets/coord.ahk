Edge = 1079

Loop
{
  MouseGetPos,mx,my

  If (my=Edge)
    bottom = 1
  Else
	bottom = 0
  Sleep,50
}


~MButton::
;If bottom
;{
	;MsgBox, yes 1
	If mx between 1474 and 1900
		msgbox, yes 2
;}