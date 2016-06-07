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

LoggedIn()
{
    if WinExist("A")
        return true
    else
        return false
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
    else
        ErrorLevel = 1
}

LockWorkstation(screenOff = 0)
{
    Run, %A_WinDir%\System32\rundll32.exe user32.dll`, LockWorkStation
    if (screenOff = 1)
    {
        Sleep 1000
        SendMessage, 0x112, 0xF170, 2,, Program Manager
    }
    Return
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

StringReplace(string, find, replace="")
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

StrFmt(string, zero, one = "", two = "", three = "", four = "", five = "")
{
    return StringFormat(string, zero, one, two, three, four, five)
}

StringFormat(string, vargs*)
{
    for each, varg in vargs
        StringReplace,string,string,`%s, % varg
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

UpFolder(folder, numberUp = 1)
{
    ; Count available directories
    DirCount := 0
    Loop, Parse, folder, \
    {
        if (StrLen(A_LoopField) > 0)
        {
            FolderArray%A_Index% = %A_Loopfield%
            DirCount++
        }
    }
    
    ; Check if file or folder and adjust DirCount
    If (IsFile(folder))
        numberUp++

    ; Not enough folders to go that high
    if (numberUp + 1 > DirCount)
    {
        ErrorLevel := 1
        return ""
    }

    ; Calculate how far to go up
    DirCount := DirCount - numberUp

    ; Generate output dir
    OutDir := ""
    Loop, %DirCount%
    {
        dir := FolderArray%A_Index%
        OutDir .= dir 
        if (A_Index != DirCount)
            OutDir .= "\"
    }
    return OutDir

}

IsFolder(fileOrFolder)
{
    return InStr( FileExist(fileOrFolder), "D" ) ? 1 : 0
}

IsFile(fileOrFolder)
{
    return InStr( FileExist(fileOrFolder), "D" ) ? 0 : 1
}
