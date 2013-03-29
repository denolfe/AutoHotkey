RWin::

Loop 
	{
		KeyWait, o, D T0.02
		If not ErrorLevel 
			msgbox, You press o after RWin.
			
		KeyWait, z, D T0.02
		If not ErrorLevel 
			msgbox, You press z after RWin.
		
		Sleep 10
	}