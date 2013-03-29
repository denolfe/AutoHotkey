SetTitleMatchMode, 2

Loop
{
	CurrTime = %A_Hour%%A_Min%
	IfWinActive, Internet Explorer
	{
		If (CurrTime >= 0745 && CurrTime <= 1700)
		{
			Send {F5}
		}
		
	}
	Sleep 60000

}



^!x::ExitApp
