#IfWinActive Microsoft SQL Server Management Studio

	^l::	
		If (A_PriorHotKey = A_ThisHotKey and A_TimeSincePriorHotkey < 500)
		{
			Send, {Shift Down}{Down}{End}{Shift Up}
		}
		else
		{
			Send, {Home}
			Send, {Shift Down}{End}{Shift Up}
		}
		Return

	+Enter::Send {F5}
	^t::	Send ^{n}
#IfWinActive