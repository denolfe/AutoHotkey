keypadEnabled := false
CapsLock::
	if (A_PriorHotkey = A_ThisHotkey && A_TimeSincePriorHotkey < 200)
	{
		if (keypadEnabled)
		{
			SplashImage,,x0 y0 b fs12 cw00FF00, Keypad Disabled
			keypadEnabled := false
			SetTimer, KPSplashOff, -1000
		}
		Else
		{
			SplashImage,,x0 y0 b fs12 cwFF0000, Keypad Enabled
			keypadEnabled := true
		}
	}
Return

#If keypadEnabled
	j::4
	k::5
	l::6
	u::7
	i::8
	o::9
	m::1
	,::2
	.::3
	Space::0
	`;::.
#If