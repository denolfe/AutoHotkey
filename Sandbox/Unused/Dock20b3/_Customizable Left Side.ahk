SetBatchLines, -1 
#SingleInstance, force 
   
  Msgbox This test will monitor Notepad appearance and add customizable number of dock clients to its left side.

   host := "ahk_class Notepad" 
   clientNo := 5 

   Dock_OnHostDeath := "OnHostDeath" 
   loop, %clientNo% 
   { 
      Gui %A_Index%:+LastFound +ToolWindow +Border +Resize -Caption 
      Gui,%A_Index%:Add, Button, 0x8000, %A_Index% 
      c%A_Index% := WinExist() 

      Dock(c%A_Index%, "x(,-1,-10) y(,," A_Index*50 ") w(,50) h(,50)") 
   } 

return 

FindHost: 
   if Dock_HostID := WinExist(host) 
   { 
      SetTimer, FindHost, OFF   
      Dock_Toggle(true) 
   } 
return 

OnHostDeath: 
   SetTimer, FindHost, 100 
return 

#include Dock.ahk