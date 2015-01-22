ShowStart(title, exe, toggle = 0)
{
	If WinActive(title) and toggle
    {
        Send, !{Tab}
		WinMinimize %title%
    }
	Else
	{
		IfWinExist, %title%
			WinActivate
		else
		{
        	Run, %exe%,, UseErrorLevel
            If ErrorLevel
            {
                Notify("Executable not found", title,-3,"Style=Mine")
                Return
            }
            WinActivate
		}
	}
}

ShowDir(title)
{
    ;RegWrite, REG_DWORD, HKCU, Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState , FullPath, 1
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

SublimeOpen(file, sublime_path) ; Refocuses Sublime if file is opened while focused
{
    Run %sublime_path% %file%
    Sleep 50
    WinActivate, ahk_class PX_WINDOW_CLASS
}

CapsNav(action, initmod = "", mod = "+")
{
	If ! GetKeyState("shift")
		Send % initmod "{" action "}"
	Else
		Send % mod . initmod "{" action "}"
	SetCapsLockState, AlwaysOff
}

ProcExists(p)
{    
    Process, Exist, % p
    Return ErrorLevel
}

ClipSave(mode = 1)
{
    global
    if (mode = 1)
        clipboard_backup := clipboard
    else if (mode = 2)
    	clipboard_backup := ClipboardAll
}

Copy()
{
	global
	clipboard =
	Send ^c
	ClipWait, 4
}

ClipRestore()
{
    global
    clipboard := clipboard_backup
}

ClipClear()
{
    global
    clipboard = ;nothing
}

WinWaitText(search, window, windowtext, timeout=10000, interval=50)
{
    loops := timeout / interval

    Loop %loops%
    {
        WinGetText, thetext, %window%, %windowtext%
        if RegExMatch(thetext, search)
            break  
        Sleep, %interval%
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

FadeOut(window = "A", TotalTime = 500, FinalTrans = 0)
{
	StartTime := A_TickCount
	Loop
	{
	   Trans := ((TimeElapsed := A_TickCount-StartTime) < TotalTime) ? 100*(1-(TimeElapsed/TotalTime)) : 0
	   WinSet, Transparent, %Trans%, %window%
	   if (Trans = FinalTrans)
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

MouseIsOverControl(winControl)
{
	MouseGetPos, , , , Control
	return (Control = winControl)
}

Show(window = "A")
{
	WinSet, Transparent, 255, %window%
}

Hide(window = "A")
{
	WinSet, Transparent, 0, %window%
}

ActiveControlIsOfClass(Class) 
{
    ControlGetFocus, FocusedControl, A
    ControlGet, FocusedControlHwnd, Hwnd,, %FocusedControl%, A
    WinGetClass, FocusedControlClass, ahk_id %FocusedControlHwnd%
    return (FocusedControlClass=Class)
}

IsOnline(machine)
{
    IfExist, \\%machine%\c$
		return 1
	else
		return 0
}

Cl(command, hide = 1)
{
	if hide
		RunWait, %comspec% /c "%command%",, Hide
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
    clipSave() 
    clipClear()
    Send, ^c 
    ClipWait, 2 
    if StrLen(clipboard) > 0
    { 
        msgbox % clipboard "`n" strlen(clipboard)
        return 1
    }
    else
        return 0
    clipRestore()
} 

Log(text, file = "debug.log")
{
    FormatTime, Now,, `nM/dd [h:mm]
    FileAppend, %Now%`t%text%, %file%
}

CreateXCut(path, shortcut, name)
{
    If FileExist(path)
    {
        FileCreateShortcut, %path%, %shortcut%, C:\, "%A_ScriptFullPath%", %name%
        msgbox, exists
    }
    Else
        Msgbox, File Does Not Exist!
}

AHKPanic(Kill=0, Pause=0, Suspend=0, SelfToo=0) 
{
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

DynaRun(TempScript, pipename="")
{
   static _:="uint",@:="Ptr"
   If pipename =
      name := "AHK" A_TickCount
   Else
      name := pipename
   __PIPE_GA_ := DllCall("CreateNamedPipe","str","\\.\pipe\" name,_,2,_,0,_,255,_,0,_,0,@,0,@,0)
   __PIPE_    := DllCall("CreateNamedPipe","str","\\.\pipe\" name,_,2,_,0,_,255,_,0,_,0,@,0,@,0)
   if (__PIPE_=-1 or __PIPE_GA_=-1)
      Return 0
   Run, %A_AhkPath% "\\.\pipe\%name%",,UseErrorLevel HIDE, PID
   If ErrorLevel
      MsgBox, 262144, ERROR,% "Could not open file:`n" __AHK_EXE_ """\\.\pipe\" name """"
   DllCall("ConnectNamedPipe",@,__PIPE_GA_,@,0)
   DllCall("CloseHandle",@,__PIPE_GA_)
   DllCall("ConnectNamedPipe",@,__PIPE_,@,0)
   script := (A_IsUnicode ? chr(0xfeff) : (chr(239) . chr(187) . chr(191))) TempScript
   if !DllCall("WriteFile",@,__PIPE_,"str",script,_,(StrLen(script)+1)*(A_IsUnicode ? 2 : 1),_ "*",0,@,0)
        Return A_LastError,DllCall("CloseHandle",@,__PIPE_)
   DllCall("CloseHandle",@,__PIPE_)
   Return PID
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

RxMatch(string, pattern)
{
    return % Substr(string, RegExMatch(string, "P)" pattern, matchlength), matchlength)
}

StringFormat(string, zero, one = "", two = "", three = "", four = "", five = "")
{
    StringReplace, string, string, `{0`}, % zero
    StringReplace, string, string, `{1`}, % one
    StringReplace, string, string, `{2`}, % two
    StringReplace, string, string, `{3`}, % three
    StringReplace, string, string, `{4`}, % four
    StringReplace, string, string, `{5`}, % five
    return string
}


RunIfExist(exe, response = 0)
{
    If FileExist(exe)
        Run "%exe%"
    Else
    {
        If response = 0
            return
        Else If response = 1
            msgbox, %exe% does not exist.
    }
}

StartDBGView()
{
	if(FileExist(A_ScriptDir "\Utilities\DebugView\Dbgview.exe"))
	{
		CoordMode, Mouse, Relative 
		;Debug view
		a_scriptPID := DllCall("GetCurrentProcessId")	; get script's PID
		if(WinExist("ahk_class dbgviewClass")) ; kill it if the debug viewer is running from an older instance
		{
			winactivate, ahk_class dbgviewClass
			Winwaitactive, ahk_class dbgviewClass
			winclose, ahk_class dbgviewClass
			WinWaitNotActive ahk_class dbgviewClass
		}
		Run %A_ScriptDir%\Utilities\DebugView\Dbgview.exe /f,,UseErrorLevel
		winwait, ahk_class dbgviewClass
		winactivate, ahk_class dbgviewClass
		Winwaitactive, ahk_class dbgviewClass
		Send ^l
		winwait, DebugView Filter
		winactivate, DebugView Filter
		Winwaitactive, DebugView Filter
		MouseGetPos, x,y
		mouseclick, left, 125, 85,,0
		MouseMove, x,y,0
		send, [%a_scriptPID%*{Enter}
		;send, !M{Down}{Enter}
		Coordmode, Mouse, Screen
		OutputDebug, DBGView Filtering on %A_ScriptName%
	}
}

varize(var, autofix = true) 
{
	;var = "€:\Dév\« ÂùtöH°tkéÿ™ »\¡Dœ©s & Inf¤ß!"
	;MsgBox, % "var:`t" . var . "`nautofix:`t" . varize(var) . "`nerrors:`t" varize(var, false)
	Loop, Parse, var
	{ c = %A_LoopField%
		x := Asc(c)
		If (x > 47 and x < 58) or (x > 64 and x < 91) or (x > 96 and x < 123)
			or c = "#" or c = "_" or c = "@" or c = "$" or c = "?" or c = "[" or c = "]"
			IfEqual, autofix, 1, SetEnv, nv, %nv%%c%
			Else er++
	} If StrLen(var) > 254
		IfEqual, autofix, 1, StringLeft, var, var, 254
		Else er++
	IfEqual, autofix, 1, Return, nv
	Else Return, er
}

UnJson(string)
{
    return % RegExReplace(string, "\\/", "/")
}

json(ByRef js, s, v = "") {
    j = %js%
    Loop, Parse, s, .
    {
        p = 2
        RegExMatch(A_LoopField, "([+\-]?)([^[]+)((?:\[\d+\])*)", q)
        Loop {
            If (!p := RegExMatch(j, "(?<!\\)(""|')([^\1]+?)(?<!\\)(?-1)\s*:\s*((\{(?:[^{}]++|(?-1))*\})|(\[(?:[^[\]]++|(?-1))*\])|"
                . "(?<!\\)(""|')[^\7]*?(?<!\\)(?-1)|[+\-]?\d+(?:\.\d*)?|true|false|null?)\s*(?:,|$|\})", x, p))
                Return
            Else If (x2 == q2 or q2 == "*") {
                j = %x3%
                z += p + StrLen(x2) - 2
                If (q3 != "" and InStr(j, "[") == 1) {
                    StringTrimRight, q3, q3, 1
                    Loop, Parse, q3, ], [
                    {
                        z += 1 + RegExMatch(SubStr(j, 2, -1), "^(?:\s*((\[(?:[^[\]]++|(?-1))*\])|(\{(?:[^{\}]++|(?-1))*\})|[^,]*?)\s*(?:,|$)){" . SubStr(A_LoopField, 1) + 1 . "}", x)
                        j = %x1%
                    }
                }
                Break
            }
            Else p += StrLen(x)
        }
    }
    If v !=
    {
        vs = "
        If (RegExMatch(v, "^\s*(?:""|')*\s*([+\-]?\d+(?:\.\d*)?|true|false|null?)\s*(?:""|')*\s*$", vx)
            and (vx1 + 0 or vx1 == 0 or vx1 == "true" or vx1 == "false" or vx1 == "null" or vx1 == "nul"))
            vs := "", v := vx1
        StringReplace, v, v, ", \", All
        js := SubStr(js, 1, z := RegExMatch(js, ":\s*", zx, z) + StrLen(zx) - 1) . vs . v . vs . SubStr(js, z + StrLen(x3) + 1)
    }
    Return, j == "false" ? 0 : j == "true" ? 1 : j == "null" or j == "nul"
        ? "" : SubStr(j, 1, 1) == """" ? SubStr(j, 2, -1) : j
}

/*
    Function: DateParse
        Converts almost any date format to a YYYYMMDDHH24MISS value.

    Parameters:
        str - a date/time stamp as a string

    Returns:
        A valid YYYYMMDDHH24MISS value which can be used by FormatTime, EnvAdd and other time commands.

    Example:
> time := DateParse("2:35 PM, 27 November, 2007")

    License:
        - Version 1.05 <http://www.autohotkey.net/~polyethene/#dateparse>
        - Dedicated to the public domain (CC0 1.0) <http://creativecommons.org/publicdomain/zero/1.0/>
*/
DateParse(str) {
    static e2 = "i)(?:(\d{1,2}+)[\s\.\-\/,]+)?(\d{1,2}|(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\w*)[\s\.\-\/,]+(\d{2,4})"
    str := RegExReplace(str, "((?:" . SubStr(e2, 42, 47) . ")\w*)(\s*)(\d{1,2})\b", "$3$2$1", "", 1)
    If RegExMatch(str, "i)^\s*(?:(\d{4})([\s\-:\/])(\d{1,2})\2(\d{1,2}))?"
        . "(?:\s*[T\s](\d{1,2})([\s\-:\/])(\d{1,2})(?:\6(\d{1,2})\s*(?:(Z)|(\+|\-)?"
        . "(\d{1,2})\6(\d{1,2})(?:\6(\d{1,2}))?)?)?)?\s*$", i)
        d3 := i1, d2 := i3, d1 := i4, t1 := i5, t2 := i7, t3 := i8
    Else If !RegExMatch(str, "^\W*(\d{1,2}+)(\d{2})\W*$", t)
        RegExMatch(str, "i)(\d{1,2})\s*:\s*(\d{1,2})(?:\s*(\d{1,2}))?(?:\s*([ap]m))?", t)
            , RegExMatch(str, e2, d)
    f = %A_FormatFloat%
    SetFormat, Float, 02.0
    d := (d3 ? (StrLen(d3) = 2 ? 20 : "") . d3 : A_YYYY)
        . ((d2 := d2 + 0 ? d2 : (InStr(e2, SubStr(d2, 1, 3)) - 40) // 4 + 1.0) > 0
            ? d2 + 0.0 : A_MM) . ((d1 += 0.0) ? d1 : A_DD) . t1
            + (t1 = 12 ? t4 = "am" ? -12.0 : 0.0 : t4 = "am" ? 0.0 : 12.0) . t2 + 0.0 . t3 + 0.0
    SetFormat, Float, %f%
    Return, d
}
