SetTitleMatchMode, 2 
SetBatchLines, -1 
#SingleInstance, force 

#UseHook On 

Run notepad,,,nPID 
WinWait ahk_pid %nPID% 
    
Dock_HostID := WinExist("ahk_pid " . nPID) 

Gui +LastFound +ToolWindow +Border +Resize -Caption 
w_ := 85 
x_ := 5 
y_ := 5 
Gui, Add, DropDownList, choose1 x%x_% y%y_% w%w_% vusepackage gusepackage, Package|-------------|amsmath|dhucs|beamer|natbib 
y_ := y_ + 25 
Gui, Add, DropDownList, choose1 x%x_% y%y_% w%w_% vsectioning gsectioning, Sectioning|-------------|paragraph|subparagraph|part|chapter|section|subsection|subsubsection 
y_ := y_ + 25 
Gui, Add, DropDownList, choose1 x%x_% y%y_% w%w_% vlisting glisting, Listing|-------------|itemize|enumerate|description 
y_ := y_ + 25 
Gui, Add, DropDownList, choose1 x%x_% y%y_% w%w_% vleft gleft, left(|left{|left[|left. 
y_ := y_ + 25 
Gui, Add, DropDownList, choose1 x%x_% y%y_% w%w_% vright gright, right)|right}|right]|right. 

Gui , Show,  LaTeX Dock 
GUI, +owner 
c1 := WinExist() 

Dock(c1, "x(1,0,-114)  y(0,0,29) t")    


Dock_OnHostDeath := "OnHostDeath" 

return 

usepackage: 
 return
return 

sectioning: 
   Gui,submit,nohide    

if (sectioning="Sectioning" or sectioning="-------------") 
   { 
   GuiControl, Choose, sectioning, 1 
   return 
   } 

   InputBox, title, \%sectioning%, title:, ,200 ,120 
   if (ErrorLevel=1) 
      { 
      GuiControl, Choose, sectioning, 1 
      WinActivate, %window_name% 
      return 
      } 

   result := "\"sectioning "{" title "}" 
   WinActivate, %window_name% 


   GuiControl, Choose, sectioning, 1 
return 

listing: 
   Gui,submit,nohide    
if (listing="Listing" or listing="-------------") 
   { 
   GuiControl, Choose, listing, 1 
   return 
   } 

   InputBox, title, \%listing%, number of items:, ,200 ,120,,,,,1 
   if (ErrorLevel=1) 
   { 
   GuiControl, Choose, listing, 1 
   WinActivate, %window_name% 
   return 
   } 

   if (listing="description") 
      { 
      addition :="[]" 
      } 

   else 
      { 
      addition :="" 
      } 

   WinActivate, %window_name% 

   result = \begin{%listing%} 

   send, {enter} 

Loop, %title% 
   { 
   result = `t\item%addition% 

   send, {space} 
   send, {enter} 
   } 

   result = \end{%listing%} 

   send, {enter} 

Loop, %title% { 
   send, {up} 
   } 

   send, {up} 
   send, {End} 
   GuiControl, Choose, listing, 1 
return 

left: 
   Gui,submit,nohide    
   result := "\"left      

   gosub output 
   GuiControl, Choose, left, 1 
return 

right: 
   Gui,submit,nohide 
   result := "\"right 
   gosub output 
   GuiControl, Choose, right, 1    
return 

output: 

   StringReplace result, result, {, \{ 
   StringReplace result, result, }, \} 
   WinActivate, %window_name% 

return 

OnHostDeath: 
   Dock_Shutdown() 
   ExitApp 
return 

GuiClose: 
   Dock_Shutdown() 
   ExitApp 
return 


;====================================== 

#include Dock.ahk