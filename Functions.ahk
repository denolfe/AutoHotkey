#Include %A_ScriptDir%\lib\ShowLauncher.ahk
#Include %A_ScriptDir%\lib\GUID.ahk
#Include %A_ScriptDir%\lib\Process.ahk
#Include %A_ScriptDir%\lib\ClipboardHelpers.ahk
#Include %A_ScriptDir%\lib\Fade.ahk
#Include %A_ScriptDir%\lib\AHKPanic.ahk
#Include %A_ScriptDir%\lib\DynaRun.ahk
#Include %A_ScriptDir%\lib\MoveTaskbar.ahk
#Include %A_ScriptDir%\lib\Varize.ahk
#Include %A_ScriptDir%\lib\DBGView.ahk
#Include %A_ScriptDir%\lib\Json.ahk

Edit(file, editorPath) ; Refocuses Sublime if file is opened while focused
{
    Run %editorPath% %file%
    Sleep 50
    WinActivate, ahk_class PX_WINDOW_CLASS
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

RunProgFiles(exe)
{
    If FileExist(A_ProgramFiles "\" exe)
        Run % A_ProgramFiles "\" exe
    else If FileExist(A_ProgramFiles86 "\" exe)
        Run % A_ProgramFiles86 "\" exe
}

UserName(username)
{
	Return % (A_Username = %username%) ? 1 : 0
}

AtWork()
{
	Return % (A_Username = "elliotd") ? 1 : 0
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
