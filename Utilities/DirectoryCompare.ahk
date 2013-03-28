#SingleInstance force
#NoTrayIcon
#NoEnv
SetFormat, Float, 0.2
Gui, +AlwaysOnTop +LastFound
Gui, Add, Edit, w500 cGray vPath1, Enter directory path #1 here.
Gui, Add, Edit, w500 cGray vPath2, Enter directory path #2 here.
Gui, Add, Button, w50 gGuiSubmit, OK
Gui, Add, Button, w50 gGuiClose x+10, Cancel
Gui, Add, ComboBox, w50 vlimit x+20 Limit, 1|1.003|1.005||1.007|1.01|0
Gui, Font, Bold
Gui, Add, Button, gHelp x+10, ?
Gui, Font, Norm
Gui, Add, Checkbox, vUnit x+50, Output file sizes in MB
Gui, Show,,Directory Compare
GuiControl, Focus, Unit
WinGet, WinID, ID
SetTimer, Edit
return
GuiClose:
ExitApp
Help:
ToolTip,
(LTrim
 The ComboBox chooses a ratio to compare file sizes.
 Differences within this ratio are considered equal.
 Choosing 1 means only identical file sizes are
 considered equal. Choosing 0 ignores file sizes.
)
WinWaitNotActive, Directory Compare ahk_class AutoHotkeyGUI
 ToolTip
return
GuiDropFiles:
If A_EventInfo > 2
{
 Gui, +OwnDialogs
 MsgBox,48,Directory Compare, More than 2 items were dropped.
 return
}
If A_EventInfo = 2
 Loop,Parse,A_GuiEvent,`n,`r
 {
  GuiControl,Font,Path%A_Index%
  GuiControl,,Path%A_Index%,%A_LoopField%
 }
Else If (A_GuiControl="path1") OR (A_GuiControl="path2")
{
 GuiControl,Font,%A_GuiControl%
 GuiControl,,%A_GuiControl%,%A_GuiEvent%
}
return
GuiSubmit:
SetTimer, Edit, Off
IfWinExist, ahk_class tooltips_class32
 ToolTip
Gui,Submit
Gui,Destroy
Loop,2
{
 IfNotExist,% path%A_Index%
 {
  MsgBox,16,Directory Compare,% "The path does not exist:`n" path%A_Index%
  ExitApp
 }
 FileGetAttrib, attribs,% path%A_Index%
 IfNotInString, attribs, D
 {
  MsgBox,16,Directory Compare,% "The path does not specify a folder:`n" path%A_Index%
  ExitApp
 }
 StringRight,slash,Path%A_Index%,1
 If slash = \
  StringTrimRight,Path%A_Index%,Path%A_Index%,1
}
Unit := Unit=1 ? "M":"K"
MorK := Unit="M" ? 1048576:1024
Gui, Add, ListView, w800 h600 Grid
, %path1%|Size(%Unit%B)|%path2%|Size(%Unit%B)|*
Loop, %Path1%\*.*,,1
 count++
Loop, %Path2%\*.*,,1
 count++
Progress, fs14 b2 r0-%count%, Checking files`, please wait.
count = 0
Loop, %path1%\*.*,,1
{
 count++
 Progress, %count%
 FileGetSize, size1, %A_LoopFileLongPath%
 size1 := size1/MorK
 StringReplace, name, A_LoopFileLongPath, %path1%\
 IfExist, %path2%\%name%
 {
  If !(limit)
   continue
  If limit > 10
   limit=10
  FileGetSize, size2, %path2%\%name%
  size2 := size2/MorK
  If (size1 >= size2)
   ratio := size1/size2
  Else ratio := size2/size1
  If (ratio < limit)
   continue
  i++
  LV_Insert(i,"", name, size1, name, size2)
 }
 Else LV_Add("", name, size1)
}
Loop, %path2%\*.*,,1
{
 count++
 Progress, %count%
 FileGetSize, size1, %A_LoopFileLongPath%
 size1 := size1/MorK
 StringReplace, name, A_LoopFileLongPath, %path2%\
 IfNotExist, %path1%\%name%
 {
  i++
  If (LV_GetCount() >= i)
   LV_Modify(i, "Col" 3, name, size1)
  Else LV_Add("Col" 3, name, size1)
 }
}
Progress, Off
If LV_GetCount() = 0
{
 MsgBox,64,Directory Compare, All files are backed up.
 ExitApp
}
Loop, % LV_GetCount()
{
 LV_GetText(text, A_Index)
 If text contains \
  LV_Modify(A_Index,"", "\"text)
 LV_GetText(text, A_Index, 3)
 If text contains \
  LV_Modify(A_Index, "Col" 3, "\"text)
}
LV_ModifyCol(1, "AutoHdr")
LV_ModifyCol(2, "AutoHdr Float")
LV_ModifyCol(3, "AutoHdr")
LV_ModifyCol(4, "AutoHdr Float")
LV_DeleteCol(5)
Gui, Show,,Directory Compare
return
Edit:
GuiControlGet,Focus,FocusV
Loop,2
{
 GuiControlGet,Contents,,Path%A_Index%
 If Focus = Path%A_Index%
 {
  If Contents = Enter directory path #%A_Index% here.
  {
   GuiControl,,Path%A_Index%
   GuiControl,Font,Path%A_Index%
  }
 }
 Else If Contents=
 {
  Gui,Font,cGray
  GuiControl,Font,Path%A_Index%
  GuiControl,,Path%A_Index%,Enter directory path #%A_Index% here.
  Gui,Font
 }
}
return
