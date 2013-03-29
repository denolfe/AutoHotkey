SetTitleMatchMode, 2
#SingleInstance force

BK := "Silver"

Gui Add, Edit, vVar
Gui Add, Button, x10 y+10 h25 w126 Default,OK
Gui Show,, Example

Gui, 2:Add, Edit, 
Gui, 2:Add, Button, x10 y+10 h50 w300 Default,OK
Gui, 2:Color, %BK%
Gui, 2:Show,, gui2



Return

ButtonOK:
Gui Submit ;, NoHide
msgbox % Var
clipboard := Var
ExitApp