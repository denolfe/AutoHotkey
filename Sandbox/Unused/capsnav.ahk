;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Written by Philipp Otto, Germany
;
; Script Function:
;	Template script (you can customize this template by editing "ShellNew\Template.ahk" in your Windows folder)
;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#NoTrayIcon

SetCapsLockState, AlwaysOff


CapsLock & i::
       if getkeystate("alt") = 0
               Send,{Up}
       else
               Send,+{Up}
return

CapsLock & l::
       if getkeystate("alt") = 0
               Send,{Right}
       else
               Send,+{Right}
return

CapsLock & j::
       if getkeystate("alt") = 0
               Send,{Left}
       else
               Send,+{Left}
return

CapsLock & k::
       if getkeystate("alt") = 0
               Send,{Down}
       else
               Send,+{Down}
return

CapsLock & ,::
       if getkeystate("alt") = 0
               Send,^{Down}
       else
               Send,+^{Down}
return

CapsLock & 8::
       if getkeystate("alt") = 0
               Send,^{Up}
       else
               Send,+^{Up}
return

CapsLock & u::
       if getkeystate("alt") = 0
               Send,{Home}
       else
               Send,+{Home}
return

CapsLock & o::
       if getkeystate("alt") = 0
               Send,{End}
       else
               Send,+{End}
return

CapsLock & h::
       if getkeystate("alt") = 0
               Send,^{Left}
       else
               Send,+^{Left}
return

      CapsLock & `;::                                  ;has to be changed (depending on the keyboard-layout)
               if getkeystate("alt") = 0
                       Send,^{Right}
               else
                       Send,+^{Right}
       return
	   
CapsLock & y::
       if getkeystate("alt") = 0
               Send,^{Home}
       else
               Send,+^{Home}
return

CapsLock & p::
       if getkeystate("alt") = 0
               Send,^{End}
       else
               Send,+^{End}
return

CapsLock & BS::Send,{Del}
CapsLock & b::Send ^x 
CapsLock & n::Send ^c
CapsLock & m::Send ^v

;Prevents CapsState-Shifting
CapsLock & Space::Send,{Space}

;*Capslock::SetCapsLockState, AlwaysOff
;+Capslock::SetCapsLockState, On