; Example #1:
SysGet, MouseButtonCount, 43
SysGet, VirtualScreenWidth, 78
SysGet, VirtualScreenHeight, 79

; Example #2: This is a working script that displays info about each monitor:
SysGet, MonitorCount, MonitorCount
SysGet, MonitorPrimary, MonitorPrimary
Message .= "Monitor Count:`t" MonitorCount "`nPrimary Monitor:`t" MonitorPrimary
Loop, %MonitorCount%
{
    SysGet, MonitorName, MonitorName, %A_Index%
    SysGet, Monitor, Monitor, %A_Index%
    SysGet, MonitorWorkArea, MonitorWorkArea, %A_Index%
    Message .= "`n`nMonitor:`t#" A_Index "`nName:`t" MonitorName "`nLeft:`t" MonitorLeft "(" MonitorWorkAreaLeft " work)`nTop:`t" MonitorTop " (" MonitorWorkAreaTop " work)`nRight:`t" MonitorRight " (" MonitorWorkAreaRight " work)`nBottom:`t" MonitorBottom "(" MonitorWorkAreaBottom " work)"
}

msgbox % Message