#Persistent
SetTitleMatchmode, 2
settimer, fixtitle, 500
return

fixtitle:
WinGetTitle, Title, Sublime Text
StringReplace, Title, Title, (UNREGISTERED), , All
WinSetTitle, ahk_class PX_WINDOW_CLASS,, %Title%

return