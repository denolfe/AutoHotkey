;http://www.autohotkey.com/board/topic/42578-lib-ini-v10-basic-ini-string-functions/
;http://www.autohotkey.com/board/topic/76802-embedded-parsing-loop-and-listview/
;http://www.autohotkey.com/board/topic/63764-load-an-ini-file-in-listview-gui-control-in-autohotkey/
;http://www.autohotkey.com/board/topic/64658-listview-checkboxes/

#NoEnv 
#Singleinstance force
SendMode Input 
SetWorkingDir %A_ScriptDir%

#Include lib\ini.ahk

Menu, Tray, Icon, lib\testing.ico
Menu, Tray, Tip, Test Config


path := ini_load(ini, "\\draven\Testing\TestComplete\TestComplete.ini")

; Create the ListView with two columns:
Gui, Add, ListView, h100 w150 r20 y10 hwndHLV Checked gMyListView, Branch
Gui, Add, Button,Default ,Submit
;Gui, Add, Button, gStart,Start Tests

sections := ini_getAllSectionNames(ini)
Loop, Parse, sections, `,
{
  LV_Add("Check" ini_getValue(ini, A_LoopField, "Run"), A_LoopField)
}

LV_ModifyCol()  ; Auto-size each column to fit its contents.
LV_ModifyCol(2)  ; For sorting purposes.

; Display the window and return. The script will be notified whenever the user double clicks a row.
Gui, Show,, Tests
return


MyListView:
if A_GuiEvent = DoubleClick
{
  LV_GetText(RowText, A_EventInfo)  ; Get the text from the row's first field.
  ToolTip You double-clicked row number %A_EventInfo%. Text: "%RowText%"
}
return

Start:
return

Buttonsubmit:

Gui, Submit, NoHide
Loop, % LV_GetCount()
{
  LV_GetText(Branch, A_Index)
  If LV_IsRowChecked(HLV, A_Index)
    ini_replaceValue(ini, Branch, "Run", 1)
  Else
    ini_replaceValue(ini, Branch, "Run", 0)
  ;msgbox % ini_getValue(ini, Branch, "Run")
}

path := ini_save(ini, "\\draven\Testing\TestComplete\TestComplete.ini")
;Run, %path%
ExitApp
Return



;ini_replaceValue(ini, "Release", "Run", 1)
;msgbox % ini_getValue(ini, "Release", "Run")


Esc::
GuiClose:  ; Indicate that the script should exit automatically when the window is closed.
ExitApp


LV_IsRowChecked(HLV, Row) {
   ; HLV  HWND of the ListView control
   ; Row  One-based row number
   Static LVIS_STATEIMAGEMASK := 0xF000   ; http://www.autohotkey.com/community/viewtopic.php?p=530415#p530415
   Static LVM_GETITEMSTATE  := 0x102C   ; http://msdn.microsoft.com/en-us/library/bb761053(VS.85).aspx
   SendMessage, LVM_GETITEMSTATE, Row - 1, LVIS_STATEIMAGEMASK, , ahk_id %HLV%
   Return (((ErrorLevel & LVIS_STATEIMAGEMASK) >> 12) = 2) ? True : False
}