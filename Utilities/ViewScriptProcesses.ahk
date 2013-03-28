#NoTrayIcon
DetectHiddenWindows, On

Gui, +Resize -MaximizeBox
Gui, Add, ListView, w500 h200 vlvwList hwndhlvwList gListClick, PID|Script Path|Working Set|Peak Working Set|Page File|Peak Page File
Gui, Add, Button, y+6 xp w247 hwndhRefresh gRefresh, Refresh list
Gui, Add, Button, yp x+6 wp hwndhEndProc gEndProc, End associated process

Gui, Show,, AHK Script Processes
Sleep 200   ;Give time for Anchor to catch on
RefreshList()
Return

GuiClose:
ExitApp

GuiSize:
    Anchor(hlvwList, "wh")
    Anchor(hRefresh, "y w0.5")
    Anchor(hEndProc, "x0.5 y w0.5")
Return

Refresh:
    RefreshList()
Return

ListClick:
    If (A_GuiEvent <> "DoubleClick")
        Return
EndProc:
    
    i := LV_GetNext()
    WinKill, % "ahk_id " AHKWindows%i%
    RefreshList()
    
Return

RefreshList() {
    Global
    
    LV_Delete()
    WinGet, AHKWindows, List, ahk_class AutoHotkey
    
    Loop %AHKWindows% {
        
        ;Get process ID
        WinGet, AHKWindows%A_Index%_PID, PID, % "ahk_id " AHKWindows%A_Index%
        GetProcessMemoryInfo(AHKWindows%A_Index%_PID)
        
        ;Get memory info
        LV_Add(0, AHKWindows%A_Index%_PID, GetScriptPathFromHwnd(AHKWindows%A_Index%)
        , Round(GetProcessMemoryInfo(0,12) / 1024) " K", Round(GetProcessMemoryInfo(0,8) / 1024) " K"
        , Round(GetProcessMemoryInfo(0,32) / 1024) " K", Round(GetProcessMemoryInfo(0,36) / 1024) " K")
    }
    
    Loop 6
        LV_ModifyCol(A_Index, "AutoHdr")
    
    ;Get columns width
    iColWidth := 0
    Loop 6 {
        SendMessage, 4125, A_Index - 1, 0,, ahk_id %hlvwList%
        iColWidth += ErrorLevel
    }
    
    ;Set main width in accordance to column width
    iWidth := iColWidth + 24
    Gui, Show, w%iWidth%
}

GetScriptPathFromHwnd(hwnd) {
    WinGetTitle, win, ahk_id %hwnd%
    Return RegExMatch(win, ".*(?= - AutoHotkey v[0-9\.]+)", ret) ? ret : win
}

GetProcessMemoryInfo(pid, info=-1) {
    Static uMemCounters := 0
    
    ;Check if we just want info from the struct
    If (info <> -1)
        Return NumGet(uMemCounters, info)
    Else {
        
        ;Open the process with PROCESS_QUERY_INFORMATION and PROCESS_VM_READ
        h := DllCall("OpenProcess", "UInt", 0x0410, "UInt", 0, "UInt", pid)
        
        ;Put info into struct
        If Not uMemCounters ;Check if it hasn't already been initialized
            VarSetCapacity(uMemCounters, 40)
        DllCall("Psapi.dll\GetProcessMemoryInfo", "UInt", h, "UInt", &uMemCounters, "UInt", 40)
        
        ;Done
        DllCall("CloseHandle", "UInt", h)
    }
}

;Anchor() by Titan
;http://www.autohotkey.com/forum/viewtopic.php?t=4348
Anchor(i, a = "", r = false) {
    static c, cs = 12, cx = 255, cl = 0, g, gs = 8, z = 0, k = 0xffff, gx = 1
    If z = 0
        VarSetCapacity(g, gs * 99, 0), VarSetCapacity(c, cs * cx, 0), z := true
    If a =
    {
        StringLeft, gn, i, 2
        If gn contains :
        {
            StringTrimRight, gn, gn, 1
            t = 2
        }
        StringTrimLeft, i, i, t ? t : 3
        If gn is not digit
            gn := gx
    }
    Else gn := A_Gui
    If i is not xdigit
    {
        GuiControlGet, t, Hwnd, %i%
        If ErrorLevel = 0
            i := t
        Else ControlGet, i, Hwnd, , %i%
    }
    gb := (gn - 1) * gs
    Loop, %cx%
        If (NumGet(c, cb := cs * (A_Index - 1)) == i) {
            If a =
            {
                cf = 1
                Break
            }
            Else gx := A_Gui
            d := NumGet(g, gb), gw := A_GuiWidth - (d >> 16 & k), gh := A_GuiHeight - (d & k), as := 1
                , dx := NumGet(c, cb + 4, "Short"), dy := NumGet(c, cb + 6, "Short")
                , dw := NumGet(c, cb + 8, "Short"), dh := NumGet(c, cb + 10, "Short")
            Loop, Parse, a, xywh
                If A_Index > 1
                    av := SubStr(a, as, 1), as += 1 + StrLen(A_LoopField)
                        , d%av% += (InStr("yh", av) ? gh : gw) * (A_LoopField + 0 ? A_LoopField : 1)
            DllCall("SetWindowPos", "UInt", i, "Int", 0, "Int", dx, "Int", dy, "Int", dw, "Int", dh, "Int", 4)
            If r != 0
                DllCall("RedrawWindow", "UInt", i, "UInt", 0, "UInt", 0, "UInt", 0x0101) ; RDW_UPDATENOW | RDW_INVALIDATE
            Return
        }
    If cf != 1
        cb := cl, cl += cs
    If (!NumGet(g, gb)) {
        Gui, %gn%:+LastFound
        WinGetPos, , , , gh
        VarSetCapacity(pwi, 68, 0), DllCall("GetWindowInfo", "UInt", WinExist(), "UInt", &pwi)
            , NumPut(((bx := NumGet(pwi, 48)) << 16 | by := gh - A_GuiHeight - NumGet(pwi, 52)), g, gb + 4)
            , NumPut(A_GuiWidth << 16 | A_GuiHeight, g, gb)
    }
    Else d := NumGet(g, gb + 4), bx := d >> 16, by := d & k
    ControlGetPos, dx, dy, dw, dh, , ahk_id %i%
    If cf = 1
    {
        Gui, %gn%:+LastFound
        WinGetPos, , , gw, gh
        d := NumGet(g, gb), dw -= gw - bx * 2 - (d >> 16), dh -= gh - by - bx - (d & k)
    }
    NumPut(i, c, cb), NumPut(dx - bx, c, cb + 4, "Short"), NumPut(dy - by, c, cb + 6, "Short")
        , NumPut(dw, c, cb + 8, "Short"), NumPut(dh, c, cb + 10, "Short")
    Return, true
}