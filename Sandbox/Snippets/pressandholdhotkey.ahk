a:: ;hotkey has 3 different functions based on press duration
aDown:=A_TickCount
Keywait a
If ((A_TickCount-aDown)<300)
  Send A
If ((A_TickCount-aDown)>300) and ((A_TickCount-aDown)<600)
  Send B
If ((A_TickCount-aDown)>600)
  Send C
Return
