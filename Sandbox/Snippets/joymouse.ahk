#SingleInstance force


;;;;;;;;TODO;;;;;;;;;;;;
;;  - Add method for holding mouse button
;;  - Add trigger support
;;  - Context-sensitive hotkeys http://www.autohotkey.com/docs/commands/Hotkey.htm



; Increase the following value to make the mouse cursor move faster:
JoyMultiplier = 0.30

; Decrease the following value to require less joystick displacement-from-center
; to start moving the mouse.  However, you may need to calibrate your joystick
; -- ensuring it's properly centered -- to avoid cursor drift. A perfectly tight
; and centered joystick could use a value of 1:
JoyThreshold = 15

; Change the following to true to invert the Y-axis, which causes the mouse to
; move vertically in the direction opposite the stick:
InvertYAxis := false

; Change these values to use joystick button numbers other than 1, 2, and 3 for
; the left, right, and middle mouse buttons.  Available numbers are 1 through 32.
; Use the Joystick Test Script to find out your joystick's numbers more easily.
ButtonLeft = 1
ButtonRight = 2
ButtonMiddle = 3
ButtonY = 4
ButtonLB = 5
ButtonRB = 6
ButtonSelect = 7
ButtonStart = 8

; If your joystick has a POV control, you can use it as a mouse wheel.  The
; following value is the number of milliseconds between turns of the wheel.
; Decrease it to have the wheel turn faster:
WheelDelay = 25

; If your system has more than one joystick, increase this value to use a joystick
; other than the first:
JoystickNumber = 1

; END OF CONFIG SECTION -- Don't change anything below this point unless you want
; to alter the basic nature of the script.

JoystickPrefix = %JoystickNumber%Joy
Hotkey, %JoystickPrefix%%ButtonLeft%, ButtonLeft
Hotkey, %JoystickPrefix%%ButtonRight%, ButtonRight
Hotkey, %JoystickPrefix%%ButtonMiddle%, ButtonMiddle
Hotkey, %JoystickPrefix%%ButtonY%, ButtonY
Hotkey, %JoystickPrefix%%ButtonLB%, ButtonLB
Hotkey, %JoystickPrefix%%ButtonRB%, ButtonRB
Hotkey, %JoystickPrefix%%ButtonSelect%, ButtonSelect
Hotkey, %JoystickPrefix%%ButtonStart%, ButtonStart


; Calculate the axis displacements that are needed to start moving the cursor:
JoyThresholdUpper := 50 + JoyThreshold
JoyThresholdLower := 50 - JoyThreshold
if InvertYAxis
    YAxisMultiplier = -1
else
    YAxisMultiplier = 1

SetTimer, WatchJoystick, 10  ; Monitor the movement of the joystick.

GetKeyState, JoyInfo, %JoystickNumber%JoyInfo
IfInString, JoyInfo, P  ; Joystick has POV control, so use it as a mouse wheel.
    SetTimer, MouseWheel, %WheelDelay%

return  ; End of auto-execute section.


; The subroutines below do not use KeyWait because that would sometimes trap the
; WatchJoystick quasi-thread beneath the wait-for-button-up thread, which would
; effectively prevent mouse-dragging with the joystick.

ButtonLeft:
SetMouseDelay, -1  ; Makes movement smoother.
MouseClick, left,,, 1, 0, D  ; Hold down the left mouse button.
SetTimer, WaitForLeftButtonUp, 10
return

ButtonRight:
SetMouseDelay, -1  ; Makes movement smoother.
MouseClick, right,,, 1, 0, D  ; Hold down the right mouse button.
SetTimer, WaitForRightButtonUp, 10
return

ButtonMiddle:
SetMouseDelay, -1  ; Makes movement smoother.
MouseClick, middle,,, 1, 0, D  ; Hold down the right mouse button.
SetTimer, WaitForMiddleButtonUp, 10
return

ButtonY:
yDown := true
	Loop 
	{
		KeyWait, %JoystickPrefix%%ButtonLB%, D T0.02
		If not ErrorLevel
		{
			Send ^+{Tab}
			break
		}
		KeyWait, %JoystickPrefix%%ButtonRB%, D T0.02
		If not ErrorLevel
		{
			Send ^{Tab}
			break
		}
		KeyWait, %JoystickPrefix%%ButtonRB%, D T0.02
		If not ErrorLevel
		{
			Send ^{Tab}
			break
		}
		KeyWait, %JoystickPrefix%%ButtonSelect%, D T0.02
		If not ErrorLevel
		{
			SendInput !{Tab}
			break
		}

		Sleep 10
	}
yDown := false
return

ButtonRB_Chrome:
Send ^l
return

ButtonLB_Chrome:
Send ^k
return


ButtonLB:
if !yDown
{
	Send !{Left}
}
return
ButtonRB:
if !yDown
{
	Send !{Right}
}
return

ButtonStart:
Send {LWin}
Return

ButtonSelect:

return

WaitForLeftButtonUp:
if GetKeyState(JoystickPrefix . ButtonLeft)
    return  ; The button is still, down, so keep waiting.
; Otherwise, the button has been released.
SetTimer, WaitForLeftButtonUp, off
SetMouseDelay, -1  ; Makes movement smoother.
MouseClick, left,,, 1, 0, U  ; Release the mouse button.
return

WaitForRightButtonUp:
if GetKeyState(JoystickPrefix . ButtonRight)
    return  ; The button is still, down, so keep waiting.
; Otherwise, the button has been released.
SetTimer, WaitForRightButtonUp, off
MouseClick, right,,, 1, 0, U  ; Release the mouse button.
return

WaitForMiddleButtonUp:
if GetKeyState(JoystickPrefix . ButtonMiddle)
    return  ; The button is still, down, so keep waiting.
; Otherwise, the button has been released.
SetTimer, WaitForMiddleButtonUp, off
MouseClick, middle,,, 1, 0, U  ; Release the mouse button.
return

WatchJoystick:
MouseNeedsToBeMoved := false  ; Set default.
SetFormat, float, 03
GetKeyState, joyx, %JoystickNumber%JoyX
GetKeyState, joyy, %JoystickNumber%JoyY
if joyx > %JoyThresholdUpper%
{
    MouseNeedsToBeMoved := true
    DeltaX := joyx - JoyThresholdUpper
}
else if joyx < %JoyThresholdLower%
{
    MouseNeedsToBeMoved := true
    DeltaX := joyx - JoyThresholdLower
}
else
    DeltaX = 0
if joyy > %JoyThresholdUpper%
{
    MouseNeedsToBeMoved := true
    DeltaY := joyy - JoyThresholdUpper
}
else if joyy < %JoyThresholdLower%
{
    MouseNeedsToBeMoved := true
    DeltaY := joyy - JoyThresholdLower
}
else
    DeltaY = 0
if MouseNeedsToBeMoved
{
    SetMouseDelay, -1  ; Makes movement smoother.
    MouseMove, DeltaX * JoyMultiplier, DeltaY * JoyMultiplier * YAxisMultiplier, 0, R
}
return

MouseWheel:
GetKeyState, JoyPOV, %JoystickNumber%JoyPOV
if JoyPOV < 0  ; No angle.
    return
else if (JoyPOV > 31500)  ; Forward
    Send {WheelUp}
else if JoyPOV between 0 and 4500   ; Forward
	Send {WheelUp}
else if JoyPOV between 4501 and 13500 ; Right
	Send {WheelRight}
else if JoyPOV between 13501 and 22500  ; Back
    Send {WheelDown}
else									; Left
	Send {WheelLeft}  
return

