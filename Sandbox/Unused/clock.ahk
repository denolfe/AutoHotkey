guiColor := "EEAA99"
fontName := "Arial", fontSize := 36, fontWeight := 6, fontColor := "C6E2FF"

setTimer, getTime, 500

Gui, +owner toolwindow -caption
Gui, Color, % guiColor
Gui, Font, % " s" fontSize " c" fontColor " w" (fontWeight * 100), % fontName
Gui, Add, Text, center vtimeDisp, loading clock..
Gui, Show,, clockWin

winWait, clockWin,,,,, winSet, bottom
winGetPos, cPosX, cPosY, cPosW, cPosH
;winMove % (A_ScreenWidth / 2) - (cPosW / 2), % "-" fontSize / 1.2
WinMove 1975, 40
winSet, TransColor, % guiColor " 255", clockWin
return

getTime:
    formatTime, curTime,, h:mm:ss tt
    GuiControl, text, timeDisp, % curTime
    winSet, bottom,, clockWin
return

esc::Exitapp