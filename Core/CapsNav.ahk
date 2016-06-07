;;;;; CapsNav ;;;;;;;

^+CapsLock::CapsLock

keypadEnabled := false
CapsLock::
	if (A_PriorHotkey = A_ThisHotkey && A_TimeSincePriorHotkey < 200)
	{
		if (keypadEnabled)
		{
			SplashImage,,x0 y0 b fs12, keypad Disabled
			keypadEnabled := false
			SetTimer, KPSplashOff, -1000
		}
		Else
		{
			SplashImage,,x0 y0 b fs12, keypad Enabled
			keypadEnabled := true
		}
	}
	Return

CapsLock & h::CapsNav("Left")
CapsLock & j::CapsNav("Down")
CapsLock & k::CapsNav("Up")
CapsLock & l::CapsNav("Right")

CapsLock & n::CapsNav("Home")
CapsLock & p::CapsNav("End")

CapsLock & o::CapsNav("Right", "^")
CapsLock & m::CapsNav("Left", "^")

CapsLock & u::CapsNav("PgDn")
CapsLock & i::CapsNav("PgUp")

CapsLock & BackSpace::Send, {Delete}

CapsLock & `;::
CapsLock & ,::

Return

CapsNav(action, initmod = "", mod = "+")
{
	If ! GetKeyState("alt")
		Send % initmod "{" action "}"
	Else
		Send % mod . initmod "{" action "}"
	SetCapsLockState, AlwaysOff
}

KPSplashOff:
   SplashImage, off
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
