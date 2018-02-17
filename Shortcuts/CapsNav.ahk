;;;;; CapsNav ;;;;;;;

^+CapsLock::CapsLock

CapsLock & h::CapsNav("Left")
CapsLock & j::CapsNav("Down")
CapsLock & k::CapsNav("Up")
CapsLock & l::CapsNav("Right")

CapsLock & n::CapsNav("Home")
CapsLock & p::CapsNav("End")

CapsLock & .::
CapsLock & o::CapsNav("Right", "^")
CapsLock & m::CapsNav("Left", "^")

CapsLock & u::CapsNav("PgDn")
CapsLock & i::CapsNav("PgUp")

CapsLock & BackSpace::
	If GetKeyState("alt")
		Send, ^{Delete}
	Else
		Send, {Delete}
Return

; CapsLock & `;::
; CapsLock & ,::
; Return

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
