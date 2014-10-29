;;;;; CapsNav ;;;;;;;

*CapsLock::SetCapsLockState, Off

+CapsLock::
	If GetKeyState("CapsLock", "T")
		SetCapsLockState, Off
	Else
		SetCapsLockState, On
	Return

CapsLock & h::CapsNav("Left")
CapsLock & j::CapsNav("Down")
CapsLock & k::CapsNav("Up")
CapsLock & l::CapsNav("Right")

CapsLock & n::CapsNav("Home")
CapsLock & p::CapsNav("End")

CapsLock & o::
CapsLock & .::CapsNav("Right", "^")
CapsLock & u::
CapsLock & m::CapsNav("Left", "^")

CapsLock & `;::
CapsLock & ,::
CapsLock & i::
Return