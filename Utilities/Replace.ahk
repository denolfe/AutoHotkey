/*
Mango: Clipboard Replace
Creator: tidbit
Version: 1.70 (Tue December 13, 2011)
Info: A plugin for my personal script Mango.
*/
#singleinstance OFF
amount:=-1
mode=
Gui, +AlwaysOnTop +Resize
Gui, Add, Text, x4 y6 w80 h20 , &Find what?
Gui, Add, Edit, x+2 yp w250 r2 wanttab gPreview vfind,
Gui, Add, Text, x4 y+3 w80 h20 , Replace &with?
Gui, Add, Edit, x+2 yp w250 r2 wanttab gPreview vrepwith,

Gui, Add, Button, xp+160 y+5 w90 h20 vbtnrep greplace, &Replace
Gui, Add, Button, xp y+3 w90 h20 vbtnprev gPreview Default, &Preview
Gui, Add, Button, xp y+3 w90 h20 vbtnCancel gcancel, Cancel (Esc)

Gui, Add, Checkbox, x6 yp-50 w90 h20 gPreview vcs, &Case Sensitive
Gui, Add, Checkbox, x+5 yp w130 h20 gPreview vwwo, &Whole Words Only
Gui, Add, Checkbox, x6 y+3 w90 h20 gPreview vra +Checked, Replace &All?
Gui, Add, Checkbox, xp y+3 w90 h20 gPreview vrem, Rege&x Mode
Gui, Add, Button, x+5 yp w20 h20 gregexhelp, ?

Gui, Add, Edit, x6 y+5 w330 h310 +HScroll vpreviewbox,

Gui, Show,, Clipboard Replace
gosub, Preview
Return


11GuiClose:
	Gui, Destroy
Return


OnClipboardChange:
	gosub, Preview
Return


replace:
	Gui, Submit, NoHide
	gui, 1: default
	Gosub, setup
	
	;StringReplace, Clipboard, previewbox, `n, `r`n, All  ;;;;;;;Changed by me
	StringReplace, Clipboard, previewbox, `n, `n, All
	GuiControl, , previewbox, %Clipboard%
Return


Preview:
	Gui, 1: Submit, NoHide
	gui, 1: default
	Gosub, setup

	reg:=case find ;combine Case and Find into one so i can Insert the combination into the Regex without any Errors.
	;stringreplace, reg, reg, %a_space%, %a_space%, all
	previewChange:=RegExReplace(Clipboard, reg, repwith)
	
	StringReplace, previewChange, previewChange, `n, `r`n, All
	GuiControl, , previewbox, %previewChange%
Return


Guisize:
	If ErrorLevel = 1  ; The window has been Minimized.  No action needed.
		Return
	; GuiControl, Movedraw, btnrep,  % "x"A_GuiWidth-96 "y"A_GuiHeight-A_GuiHeight +67
	; GuiControl, Movedraw, btnprev, % "x"A_GuiWidth-96 "y"A_GuiHeight-A_GuiHeight +92
	; GuiControl, Movedraw, btnCancel, % "x"A_GuiWidth-96 "y"A_GuiHeight-A_GuiHeight+117
	; GuiControl, Move, find, % "w"A_GuiWidth-91
	; GuiControl, Move, repwith, % "w"A_GuiWidth-91
	; GuiControl, Move, previewbox, % "W"A_GuiWidth-6 "H"A_GuiHeight-127
anchor("find", "w")
anchor("repwith", "w")
anchor("previewbox", "w h")
anchor("btnrep", "x")
anchor("btnprev", "x")
anchor("btncancel", "x")
Return


setup:
Gui, Submit, NoHide
gui, 1: default
	If (cs=1) ;case sensitive
		case=
	Else
		case=i)

	If (rem=0) ;regex mode
		find:=RegExReplace(find,  "[\\.*?+[{|()^$]", "\$0")

	;this >>MUST<< be after Regex Mode.
	If (wwo=1) ;whole words only
		find=\b%find%\b

	If (ra=1) ;replace all
		amount=-1
	Else
		amount=1
Return


regexhelp:
	Gui, 11: Destroy
	Gui, 11: Default
	help=
	(
.	Matches any character.	cat. matches catT and cat2 but not catty
[]	Bracket expression. Matches one of any characters enclosed.	gr[ae]y matches gray or grey
[^]	Negates a bracket expression. Matches one of any characters EXCEPT those enclosed.	1[^02] matches 13 but not 10 or 12
[-]	Range. Matches any characters within the range.	[1-9] matches any single digit EXCEPT 0
?	Preceeding item must match one or zero times.	colou?r matches color or colour but not colouur
()	Parentheses. Creates a substring or item that metacharacters can be applied to	a(bee)?t matches at or abeet but not abet
{n}	Bound. Specifies exact number of times for the preceeding item to match.	[0-9]{3} matches any three digits
{n,}	Bound. Specifies minimum number of times for the preceeding item to match.	[0-9]{3,} matches any three or more digits
{n,m}	Bound. Specifies minimum and maximum number of times for the preceeding item to match.	[0-9]{3,5} matches any three, four, or five digits
|	Alternation. One of the alternatives has to match.	July (first|1st|1) will match July 1st but not July 2
[:alnum:]	alphanumeric character	[[:alnum:]]{3} matches any three letters or numbers, like 7Ds
[:alpha:]	alphabetic character, any case	[[:alpha:]]{5} matches five alphabetic characters, any case, like aBcDe
[:blank:]	space and tab	[[:blank:]]{3,5} matches any three, four, or five spaces and tabs
[:digit:]	digits	[[:digit:]]{3,5} matches any three, four, or five digits, like 3, 05, 489
[:lower:]	lowercase alphabetics	[[:lower:]] matches a but not A
[:punct:]	punctuation characters	[[:punct:]] matches ! or . or , but not a or 3
[:space:]	all whitespace characters, including newline and carriage return	[[:space:]] matches any space, tab, newline, or carriage return
[:upper:]	uppercase alphabetics	[[:upper:]] matches A but not a
	Default delimiters for pattern	colou?r matches color or colour
i	Append to pattern to specify a case insensitive match	colou?ri matches COLOR or Colour
\b	A word boundary, the spot between word (\w) and non-word (\W) characters	\bfred\bi matches Fred but not Alfred or Frederick
\B	A non-word boundary	fred\Bi matches Frederick but not Fred
\d	A single digit character	a\dbi matches a2b but not acb
\D	A single non-digit character	a\Dbi matches aCb but not a2b
\n	The newline character. (ASCII 10)	\n matches a newline
\r	The carriage return character. (ASCII 13)	\r matches a carriage return
\s	A single whitespace character	a\sb matches a b but not ab
\S	A single non-whitespace character	a\Sb matches a2b but not a b
\t	The tab character. (ASCII 9)	\t matches a tab.
\w	A single word character - alphanumeric and underscore	\w matches 1 or _ but not ?
\W	A single non-word character	a\Wbi matches a!b but not a2b

	)

	Gui, 11: add, text, y6 x6, Regex Help
	Gui, 11:add, ListView, yp+22 xp w450 r25 vlist, Key|Description|Example


	Loop, Parse, help, `n, `r
	{
		StringSplit, col, A_LoopField, %A_Tab%
		LV_Add( "", col1, col2, col3)
	}

	LV_ModifyCol(1, "Auto")
	LV_ModifyCol(2, 200)
	LV_ModifyCol(3, "Auto")

	gui, 11: show, x45 , Regex Help
Return


Esc::
cancel:
GuiClose:
	ExitApp
Return








/*
	Function: Anchor
		Defines how controls should be automatically positioned relative to the new dimensions of a window when resized.

	Parameters:
		cl - a control HWND, associated variable name or ClassNN to operate on
		a - (optional) one or more of the anchors: 'x', 'y', 'w' (width) and 'h' (height),
			optionally followed by a relative factor, e.g. "x h0.5"
		r - (optional) true to redraw controls, recommended for GroupBox and Button types

	Examples:
> "xy" ; bounds a control to the bottom-left edge of the window
> "w0.5" ; any change in the width of the window will resize the width of the control on a 2:1 ratio
> "h" ; similar to above but directrly proportional to height

	Remarks:
		To assume the current window size for the new bounds of a control (i.e. resetting) simply omit the second and third parameters.
		However if the control had been created with DllCall() and has its own parent window,
			the container AutoHotkey created GUI must be made default with the +LastFound option prior to the call.
		For a complete example see anchor-example.ahk.

	License:
		- Version 4.60a <http://www.autohotkey.net/~polyethene/#anchor>
		- Dedicated to the public domain (CC0 1.0) <http://creativecommons.org/publicdomain/zero/1.0/>
*/
Anchor(i, a = "", r = false) {
	static c, cs = 12, cx = 255, cl = 0, g, gs = 8, gl = 0, gpi, gw, gh, z = 0, k = 0xffff
	If z = 0
		VarSetCapacity(g, gs * 99, 0), VarSetCapacity(c, cs * cx, 0), z := true
	If (!WinExist("ahk_id" . i)) {
		GuiControlGet, t, Hwnd, %i%
		If ErrorLevel = 0
			i := t
		Else ControlGet, i, Hwnd, , %i%
	}
	VarSetCapacity(gi, 68, 0), DllCall("GetWindowInfo", "UInt", gp := DllCall("GetParent", "UInt", i), "UInt", &gi)
		, giw := NumGet(gi, 28, "Int") - NumGet(gi, 20, "Int"), gih := NumGet(gi, 32, "Int") - NumGet(gi, 24, "Int")
	If (gp != gpi) {
		gpi := gp
		Loop, %gl%
			If (NumGet(g, cb := gs * (A_Index - 1)) == gp) {
				gw := NumGet(g, cb + 4, "Short"), gh := NumGet(g, cb + 6, "Short"), gf := 1
				Break
			}
		If (!gf)
			NumPut(gp, g, gl), NumPut(gw := giw, g, gl + 4, "Short"), NumPut(gh := gih, g, gl + 6, "Short"), gl += gs
	}
	ControlGetPos, dx, dy, dw, dh, , ahk_id %i%
	Loop, %cl%
		If (NumGet(c, cb := cs * (A_Index - 1)) == i) {
			If a =
			{
				cf = 1
				Break
			}
			giw -= gw, gih -= gh, as := 1, dx := NumGet(c, cb + 4, "Short"), dy := NumGet(c, cb + 6, "Short")
				, cw := dw, dw := NumGet(c, cb + 8, "Short"), ch := dh, dh := NumGet(c, cb + 10, "Short")
			Loop, Parse, a, xywh
				If A_Index > 1
					av := SubStr(a, as, 1), as += 1 + StrLen(A_LoopField)
						, d%av% += (InStr("yh", av) ? gih : giw) * (A_LoopField + 0 ? A_LoopField : 1)
			DllCall("SetWindowPos", "UInt", i, "Int", 0, "Int", dx, "Int", dy
				, "Int", InStr(a, "w") ? dw : cw, "Int", InStr(a, "h") ? dh : ch, "Int", 4)
			If r != 0
				DllCall("RedrawWindow", "UInt", i, "UInt", 0, "UInt", 0, "UInt", 0x0101) ; RDW_UPDATENOW | RDW_INVALIDATE
			Return
		}
	If cf != 1
		cb := cl, cl += cs
	bx := NumGet(gi, 48), by := NumGet(gi, 16, "Int") - NumGet(gi, 8, "Int") - gih - NumGet(gi, 52)
	If cf = 1
		dw -= giw - gw, dh -= gih - gh
	NumPut(i, c, cb), NumPut(dx - bx, c, cb + 4, "Short"), NumPut(dy - by, c, cb + 6, "Short")
		, NumPut(dw, c, cb + 8, "Short"), NumPut(dh, c, cb + 10, "Short")
	Return, true
}
