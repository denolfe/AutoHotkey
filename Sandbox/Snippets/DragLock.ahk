;DragLock.ahk
; Press the windows key to lock the mouse movement along one axis
;Skrommel @ 2008

#NoEnv
#SingleInstance,Force
SetBatchLines,-1
SetWinDelay,0
CoordMode,Mouse,Screen

applicationname=DragLock
Gosub,INIREAD
Gosub,TRAYMENU
Return


HOTKEY:
MouseGetPos,mx1,my1,mwin,mctrl

Loop
{
  MouseGetPos,mx2,my2,mwin,mctrl
  If (mx2<>mx1 Or my2<>my1)
    Break
  Sleep,100
}

If (Abs(mx2-mx1)>Abs(my2-my1))
  lock=horizontal
Else
  lock=vertical

MouseGetPos,mx2,my2,mwin,mctrl
If lock=horizontal
  MouseMove,%mx2%,%my1%,0
Else
  MouseMove,%mx1%,%my2%,0
Gosub,LOCK

Loop
{
  GetKeyState,key,%hotkey%,P
  If key=U
  {
    DllCall("ClipCursor") 
    Break
  }
  Sleep,10
}
Return


LOCK:
minx=9999
miny=9999
maxw=0
maxh=0
SysGet,monitors,MonitorCount
Loop,% monitors
{
  current:=A_Index
  SysGet,monitor,Monitor,% current
  If (monitorLeft<minx)
    minx:=monitorLeft
  If (monitorTop<miny)
    miny:=monitorTop
  If (monitorRight>maxw)
    maxw:=monitorRight
  If (monitorBottom>maxh)
    maxh:=monitorBottom
}
ToolTip,%lock%
If lock=horizontal
{
  rl:=minx
  rt:=my2
  rr:=maxw
  rb:=my2
}
Else
{
  rl:=mx2
  rt:=miny
  rr:=mx2
  rb:=maxh
} 
VarSetCapacity(rect,16) 
Loop,4 
{ 
  DllCall("RtlFillMemory",UInt,&rect+0+A_Index-1, UInt,1,UChar,rl >> 8*A_Index-8) 
  DllCall("RtlFillMemory",UInt,&rect+4+A_Index-1, UInt,1,UChar,rt >> 8*A_Index-8) 
  DllCall("RtlFillMemory",UInt,&rect+8+A_Index-1, UInt,1,UChar,rr >> 8*A_Index-8) 
  DllCall("RtlFillMemory",UInt,&rect+12+A_Index-1,UInt,1,UChar,rb >> 8*A_Index-8) 
}                                                        
DllCall("ClipCursor", "UInt", &rect) 
ToolTip,% rl "," rt "," rr "," rb
Return


TRAYMENU:
Menu,Tray,NoStandard
Menu,Tray,Add,%applicationname%,SETTINGS
Menu,Tray,Add,
Menu,Tray,Add,&Settings...,SETTINGS
Menu,Tray,Add,&About...,ABOUT
Menu,Tray,Add,E&xit,EXIT
Menu,Tray,Default,%applicationname%
Menu,Tray,Tip,%applicationname%
Return


INIREAD:
IfNotExist,%applicationname%.ini
{
  ini=
(
`;[Settings]
`;hotkey=LWin    `;LWin  LAlt  LCtrl  LShift 

[Settings]
hotkey=LWin
)
  FileAppend,%ini%,%applicationname%.ini
}
IniRead,hotkey,%applicationname%.ini,Settings,hotkey
If (hotkey="" Or hotkey="ERROR")
  hotkey=LWin
hotkeydown=~*%hotkey%
Hotkey,%hotkeydown%,HOTKEY,On
Return


SETTINGS:
Hotkey,%hotkeydown%,HOTKEY,Off
Gui,Destroy
FileRead,ini,%applicationname%.ini
Gui,Font,Courier New
Gui,Add,Edit,Vnewini -Wrap W400,%ini%
Gui,Font
Gui,Add,Button,GSETTINGSOK Default W75,&OK
Gui,Add,Button,GSETTINGSCANCEL x+5 W75,&Cancel
Gui,Show,%applicationname% Settings
Return


SETTINGSOK:
Gui,Submit
FileDelete,%applicationname%.ini
FileAppend,%newini%,%applicationname%.ini
Gosub,INIREAD
Return


GuiEscape:
GuiClose:
SETTINGSCANCEL:
Gui,Destroy
Hotkey,%hotkeydown%,HOTKEY,On
Return


EXIT:
ExitApp


ABOUT:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname% v1.0
Gui,99:Font
Gui,99:Add,Text,y+10,Press the windows key to lock the mouse movement along one axis
Gui,99:Add,Text,y+5,- Change hotkey using Settings in the tray menu

Gui,99:Add,Picture,xm y+20 Icon5,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,1 Hour Software by Skrommel
Gui,99:Font
Gui,99:Add,Text,y+10,For more tools, information and donations, please visit 
Gui,99:Font,CBlue Underline
Gui,99:Add,Text,y+5 G1HOURSOFTWARE,www.1HourSoftware.com
Gui,99:Font

Gui,99:Add,Picture,xm y+20 Icon7,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,DonationCoder
Gui,99:Font
Gui,99:Add,Text,y+10,Please support the contributors at
Gui,99:Font,CBlue Underline
Gui,99:Add,Text,y+5 GDONATIONCODER,www.DonationCoder.com
Gui,99:Font

Gui,99:Add,Picture,xm y+20 Icon6,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,AutoHotkey
Gui,99:Font
Gui,99:Add,Text,y+10,This tool was made using the powerful
Gui,99:Font,CBlue Underline
Gui,99:Add,Text,y+5 GAUTOHOTKEY,www.AutoHotkey.com
Gui,99:Font

Gui,99:+AlwaysOnTop
Gui,99:Show,,%applicationname% About
hCurs:=DllCall("LoadCursor","UInt",NULL,"Int",32649,"UInt") ;IDC_HAND
OnMessage(0x200,"WM_MOUSEMOVE") 
Return

1HOURSOFTWARE:
  Run,http://www.1hoursoftware.com,,UseErrorLevel
Return

DONATIONCODER:
  Run,http://www.donationcoder.com,,UseErrorLevel
Return

AUTOHOTKEY:
  Run,http://www.autohotkey.com,,UseErrorLevel
Return

99GuiClose:
  Gui,99:Destroy
  OnMessage(0x200,"")
  DllCall("DestroyCursor","Uint",hCur)
Return

WM_MOUSEMOVE(wParam,lParam)
{
  Global hCurs
  MouseGetPos,,,,ctrl
  If ctrl in Static8,Static12,Static16
    DllCall("SetCursor","UInt",hCurs)
  Return
}
Return
