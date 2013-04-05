RDP(comp, pw, title = "Remote Connection", message = "Are you sure you want to remote in?")
{
	MsgBox, 36, %title%, %message%
	IfMsgBox Yes
	{
		Run mstsc.exe /console
		WinWaitActive Remote Desktop Connection
		Send %comp%{Enter}
		WinWaitActive Windows Security
		Send %pw%{Enter}
		Return
	}
	Else
		Return
}

AHKPanic(Kill=0, Pause=0, Suspend=0, SelfToo=0) {
DetectHiddenWindows, On
WinGet, IDList ,List, ahk_class AutoHotkey
Loop %IDList%
  {
  ID:=IDList%A_Index%
  WinGetTitle, ATitle, ahk_id %ID%
  IfNotInString, ATitle, %A_ScriptFullPath%
    {
    If Suspend
      PostMessage, 0x111, 65305,,, ahk_id %ID%  ; Suspend. 
    If Pause
      PostMessage, 0x111, 65306,,, ahk_id %ID%  ; Pause.
    If Kill
      WinClose, ahk_id %ID% ;kill
    }
  }
If SelfToo
  {
  If Suspend
    Suspend, Toggle  ; Suspend. 
  If Pause
    Pause, Toggle, 1  ; Pause.
  If Kill
    ExitApp
  }
}


ShowStart(title, exe, toggle = 0)
{

    ;msgbox % RegExReplace(exe, "\s+\S*$","")

	If WinActive(title) and toggle
		WinMinimize %title%
	Else
	{
		IfWinExist, %title%
			WinActivate
		else
		{
            ;If FileExist(RegExReplace(exe, "\s+\S*$","")) ;removes everything after last space
            ;{
            	Run, %exe%,, UseErrorLevel
                If ErrorLevel
                {
                    msgbox, File not found
                    Return
                }
                WinActivate
            ;}
		}
	}
}

ShowDir(title)
{
	SetTitleMatchMode, 3
	IfWinExist, %title% ahk_class CabinetWClass
		WinActivate
	else
	{
		Run, %title%
		WinActivate
	}
	SetTitleMatchMode, 2
}

WinWaitText(text)
{
    Loop
    {
        WinGetText, A
        if RegExMatch(thetext, text)
            break  
    }
    
}

UserName(username)
{
	Return % (A_Username = %username%) ? 1 : 0
}

AtWork()
{
	Return % (A_Username = "elliotd") ? 1 : 0
}

FadeIn(window = "A", TotalTime = 500, transfinal = 255)
{
	StartTime := A_TickCount
	Loop
	{
	   Trans := Round(((A_TickCount-StartTime)/TotalTime)*transfinal)
	   WinSet, Transparent, %Trans%, %window%
	   if (Trans >= transfinal)
		  break
	   Sleep, 10
	}
}

FadeOut(window = "A", TotalTime = 500)
{
	StartTime := A_TickCount
	Loop
	{
	   Trans := ((TimeElapsed := A_TickCount-StartTime) < TotalTime) ? 100*(1-(TimeElapsed/TotalTime)) : 0
	   WinSet, Transparent, %Trans%, %window%
	   if (Trans = 0)
		  break
	   Sleep, 10
	}
}

MouseIsOver(Wintitle) {
    MouseGetPos,,, Win
    return WinExist(Wintitle . " ahk_id " . Win)
}

MouseIsOverClass(WinClass) {
    MouseGetPos,,,win
    WinGetClass,class,ahk_id %win%
    return (class = winClass)
}

Show(window = "A")
{
	WinSet, Transparent, 255, %window%
}

Hide(window = "A")
{
	WinSet, Transparent, 0, %window%
}

ActiveControlIsOfClass(Class) {
    ControlGetFocus, FocusedControl, A
    ControlGet, FocusedControlHwnd, Hwnd,, %FocusedControl%, A
    WinGetClass, FocusedControlClass, ahk_id %FocusedControlHwnd%
    return (FocusedControlClass=Class)
}

IsOnline(machine)
{
	Runwait,%comspec% /c ping -n 1 -w 50 %machine%>ping.log,,hide 
	FileRead, StrTemp, ping.log
	FileDelete ping.log
	if Instr(StrTemp, "Received = 1")
		return 1
	else
		return 0
}

Cl(command, hide = 1)
{
	if hide
		RunWait, %comspec% /c %command%,, Hide
	Else
		Run, %comspec% /c %command%
}

IsFocusOn(current)
{
	ControlGetFocus, OutputVar, A
	IfEqual, current, %OutPutVar%
		return 1
	else
		return 0
}

Replace(string, find, replace="")
{
    Stringreplace, string, string, % find, % replace, All
    return string
}

RegInStr(haystack, needle)
{
    return % If Instr(RegExReplace(haystack, needle, "foundit!"), "foundit!") ? 1 : 0
}

IsTextSelected()
{

    ; BlockInput, on 
    prevClipboard = %clipboard% 
    clipboard = 
    Send, ^c 
    ClipWait, 2 
    clipboard = %prevClipboardAll%
    if ErrorLevel = 0 
        return 1
    else
        return 0
} 

Log(text, file = "debug.log")
{
    FormatTime, Now,, `nM/dd [h:mm]
    FileAppend, %Now%`t%text%, %file%
}

GetSQLDriver()
{
    RegRead, SQLVersion, HKLM, Software\Microsoft\MSSQLServer\MSSQLServer\CurrentVersion, CurrentVersion
    If RegExMatch(SQLVersion, "P)\d*", matchlength)
        SQLVersion := SubStr(SQLVersion, 1, matchlength)

    If (SQLVersion = "9") 
        return "SQL Native Client"      ;SQL 2005
    Else If (SQLVersion = "10")
        return "SQL Server Native Client 10.0"  ;SQL 2008
    Else If (SQLVersion = "11") 
        return "SQL Server Native Client 11.0"  ;SQL 2012
}























; Move the taskbar
; dspNumber:    number.  device number (primary display is 1, secondary display is 2...)
; edge:         string.  Top, Right, Bottom, or Left
MoveTaskbar(dspNumber, edge)
{
    Critical 
    OutputDebug MoveTaskbar - called to move taskbar to display #%dspNumber% ("%edge%" edge)

    ; absolute coordinate system
    CoordMode, Mouse, Screen

    ; error checking for dspNumber
    SysGet, numMonitors, MonitorCount
    if (numMonitors<dspNumber)
    {
        OutputDebug MoveTaskbar - [ERROR] target monitor does not exist (dspNumber = "%dspNumber%")
        return
    }

    ; get screen position for target monitor
    SysGet, target, Monitor, %dspNumber%

    oX := 7
    oY := 7

    ; get coordinates for where to move the taskbar
    if (edge = "Top")
    {
        oX := (targetRight-targetLeft)/2
        trgX := oX+targetLeft
        trgY := targetTop+15
    }
    else if (edge = "Right")
    {
        oY := -(targetBottom-targetTop)/2
        trgX := targetRight-15
        trgY := -oY + targetTop
    }
    else if (edge = "Bottom")
    {
        oX := -(targetRight-targetLeft)/2
        trgX := -oX+targetLeft
        trgY := targetBottom-15
    }
    else if (edge = "Left")
    {
        oY := (targetBottom-targetTop)/2
        trgX := targetLeft+15
        trgY := oY+targetTop
    }
    else
    {
        OutputDebug MoveTaskbar - [ERROR] target edge was improperly specified (edge = "%edge%")
        return
    }
    trgX := round(trgX)
    trgY := round(trgY)
    oX := round(oX)
    oY := round(oY)

    OutputDebug MoveTaskbar - target location is (%trgX%,%trgY%)
    MouseGetPos, startX, startY
    OutputDebug MoveTaskbar - mouse is currently at (%startX%,%startY%)

    ; request the move mode (via context menu)
    SendInput #b
    SendInput !+{Space}
    SendInput m

    ; wait for the move mode to be ready
    Loop 
    {
        if A_Cursor = SizeAll
            break
    }
    OutputDebug MoveTaskbar - move mode is ready

    ; start the move mode
    SendInput {Right}   

    ; wait for the move mode to become active for mouse control
    Loop 
    {
        if A_Cursor = Arrow
            break
    }
    OutputDebug MoveTaskbar - move mode is active for mouse control

    ; move taskbar (and making sure it actually does move)
    offset := 7
    count := 0
    Loop
    {
        ; move the taskbar to the desired location
        OutputDebug MoveTaskbar - attempting to move mouse to (%trgX%,%trgY%)
        MouseMove, %trgX%, %trgY%, 0
        MouseGetPos, mX, mY, win_id
        WinGetClass, win_class, ahk_id %win_id%

        count += 1

        ; if the mouse didn't get where it was supposed to, try again
        If ((mX != trgX) or (mY != trgY))
        {
            OutputDebug MoveTaskbar - mouse didn't get to its destination (currently at (%mX%,%mY%)).  Trying the move again...
            continue
        }

        ; if the taskbar hasn't followed yet, wiggle the mouse!
        if (win_class != "Shell_TrayWnd")
        {
            OutputDebug MoveTaskbar - window with class "%win_class%" is under the mouse... wiggling the mouse until the taskbar gets over here

            ;offset := - offset
            trgX -= round(oX/2)
            trgY -= round(oY/2)
            oX := -oX
            oY := -oY
            if count = 50
            {
                OutputDebug, MoveTaskbar - wiggling isn't working, so I'm giving up.
                return
            }
        }
        else
            break
    }

    OutputDebug MoveTaskbar - taskbar successfully moved
    SendInput {Enter}
}


GetGPVersion()
{
    If (A_ComputerName = "ELLIOT-PC" or A_ComputerName = "TESTING-PC" or A_ComputerName = "SMARTBEAR")
        return "GP2010"
    Else If (A_ComputerName = "SQL2005")
        return "GP10"
    Else If (A_ComputerName = "GP2013")
        return "GP2013"
}

DebugMsgBox(message = "")
{   
    global DebugMsgBox_ShowMessages
    if (%DebugMsgBox_ShowMessages% != false)
        MsgBox, %message%
}

RxMatch(string, pattern)
{
    return % Substr(string, RegExMatch(string, "P)" pattern, matchlength), matchlength)
}