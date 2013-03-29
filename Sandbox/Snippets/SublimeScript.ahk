#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#WinActivateForce
#SingleInstance force
SetTitleMatchMode, 2

#IfWinActive ahk_class PX_WINDOW_CLASS
	~^s::
		sleep, 200
    	IfWinExist, unregistered
			WinClose
		Return
#IfWinActive