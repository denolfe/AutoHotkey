; MuteOnKeypress_v1.0.ahk
;
; AutoHotkey script to mute microphone once the keyboard is pressed
;
; @author Samuel Blomberg
; @date 6/23/2011

; MuteUntil variable used to track the time from the last keypress
MuteUntil := A_TickCount
; SetTimer creates a thread that executes MuteChecker every 250ms (0.25 seconds)
SetTimer MuteChecker,250

; All the main thread of this program will do is 
;  loop through this single set of commands. The 
;  Input, SingleKey, L1VI... line pauses the thread
;  until a keyboard input is received. At that time
;  the MuteUntil variable is changed to one second
;  (1000ms) from the current time and the MuteMic() 
;  method is called
Loop {
	Input, SingleKey, L1VI, {LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{Capslock}{Numlock}{PrintScreen}{Pause} 
	MuteUntil := A_TickCount + 1000
	MuteMic()
}

; This subroutine operates on a 250ms timer. Every
;  time it is executed, it checks to see if the mic
;  should be unmuted by comparing the MuteUntil variable
;  with the current time
MuteChecker:
	If (MuteUntil < A_TickCount) {
		UnmuteMic()
	}
	Return

; Mutes system microphone
MuteMic() {
; --- YOU WILL NEED TO CHANGE THE FOLLOWING LINE ---
	VA_SetMasterMute(true, "capture") ;<--Change what's between quotation marks with the system name of your microphone
}

; Unmutes system microphone
UnmuteMic() {
; --- YOU WILL NEED TO CHANGE THE FOLLOWING LINE ---
	VA_SetMasterMute(false, "capture")  ;<--Change what's between quotation marks with the system name of your microphone
}