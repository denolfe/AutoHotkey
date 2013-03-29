; =====================================================================================================================================================
;                   Original Author: jpjazzy            Link: http://www.autohotkey.com/forum/viewtopic.php?p=487175#487175
;					Script: SmartBright
; =====================================================================================================================================================
#SingleInstance force
;Menu, Tray, Icon, lib\moon.ico

Settimer, GUI2AlwaysOnTop, 10 ; Keep gui 2 on top

SetBatchLines, -1

FormatTime, CurrentHour,, h
FormatTime, CurrentAMPM,, tt         ; Get the relavent time set
FormatTime, CurrentMinute,, m


If (CurrentHour >= 1 && CurrentHour <= 7 && CurrentAMPM == "AM") ; If the time is 1 AM - 7 AM [MORNING]
{
   Intensity := 150 ; Dim intensity 150
}
Else If (CurrentHour >= 7 && CurrentHour <= 10 && CurrentAMPM == "AM") ; If the time is 7 AM - 10 AM [MORNING]
{
   Intensity := 50
}
Else If (CurrentHour >= 10 && CurrentHour <= 12 && CurrentAMPM == "PM") ; If the time is 10 PM - 12 PM [Evening]
{
   Intensity := 150
}
else
   Intensity := 0 ; Set intesity to nothing if the time frame is anything different

Gui, 1: Default
Gui, Color, 0x000000 ; Color to black
Gui, +LastFound +AlwaysOnTop -Caption +E0x20 ; Click through GUI always on top.
WinSet, Transparent, %Intensity% ; Set intensity first based on the time of dday
Gui, 1: +owner
Gui, Show, x-1920 y0 w5760 h1200 ; Cover entire screen

;Gui, 2: Default ; Generate the Autohide options GUI
;Gui, Color, 0xC11B17
;gui, Font, s12 bold underline C0xFFFFFF, Times New Roman
;Gui, Add, Text, x22 y10 w190 h20 , Screen Luminosity Options
;gui, Font, s12 norm C0x7E2817, Times New Roman
;gui, Font, s10 bold C0x7E2917, Times New Roman
;Gui, Add, CheckBox, x22 y30 w170 h20 Checked vOnOffToggle gEnDisCusLum, Enable custom luminosity
;Gui, Add, CheckBox, x22 y50 w170 h20 Checked vAutoHideCheck gAutoHideCheck, Auto-Hide options window
;gui, Font, s10 bold underline C0xFFFFFF, Times New Roman
;Gui, Add, Text, x232 y20 w170 h20 , Luminosity intensity
;gui, Font, s7 norm C0xFFFFFF, Times New Roman
;Gui, Add, Slider, x232 y40 w130 h20 Range0-200 vIntensity gAdjustLum, %Intensity%
;Gui, Add, Text, x350 y60 w10 h20 , +
;Gui, Add, Text, x240 y60 w10 h20 , -
;Gui, Add, Text, x362 y40 w30 h20 , MAX
;Gui, Add, Text, x213 y40 w20 h20 , MIN
;Gui,  -Border +LastFound +AlwaysOnTop ;+NoActivate
;Gui, 2: +owner
;Gui, Show, y0 Autosize
;GUI_AutoHide("U", 2, 2000) ; Autohide using my previously written function
;return

GUI2AlwaysOnTop:
Gui, 2: +AlwaysonTop
return

EnDisCusLum: ; Turn on off custom brightness
Gui, 2: Submit, Nohide
Gui, 1: Default
If (OnOffToggle = 1)
	Gui, Show
else
	Gui, Hide
return

AutoHideCheck: ; Turn on or off the autohide for GUI 2
Gui, 2: Submit, Nohide
If (AutoHideCheck = 1) ; Checked
	GUI_AutoHide("U", 2, 2000)
else
	GUI_AutoHide("U", 2, 2000, 5, 0)
return

AdjustLum:
Gui, 2: Submit, NoHide
Gui, 1: Default
Gui, +LastFound
WinSet, Transparent, %Intensity%
return

~LButton & WheelUp:: ; Turn up the brightness by dimming the GUI
If Intensity = 0 ; Return if intensity is nothing
   return
Intensity-=5
Gui, +LastFound
WinSet, Transparent, %Intensity%
return

~LButton & WheelDown:: ; Turn down the brightness by making the GUI more visible
If Intensity > 200 ; Return if intensity is greater than 200, since we don't want the screen to go black
   return
Intensity+=5
Gui, +LastFound
WinSet, Transparent, %Intensity%
return

Shift & Esc:: ; Shut down window
ExitApp



; =====================================================================================================================================================





; ================================================================ Previously written GUI-Hider ======================================================




; =====================================================================================================================================================
;                   Original Author: jpjazzy            Link: http://www.autohotkey.com/forum/viewtopic.php?p=485853#485853
; =====================================================================================================================================================
;   GUI_AutoHide(Hide direction, [Gui # to hide, Delay in milliseconds before hiding, Number of pixels to display while hidden (offset), Enabled/Disabled Flag])
; =====================================================================================================================================================
; Required parameters: Hide direction (LEFT="L", RIGHT="R", UP="U", DOWN="D")
; Defaults for optional parameters: GUI # = 1, Delay in ms = 3000 = 3 seconds, Number of pixels to display while hidden = 5, Enabled/Disabled Flag = 1 (Enabled=1 Disabled=0)
; =====================================================================================================================================================
; NOTES: 
; * Functions work with expressions, so make sure you use quotes when inputting settings unless the setting is contained within a variable
; * Function must be placed directly after the GUI you are using it for
; * Function will make the GUI AlwaysOnTop so the user can activate it from the autohide
; * Specifying 0 for the Enabled/Disabled Flag will return the GUI to it's original position before deactivating autohide
; * The window must be hidden and docked to the side of the screen before the effects of the autohide take place
; * The titlebar sometimes gets in the way of reactivating the hidden GUI if there is one... To get around this either remove the caption/border or Set a higher pixel offset
; =====================================================================================================================================================
; LIMITATIONS:
; - Using this on multiple GUIs most likely will cause problems due to the hide overlapping
; =====================================================================================================================================================
; ========================================= (AUTOHIDE FUNCTIONS) ==========================================
GUI_AutoHide(Hide_Direction, Gui_Num_To_Hide_Clone=1, Delay_Before_Hide=3000, Number_Of_Offset_Pixels=5, Enabled_Disabled_Flag=1) ; Autohide the GUI function
{
   global ; Assume global
   Gui_Num_To_Hide := Gui_Num_To_Hide_Clone
   Gui, %Gui_Num_To_Hide%: +LastFound ; Set GUI settings so we can obtain it's settings and give it an alwaysontop attribute to make the user be able to unhide it

   ; ** OBTAIN  AND SET VARIABLES **
   StringUpper, Hide_Direction, Hide_Direction ; Capitalize it just in case the user didn't for the label
   If ( Enabled_Disabled_Flag = 0 )
   {
   %Gui_Num_To_Hide%_Enabled_Disabled_Flag := 0
    WinMove, % %Gui_Num_To_Hide%_Gui_Title,, % %Gui_Num_To_Hide%_GUIX, % %Gui_Num_To_Hide%_GUIY
    return
   }
   
   WinGetPos, %Gui_Num_To_Hide%_GUIX, %Gui_Num_To_Hide%_GUIY, %Gui_Num_To_Hide%_GUIW, %Gui_Num_To_Hide%_GUIH, A
   WinGetTitle, %Gui_Num_To_Hide%_Gui_Title, A
   %Gui_Num_To_Hide%_TimeLapse := A_TickCount                           ; Set the specified variables with respect to which GUI the settings go to
   %Gui_Num_To_Hide%_Enabled_Disabled_Flag := Enabled_Disabled_Flag
   %Gui_Num_To_Hide%_Number_Of_Offset_Pixels := Number_Of_Offset_Pixels
   %Gui_Num_To_Hide%_Delay_Before_Hide := Delay_Before_Hide
   %Gui_Num_To_Hide%_Hide_Direction := Hide_Direction
    ;MsgBox % %Gui_Num_To_Hide%_Gui_Title
    
   
   
Loop
{
	CurrTime = %A_Hour%%A_Min%
	msgbox % CurrTime
		If (CurrTime >= 0740 && CurrTime <= 0830)
		{
			Intensity := 150 ; Dim intensity 150
			WinSet, Transparent, %Intensity%
		}
		Else If (CurrTime >= 0831 && CurrTime <= 1000)
		{
			Intensity := 100
			WinSet, Transparent, %Intensity%
		}
		Else If (CurrTime >= 1001 && CurrTime <= 1100)
		{
			Intensity := 50
			WinSet, Transparent, %Intensity%
		}
		Else If (CurrTime >= 1101 && CurrTime <= 1559)
		{
			Intensity := 0
			WinSet, Transparent, %Intensity%
		}
		Else If (CurrTime >= 1600 && CurrTime <= 1800)
		{
			Intensity := 50
			WinSet, Transparent, %Intensity%
		}
		
	
	Sleep 5000
	msgbox, % Intensity

}
   
   ; ** Place message for GUI **
   OnMessage(0x200,"WM_MOUSEMOVE") ; Message to send when the mouse is over the GUI
   SetTimer, HideGUI%Hide_Direction%, 500 ; Set timer to hide the GUI in whatever direction you chose
   return
   
      ; ** HideGUI Settings **
   HideGUIU:
   ;~ ;MsgBox % "If (" A_TickCount - %Gui_Num_To_Hide%_TimeLapse " < " %Gui_Num_To_Hide%_Delay_Before_Hide ") "
   If (%Gui_Num_To_Hide%_Enabled_Disabled_Flag != 1)
      return
   If (A_TickCount - %Gui_Num_To_Hide%_TimeLapse < %Gui_Num_To_Hide%_Delay_Before_Hide)         ; If the mouse was over the GUI within the last 3 seconds, don't hide it
      return
   
      WinGetPos,  GUIX, GUIY,,, % %Gui_Num_To_Hide%_Gui_Title ; Get the position of the GUI
      Loop
      {
         ; MsgBox % "If (" %Gui_Num_To_Hide%_GUIY+%Gui_Num_To_Hide%_GUIH " > " %Gui_Num_To_Hide%_Number_Of_Offset_Pixels ")"
         If (GUIY + %Gui_Num_To_Hide%_GUIH > %Gui_Num_To_Hide%_Number_Of_Offset_Pixels)     ; If the GUI is not hidden hide it then break
         {
            ;~ ;MsgBox % "WinMove,"  %Gui_Num_To_Hide%_Gui_Title ",, " GUIX ", " GUIY-(A_Index)
            WinMove, % %Gui_Num_To_Hide%_Gui_Title,, %GUIX%, % GUIY-(A_Index)
            WinGetPos,  GUIX, GUIY,,, % %Gui_Num_To_Hide%_Gui_Title
            ;MsgBox % "WinGetPos,  " GUIX ", " GUIY ",,, "  %Gui_Num_To_Hide%_Gui_Title
         }
         else
            break
      }
   
   If ((GUIY + %Gui_Num_To_Hide%_GUIH) < (%Gui_Num_To_Hide%_Number_Of_Offset_Pixels-1)) ; Failsafe if the GUI moves too far
   {
      WinMove, % %Gui_Num_To_Hide%_Gui_Title,, %GUIX%, % (-%Gui_Num_To_Hide%_GUIH+%Gui_Num_To_Hide%_Number_Of_Offset_Pixels)
   }
   SetTimer, HideGUIU, OFF
   return
   
      HideGUID:
   ;~ ;MsgBox % "If (" A_TickCount - %Gui_Num_To_Hide%_TimeLapse " < " %Gui_Num_To_Hide%_Delay_Before_Hide ") "
      If (%Gui_Num_To_Hide%_Enabled_Disabled_Flag != 1)
      return
   If (A_TickCount - %Gui_Num_To_Hide%_TimeLapse < %Gui_Num_To_Hide%_Delay_Before_Hide)         ; If the mouse was over the GUI within the last 3 seconds, don't hide it
      return
   
      WinGetPos,  GUIX, GUIY,,, % %Gui_Num_To_Hide%_Gui_Title ; Get the position of the GUI
      Loop
      {
         ; MsgBox % "If (" %Gui_Num_To_Hide%_GUIY+%Gui_Num_To_Hide%_GUIH " > " %Gui_Num_To_Hide%_Number_Of_Offset_Pixels ")"
         If (GUIY < A_ScreenHeight-%Gui_Num_To_Hide%_Number_Of_Offset_Pixels)     ; If the GUI is not hidden hide it then break
         {
            ;~ ;MsgBox % "WinMove,"  %Gui_Num_To_Hide%_Gui_Title ",, " GUIX ", " GUIY-(A_Index)
            WinMove, % %Gui_Num_To_Hide%_Gui_Title,, %GUIX%, % GUIY+(A_Index)
            WinGetPos,  GUIX, GUIY,,, % %Gui_Num_To_Hide%_Gui_Title
            ;MsgBox % "WinGetPos,  " GUIX ", " GUIY ",,, "  %Gui_Num_To_Hide%_Gui_Title
         }
         else
            break
      }
   
   If (GUIY > A_ScreenHeight-(%Gui_Num_To_Hide%_Number_Of_Offset_Pixels-1)) ; Failsafe if the GUI moves too far
   {
      WinMove, % %Gui_Num_To_Hide%_Gui_Title,, %GUIX%, % (A_ScreenHeight - %Gui_Num_To_Hide%_Number_Of_Offset_Pixels)
   }
   SetTimer, HideGUID, OFF
   return
   
   HideGUIR:
      If (%Gui_Num_To_Hide%_Enabled_Disabled_Flag != 1)
      return
   ;~ ;MsgBox % "If (" A_TickCount - %Gui_Num_To_Hide%_TimeLapse " < " %Gui_Num_To_Hide%_Delay_Before_Hide ") "
   If (A_TickCount - %Gui_Num_To_Hide%_TimeLapse < %Gui_Num_To_Hide%_Delay_Before_Hide)         ; If the mouse was over the GUI within the last 3 seconds, don't hide it
      return
   
      WinGetPos,  GUIX, GUIY,,, % %Gui_Num_To_Hide%_Gui_Title ; Get the position of the GUI
      Loop
      {
         ; MsgBox % "If (" %Gui_Num_To_Hide%_GUIY+%Gui_Num_To_Hide%_GUIH " > " %Gui_Num_To_Hide%_Number_Of_Offset_Pixels ")"
         If (GUIX < A_ScreenWidth-%Gui_Num_To_Hide%_Number_Of_Offset_Pixels)     ; If the GUI is not hidden hide it then break
         {
            ;~ ;MsgBox % "WinMove,"  %Gui_Num_To_Hide%_Gui_Title ",, " GUIX ", " GUIY-(A_Index)
            WinMove, % %Gui_Num_To_Hide%_Gui_Title,, % GUIX+A_Index, %GUIY%
            WinGetPos,  GUIX, GUIY,,, % %Gui_Num_To_Hide%_Gui_Title
            ;MsgBox % "WinGetPos,  " GUIX ", " GUIY ",,, "  %Gui_Num_To_Hide%_Gui_Title
         }
         else
            break
      }
   
   If (GUIX > A_ScreenWidth-%Gui_Num_To_Hide%_Number_Of_Offset_Pixels) ; Failsafe if the GUI moves too far
   {
      WinMove, % %Gui_Num_To_Hide%_Gui_Title,, % A_ScreenWidth-%Gui_Num_To_Hide%_Number_Of_Offset_Pixels, %GUIY%
   }
   SetTimer, HideGUIR, OFF
   return
   
      HideGUIL:
   ;~ ;MsgBox % "If (" A_TickCount - %Gui_Num_To_Hide%_TimeLapse " < " %Gui_Num_To_Hide%_Delay_Before_Hide ") "
      If (%Gui_Num_To_Hide%_Enabled_Disabled_Flag != 1)
      return
   If (A_TickCount - %Gui_Num_To_Hide%_TimeLapse < %Gui_Num_To_Hide%_Delay_Before_Hide)         ; If the mouse was over the GUI within the last 3 seconds, don't hide it
      return
   
      WinGetPos,  GUIX, GUIY,,, % %Gui_Num_To_Hide%_Gui_Title ; Get the position of the GUI
      Loop
      {
         ; MsgBox % "If (" %Gui_Num_To_Hide%_GUIY+%Gui_Num_To_Hide%_GUIH " > " %Gui_Num_To_Hide%_Number_Of_Offset_Pixels ")"
         If (GUIX+%Gui_Num_To_Hide%_GUIW > %Gui_Num_To_Hide%_Number_Of_Offset_Pixels)     ; If the GUI is not hidden hide it then break
         {
            ;~ ;MsgBox % "WinMove,"  %Gui_Num_To_Hide%_Gui_Title ",, " GUIX ", " GUIY-(A_Index)
            WinMove, % %Gui_Num_To_Hide%_Gui_Title,, % GUIX-A_Index, %GUIY%
            WinGetPos,  GUIX, GUIY,,, % %Gui_Num_To_Hide%_Gui_Title
            ;MsgBox % "WinGetPos,  " GUIX ", " GUIY ",,, "  %Gui_Num_To_Hide%_Gui_Title
         }
         else
            break
      }
   
   If (GUIX+%Gui_Num_To_Hide%_GUIW < %Gui_Num_To_Hide%_Number_Of_Offset_Pixels) ; Failsafe if the GUI moves too far
   {
      WinMove, % %Gui_Num_To_Hide%_Gui_Title,, % -%Gui_Num_To_Hide%_GUIW+%Gui_Num_To_Hide%_Number_Of_Offset_Pixels, %GUIY%
   }
   SetTimer, HideGUIL, OFF
   return
   
}


WM_MOUSEMOVE(wParam,lParam) ; Action to take if the mouse moves over the GUI
{
   If (%A_Gui%_Enabled_Disabled_Flag = 1)
   {
      RestartGUIActivate:
      LabelDir := %A_Gui%_Hide_Direction
      SetTimer, HideGUI%LabelDir%, Off ; Turn off the label while the mouse is over the GUI
      WinGetPos,  GUIX, GUIY,,, % %A_Gui%_Gui_Title ; Get the position of the GUI if your cursor is over it.
      
      ; DO ACTION BASED ON WHAT DIRECTION THE GUI IS SET TO
      If (%A_Gui%_Hide_Direction == "U")
      {
         Loop
         {
            If (GUIY+%A_Gui%_GUIH < %A_Gui%_GUIH) ; If the GUI is hidden, show it then break
            {
               WinMove, % %A_Gui%_Gui_Title,, %GUIX%, % GUIY+(A_Index)
               WinGetPos,  GUIX, GUIY,,, % %A_Gui%_Gui_Title
            }
            else
               break
         }
      }
      Else If (%A_Gui%_Hide_Direction == "D")
      {
         Loop
         {
            If (GUIY > A_ScreenHeight-%A_Gui%_GUIH) ; If the GUI is hidden, show it then break
            {
               WinMove, % %A_Gui%_Gui_Title,, %GUIX%, % GUIY-(A_Index)
               WinGetPos,  GUIX, GUIY,,, % %A_Gui%_Gui_Title
            }
            else
               break
         }
      }
      Else If (%A_Gui%_Hide_Direction == "R")
      {
         Loop
         {
            If (GUIX+%A_Gui%_GUIW > A_ScreenWidth+%A_Gui%_Number_Of_Offset_Pixels) ; If the GUI is hidden, show it then break
            {
               WinMove, % %A_Gui%_Gui_Title,, GUIX-A_Index, %GUIY%
               WinGetPos,  GUIX, GUIY,,, % %A_Gui%_Gui_Title
            }
            else
               break
         }
      }
      Else If (%A_Gui%_Hide_Direction == "L")
      {
         Loop
         {
            If (GUIX+%A_Gui%_Number_Of_Offset_Pixels < 0) ; If the GUI is hidden, show it then break
            {
               WinMove, % %A_Gui%_Gui_Title,, GUIX+A_Index, %GUIY%
               WinGetPos,  GUIX, GUIY,,, % %A_Gui%_Gui_Title
            }
            else
               break
         }
      }
      
      CoordMode, Mouse, Screen         ;get the mouse position in SCREEN MODE because your GUI is relative to the screen
      MouseGetPos, MX, MY
      CoordMode, Mouse, Relative
      If (%A_Gui%_Hide_Direction == "U" && MX >= %A_Gui%_GUIX && MX <= %A_Gui%_GUIX+%A_Gui%_GUIW && MY >= 0 && MY <= %A_Gui%_GUIH) ; Check if your mouse is still over the GUI (U)
      {
       goto, RestartGUIActivate  ;Restart if it is
      }
      Else If (%A_Gui%_Hide_Direction == "D" && MX >= %A_Gui%_GUIX && MX <= %A_Gui%_GUIX+%A_Gui%_GUIW && MY >= A_ScreenHeight-%A_Gui%_GUIH && MY-%A_Gui%_GUIH <= A_ScreenHeight) ; Check if your mouse is still over the GUI (D)
      {
       goto, RestartGUIActivate  ;Restart if it is
      }
      Else If (%A_Gui%_Hide_Direction == "R" && MX >= A_ScreenWidth-%A_Gui%_GUIW && MX <= A_ScreenWidth && MY >= %A_Gui%_GUIY && MY <= %A_Gui%_GUIY+%A_Gui%_GUIH) ; Check if your mouse is still over the GUI (R)
      {
       goto, RestartGUIActivate  ;Restart if it is
      }
      Else If (%A_Gui%_Hide_Direction == "L" && MX >= 0 && MX <= %A_Gui%_GUIW && MY >= %A_Gui%_GUIY && MY <= %A_Gui%_GUIY+%A_Gui%_GUIH) ; Check if your mouse is still over the GUI (L)
      {
       goto, RestartGUIActivate  ;Restart if it is
      }
      
      else ; If your mouse is not over the GUI, prepare to hide it.
      {
      %A_Gui%_TimeLapse := A_TickCount
      SetTimer, HideGUI%LabelDir%, 1000
      }
   }
}





msgbox, test
