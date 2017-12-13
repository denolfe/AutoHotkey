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
