Process, Exist, Steam.exe
if ErrorLevel
	Run, "steam://open/bigpicture"
else
	Run, "D:\Games\Steam\Steam.exe" -bigpicture
WinWait, Steam ahk_class CUIEngineWin32
