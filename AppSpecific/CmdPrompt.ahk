#IfWinActive ahk_class ConsoleWindowClass
  ; Paste
	^V::SendInput {Raw}%clipboard%
  ; Ctrl+L for clear
	^L::SendInput, {Esc}cls{Enter}
#IfWinActive
