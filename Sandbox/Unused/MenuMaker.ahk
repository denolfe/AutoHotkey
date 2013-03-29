;Generated in SmartGUI 4.0 :)
Gui, Add, Text, x2 y2 w100 h20 , Menu Name
Gui, Add, Text, x2 y82 w100 h30 , Menu Display name
Gui, Add, Edit, x2 y112 w100 h30 vShowName, Display Name
Gui, Add, Edit, x2 y22 w100 h30 vname, Menu Name
Gui, Add, Button, x42 y172 w60 h20 gSubmit, Ok
Gui, Add, Edit, x222 y2 w160 h180 vFunc, Function
Gui, Add, Edit, x392 y2 w300 h190 +ReadOnly vres, Result `;)
Gui, Add, Edit, x112 y52 w100 h30 vCommand, Label name
Gui, Add, Text, x112 y22 w100 h30 , Menu Func Name
Gui, Show, x129 y85 h218 w706, Menu Creator 
Return

GuiClose:
ExitApp


Submit:
Gui,Submit,NoHide

GuiControl,,res,Menu,%Name%,Add,%ShowName%,%Command%`n%Command%:`n%Func%
Return