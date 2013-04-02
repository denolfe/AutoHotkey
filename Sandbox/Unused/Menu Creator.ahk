#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, force

CreateMenu(LVMenu, PMenu), CreateHotkey("PGUP", "PGDN")
, qmenu := new MenuProp()
, item := new ItemProp()
, qmenu.Create(), qmenu.Show()
return

QMenuContextMenu:
GuiContextHandler(A_Gui, A_GuiControl)
return

QMenuClose:
if (A_Gui == "Main")
	qmenu.Destroy()
if (A_Gui == "2")
	item.Destroy()
return

QMenuCommand:
GuiCommandHandler(A_Gui)
return

#IfWinActive, Menu Creator
QMenuKey:
HotkeyHandler(A_ThisHotkey)
return

;=======================================================================================
;~ Functions
;=======================================================================================

CreateMenu(ByRef ObjA, ByRef ObjB) {
	global Menu
	ObjA := new Menu("LVMenu"), ObjB := new Menu("Preview")
	i := ["Add Item", "Edit Item", "Add Separator", "Remove Item", "Quick Help", "", "Preview"]
	for k, v in i {
		if (v <> "")
			v <>  "Preview" ? ObjA.AppendItem(v, "MenuCommandHandler") : ObjA.AddSubMenu(ObjB,  v) 
		else
			ObjA.AddSeparator()
	}
}

CreateHotkey(params*) {
	for k, v in params
		Hotkey, % v, QMenuKey
}

MenuCommandHandler() {
	global qmenu, item
	if (A_ThisMenuItem == "Add Item")
		item.Create(), item.Show()
	if (A_ThisMenuItem == "Edit Item")
		item.Create(true, qmenu.MenuItems.GetSelProp()), item.Show(A_ThisMenuItem " " LV_GetNext())
	if (A_ThisMenuItem == "Add Separator")
		qmenu.MenuItems.AddSep()
	if (A_ThisMenuItem == "Remove Item")
		qmenu.MenuItems.Remove()
	if (A_ThisMenuItem == "Quick Help")
		MenuMsgHandler(A_ThisMenuItem)
}

GuiCommandHandler(param) {
	global qmenu, item
	if (param == "Main")
		qmenu.CommandHandler(A_GuiControl)
	if (param == "2")
		item.CommandHandler(A_GuiControl)
}

GuiContextHandler(param1, param2) {
	global LVMenu
	if (param1 == "Main") {
		if (param2 == "Items")
			LV_GetText(txt, LV_GetNext() ? LV_GetNext() : 1, 2)
			, LVMenu.SetItem("Edit Item", (txt == "<Separator>" || txt == "<StdItems=10>" || txt == "" ? "Disable" : "Enable"))
			, LVMenu.SetItem("Remove Item", (txt == "<StdItems=10>" || txt == "" ? "Disable" : "Enable"))
			, LV_GetCount() >= 1 ? (LVMenu.SetItem("Preview", "Enable"), CreatePreview()) : LVMenu.SetItem("Preview", "Disable")
			, LVMenu.Show()
	}
}

HotkeyHandler(param) {
	global qmenu
	if (param == "PGUP")
		qmenu.MenuItems.MoveItem()
	if (param == "PGDN")
		qmenu.MenuItems.MoveItem(false)
}

CreatePreview() {
	global qmenu
	qmenu.Submit(m, false), qmenu.MenuItems.GetAll(i)
	, Preview(m, i, m["MenuName"] = "Tray" ? true : false)
}

Preview(m, i, tray=false) {
	global PMenu
	PMenu.RemoveAll(), PMenu.Standard(false), PMenu.SetColor("Default", true)
	for a, b in i {
		sLine := ""
		if !In(b["ItemName"], "<Separator>`,<StdItems=10>") ; Normal item
			SubStr(b["LabelorSubMenu"], 1, 1) == ":"
				? PMenu.AddSubMenu("Tray", (InStr(b["ItemName"], "``t") ? RegExReplace(b["ItemName"], "``t", "`t") : b["ItemName"]))
				: PMenu.AppendItem(InStr(b["ItemName"], "``t") ? RegExReplace(b["ItemName"], "``t", "`t") : b["ItemName"], "MenuMsgHandler")
		else if (b["ItemName"] == "<Separator>") ; Separator
			PMenu.AddSeparator()
		else if (b["ItemName"] == "<StdItems=10>") ; Standard items
			PMenu.Standard()
		if !In(b["State"], "<Separator>,<StdItems=10>,Normal") { ; Item states
			states := b["State"]
			Loop, Parse, states, `,
				In(A_LoopField, "Check,Disable")
					? PMenu.SetItem(InStr(b["ItemName"], "``t") ? RegExReplace(b["ItemName"], "``t", "`t") : b["ItemName"], A_LoopField)
					: PMenu.Default(InStr(b["ItemName"], "``t") ? RegExReplace(b["ItemName"], "``t", "`t") : b["ItemName"])
		}
		if !In(b["IconFile"], "`,<Separator>,<StdItems=10>")
			PMenu.SetIcon(InStr(b["ItemName"], "``t") ? RegExReplace(b["ItemName"], "``t", "`t") : b["ItemName"], b["IconFile"], (b["IconNumber"] ? b["IconNumber"] : ""), (b["IconWidth"] ? b["IconWidth"] : ""))
	}
	m["MenuColor"] <> "Default" ? PMenu.SetColor(m["MenuColor"], m["Single"]) : ""
}

MenuMsgHandler(param="Preview") {
	if (param == "Preview")
		MsgBox, 64, , This is a preview.
	if (param == "Quick Help")
		MsgBox, 0, Menu Creator - Quick Help, 
		(LTrim
		Use "PageUp" and "PageDown" to move an item up and down the ListView.
		
		When specifiying an item name in the Add/Edit Item window, ampersands(&) are treated as literal ampersands. Select the letter that you would like to underline from the "Underlined letter" DropDownList.
		
		Duplicate "hotkeys" are allowed when creating menus, but for "Best Practices" purposes, a warning message is displayed every time a duplicate is found. Should you wish to create items sharing the same hotkeys, just edit those lines manually after you have copied and pasted the generated code. Same goes for underlined letters, but since it is useful for navigation, an option to allow same underlined letters is provided in the main window of the script.
		)
}

;~ Miscellaneous functions
GetFileName(FilePattern) {
	SplitPath, FilePattern, FileName
	return FileName
}

IsEnabled(control) {
	GuiControlGet, e, Enabled, % control
	return e
}

IsChecked(control) {
	if InStr(control, "Button")
		GuiControlGet, c,, % control
	return c ? c : false
}

CtrlEnable(enable=true, controls*) {
	for k, v in controls {
		if enable {
			if !IsEnabled(v)
				GuiControl, Enable, % v
		} else {
			if IsEnabled(v)
				GuiControl, Disable, % v
		}
	}
}

CtrlCheck(check=true, controls*) {
	for k, v in controls {
		if check {
			if !IsChecked(v)
				GuiControl,, % v, 1
		} else {
			if IsChecked(v)
				GuiControl,, % v, 0
		}
	}
}

LV_Get(row, col) {
	LV_GetText(txt, row, col)
	return txt
}

EnvReplace(haystack) {
	while pos := RegExMatch(haystack, "\%\w+\%", env, pos ? pos+StrLen(str) : 1) {
		EnvGet, str, % RegExReplace(env, "\%", "")
		haystack := RegExReplace(haystack, env, str)
	}
		return haystack
}

KeyVal(Array, f, key=true) {
	f := Func(f)
	for k, v in Array
		if f.(key ? k : v)
			return key ? v : k
}

In(var, MatchList) {
   if var in % MatchList
      return True
}

Contains(var, MatchList) {
	if var contains % MatchList
		return true
}

Dlg_Color(ByRef Color, hGui=0) {
	;covert from rgb
    clr := ((Color & 0xFF) << 16) + (Color & 0xFF00) + ((Color >> 16) & 0xFF)
    VarSetCapacity(CHOOSECOLOR, 0x24, 0), VarSetCapacity(CUSTOM, 64, 0)
	 , NumPut(0x24,		CHOOSECOLOR, 0)      ; DWORD lStructSize 
	 , NumPut(hGui,		CHOOSECOLOR, 4)      ; HWND hwndOwner (makes dialog "modal"). 
	 , NumPut(clr,		CHOOSECOLOR, 12)     ; clr.rgbResult 
	 , NumPut(&CUSTOM,	CHOOSECOLOR, 16)     ; COLORREF *lpCustColors
	 , NumPut(0x00000103,CHOOSECOLOR, 20)     ; Flag: CC_ANYCOLOR || CC_RGBINIT 
    nRC := DllCall("comdlg32\ChooseColorA", str, CHOOSECOLOR)  ; Display the dialog. 
    if (errorlevel <> 0) || (nRC = 0) 
       return  false 
    clr := NumGet(CHOOSECOLOR, 12) 
    oldFormat := A_FormatInteger 
    SetFormat, integer, hex  ; Show RGB color extracted below in hex format. 
	;convert to rgb 
    Color := (clr & 0xff00) + ((clr & 0xff0000) >> 16) + ((clr & 0xff) << 16) 
    StringTrimLeft, Color, Color, 2 
    Loop, % 6-strlen(Color) 
		Color=0%Color% 
    Color=0x%Color% 
    SetFormat, integer, %oldFormat% 
	return true
}

Dlg_Icon(ByRef Icon, ByRef Index, hGui=0) {
	PtrType := A_PtrSize ? "Ptr" : "UInt"
	VarSetCapacity(wIcon, 1025, 0)
	if (Icon && !StrPut(Icon, &wIcon, StrLen(Icon) + 1, "UTF-16"))
		return false
	r := DllCall(DllCall("GetProcAddress", PtrType, DllCall("LoadLibrary", "str", "shell32.dll"), "Uint", 62, PtrType), PtrType, hGui, PtrType, &wIcon, "uint", 1025, "intp", --Index)
	Index++
	IfEqual, r, 0, return false
	len := DllCall("lstrlenW", "UInt", &wIcon)
	if (A_IsUnicode)
		return true, VarSetCapacity(wIcon, -1), Icon := wIcon
	if (!Icon := StrGet(&wIcon, len + 1, "UTF-16"))
		return false
    return True 
}

;=======================================================================================
;~ Classes
;=======================================================================================

class MenuProp
{
	static Handle := "", ImageList := 
	
	__New() {
		MenuProp.ImageList := IL_Create()
	}
	
	Create() {
		static MName, Color, More, Icon, Items, Standard, Space, Show, Mouse, Coord, MBar, Insert, Copy, Cancel
		; Menu Properties
		Gui , Main: +HwndhMenuProp +LabelQMenu
		Gui , Main:Add , Groupbox , x8 y7 w260 h120 , Menu Properties
		Gui , Main:Add , Text , x42 y34 w60 h15 Right , Menu Name
		Gui , Main:Add , Edit , x108 y34 w150 h20 vMName gQMenuCommand,
		Gui , Main:Add , Text , x17 y62 w85 h15 Right , Background Color
		Gui , Main:Add , ComboBox , x108 y62 w95 vColor gQMenuCommand, Default||Black|Silver|Gray|White|Maroon|Red|Purple|Fuchsia|Green|Lime|Olive|Yellow|Navy|Blue|Teal|Aqua
		Gui , Main:Add , Button , x209 y62 w50 h22 vMore gQMenuCommand, More
		Gui , Main:Add , Checkbox , x16 y90 w245 h26 0x400 , Single (If checked, any attached submenus will not be affected by the color setting)
		; Tray Properties
		Gui , Main:Add , Groupbox , x275 y7 w268 h120 , Tray Properties (Menu name must be "Tray")
		Gui , Main:Add , Text , x278 y34 w50 h15 Right , Icon File
		Gui , Main:Add , Edit , x335 y34 w163 h20 ,
		Gui , Main:Add , Button , x504 y34 w30 h22 vIcon gQMenuCommand, ...
		Gui , Main:Add , Text , x280 y62 w50 h15 Right , Icon No
		Gui , Main:Add , Edit , x335 y62 w42 h21 ,
		Gui , Main:Add , UpDown , x375 y62 w18 h21 , UpDown
		Gui , Main:Font , Italic
		Gui , Main:Add , Checkbox , x384 y62 w150 h13 , Exclude file path from output
		Gui , Main:Font , Normal
		Gui , Main:Add , Text , x298 y91 w30 h15 Right , Tip
		Gui , Main:Add , Edit , x335 y90 w200 h21 ,
		; Menu items
		Gui , Main:Add , Text , x10 y138 w230 h15 , Menu Items (Right-click for the command menu)
		Gui , Main:Add , Checkbox , x420 y138 w125 h13 vStandard gQMenuCommand, Include standard items
		Gui , Main:Add , ListView , x8 y155 w535 h190 NoSortHdr LV0x400 vItems , Pos|Item Name|Label or Submenu|Item State|Icon File|Icon No.|Icon Width
		;Additional options
		Gui , Main:Add , Groupbox , x8 y350 w535 h143 , Additional Options ; h58
		Gui , Main:Add , Checkbox , x16 y370 w435 h13 , Allow same underlined letter (This option will only affect succeeding added/edited items)
		Gui , Main:Add , Checkbox , x16 y387 w230 h13 vSpace gQMenuCommand, Add spaces to output [S=space `; C=comma]
		Gui , Main:Add , Radio , x253 y387 w40 h15 , SCS
		Gui , Main:Add , Radio , x300 y387 w40 h15 , CS
		Gui , Main:Add , Radio , x342 y387 w40 h15 , SC
		Gui , Main:Add , Checkbox , x16 y404 w220 h13 vShow gQMenuCommand , Add "Menu, [MenuName], Show" to output
		Gui , Main:Add , Radio , x32 y422 w175 h15 vMouse gQMenuCommand, Show at mouse position (Default)
		Gui , Main:Add , Radio , x32 y445 w150 h15 vCoord gQMenuCommand, Show at [X , Y] coordinates 
		Gui , Main:Add , Radio , x32 y468 w120 h15 vMBar gQMenuCommand, Show as Menu bar
		Gui , Main:Add , Edit , x185 y444 w60 h18 Number, ; 153
		Gui , Main:Add , UpDown , % "0x80 Range0-" A_ScreenWidth
		Gui , Main:Add , Edit , x253 y444 w60 h18 Number, ; 196
		Gui , Main:Add , UpDown , % "0x80 Range0-" A_ScreenHeight
		Gui , Main:Add , Radio , x321 y446 w60 h13 , Window
		Gui , Main:Add , Radio , x386 y446 w60 h13 , Screen
		Gui , Main:Add , Radio , x446 y446 w60 h13 , Client
		Gui, Main:Add , Text, x156 y469 w25 h15 , GUI ; x255
		Gui , Main:Add , Edit , x185 y467 w129 h18
		;~ Buttons
		Gui , Main:Add , Button , x169 y500 w120 h22 vInsert gQMenuCommand, Insert in SciTE
		Gui , Main:Add , Button , x296 y500 w160 h22 vCopy gQMenuCommand, Copy code to clipboard ;  y417
		Gui , Main:Add , Button , x463 y500 w80 h22 vCancel gQMenuCommand, Cancel
		Gui, Main:Default
		MenuProp.Handle := hMenuProp, LV_SetImageList(MenuProp.ImageList)
		CtrlEnable(false, "Edit3", "Button5", "Edit4", "msctls_updown321", "Button6", "Edit5")
		CtrlCheck(true, "Button10", "Button11", "Button14", "Button15", "Button18")
		CtrlEnable(false, "Edit6", "Edit7", "Button18", "Button19", "Button20", "Static7", "Edit8")
	}
	
	Show(param="Menu Creator") {
		Gui , Main:Show , w551 h527 , % param ; h445 
	}
	
	Submit(ByRef Fields, warn=true) {
		Gui, Main:Default
		Fields := []
		for k, v in {MenuName: "Edit1", MenuColor: "ComboBox1", Single: "Button3", tIcon: "Edit3", tIconNo: "msctls_updown321", tExcPath: "Button6", tTip: "Edit5", xPos: "msctls_updown322", yPos: "msctls_updown323", GUI: "Edit8"} {
			GuiControlGet, contents, , % v
			if warn
				if (k == "MenuName" && contents == "") {
					MsgBox, 48, Quick Menu, Menu name cannot be blank, please provide a menu name.
					GuiControl, Focus, Edit1
					Exit
				}
			Fields[k] := contents
		}
	}
	
	Destroy() {
		Gui, Main:Destroy
		ExitApp
	}
	
	Copy() {
		this.Submit(m), this.MenuItems.GetAll(i)
		Clipboard := "", Clipboard :=  this.GenCode(m, i, m["MenuName"] = "Tray" ? true : false)
		MsgBox, 64, , Code copied to clipboard., 1
	}
	
	SciTeInsert(oSciTe) {
		this.Submit(m), this.MenuItems.GetAll(i)
		oSciTe.InsertText(this.GenCode(m, i, m["MenuName"] = "Tray" ? true : false))
	}
	
	CopyAlt() {
		this.Submit(m), this.MenuItems.GetAll(i)
		MsgBox, %  this.GenCode(m, i, m["MenuName"] = "Tray" ? true : false)
	}
	
	GenCode(m, i, tray=false) {
		spc := IsChecked("Button10") ? KeyVal({Button11: " `, ", Button12: "`, ", Button13: " `,"}, "IsChecked") : ","
		if tray { ; Tray properties
			std := IsChecked("Button7") ? (LV_Get(1, 2) == "<StdItems=10>" ? 2 : 1) : 0
			tLine1 := m["tIcon"] ? "Menu" spc m["MenuName"] spc "Icon" spc (m["tExcPath"] ? GetFileName(m["tIcon"]) : m["tIcon"]) (m["tIconNo"] ? spc m["tIconNo"] "`r`n": "`r`n") : ""
			tLine2 := m["tTip"] ? "Menu" spc m["MenuName"] spc "Tip" spc m["tTip"] "`r`n" : ""
			stdLine := ((std < 2) ? "Menu" spc m["MenuName"] spc "NoStandard" "`r`n" : "")
		}
		for a, b in i { ; Generate items
			sLine := "", iLine := ""
			if !In(b["ItemName"], "<Separator>`,<StdItems=10>") ; Normal item
				mLine := "Menu" spc m["MenuName"] spc "Add" spc b["ItemName"] (b["LabelorSubmenu"] <> "" ? spc b["LabelorSubmenu"] : "")
			else if (b["ItemName"] == "<Separator>") ; Separator
				mLine := "Menu" spc m["MenuName"] spc "Add"
			else if (b["ItemName"] == "<StdItems=10>") ; Standard items
				mLine := tray ? (a <= 1 ? "" : "Menu" spc m["MenuName"] spc "Standard") : "Menu" spc m["MenuName"] spc "Standard"
			if b["IncLabel"]
				lLine .= (b["LabelorSubmenu"] ? b["LabelorSubmenu"] : b["ItemName"]) ":`r`n"
			if !In(b["State"], "<Separator>,<StdItems=10>,Normal") { ; Item states
				states := b["State"], sLine := ""
				Loop, Parse, states, `,
					sLine .= "Menu" spc m["MenuName"] spc A_LoopField  spc b["ItemName"] "`r`n"
				sLine := SubStr(sLine, 1, StrLen(sLine)-2)
			}
			if !In(b["IconFile"], ",<Separator>,<StdItems=10>") ; Item icon
				iLine := "Menu" spc m["MenuName"] spc "Icon" spc b["ItemName"]  spc b["IconFile"] (b["IconNumber"] <> "" ? (b["IconWidth"] <> "" ? spc b["IconNumber"] spc b["IconWidth"] : spc b["IconNumber"]) : "")
			lines .= (b["ItemName"] <> "<Separator>" && b["ItemName"] <> "<StdItems=10>") ? (mLine (sLine ? (iLine ? "`r`n" sLine "`r`n" iLine "`r`n" : "`r`n" sLine "`r`n") : (iLine ? "`r`n" iLine "`r`n" : "`r`n"))) : (mLine ? mLine "`r`n" : mline)
		}
		if lLine {
			Sort, lLine, U D
			lLine := RegExReplace(lLine, "\:", ":`r`nreturn")
		}
		cLine := m["MenuColor"] <> "Default" && m["MenuColor"] <> "" ? "Menu" spc m["MenuName"] spc "Color" spc m["MenuColor"] (m["Single"] ? spc "Single`r`n" : "`r`n") : "" ; Menu color
		if IsChecked("Button14") {
			if IsChecked("Button15")
				show := "Menu" spc m["MenuName"] spc "Show`r`n" 
			if IsChecked("Button16")
				show := "Menu" spc m["MenuName"] spc "Show" spc m["xPos"] spc m["yPos"] "`r`n"
				, coord := "CoordMode" spc "Menu" spc KeyVal({Button18: "Window", Button19: "Screen", Button20: "Client"}, "IsChecked") "`r`n"
			if IsChecked("Button17")
				show := "Gui" spc (m["GUI"] ? m["GUI"] ":Menu" : "Menu") spc m["MenuName"] "`r`n"
		}
		return (tray ? tLine1 tLine2 stdLine : "") (lLine ? lines (cLine ? cLine : "") (show ? (coord ? coord : "") show : "") "return`r`n" SubStr(lLine, 1, StrLen(lLine)-2) : lines (cLine ? cLine : "") (show ? (coord ? coord : "") show : "") "return")
	}
	
	CheckName() {
		Gui, Main:Default
		GuiControlGet, txt,, Edit1
		if (txt = "Tray") {
			CtrlEnable(true, "Edit3", "Button5", "Edit4", "msctls_updown321", "Button6", "Edit5")
			GuiControlGet, std,, Button7
			if !std {
				GuiControl,, Button7, 1
				this.MenuItems.AddStdItems()
			}
		} else
			CtrlEnable(false, "Edit3", "Button5", "Edit4", "msctls_updown321", "Button6", "Edit5")
	}
	
	ChooseColor() {
		Dlg_Color(color, MenuProp.Handle)
		if (color <> "")
			GuiControl,, ComboBox1, % color "||"
	}
	
	ChooseIcon() {
		Dlg_Icon(icon, index, MenuProp.Handle)
		GuiControlGet, e,, Edit3
		GuiControlGet, i,, msctls_updown321
		;~ GuiControl,, Edit3, % InStr(icon, "`%SystemRoot`%") ? RegExReplace(icon, "\%SystemRoot\%", A_WinDir ) : icon
		GuiControl,, Edit3, % icon ? EnvReplace(icon) : e
		GuiControl,, msctls_updown321, % index ? index : i
	}
	
	CommandHandler(param="") {
		if (param == "MName")
			this.CheckName()
		if (param == "Color") {
			GuiControlGet, clr,, ComboBox1
			if (clr == "Default")
				CtrlCheck(false, "Button3")
		}
		if (param == "More")
			this.ChooseColor()
		if (param == "Icon")
			this.ChooseIcon()
		if (param == "Standard")
			this.MenuItems.AddStdItems()
		if (param == "Space")
			CtrlEnable(IsChecked("Button10"), "Button11", "Button12", "Button13")
		if (param == "Show")
			CtrlEnable(IsChecked("Button14"), "Button15", "Button16", "Button17")
		if (param == "Mouse")
			CtrlEnable(IsChecked("Button16"), "Edit6", "Edit7", "Button18", "Button19", "Button20")
			, CtrlEnable(IsChecked("Button17"), "Static7", "Edit8")
		if (param == "Coord")
			CtrlEnable(IsChecked("Button16"), "Edit6", "Edit7", "Button18", "Button19", "Button20")
			, CtrlEnable(IsChecked("Button17"), "Static7", "Edit8")
		if (param == "MBar")
			CtrlEnable(IsChecked("Button17"), "Static7", "Edit8")
			, CtrlEnable(IsChecked("Button16"), "Edit6", "Edit7", "Button18", "Button19", "Button20")
		if (param == "Insert") {
			if oScite := ComObjActive("SciTE4AHK.Application")
				this.SciTeInsert(oSciTe)
			else
				MsgBox, 16, Menu Creator, SciTe4AutoHotkey is not running.
		}
		if (param == "Copy")
			this.Copy()
		if (param == "Cancel")
			this.Destroy()
	}
	
	class MenuItems
	{
		Items := [], RecentIcon := [], ImgLst := []
		
		AddItem(f, add=true, pos="") {
			static j
			Gui, Main:Default
			for k, v in this.Items
				if (v["ItemName"] = f["ItemName"] && v["UnderChar"] = f["UnderChar"] && v["Hotkey"] = f["Hotkey"] && k <> (add ? LV_GetCount()+1 : pos)) {
					MsgBox, 48, Quick Menu, % "Menu item name: """ f["ItemName"] """ is already in use.`nItem No. " k " , Item Name: """ v["ItemName"] """ , is currently using it. `nPlease come up with a diiferent item name."
					return [add ? true : false, add ? "" : pos]
				}
			for k, v in {Disable: f["Disabled"], Check: f["Checked"], Default: f["Default"]}
				if v {
					if (k == "Default") { ; Check duplicate default items
						for a, b in this.Items {
							if (b["Default"] && a <> (add ? LV_GetCount()+1 : pos))
								if this.AlertMsg(1, a, b["ItemName"])
									b["Default"] := 0, LV_GetText(txt, a, 4), LV_Modify(a, "Col4", RegExReplace(txt, (StrLen(txt) <= StrLen(k) ? k : (InStr(txt, "Checked") ? "\," k : k "\,")), ""))
								else {
									f["Default"] := 0
									continue, 2
									break
								}
						}
					}
					State .= k ","
				}
			if (f["UnderChar"]<> "None") {
				GuiControlGet, allow,, Button9
				if !allow {
					for k, v in this.Items ; Check duplicate underlined characters
						if (SubStr(v["UnderChar"], 0, 1) = SubStr(f["UnderChar"], 0, 1) && k <> (add ? LV_GetCount()+1 : pos))
							this.AlertMsg(2, k, v["ItemName"], f) ? (LV_GetText(txt, k, 2), LV_Modify(k, "Col2", RegExReplace(txt, "\&" SubStr(v["UnderChar"], 0, 1), SubStr(v["UnderChar"], 0, 1), "", 1, SubStr(v["UnderChar"], 1, 1))), v["UnderChar"] := "None") : f["UnderChar"] := "None"
				}
				if (f["UnderChar"] <> "None") { ; Check again in case duplicate is found and no replacement occured
					iName := f["ItemName"], iName := (InStr(iName, "&") ? RegExReplace(iName, "\&", "&&") : iName)
					Loop, Parse, iName
						Name .= (A_Index == SubStr(f["UnderChar"], 1, 1) && A_LoopField == SubStr(f["UnderChar"], 0, 1)) ? "&" A_LoopField : A_LoopField
				}
			}
			if (f["Hotkey"] <> "") ; Check duplicate hotkeys
				for k, v in this.Items
					if (v["Hotkey"] = f["Hotkey"] && k <> (add ? LV_GetCount()+1 : pos))
						this.AlertMsg(3, k, v["ItemName"], f) ? (LV_GetText(txt, k, 2), LV_Modify(k, "Col2", RegExReplace(txt, "``t" RegExReplace(this.ConvertHotkey(v["Hotkey"]), "\+", "\+"), "")), v["Hotkey"] := "") : f["Hotkey"] := ""
			i := (f["IconFile"]<> "") ; process icon, image list
				? (add ; Has icon
					? (this.CheckImgLst(f["IconFile"], f["IconNumber"], n)
						? n
						: (IL_Add(MenuProp.ImageList, f["IconFile"], f["IconNumber"]), img := true))
					: ((f["IconFile"] == this.Items[pos]["IconFile"] && f["IconNumber"] == this.Items[pos]["IconNumber"]) ; Edit Item
						? this.RecentIcon[pos] ; No icon change
						: (this.CheckImgLst(f["IconFile"], f["IconNumber"], n)
							? n
							: (IL_Add(MenuProp.ImageList, f["IconFile"], f["IconNumber"]), img :=true)))) ; Icon change			
				: ""
			add	
				? LV_Add("Icon" i
				, LV_GetCount()+1
				,  (Name <> "") 
					? (f["Hotkey"] <> "" 
						? Name "``t" this.ConvertHotkey(f["Hotkey"])
						: Name) 
					: (InStr(f["ItemName"], "&") 
						? (f["Hotkey"] <> "" 
							? RegExReplace(f["ItemName"], "\&", "&&") "``t" this.ConvertHotkey(f["Hotkey"])
							: RegExReplace(f["ItemName"], "\&", "&&")) 
						: (f["Hotkey"] <> "" 
							? f["ItemName"] "``t" this.ConvertHotkey(f["Hotkey"])
							: f["ItemName"]))
				, f["Label"] == 1 ? f["LabelorSubmenu"] : ":" f["LabelorSubmenu"]
				, State <> "" ? SubStr(State, 1, StrLen(State)-1) : "Normal"
				, f["IconFile"] ? (f["ExcFilePath"] ? GetFileName(f["IconFile"]) : f["IconFile"]) : ""
				, f["IconNumber"] && f["IconFile"] ? f["IconNumber"] : ""
				, f["IconWidth"] ? f["IconWidth"] : "")

				: LV_Modify(pos
				, "Icon" i
				, pos
				, (Name <> "") 
					? (f["Hotkey"] <> "" 
						? Name "``t" this.ConvertHotkey(f["Hotkey"])
						: Name) 
					: (InStr(f["ItemName"], "&") 
						? (f["Hotkey"] <> "" 
							? RegExReplace(f["ItemName"], "\&", "&&") "``t" this.ConvertHotkey(f["Hotkey"])
							: RegExReplace(f["ItemName"], "\&", "&&")) 
						: (f["Hotkey"] <> "" 
							? f["ItemName"] "``t" this.ConvertHotkey(f["Hotkey"])
							: f["ItemName"]))
				, f["Label"] == 1 ? f["LabelorSubmenu"] : ":" f["LabelorSubmenu"]
				, State <> "" ? SubStr(State, 1, StrLen(State)-1) : "Normal"
				, f["IconFile"] ? (f["ExcFilePath"] ? GetFileName(f["IconFile"]) : f["IconFile"]) : ""
				, f["IconNumber"] && f["IconFile"]  ? f["IconNumber"] : ""
				, f["IconWidth"] ? f["IconWidth"] : "")
			LV_ModifyCol(2, "AutoHdr") , LV_ModifyCol(5, 130)
			this.Items[add ? LV_GetCount() : pos] := f, this.RecentIcon[add ? LV_GetCount() : pos] := i
			if img ; Check if a new icon was added to the image list
				this.ImgLst[this.ImgLst.MaxIndex()>=1 ? this.ImgLst.MaxIndex()+1 : 1] := {File: f["IconFile"], Idx: f["IconNumber"]}
				;~ j := (j == "") ? 1 : j+1, this.ImgLst[j] := {File: f["IconFile"], Idx: f["IconNumber"]} ; Keep track of icons in the image list
			return false ; No errors
		}
		
		AddSep() {
			Gui, Main:Default
			LV_Add("Icon", LV_GetCount()+1,  "<Separator>", "<Separator>","<Separator>", "<Separator>","<Separator>", "<Separator>")
			, this.Items[LV_GetCount()] := {ItemName: "<Separator>", UnderChar: "None", Hotkey: "", LabelorSubmenu: "<Separator>", Label: 1, Disabled: 0, Checked: 0, Default: 0, IconFile: "", IconNumber: "", IconWidth: "", ExcFilePath: 0}
			, this.RecentIcon[LV_GetCount()] := ""
		}
		
		AddStdItems() {
			Gui, Main:Default
			GuiControlGet, std,, Button7
			if std {
				i := this.CheckImgLst(A_AhkPath , 1, n)  ? n :  (IL_Add(MenuProp.ImageList, A_AhkPath, 1), img := true)
				LV_Add("Icon" i, LV_GetCount()+1,  "<StdItems=10>", "<StdItems=10>","<StdItems=10>", "<StdItems=10>","<StdItems=10>", "<StdItems=10>")
				, this.Items[LV_GetCount()] := {ItemName: "<StdItems=10>", UnderChar: "None", Hotkey: "", LabelorSubmenu: "<StdItems=10>", Label: 1, Disabled: 0, Checked: 0, Default: 0, IconFile: A_AhkPath, IconNumber: 1, IconWidth: "", ExcFilePath: 0}
				, this.RecentIcon[LV_GetCount()] :=  i
			} else {
				Loop, % LV_GetCount() {
					LV_GetText(txt, A_Index, 2)
					if (txt == "<StdItems=10>")
						this.Remove(A_Index)
				}
			}
			if img
				this.ImgLst[this.ImgLst.MaxIndex()>=1 ? this.ImgLst.MaxIndex()+1 : 1] := {File: A_AhkPath, Idx: "1"}
		}
		
		Remove(pos="") {
			Gui, Main:Default
			this.Items.Remove(pos ? pos : LV_GetNext()), this.RecentIcon.Remove(pos ? pos : LV_GetNext()), LV_Delete(pos ? pos : LV_GetNext()), this.UpdatePos()
		}
		
		GetAll(ByRef AllFields) {
			AllFields := []
			ControlGet, All, List,, SysListView321, % "ahk_id " MenuProp.Handle
			Loop, Parse, All, `n
			{
				StringSplit, field, A_LoopField, `t
				AllFields[A_Index] := {Pos: field1, ItemName: field2, LabelorSubMenu: field3, State: field4, IconFile: field5, IconNumber: field6, IconWidth: field7, IncLabel: this.Items[A_Index, "IncLabel"]}
			}
		}
		
		GetSelectedAll(ByRef Fields) {
			Gui, Main:Default
			Fields := [], RowNumber := 0
			for k, v in ["Pos", "ItemName", "LabelorSubMenu", "State", "IconFile"] {
				LV_GetText(Text, LV_GetNext("", "Focused"), A_Index)
				Fields[v] := Text
			}
		}
		
		GetSelected(col) {
			Gui, Main:Default
			LV_GetText(txt, LV_GetNext(), col)
			return txt
		}
		
		GetSelProp() {
			Gui, Main:Default
			return this.Items[LV_GetNext()]
		}
		
		MoveItem(up=true) {
			Gui, Main:Default
			if (up && LV_GetNext()==1) || (!up && LV_GetNext() == LV_GetCount()) || LV_GetNext() == 0
				return
			pos := LV_GetNext(), xpos := up ? pos-1 : pos+1
			this.Items.Insert(xpos, this.Items.Remove(pos)) , this.RecentIcon.Insert(xpos, this.RecentIcon.Remove(pos))
			Loop,% LV_GetCount("Col")
				LV_GetText(a, A_Index > 1 ? pos : xpos, A_Index), LV_GetText(b, A_Index > 1 ? xpos : pos, A_Index)
				, LV_Modify(pos, "Col" A_Index " Icon" this.RecentIcon[pos], b)
				, LV_Modify(xpos, "Col" A_Index " Icon" this.RecentIcon[xpos], a)
			LV_Modify(pos, "-Select -Focus"), LV_Modify(xpos, "Select Focus")
		}
		
		CheckImgLst(file, idx, ByRef n) {
			for k, v in this.ImgLst {
				if (v["File"] == file && v["Idx"] == idx) {
					n := k
					return true
				}
			}
		}
		
		ConvertHotkey(Hotkey) {
			Loop, Parse, Hotkey
				key .= A_Index <> StrLen(Hotkey) ? A_LoopField "|" : A_LoopField
			for k, v in {Alt: "!", Ctrl: "^", Shift: "+"}
				key := InStr(key, v) ? RegExReplace(key, "\" v, k) : key
			return RegExReplace(key, "\|", "+")
		}
		
		AlertMsg(MsgNo, ItemNo, ItemName, o="") {
			m1 := "Item No. " ItemNo " , Item Name: """ ItemName """ , is currently the default item.`nWould you like to replace it?"
			m2 := "Conflict with underlined character: """ SubStr(o["UnderChar"], 0, 1) """`nItem No. " ItemNo " , Item Name: """ ItemName """ , is currently using it.`nWould you like to replace it?"
			m3 := "Conflict with item hotkey: """ this.ConvertHotkey(o["Hotkey"]) """`nItem No. " ItemNo " , Item Name: """ ItemName """ , is currently using it.`nWould you like to replace it?"
			MsgBox, 52, Quick Menu, % m%MsgNo%
			IfMsgBox, Yes
				return true
			else
				return false
		}
		
		UpdatePos() {
			Gui, Main:Default
			Loop, % LV_GetCount() {
				if (A_Index <> LV_Get(A_Index, 1))
					LV_Modify(A_Index, "Icon" this.RecentIcon[A_Index] " Col1", A_Index )
			}
		}
		
	}
	
}

class ItemProp extends MenuProp
{
	__New() {
		this.ExcFilePath := false
	}
	
	__Delete() {
		Gui, 2:Destroy
	}
	
	Create(param=false, f="") {
		static Item, Icon, Exclude, OK, Cancel
		Gui , 2:+HwndhItemProp +LabelQMenu +OwnerMain
		; Item properties
		Gui, 2: Add , Groupbox , x7 y8 w380 h130 , Item Properties
		Gui, 2: Add , Text , x50 y33 w60 h15 Right , Item Name
		Gui, 2: Add , Edit , x116 y33 w260 h20 vItem gQMenuCommand, % param ? f["ItemName"] : ""
		Gui, 2: Add , Text , x20 y61 w90 h15 Right , Underlined char
		Gui, 2: Add , DropDownList , x117 y60 w60 , % param ? this.SetComboField(f["ItemName"], (f["UnderChar"] <> "None" ? f["UnderChar"] : "")) : "None||"
		Gui, 2: Add , Text , x185 y61 w50 h15 Right , Hotkey
		Gui, 2: Add , Hotkey , x241 y60 w135 h21 , % param ? f["Hotkey"] : "Hotkey"
		Gui, 2: Add , Text , x16 y88 w95 h15 Right , Label or Submenu
		Gui, 2: Add , Edit , x116 y88 w260 h20 , % param ? f["LabelorSubmenu"] : ""
		Gui, 2: Add , Radio , % "x116 y113 w50 h13 gQMenuCommand " (param ? "Checked" (f["Label"] == 1 ? "1" : "0") : "Checked1") , Label
		Gui, 2: Add , Radio , % "x168 y113 w65 h13 gQMenuCommand " (param ? "Checked" (f["Label"] == 1 ? "0" : "1") : "Checked0") , Submenu
		Gui, 2:Font , Italic
		Gui, 2: Add , Checkbox , % "x240 y113 w140 h13 " (param ? "Checked" f["IncLabel"] : "Checked0") " " (param ? (f["Label"] ? "Disabled0" : "Disabled1") : "") , Include "Label" in output
		Gui, 2:Font , Normal
		; Initial Item state
		Gui, 2: Add , Groupbox , x7 y144 w380 h45 , Item State
		Gui, 2: Add , Checkbox , % "x35 y164 w70 h15 " (param ? "Checked" f["Disabled"] : "Checked0") , Disabled
		Gui, 2: Add , Checkbox , % "x171 y164 w70 h15 " (param ? "Checked" f["Checked"] : "Checked0") , Checked
		Gui, 2: Add , Checkbox , % "x310 y164 w60 h15 " (param ? "Checked" f["Default"] : "Checked0") , Default
		; Item icon properties
		Gui, 2: Add , Groupbox , x7 y195 w380 h101 , Item Icon Properties
		Gui, 2: Add , Text , x35 y222 w50 h15 Right , Icon File
		Gui, 2: Add , Edit , x90 y222 w250 h20 , % param ? f["IconFile"] : ""
		Gui, 2: Add , Button , x345 y222 w30 h22 vIcon gQMenuCommand, ...
		Gui, 2:Font , Italic
		Gui, 2:Add, CheckBox, % "x90  y245 w150 h13  0x400 vExclude gQMenuCommand Checked" (param ? f["ExcFilePath"] : this.ExcFilePath) , Exclude file path from output
		Gui, 2:Font , Normal
		Gui, 2: Add , Text , x14 y265 w70 h15 Right , Icon Number
		Gui, 2: Add , Edit , x90 y265 w40 h20 ,
		Gui, 2: Add , UpDown , x112 y265 w18 h20 Range-1000-1000, % param ? f["IconNumber"] : "1"
		Gui, 2: Add , Text , x140 y265 w100 h15 Right , Icon Width (Optional)
		Gui, 2: Add , ComboBox , x247 y264 w44 , % param ? f["IconWidth"] : "16|24|32" ; x194
		;~ Buttons
		Gui, 2: Add , Button , x219 y305 w80 h22 vOK gQMenuCommand, OK
		Gui, 2: Add , Button , x307 y305 w80 h22 vCancel gQMenuCommand, Cancel
		this.Handle := hItemProp
	}
	
	Show(param="Add Item") {
		this.Title := "Menu Creator - " Param
		Gui , 2:Show , w395 h333  , % this.Title
		Gui, Main:+Disabled
	}
	
	Submit(ByRef Fields) {
		Fields := []
		for k, v in {ItemName: "Edit1", UnderChar: "ComboBox1", Hotkey: "msctls_hotkey321", LabelorSubmenu: "Edit2", Label: "Button2", IncLabel: "Button4", Disabled: "Button6", Checked: "Button7", Default: "Button8", IconFile: "Edit3", IconNumber: "msctls_updown321", IconWidth: "ComboBox2", ExcFilePath: "Button11"} {
			GuiControlGet, contents, 2:, % v
			Fields[k] := contents
		}
	}
	
	OK(param=true) {
		this.Submit(f)
		if (f["ItemName"] == "" && f["Hotkey"] == "") {
			MsgBox, 48, Quick Menu, Menu item name cannot be blank, please provide an item name.`nIf you are trying to add a separator, right-click on the ListView(Main window) and select "Add Separator" from the menu.
			Exit
		}
		if (!f["LabelorSubmenu"] && f["Label"]) && (f["Hotkey"] || RegExMatch(f["ItemName"], "[\s\,``]")) {
			if (f["Hotkey"] && !RegExMatch(f["ItemName"], "\s"))
				MsgBox, 48, Quick Menu, Menu item name cannot be used as the target label in this case as you have specifically assigned a "Hotkey" (Item name output contains the "``t"[Tab] character). Please provide a target label.
			else if (RegExMatch(f["ItemName"], "[\s\,``]")) && (!f["Hotkey"] || f["Hotkey"])
				MsgBox, 48, Quick Menu, Menu item name cannot be used as the target label in this case as it contains charatcer(s) not allowed in labels. Labels cannot contain the following: space, tab, comma and the escape character (``).
			Exit
		}
		if (!f["LabelorSubmenu"] && !f["Label"]) {
			MsgBox, 48, Quick Menu, Submenu cannot be blank. Please provide a submenu.
			Exit
		}
		if (f["Label"] && RegExMatch(f["LabelorSubmenu"], "[\s\,``]")) {
			MsgBox, 48, Quick Menu, The specified "label" contains character(s) not allowed in labels. Labels cannot contain the following: space, tab, comma and the escape character (``).
			Exit
		}	
		this.Destroy()
		error := param ? base.MenuItems.AddItem(f) : base.MenuItems.AddItem(f, false, SubStr(this.Title, 0, 1))
		if error
			this.Create(true, f), this.Show(error[1] ? "Add New" : "Edit Item " error[2])
	}
	
	Destroy() {
		Gui, Main:-Disabled
		Gui, 2:Destroy
	}
	
	SetUnderChar(param="") {
		GuiControl,, ComboBox1, |
		GuiControlGet, Name,, Edit1
		GuiControl,, ComboBox1, % Name <> "" ? this.SetComboField(Name) : "None||"
	}
	
	SetComboField(items, choice="") {
		Loop, Parse, items
			if (A_LoopField <> A_Space)
				UChar .= A_Index >= StrLen(items) ? A_Index " - " A_LoopField  : A_Index " - " A_LoopField "|"
		return choice <> "" ? "None|" RegExReplace(UChar, choice, choice "|") : "None||" UChar
	}
	
	SetIncLabel() {
		GuiControlGet, l,, Button2
		GuiControlGet, i,, Button4
		l ? CtrlEnable(true, "Button4") : (i ? (CtrlEnable(false, "Button4"), CtrlCheck(false, "Button4")) : CtrlEnable(false, "Button4"))
	}
	
	ChooseIcon() {
		GuiControlGet, e,, Edit3
		GuiControlGet, i,, msctls_updown321
		Dlg_Icon(icon, index, this.Handle)
		;~ GuiControl,, Edit3, % InStr(icon, "`%SystemRoot`%") ? RegExReplace(icon, "\%SystemRoot\%", A_WinDir ) : icon
		GuiControl,, Edit3, % icon ? EnvReplace(icon) : e
		GuiControl,, msctls_updown321, % index ? index : i
	}
	
	ExcludeFilePath() {
		Gui, 2:Default
		GuiControlGet, efp,, Button10
		this.ExcFilePath := efp
	}
	
	CommandHandler(param="") {
		if (param == "Item")
			this.SetUnderChar()
		if (param == "Label" || param == "Submenu")
			this.SetIncLabel()
		if (param == "Icon")
			this.ChooseIcon()
		if (param == "Exclude")
			this.ExcludeFilePath()
		if (param == "OK")
			this.OK(InStr(this.Title, "Add Item") ? true : false)
		if  (param == "Cancel")
			this.Destroy()
	}

}

class Menu
{
	static MenuList := [], MenuCount := 0, RetVal := ""
	
	__New(MenuName) { ; Creates a new menu
		this.Instance := true, this.Name := MenuName, this.ItemCount := 0, this.MenuItems := []
		if (this.Name <> "Tray")
			this.AddSeparator(), this.RemoveAll()
		this.IsStandard := this.Name == "Tray" ? true : false
		Menu.MenuCount++
	}
	
	__Delete() {
	}
	
	AppendItem(MenuItemName, LabelorFunction="", mode=true) {
		if !this.IsInstance()
			return
		if (this.ItemCount >= 1)
			for k, v in this.MenuItems
				if (v["MenuItem"] == MenuItemName) {
					MsgBox, Menu item "%MenuItemName%" already exists!
					return
				}
		this.SetItemAction(MenuItemName, LabelorFunction, mode)
		this.ItemCount := DllCall("GetMenuItemCount", "Int", this.GetMenuHandle(this.Name))
		this.AppendToList(MenuItemName, LabelorFunction <> "" ?  LabelorFunction : MenuItemName, mode)
	}
	
	AddSubMenu(MenuName, MenuItemName) {
		if !this.IsInstance()
			return
		Menu, % this.Name, Add, % MenuItemName, % IsObject(MenuName) ? ":" MenuName.Name : ":" MenuName
		this.ItemCount := DllCall("GetMenuItemCount", "Int", this.GetMenuHandle(this.Name))
		this.AppendToList(MenuItemName, IsObject(MenuName) ? this.GetMenuHandle(MenuName.Name) : this.GetMenuHandle(MenuName))
	}
	
	AddSeparator() {
		if !this.IsInstance()
			return
		Menu, % this.Name, Add
		this.ItemCount := DllCall("GetMenuItemCount", "Int", this.GetMenuHandle(this.Name))
		this.AppendToList("", "")
	}
	
	ModifyItem(MenuItemName, Param="", mode=true) { 
		if !this.IsInstance()
			return
		if (IsObject(Param) || InStr(Param, ":") == 1) { ; Converted to submenu
			Menu, % this.Name, Add, % MenuItemName, % IsObject(Param) ? ":" Param.Name : Param
			this.MenuItems[this.GetItemPos(MenuItemName), "LabelorFunction"] := IsObject(Param) ?this.GetMenuHandle(Param.Name) : this.GetMenuHandle(SubStr(Param, 2))
			this.MenuItems[this.GetItemPos(MenuItemName), "Mode"] := true ; reset mode to "true" if item is converted to submenu
		} else { ; New label or function
			this.SetItemAction(MenuItemName, Param, mode)
			this.MenuItems[this.GetItemPos(MenuItemName), "LabelorFunction"] := Param <> "" ? Param : MenuItemName
			this.MenuItems[this.GetItemPos(MenuItemName), "Mode"] := mode
		}
	}
	
	RenameItem(MenuItemName, NewName="") { ; if blank, MenuItemName will be converted to a separator. This action cannot be undone.
		if !this.IsInstance()
			return
		Menu, % this.Name, Rename, % MenuItemName, % NewName
		NewName <> "" ? this.MenuItems[this.GetItemPos(MenuItemName), "MenuItem"] := NewName : this.MenuItems[this.GetItemPos(MenuItemName), "MenuItem"] := "",  this.MenuItems[this.GetItemPos(MenuItemName), "LabelorFunction"] := "", this.MenuItems[this.GetItemPos(MenuItemName), "Mode"] := true ; reset mode to "true" if item is converted to a separator
	}
	
	RemoveItem(MenuItemNameorPos, ByName=true, Occurrence=1) { ; If item name is blank(""), this method will remove a separator. By default it will remove the first. Specify "2" for the "Occurrence" parameter to remove the second, "3" for third, and so on... Set "ByName" parameter to "false" if you want to specify the menu item's position instead for the "MenuItemNameorPos" parameter.
		if !this.IsInstance()
			return
		ByName := ByName == "" ? true : ByName ; set to "true"(default) if parameter is blank("")
		if (ByName && MenuItemNameorPos <> "") ; Normal item
			Menu, % this.Name, Delete, % MenuItemName
		else if (ByName && MenuItemNameorPos == "") ; Separator
			DllCall("RemoveMenu", Int, this.GetMenuHandle(this.Name), UInt, this.GetItemPos(MenuItemNameorPos, Occurrence)-1, UInt, "0x00000400L")
		else  { ; By position
			if (this.MenuItems[MenuItemNameorPos, "MenuItem"] <> "")  ; Normal Item
				Menu, % this.Name, Delete, % this.MenuItems[MenuItemNameorPos, "MenuItem"]
			else ; Separator
				DllCall("RemoveMenu", Int, this.GetMenuHandle(this.Name), UInt, MenuItemNameorPos-1, UInt, "0x00000400L")
		}
		this.MenuItems.Remove(ByName ? this.GetItemPos(MenuItemNameorPos, MenuItemNameorPos == "" ? Occurrence : 1) : MenuItemNameorPos)
		this.ItemCount := DllCall("GetMenuItemCount", "Int", this.GetMenuHandle(this.Name))
	}
	
	RemoveAll() {
		if !this.IsInstance()
			return
		Menu, % this.Name, DeleteAll
		this.IsStandard ? (this.Standard(false), this.MenuItems.Remove(1, this.MenuItems.MaxIndex()), this.Standard()) : this.MenuItems.Remove(1, this.MenuItems.MaxIndex()) ; if Menu contains the standard items, remove them temporarily, clear the list, and add them back again
		this.ItemCount := DllCall("GetMenuItemCount", "Int", this.GetMenuHandle(this.Name))
	}
	
	SetItem(MenuItemName, Options="") { ; "Options" can be any of the following(space-delimited): Check, Uncheck, ToggleCheck, Enable, Disable, ToggleEnable
		if !this.IsInstance()
			return
		if (Options <> "") { ; nothing is altered if omitted
			Options := RegExReplace(Options, "S) +", A_Space) ; replace multiple spaces with a single space
			Loop, Parse, Options, % A_Space
				if A_LoopField in Check,Uncheck,ToggleCheck,Enable,Disable,ToggleEnable ; check if option is valid, if not, nothing is altered
					Menu, % this.Name, % A_LoopField, % MenuItemName
		}
	}
	
	Default(MenuItemName="") {
		if !this.IsInstance()
			return
		Menu, % this.Name, Default, % MenuItemName
	}
	
	Standard(param=true) {
		if !this.IsInstance()
			return
		this.ItemCount := DllCall("GetMenuItemCount", "Int", this.GetMenuHandle(this.Name)) ; get menu item count prior to adding the standard items
		Menu, % this.Name, % param ? "Standard" : "NoStandard"
		if param {
			for k, v in ["Open", "Help", "", "Window Spy", "Reload This Script", "Edit This Script", "", "Suspend Hotkeys", "Pause Script", "Exit"]
				this.ItemCount++, this.AppendToList(v, "`nStdItem")
		} else  {
			a := "", b := 0 ; counters: a=index of the first standard item | b=index of the last standard item
			for k, v in this.MenuItems
				if (v["LabelorFunction"] == "`nStdItem")
					a := b <= 0 ? k : a, b := b <= 0 ? k : b+1
			this.MenuItems.Remove(a, b) ; remove the standard items from array
		}
		this.ItemCount := DllCall("GetMenuItemCount", "Int", this.GetMenuHandle(this.Name)) ; Get the new item count
		this.IsStandard := param
	}
	
	SetIcon(MenuItemName, FileName, IconNumber="", IconWidth="") {
		if !this.IsInstance()
			return
		Menu, % this.Name, Icon, % MenuItemName, % FileName, % IconNumber, % IconWidth
	}
	
	RemoveIcon(MenuItemName) {
		if !this.IsInstance()
			return
		Menu, % this.Name, NoIcon, % MenuItemName
	}
	
	Destroy() {
		if !this.IsInstance()
			return
		for k, v in Menu.MenuList
			for a, b in v
				if (b["LabelorFunction"] == this.GetMenuHandle(this.Name)) ; Remove item entries in list for other items that is using the currently destoyed menu as a submenu.
					v.Remove(a)
		Menu, % this.Name, Delete
		Menu.MenuList.Remove(this.Name)
		this.Instance := false, this.Name := "", this.ItemCount := "", this.MenuItems := ""
		Menu.MenuCount--
	}

	Show(X="", Y="") {
		if !this.IsInstance()
			return
		Menu, % this.Name, Show, % X, % Y
	}

	InsertItem(MenuItemName, Pos, Param="", mode=true) {
		if !this.IsInstance()
			return
		this.AppendItem(MenuItemName, Param, mode)
		count := this.IsStandard ? this.ItemCount - 9 : this.ItemCount
		Loop, % count - Pos
			this.MoveItem(MenuItemName)
	}
	
	InsertSubMenu(MenuName, MenuItemName, Pos) {
		if !this.IsInstance()
			return
		this.AddSubMenu(MenuName, MenuItemName)
		count := this.IsStandard ? this.ItemCount - 9 : this.ItemCount
		Loop, % count - Pos
			this.MoveItem(MenuItemName)
	}
	
	InsertSeparator(Pos) {
		if !this.IsInstance()
			return
		this.AddSeparator()
		xpos := this.ItemCount ; get the newly appended separator's position
		count := this.IsStandard ? this.ItemCount - 9 : this.ItemCount
		Loop, % count - Pos
			xpos := this.MoveItem(xpos, true, false)
	}
	
	MoveItem(MenuItemNameorPos, up=true, ByName=true) {
		if !this.IsInstance()
			return
		up := up == "" ? true : up ; set to "true"(default) if parameter is blank("")
		items := [], oldh := [] ; Objects to temporarily hold menus/menu items properties after removal
		pos := ByName ? this.GetItemPos(MenuItemNameorPos) : MenuItemNameorPos
		xpos := up ? pos-1 : pos+1
		if (up && pos <= 1 || !up && pos >= this.ItemCount) ; Unable to move item due to its postition and the associated direction
			return
		if (this.MenuItems[xpos, "LabelorFunction"] == "`nStdItem")
			xpos := up ? xpos-9 : xpos+9
		for k, v in this.MenuItems
			items[k] := {name: v["MenuItem"],  action: v["LabelorFunction"], mode: v["Mode"]}
		items.Insert(xpos, items.Remove(pos))
		for m in Menu.MenuList ; Retrieve handle of menus, menu(s) which are being used as submenu(s) gets a new handle if the item that opens it is removed
			oldh[m] := this.GetMenuHandle(m) ; store handle(s) in object for later comparison
		this.IsStandard ? (this.Standard(false), RemoveStd := true, this.RemoveAll()) : this.RemoveAll()
		for a, b in items {
			item := b["name"], action := b["action"], mode := b["mode"]
			if (action <> "`nStdItem") {
				if (item <> "") { ; Item is not a separator
					if (!IsLabel(action) && !IsFunc(action)) { ; Item opens a submenu
						for m in Menu.MenuList ; Retrieve new menu handle(s)
							if (oldh[m] <> this.GetMenuHandle(m) && oldh[m] == action) ; compare handle changes and filter out the new handle
								this.AddSubMenu(m, item)
					} else if (IsLabel(action) || IsFunc(action)) ; Normal item
						this.AppendItem(item, action, mode)
				} else ; Item is a separator
					this.AddSeparator()
			} else if (action == "`nStdItem" && RemoveStd == true)
				this.Standard(), RemoveStd := false
		}
		return xpos ; return the new position of the item
	}
	
	GetItemPos(MenuItemName, Occurrence=1) {
		if !this.IsInstance()
			return
		i := 0
		for k, v in this.MenuItems
			if (MenuItemName == v["MenuItem"] && MenuItemName <> "")
				return k
			else if (MenuItemName == v["MenuItem"] && MenuItemName == "" && v["LabelorFunction"] <> "`nStdItem") {
				i++
				if (i == Occurrence)
					return k
			}
	}
	
	;~ Miscellaneous Commands
	
	SetColor(ColorValue="Default", Single=false) {
		if !this.IsInstance()
			return
		Menu, % this.Name, Color, % ColorValue, % Single ? "Single" : ""
	}
	
	UseErrorLevel(param=false) {
		if !this.IsInstance()
			return
		Menu, % this.Name, UseErrorLevel, % param ? "" : "Off"
	}
	
	;~==========================================
	;~ Tray-specific methods/functions - MenuName must be "Tray"
	;~==========================================
	
	TrayIcon(FileName="", IconNumber="", state=0) { ; Omit all parameters to create the tray icon if it isn't already present
		if !this.IsInstance()
			return
		if (this.Name == "Tray") ; verify if the "Tray" is the Menu name
			Menu, % this.Name, Icon, % FileName, % IconNumber, % (FileName == "" && IconNumber == "") ? "" : state
	}
	
	TrayNoIcon() {
		if !this.IsInstance()
			return
		if (this.Name == "Tray")
			Menu, % this.Name, NoIcon
	}
	
	TrayTip(Text="") {
		if !this.IsInstance()
			return
		if (this.Name == "Tray")
			Menu, % this.Name, Tip, % Text
	}
	
	TrayClick(ClickCount=2) {
		if !this.IsInstance()
			return
		if (this.Name == "Tray")
			Menu, % this.Name, Click, % ClickCount
	}
	
	TrayMainWindow(default=true) {
		if !this.IsInstance()
			return
		if (this.Name == "Tray")
			Menu, % this.Name, % default ? "NoMainWindow" : "MainWindow"
	}
	
	;~=======================================
	; The following methods are for internal use only, Do not use.
	;~=======================================
	
	SetItemAction(MenuItemName, LabelorFunction="", mode=true) { ; Internal use only
		if (LabelorFunction <> "") {
			x := [LabelorFunction, "MenuItemFunctionHandlerLabel", mode ? LabelorFunction : "MenuItemFunctionHandlerLabel"]
			Menu, % this.Name, Add, % MenuItemName, % x[this.GetActionType(LabelorFunction)]
		} else {
			x := ["", "MenuItemFunctionHandlerLabel", mode ? "" : "MenuItemFunctionHandlerLabel"]
			Menu, % this.Name, Add, % MenuItemName, % x[this.GetActionType(MenuItemName)]
		}
	}
	
	GetActionType(Action) { ; 1=Label, 2=Function, 3=Both | Internal use only
		if (IsLabel(Action) && !IsFunc(Action))
			return 1
		else if (IsFunc(Action) && !IsLabel(Action))
			return  2
		else if (IsLabel(Action) && IsFunc(Action))
			return 3
	}
	
	MenuItemFunctionHandler() { ; This method is for internal use only
		return ; return when this method is called
		MenuItemFunctionHandlerLabel: ; This label is for internal use only
		if (Menu.MenuList[A_ThisMenu][A_ThisMenuItemPos, "MenuItem"] == A_ThisMenuItem)
			ItemFunc := Func(Menu.MenuList[A_ThisMenu][A_ThisMenuItemPos, "LabelorFunction"]), Menu.RetVal := ItemFunc.()
		return
	}
	
	AppendToList(MenuItemName, LabelorFunction, mode=true) { ; Internal use only
		this.MenuItems[this.ItemCount] := {MenuItem: MenuItemName, LabelorFunction: LabelorFunction, Mode: mode}
		Menu.MenuList[this.Name] := this.MenuItems
	}
	
	GetMenuHandle(MenuName) {
		static   h_menuDummy
		If !h_menuDummy { ; v2.2: Check for !h_menuDummy instead of h_menuDummy="" in case init failed last time.
			Menu, menuDummy, Add
			Menu, menuDummy, DeleteAll
			Gui, 99:Menu, menuDummy
			Gui, 99:+LastFound ; v2.2: Use LastFound method instead of window title. [Thanks animeaime.]
			h_menuDummy := DllCall("GetMenu", "uint", WinExist())
			Gui, 99:Menu
			Gui, 99:Destroy
			if !h_menuDummy ; v2.2: Return only after cleaning up. [Thanks animeaime.]
				return 0
		}
		Menu, menuDummy, Add, :%MenuName%
		h_menu := DllCall( "GetSubMenu", "uint", h_menuDummy, "int", 0 )
		DllCall( "RemoveMenu", "uint", h_menuDummy, "uint", 0, "uint", 0x400 )
		Menu, menuDummy, Delete, :%MenuName%
		return h_menu
	}
	
	GetMenuName(MenuHandle) {
		for m in Menu.MenuList
			if (this.GetMenuHandle(m) == MenuHandle)
				return m
	}
	
	IsInstance() {
		if (!this.Instance)
			MsgBox, 16, % A_ScriptName, Menu or menu object does not exist! Please create a new instance using "__New".
		return this.Instance
	}
	
}