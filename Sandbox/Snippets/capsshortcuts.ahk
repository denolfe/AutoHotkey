#Include mymethods.ahk
#Singleinstance force

SetTitleMatchmode, RegEx

screenmid := A_ScreenWidth/2 - 16

CapsLock:: (cmd:=!cmd) ; use () to indicate an expression in which a variable is assigned the value of its boolean negation

#if cmd

	esc::WinClose, CMD

	s::Launch("Microsoft SQL Server Management Studio", "C:\Program Files (x86)\Microsoft SQL Server\110\Tools\Binn\ManagementStudio\Ssms.exe")
	d::Launch("ahk_class PX_WINDOW_CLASS", "C:\Program Files\Sublime Text 2\sublime_text.exe")
	f::Launch("Google Chrome", "chrome.exe")
	g::

		IfWinExist, ahk_class WindowsForms10.Window.8.app.0.13965fa_r11_ad1
		{
			WinActivate ahk_class WindowsForms10.Window.8.app.0.13965fa_r11_ad1
		}
		else
		{
			Loop, C:\Program Files (x86)\SalesPad.GP ServPack\Sales*.exe, 0, 1
			{
				 FileGetTime, Time, %A_LoopFileFullPath%, C
				 If (Time > Time_Orig)
				 {
					  Time_Orig := Time
					  exe := A_LoopFileFullPath
				 }
			}
			Run %exe%
		}
		WinClose, CMD
		Return

	w::Launch("Inbox", "chrome.exe www.gmail.com")
	e::Launch("Calendar", "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe  --app=https://www.google.com/calendar/render?pli=1")
	r::return
	t::Send {Right}

	z::		
		loop
		{
			WinClose, ahk_class CabinetWClass
			IfWinNotExist, ahk_class CabinetWClass
				break
		}
		loop
		{
			WinClose, Greenshot image editor
			IfWinExist, Save image?
			{
				WinActivate
				Send {Enter}
			}
			IfWinNotExist, Greenshot image editor
				break
		}
		WinClose ahk_class EVERYTHING
		Notify("Windows Purged","",-1,"GC=555555 TC=White MC=White")
		WinClose, CMD
		Return
	x::return
	c::return
	v::return
	b::
		Run, buildprompt.ahk
		WinClose, CMD
		return


#if

Launch(title, exe, toggle = 0)
{
	WinClose, CMD
	If WinActive(title) and toggle
		WinMinimize %title%
	Else
		{
			IfWinExist, %title%
				WinActivate
			else
			{
				Run, %exe%
				WinActivate
			}
		}
}