#NoTrayIcon

BlockInput, MouseMove
Return

~RCTRL::
if !Toggle
{
    BlockInput, MouseMoveOff
    KeyWait, RCTRL
    BlockInput, MouseMove
}
else
    KeyWait, RCTRL
if (A_PriorHotkey=A_ThisHotkey && A_TimeSincePriorHotkey <= 500)
{
    Toggle := !Toggle
    BlockInput, % Toggle ? "MouseMoveOff" : "MouseMove"
    ToolTip % Toggle ? "Off" : "On"
    SetTimer, ToolTipOff, 1500
}
Return

ToolTipOff:
ToolTip
Return