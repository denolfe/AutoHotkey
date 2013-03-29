/*
Author: jpjazzy (Jeremy)

Last edit date: 11/25/2011

Description:
   Originally as part of the MW3 Joystick script, I decided I wanted to take it a step farther and let people make their own settings! This will work for any game that AutoHotkey can interact with (note that some full screen games function on a different level, so you will either need to window mode them some how or they will not work). This script is meant to be an alternative to joystick support programs that cost money such as Pinnacle Game Profiler.
   
Features:
   -Save your controller layout settings as a .jjc file (you can even give these to friends to help someone else with a controller layout for a new game)
   -Turn on and off 360 controller motors
   -A new way of reading the LT and RT buttons eliminates the Z axis problems, see lexikos script link for details
   -Send to tray
   -Mouse emulation
   -Threshold calibration
   -For people with more controllers than one, you can change which controller you use by changing the Joystick Number
   -Rapid fire (simply turns a semi-automatic to an automatic, it doesn't function all that fast)
   -Different key modes make getting the right setting for your game a lot easier

Future features:
   -Checking for updates
   -Help file
   -Game window sensitive hotkeys

Saved files extensions: \*.jjc [Jeremy's Joystick Configuration] [NOTE: THE ONLY THING SAVED IS THE LISTVIEW, NOT OTHER SETTINGS]

Required additions (Included at the bottom of the script):
   XInput.ahk - Script by Lexikos for xbox controller (http://www.autohotkey.com/forum/topic39091.html)
   json.ahk - Script by polyethene (http://www.autohotkey.com/forum/viewtopic.php?t=34565)

*/

; ###################### Initial settings ###############################
#Persistent
#SingleInstance, Force ; For restarting
SetBatchLines, -1 ; Faster script settings
Version := "1.0.0" ; Version number

;function to make the LT/RT keys function properly rather than on one axis
XInput_Init()

; Increase the following value to make the mouse cursor move faster:
JoyMultiplier = 0.40

; Decrease the following value to require less joystick displacement-from-center
; to start moving the mouse.  However, you may need to calibrate your joystick
; -- ensuring it's properly centered -- to avoid cursor drift. A perfectly tight
; and centered joystick could use a value of 1:
JoyThreshold = 15

; Same as above with RT/LT threshold displacement
TriggerThreshold := 5

; If your system has more than one joystick, increase this value to use a joystick
; other than the first:
JoystickNumber = 1

; For inverting the axis
YAxisMultiplier := 1

; Calculate the axis displacements that are needed to start moving the cursor:
JoyThresholdUpper := 50 + JoyThreshold
JoyThresholdLower := 50 - JoyThreshold

SetTimer, CheckTriggers, 5 ; Watches the triggers on the controller
SetTimer, JoyToMouse, 10 ; Monitors analog to mouse
SetTimer, WatchAxis, 10 ; Monitors analog to keys
SetTimer, WatchPOV, 10 ; watch dpad

Loop 10 ; Handles joy1-10
   Hotkey, Joy%A_Index%, JoyButtonHandler


Menu, Tray, Add, Unhide, Unhide ; Handles unhiding the GUI
menu, Tray, Default, Unhide
Menu, Tray, Click, 1

; ###################### Generate Main GUI ###############################
Gui, Color, 0xC20000
Menu, FileMenu, Add, &Open Previous Game Settings..., MenuFileOpen
Menu, FileMenu, Add, &Save Game Settings..., MenuFileSave
Menu, FileMenu, Add, Send to tray, MenuHandler
Menu, FileMenu, Add, E&xit, GuiClose
Menu, HelpMenu, Add, &About, MenuHandler
Menu, HelpMenu, Add, Help, MenuHandler
Menu, HelpMenu, Add, &Check for updates..., MenuHandler
Menu, MyMenuBar, Add, &File, :FileMenu  ; Attach the two sub-menus that were created above.
Menu, MyMenuBar, Add, &Help, :HelpMenu
Gui, Menu, MyMenuBar
Gui, Font, bold c700000
Gui, Add, GroupBox, x15 y20 w130 h90 , Controller Vibration
Gui, Add, CheckBox, x22 y40 w100 h30 Checked vLTV, LT Button Vibration
Gui, Add, CheckBox, x22 y70 w100 h30 Checked vRTV, RT Button Vibration
Gui, Add, GroupBox, x152 y20 w220 h80 , Controller options
Gui, Add, Text, x172 y40 w100 h30 , Controller Threshold:
Gui, Add, Slider, x272 y40 w90 h20 vJoyThreshold R0-30 ToolTip, 15
Gui, Add, Text, x172 y70 w100 h20 , Joystick Number:
Gui, Add, Edit, x272 y70 w90 h20 vJoystickNumber, 1
Gui, Font, s12 bold c700000
Gui, Add, Text, x10 y+40, Key Mappings:
Gui, Font, s9 bold c000000, Times New Roman
Gui, Add, ListView, x10 r25 w420 gJoyController grid, 360 Controller Button|Button Mode|Remap key(s)
LV_Add("", "A Button", "", "")
LV_Add("", "B Button", "", "")
LV_Add("", "X Button", "", "")
LV_Add("", "Y Button", "", "")
LV_Add("", "LB Button", "", "")
LV_Add("", "RB Button", "", "")
LV_Add("", "Select Button", "", "")
LV_Add("", "Start Button", "", "")
LV_Add("", "Left Joystick Button", "", "")
LV_Add("", "Right Joystick Button", "", "")
LV_Add("", "RT Button", "", "")
LV_Add("", "LT Button", "", "")
LV_Add("", "Directional Pad Up Button", "", "")
LV_Add("", "Directional Pad Down Button", "", "")
LV_Add("", "Directional Pad Right Button", "", "")
LV_Add("", "Directional Pad Left Button", "", "")
LV_Add("", "Left Joystick Right", "", "")
LV_Add("", "Left Joystick Left", "", "")
LV_Add("", "Left Joystick Up", "", "")
LV_Add("", "Left Joystick Down", "", "")
LV_Add("", "Right Joystick Right", "", "")
LV_Add("", "Right Joystick Left", "", "")
LV_Add("", "Right Joystick Up", "", "")
LV_Add("", "Right Joystick Down", "", "")
LV_ModifyCol(1)  ; Auto-size each column to fit its contents.
Gui, Font, s7 bold c000000, Times New Roman
Gui, Add, Text,, Jeremy's 360 controller support © 2011
Gui, Show, Autosize, Universal 360 Controller Support
return

; ###################### Saving File Code ###############################
MenuFileSave:
Loop, 24
{
   O_Index := A_Index
LV_GetText(TempReader1, O_Index)
LV_GetText(TempReader2, O_Index, 2)
LV_GetText(TempReader3, O_Index, 3)
If (!SaveFile)
{
   SaveFile := TempReader1
   If (TempReader2)
      SaveFile .= "|" TempReader2
   If (TempReader3)
      SaveFile .= "|" TempReader3
}
else
   {
      Loop, 3
      {
         I_Index := A_Index
         If (I_Index = 1 && TempReader1 != "")
            SaveFile .= "`n" TempReader1
         else if (I_Index = 2 && TempReader2 != "")
            SaveFile .= "|" TempReader2
         else if (I_Index = 3 && TempReader3 != "")
            SaveFile .= "|" TempReader3
      }
   }
}
FileSelectFile, SaveLocation, S,,, Jeremy's Joystick Configuration (*.jjc)
If ErrorLevel = 1
   return
If (!RegExMatch(SaveLocation, "(.*)\.jjc$"))
   SaveLocation .= ".jjc"
FileAppend, %SaveFile%, %SaveLocation%
SaveLocation := ""
SaveFile := "" ; Clear the variables
return

; ###################### Opening File Code ###############################
MenuFileOpen:
FileSelectFile, OpenLocation,,, Open file, Jeremy's Joystick Configuration (*.jjc)
If (!RegExMatch(OpenLocation, "(.*)\.jjc$"))
{
MsgBox, 16, Error, The file selected is not a .jjc file.
}
else
{
   Loop, Read, %OpenLocation%
   {
      StringSplit, Col, A_LoopReadLine, |
      ;~ MsgBox % Col1 "`n" Col2 "`n" Col3
      LV_Modify(A_Index, "", Col1, Col2, Col3)
      ;~ If (Col2)
         ;~ LV_Modify(A_Index, "", "", Col2)
      ;~ If (Col3)
         ;~ LV_Modify(A_Index, "", "", "", Col3)
      
      Loop, 3
         Col%A_Index% := "" ; Clear variable
   }
}
OpenLocation := "" ; Clear variable
return

; ###################### Menu Handling Code ###############################
MenuHandler:
If (A_ThisMenuItem == "&About" && A_ThisMenu == "HelpMenu")
{
   MsgBox, 64, About, Version: %Version%`nUniversal 360 Controller Support by Jeremy © 2011`n`nSpecial thanks to polyethene and Lexikos for the script functions.
}
Else If (A_ThisMenuItem == "Send to tray" && A_ThisMenu == "FileMenu")
{
   Gui, 1: Default
   Gui, Hide
}
return

; ###################### For LT and RT buttons ###############################
CheckTriggers:
GetTriggerState(LT, RT)
RTNum := 11
LTNum := 12

LV_GetText(RTKeyMode, RTNum, 2)
LV_GetText(Keys, RTNum, 3)
RHitKey := RegExReplace(Keys, "^(.*)\(When Pushed\)(.*)", "$1")
LV_GetText(LTKeyMode, LTNum, 2)
LV_GetText(Keys, LTNum, 3)
LHitKey := RegExReplace(Keys, "^(.*)\(When Pushed\)(.*)", "$1")
HitTriggers := false


If (LT > TriggerThreshold)
   HitTriggers := true
Else If (RT > TriggerThreshold)
   HitTriggers := true

If (HitTriggers)
{
   
   If (RTKeyMode == "Rapid Fire" && RT > TriggerThreshold)
      SendInput, {%RHitKey%}
   If (LTKeyMode == "Rapid Fire" && LT > TriggerThreshold)
      SendInput, {%LHitKey%}
   If (LT > TriggerThreshold && LTFlag != 1)
   {
      SendInput, {%LHitKey% down}
      LTFlag := 1
   }
   else if (LT <= TriggerThreshold)
      LTFlag := 0
   If (RT > TriggerThreshold && RTFlag != 1)
   {
      SendInput, {%RHitKey% down}
      RTFlag := 1
   }
   else if (RT <= TriggerThreshold)
      RTFlag := 0
}
Else
{
   If (RTFlag)
   {
   SendInput, {%RHitKey% up}
   RTFlag := 0
   }
   If (LTFlag)
   {
   SendInput, {%LHitKey% up}
   LTFlag := 0
   }
}
return


; ###################### Add joystick configuration on double click ###############################
JoyController:
if (A_GuiEvent = "DoubleClick" && A_EventInfo <= 10) ; Only do this for the first 10 buttons
{
   Gui, 2: Default
   Gui +Owner
   Gui, Add, Text,, Button Style:
   Gui, Add, Text,, Key(s)
   Gui, Add, DropDownList, r5 ys gEnDisFields vKeyType, Key Push||Key Push and Hold|Dual Key Push and Hold|Hold Key Until Release||Rapid Fire
   Gui, Add, Edit, v360Key1,
   Gui, Add, Edit, v360Key2,
   Gui, Add, Button, Default gSubmitButtonFields, Submit
   Gui, Add, Button, g2GuiClose, Cancel
   GuiControl, Disable, 360Key2
   Gui, Add, Button, ys gAboutModes, ?
   Gui, Add, Button, gShowSpecialKeys, Special key names
   Gui, -Border
   Gui, Show, Autosize, Add Setting
   Gui, 1: Default
   ActiveRow := A_EventInfo
   LV_GetText(360ButtonName, A_EventInfo)
   SetTimer, CheckActive, 50
}
Else if (A_GuiEvent = "DoubleClick" && (A_EventInfo = 11 || A_EventInfo = 12) ) ; Only do this for RT and LT buttons
{
    Gui, 2: Default
   Gui +Owner
   Gui, Add, Text,, Button Style:
   Gui, Add, Text,, Key(s)
   Gui, Add, DropDownList, r2 ys gEnDisFields vKeyType, Key Push and Hold||Rapid Fire
   Gui, Add, Edit, v360Key1,
   Gui, Add, Edit, v360Key2,
   Gui, Add, Button, Default gSubmitButtonFields, Submit
   Gui, Add, Button, g2GuiClose, Cancel
   GuiControl, Disable, 360Key2
   Gui, Add, Button, ys gAboutModes, ?
   Gui, Add, Button, gShowSpecialKeys, Special key names
   Gui, -Border
   Gui, Show, Autosize, Add Setting
   Gui, 1: Default
   ActiveRow := A_EventInfo
   LV_GetText(360ButtonName, A_EventInfo)
   SetTimer, CheckActive, 50
}
Else if (A_GuiEvent = "DoubleClick" && (A_EventInfo >= 13 && A_EventInfo < 17) ) ; dpad
{
    Gui, 2: Default
   Gui +Owner
   Gui, Add, Text,, Directional Pad Style:
   Gui, Add, Text,, Key(s)
   Gui, Add, DropDownList, r3 ys gEnDisFields vKeyType, KeyPush||Key Push and Hold|
   Gui, Add, Edit, v360Key1,
   Gui, Add, Edit, v360Key2,
   Gui, Add, Button, Default gSubmitButtonFields, Submit
   Gui, Add, Button, g2GuiClose, Cancel
   GuiControl, Disable, 360Key2
   Gui, Add, Button, ys gAboutModes, ?
   Gui, Add, Button, gShowSpecialKeys, Special key names
   Gui, -Border
   Gui, Show, Autosize, Add Setting
   Gui, 1: Default
   ActiveRow := A_EventInfo
   LV_GetText(360ButtonName, A_EventInfo)
   SetTimer, CheckActive, 50
}
Else if (A_GuiEvent = "DoubleClick" && (A_EventInfo >= 17 && A_EventInfo < 21) ) ; left joystick
{
    Gui, 2: Default
   Gui +Owner
   Gui, Add, Text,, Left Joystick Style:
   Gui, Add, Text,, Key(s)
   Gui, Add, DropDownList, r3 ys gEnDisFields vKeyType, KeyPush|Key Push and Hold||Mouse Emulation
   Gui, Add, Edit, v360Key1,
   Gui, Add, Edit, v360Key2,
   Gui, Add, Button, Default gSubmitButtonFields, Submit
   Gui, Add, Button, g2GuiClose, Cancel
   GuiControl, Disable, 360Key2
   Gui, Add, Button, ys gAboutModes, ?
   Gui, Add, Button, gShowSpecialKeys, Special key names
   Gui, -Border
   Gui, Show, Autosize, Add Setting
   Gui, 1: Default
   ActiveRow := A_EventInfo
   LV_GetText(360ButtonName, A_EventInfo)
   SetTimer, CheckActive, 50
}
Else if (A_GuiEvent = "DoubleClick" && (A_EventInfo >= 21 && A_EventInfo < 25) ) ; right joystick
{
    Gui, 2: Default
   Gui +Owner
   Gui, Add, Text,, Right Joystick Style:
   Gui, Add, Text,, Key(s)
   Gui, Add, DropDownList, r3 ys gEnDisFields vKeyType, KeyPush|Key Push and Hold||Mouse Emulation
   Gui, Add, Edit, v360Key1,
   Gui, Add, Edit, v360Key2,
   Gui, Add, Button, Default gSubmitButtonFields, Submit
   Gui, Add, Button, g2GuiClose, Cancel
   GuiControl, Disable, 360Key2
   Gui, Add, Button, ys gAboutModes, ?
   Gui, Add, Button, gShowSpecialKeys, Special key names
   Gui, -Border
   Gui, Show, Autosize, Add Setting
   Gui, 1: Default
   ActiveRow := A_EventInfo
   LV_GetText(360ButtonName, A_EventInfo)
   SetTimer, CheckActive, 50
}

return

; ###################### dpad to key ######################
WatchPOV:
   Loop, 4
   {
   LV_GetText(DPAD%A_Index%KeyMode, 13+(A_Index-1), 2)
   LV_GetText(DPAD%A_Index%Keys, 13+(A_Index-1), 3)
   DPADKey%A_Index% := RegExReplace(DPAD%A_Index%Keys, "^(.*)\(When Pushed\)(.*)", "$1")
   }

GetKeyState, POV, JoyPOV  ; Get position of the POV control.

; Some joysticks might have a smooth/continous POV rather than one in fixed increments.
; To support them all, use a range:
if POV < 0   ; No angle to report
    POVKeyToHoldDown =
else if POV > 31500                 ; 315 to 360 degrees: Forward
    POVKeyToHoldDown = %DPADKey1%
else if POV between 0 and 4500      ; 0 to 45 degrees: Forward
    POVKeyToHoldDown = %DPADKey1%
else if POV between 4501 and 13500  ; 45 to 135 degrees: Right
    POVKeyToHoldDown = %DPADKey3%
else if POV between 13501 and 22500 ; 135 to 225 degrees: Down
    POVKeyToHoldDown = %DPADKey2%
else                                ; 225 to 315 degrees: Left
    POVKeyToHoldDown = %DPADKey4%

If (POVKeyToHoldDown)
{
SendInput, %POVKeyToHoldDown%
Sleep 300
}
return

; ###################### Analog to key ######################
WatchAxis:
Loop, 8
{
LV_GetText(RKs2, 17+(A_Index-1), 3)
   If (RKs2 != "MOUSE" || RKs2 != "")
   {
      LV_GetText(JoystickSide2, 17+(A_Index-1))
      If (RegExMatch(JoystickSide2, "^Right Joystick"))
         AxisSet2 := "U|R"
      Else If (RegExMatch(JoystickSide2, "^Left Joystick"))
         AxisSet2 := "X|Y"
      
      Break
   }
   
If (A_index = 8)
   AxisSet2 := ""
}
If (!AxisSet2) ; Determines if there is nothing assigned to mouse emulation
   return
Loop, Parse, AxisSet2, | ; If there is this breaks the axis' up
   Axis%A_Index% := A_LoopField

If (AxisSet2 == "X|Y")
{
   Loop, 4
   {
   LV_GetText(Joy%A_Index%KeyMode, 17+(A_Index-1), 2)
   LV_GetText(Joy%A_Index%Keys, 17+(A_Index-1), 3)
   JoyKey%A_Index% := RegExReplace(Joy%A_Index%Keys, "^(.*)\(When Pushed\)(.*)", "$1")
   }
}
Else If (AxisSet2 == "U|R")
{
   Loop, 4
   {
   LV_GetText(Joy%A_Index%KeyMode, 21+(A_Index-1), 2)
   LV_GetText(Joy%A_Index%Keys, 21+(A_Index-1), 3)
   JoyKey%A_Index% := RegExReplace(Joy%A_Index%Keys, "^(.*)\(When Pushed\)(.*)", "$1")
   }
}

GetKeyState, JoyX, Joy%Axis1%  ; Get position of X axis.
GetKeyState, JoyY, Joy%Axis2%  ; Get position of Y axis.
KeyToHoldDownPrev = %KeyToHoldDown%  ; Prev now holds the key that was down before (if any).

if (JoyX > 50+JoyThreshold)
    KeyToHoldDown = %JoyKey1%
else if (JoyX < 50-JoyThreshold)
    KeyToHoldDown = %JoyKey2%
else if (JoyY > 50+JoyThreshold)
    KeyToHoldDown = %JoyKey4%
else if (JoyY < 50-JoyThreshold)
    KeyToHoldDown = %JoyKey3%
else
    KeyToHoldDown =

if KeyToHoldDown = %KeyToHoldDownPrev%  ; The correct key is already down (or no key is needed).
    return  ; Do nothing.

; Otherwise, release the previous key and press down the new key:
SetKeyDelay -1  ; Avoid delays between keystrokes.
if KeyToHoldDownPrev   ; There is a previous key to release.
    Send, {%KeyToHoldDownPrev% up}  ; Release it.
if KeyToHoldDown   ; There is a key to press down.
    Send, {%KeyToHoldDown% down}  ; Press it down.

return


; ###################### Converts a joystick to mouse movement ######################
JoyToMouse:
Loop, 8
{
LV_GetText(RKs, 17+(A_Index-1), 3)
   If (RKs == "MOUSE")
   {
      LV_GetText(JoystickSide, 17+(A_Index-1))
      If (RegExMatch(JoystickSide, "^Right Joystick"))
         AxisSet := "U|R"
      Else If (RegExMatch(JoystickSide, "^Left Joystick"))
         AxisSet := "X|Y"
      
      Break
   }
   
If (A_index = 8)
   AxisSet := ""
}

If (!AxisSet) ; Determines if there is nothing assigned to mouse emulation
   return
Loop, Parse, AxisSet, | ; If there is this breaks the axis' up
   %A_Index%Axis := A_LoopField

MouseNeedsToBeMoved := false  ; Set default.
SetFormat, float, 03
GetKeyState, joyx, %JoystickNumber%Joy%1Axis%
GetKeyState, joyy, %JoystickNumber%Joy%2Axis%
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

; ###################### Destroys the GUI if it is not active ######################
CheckActive: 
IfWinNotActive, Add Setting ahk_class AutoHotkeyGUI
   {
   Gui, 2: Destroy
   SetTimer, CheckActive, off
   }
return

; ###################### Information about the key modes ###############################
AboutModes:
MsgBox, 64, Mode information, Key Push - Pushes the designated key one time`n`nKey Push and Hold - Pushes the designated key then waits 400 milliseconds and then continues pressing the key every 50 milliseconds until release`n`nDual Key Push and Hold - Pushes the designed first key then waits 400 milliseconds and holds the next key until release`n`nHold Key Until Release - Holds the key until release`n`nRapid Fire - For automatically clicking a button quickly while it is held.`n`nMouse Emulation - Makes the joystick emulate mouse movement
return

; ###################### Information on key remappings ###############################
ShowSpecialKeys:
MsgBox, 64, Special Keys, You will now be redirected to the AutoHotkey documentation key list.
Run, http://www.autohotkey.com/docs/KeyList.htm
return

; ###################### Submit new key set ###############################
SubmitButtonFields:
Gui, 2: Submit
Gui, 2: Destroy
If (KeyType == "Mouse Emulation") ; makes the desired joystick a mouse emulation
{
   If (ActiveRow >= 21 && ActiveRow < 25) ; Right
   {
      Loop, 4
      {
      Gui, 1: Default
      LV_GetText(360ButtonName, 21+(A_Index-1))
      LV_Modify(21+(A_Index-1), "", 360ButtonName, KeyType, "MOUSE")
      }
   }
   Else If (ActiveRow >= 17 && ActiveRow < 21) ; Left
   {
      Loop, 4
      {
      Gui, 1: Default
      LV_GetText(360ButtonName, 17+(A_Index-1))
      LV_Modify(17+(A_Index-1), "", 360ButtonName, KeyType, "MOUSE")
      }
   }
      
      goto, Done ; Skip key inputting
}
If (!360Key1) ; Check the first key
   KeySet := "- Blank -"
else
   KeySet := 360Key1 "(When Pushed)"

If (360Key2) ; Check second key
   KeySet .= " and " 360Key2 "(While Held)"

Gui, 1: Default ; Add the items
LV_Modify(ActiveRow, "", 360ButtonName, KeyType, KeySet)

Done:
KeySet := "" ; clear variables
360Key1 := ""
360Key2 := ""
KeyType := ""
return

; ###################### Enable/Disable key fields based on the type of key mode ###############################
EnDisFields:
Gui, 2: Default
Gui, Submit, Nohide
If (KeyType == "Key Push" || KeyType == "Key Push and Hold" || KeyType == "Hold Key Until Release")
{
   GuiControl,, 360Key2,
   GuiControl, Disable, 360Key2
}
Else If (KeyType == "Dual Key Push and Hold")
{
   GuiControl, Enable, 360Key2
}
Gui, 1: Default
return

; ###################### Handdles the button pressing ###############################
JoyButtonHandler:
Gui, 1: Default
StringTrimLeft, JoyNumber, A_ThisHotkey, 3
LV_GetText(KeyMode, JoyNumber, 2)
LV_GetText(Keys, JoyNumber, 3)
Key1 := RegExReplace(Keys, "^(.*)\(When Pushed\)(.*)", "$1")
If (RegExMatch(Keys, "^(.*)and (.*)\(While Held\)"))
   Key2 := RegExReplace(Keys, "^(.*)and (.*)\(While Held\)", "$2")
If (KeyMode == "" || Keys == "" || Keys == "- Blank -")
   return

;~ MsgBox % Key2
If (KeyMode == "Key Push")
   SendInput, {%Key1%}
Else if (KeyMode == "Key Push and Hold")
   PushHold(Key1)
Else if (KeyMode == "Dual Key Push and Hold")
   DualKeyHold(Key1, Key2)
Else if (KeyMode == "Hold Key Until Release")
   HoldKeyUntilRelease(Key1)
Else if (KeyMode == "Rapid Fire")
   RapidFire(Key1)
return

; ###################### For cancel button on 2nd GUI ###############################
2GuiClose:
Gui, 2: Destroy
return

GuiClose:
ExitApp

; ######################## Unhides GUI if you click on the tray icon #################
Unhide:
Gui, 1: Default
Gui, Show, Autosize
return


; ##################################### Functions ######################################
; $$$$$$$$$$$$$$$$$$$ FUNCTION TO KEEP KEY PUSHED UNTIL I RELEASE IT $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
; Remap key = key to push with keyboard/mouse (including {} brackets if needed). Intial delay = delay before the key continues to be sent. Delay = Delay between each send key after initial delay if you hold the joy button.
PushHold(RemapKey, InitialDelay=400, Delay=50)
{ 
   SendInput, %RemapKey%
   Sleep %InitialDelay%
      while (GetKeyState(A_ThisHotkey, "P"))
      {
      SendInput, {%RemapKey%}
      Sleep %Delay%
      }
   return
}
; $$$$$$$$$$ Rapid fire function to turn an button into an automaic button press $$$$$$$$$$$$$$
RapidFire( rapidfirekey ){
While (GetKeyState(A_ThisHotkey, "P"))
   {
   SendInput, {%rapidfirekey%
   Sleep, 10
   }
}

; $$$$$$$$$$ FUNCTION FOR KEYS THAT NEED MULTIPLE USES $$$$$$$$$$$$$$
DualKeyHold(FirstKey, SecondKey, DelayBetweenKeys=400){
   SendInput, {%FirstKey%}
   Sleep %DelayBetweenKeys%
   If (GetKeyState(A_ThisHotkey, "P"))
      {
      SendInput, {%SecondKey% DOWN}
      Keywait, %A_ThisHotkey%
      SendInput, {%SecondKey% Up}
      }
      return
}

; $$$$$$$$$$$$$ HOLDS THE KEY UNTIL THE BUTTON IS RELEASED
HoldKeyUntilRelease(KeyToHold){
   SendInput, {%KeyToHold% down}
   KeyWait, %A_ThisHotkey%
   SendInput, {%KeyToHold% up}
}

; $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$  FUNCTION TO GET LT/RT STATES $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
GetTriggerState(ByRef LT, ByRef RT){
    Gui, 1: Default
    Gui, Submit, Nohide
    global RTV, LTV ; get the checkbox variables
    Loop, 4 {
        if XInput_GetState(A_Index-1, State)=0 {
            LT := json(State,"bLeftTrigger")
            RT := json(State,"bRightTrigger")
            XInput_SetState(A_Index-1, LT*257*LTV, RT*257*RTV) ; Vibrates for checked boxes
            
        }
    }
   Return
}

; ############################## Additional needed scripts (I did not design these. See the top for info.) ####################

; ################## json.ahk #########################

/*
   Function: JSON

   Parameters:
      js - source
      s - path to element
      v - (optional) value to overwrite

   Returns:
      Value of element (prior to change).

   License:
      - Version 2.0 <http://www.autohotkey.net/~polyethene/#json>
      - Dedicated to the public domain <http://creativecommons.org/licenses/publicdomain/>
*/
json(ByRef js, s, v = "") {
   j = %js%
   Loop, Parse, s, .
   {
      p = 2
      RegExMatch(A_LoopField, "([+\-]?)([^[]+)((?:\[\d+\])*)", q)
      Loop {
         If (!p := RegExMatch(j, "(?<!\\)(""|')([^\1]+?)(?<!\\)(?-1)\s*:\s*((\{(?:[^{}]++|(?-1))*\})|(\[(?:[^[\]]++|(?-1))*\])|"
            . "(?<!\\)(""|')[^\7]*?(?<!\\)(?-1)|[+\-]?\d+(?:\.\d*)?|true|false|null?)\s*(?:,|$|\})", x, p))
            Return
         Else If (x2 == q2 or q2 == "*") {
            j = %x3%
            z += p + StrLen(x2) - 2
            If (q3 != "" and InStr(j, "[") == 1) {
               StringTrimRight, q3, q3, 1
               Loop, Parse, q3, ], [
               {
                  z += 1 + RegExMatch(SubStr(j, 2, -1), "^(?:\s*((\[(?:[^[\]]++|(?-1))*\])|(\{(?:[^{\}]++|(?-1))*\})|[^,]*?)\s*(?:,|$)){" . SubStr(A_LoopField, 1) + 1 . "}", x)
                  j = %x1%
               }
            }
            Break
         }
         Else p += StrLen(x)
      }
   }
   If v !=
   {
      vs = "
      If (RegExMatch(v, "^\s*(?:""|')*\s*([+\-]?\d+(?:\.\d*)?|true|false|null?)\s*(?:""|')*\s*$", vx)
         and (vx1 + 0 or vx1 == 0 or vx1 == "true" or vx1 == "false" or vx1 == "null" or vx1 == "nul"))
         vs := "", v := vx1
      StringReplace, v, v, ", \", All
      js := SubStr(js, 1, z := RegExMatch(js, ":\s*", zx, z) + StrLen(zx) - 1) . vs . v . vs . SubStr(js, z + StrLen(x3) + 1)
   }
   Return, j == "false" ? 0 : j == "true" ? 1 : j == "null" or j == "nul"
      ? "" : SubStr(j, 1, 1) == """" ? SubStr(j, 2, -1) : j
}

; ########################## XInput.ahk ################################
/*
    Function: XInput_Init
    
    Initializes XInput.ahk with the given XInput DLL.
    
    Parameters:
        dll     -   The path or name of the XInput DLL to load.
*/
XInput_Init(dll="xinput1_3")
{
    global
    if _XInput_hm
        return
    
    ;======== CONSTANTS DEFINED IN XINPUT.H ========
    
    ; NOTE: These are based on my outdated copy of the DirectX SDK.
    ;       Newer versions of XInput may require additional constants.
    
    ; Device types available in XINPUT_CAPABILITIES
    XINPUT_DEVTYPE_GAMEPAD          = 0x01

    ; Device subtypes available in XINPUT_CAPABILITIES
    XINPUT_DEVSUBTYPE_GAMEPAD       = 0x01

    ; Flags for XINPUT_CAPABILITIES
    XINPUT_CAPS_VOICE_SUPPORTED     = 0x0004

    ; Constants for gamepad buttons
    XINPUT_GAMEPAD_DPAD_UP          = 0x0001
    XINPUT_GAMEPAD_DPAD_DOWN        = 0x0002
    XINPUT_GAMEPAD_DPAD_LEFT        = 0x0004
    XINPUT_GAMEPAD_DPAD_RIGHT       = 0x0008
    XINPUT_GAMEPAD_START            = 0x0010
    XINPUT_GAMEPAD_BACK             = 0x0020
    XINPUT_GAMEPAD_LEFT_THUMB       = 0x0040
    XINPUT_GAMEPAD_RIGHT_THUMB      = 0x0080
    XINPUT_GAMEPAD_LEFT_SHOULDER    = 0x0100
    XINPUT_GAMEPAD_RIGHT_SHOULDER   = 0x0200
    XINPUT_GAMEPAD_A                = 0x1000
    XINPUT_GAMEPAD_B                = 0x2000
    XINPUT_GAMEPAD_X                = 0x4000
    XINPUT_GAMEPAD_Y                = 0x8000

    ; Gamepad thresholds
    XINPUT_GAMEPAD_LEFT_THUMB_DEADZONE  = 7849
    XINPUT_GAMEPAD_RIGHT_THUMB_DEADZONE = 8689
    XINPUT_GAMEPAD_TRIGGER_THRESHOLD    = 30

    ; Flags to pass to XInputGetCapabilities
    XINPUT_FLAG_GAMEPAD             = 0x00000001
    
    ;=============== END CONSTANTS =================
    
    _XInput_hm := DllCall("LoadLibrary" ,"str",dll)
    
    if !_XInput_hm
    {
        MsgBox, Failed to initialize XInput: %dll%.dll not found.
        return
    }
    
    ;_XInput_GetState        := DllCall("GetProcAddress" ,"uint",_XInput_hm ,"str","XInputGetState")
    ;_XInput_SetState        := DllCall("GetProcAddress" ,"uint",_XInput_hm ,"str","XInputSetState")
    ;_XInput_GetCapabilities := DllCall("GetProcAddress" ,"uint",_XInput_hm ,"str","XInputGetCapabilities")
	;; 64-bit support
	_XInput_GetState        := DllCall("GetProcAddress" ,"uint",_XInput_hm ,"AStr","XInputGetState")
	_XInput_SetState        := DllCall("GetProcAddress" ,"uint",_XInput_hm ,"AStr","XInputSetState")
	_XInput_GetCapabilities := DllCall("GetProcAddress" ,"uint",_XInput_hm ,"AStr","XInputGetCapabilities")
    
    if !(_XInput_GetState && _XInput_SetState && _XInput_GetCapabilities)
    {
        XInput_Term()
        MsgBox, Failed to initialize XInput: function not found.
        return
    }
}

/*
    Function: XInput_GetState
    
    Retrieves the current state of the specified controller.

    Parameters:
        UserIndex   -   [in] Index of the user's controller. Can be a value from 0 to 3.
        State       -   [out] Receives the current state of the controller.
    
    Returns:
        If the function succeeds, the return value is ERROR_SUCCESS (zero).
        If the controller is not connected, the return value is ERROR_DEVICE_NOT_CONNECTED (1167).
        If the function fails, the return value is an error code defined in Winerror.h.
            http://msdn.microsoft.com/en-us/library/ms681381.aspx

    Remarks:
        XInput.dll returns controller state as a binary structure:
            http://msdn.microsoft.com/en-us/library/bb174834.aspx
        XInput.ahk converts this structure to a string, compatible with Titan's json():
            http://www.autohotkey.com/forum/topic34565.html
*/
XInput_GetState(UserIndex, ByRef State)
{
    global _XInput_GetState
    
    VarSetCapacity(xiState,16)
    
    if ErrorLevel := DllCall(_XInput_GetState ,"uint",UserIndex ,"uint",&xiState)
        State =
    else
        State := "{
        ( C LTrim Join
            'dwPacketNumber':" NumGet(xiState,0) ",
            ;   Seems less convenient - though more technically accurate - to require
            ;   "Gamepad." prefix to access any of the useful properties with json().
            ;'Gamepad':{
                'wButtons':" NumGet(xiState,4,"UShort") ",
                'bLeftTrigger':" NumGet(xiState,6,"UChar") ",
                'bRightTrigger':" NumGet(xiState,7,"UChar") ",
                'sThumbLX':" NumGet(xiState,8,"Short") ",
                'sThumbLY':" NumGet(xiState,10,"Short") ",
                'sThumbRX':" NumGet(xiState,12,"Short") ",
                'sThumbRY':" NumGet(xiState,14,"Short") "
            ;}
        )}"
    
    return ErrorLevel
}

/*
    Function: XInput_SetState
    
    Sends data to a connected controller. This function is used to activate the vibration
    function of a controller.
    
    Parameters:
        UserIndex       -   [in] Index of the user's controller. Can be a value from 0 to 3.
        LeftMotorSpeed  -   [in] Speed of the left motor, between 0 and 65535.
        RightMotorSpeed -   [in] Speed of the right motor, between 0 and 65535.
    
    Returns:
        If the function succeeds, the return value is 0 (ERROR_SUCCESS).
        If the controller is not connected, the return value is 1167 (ERROR_DEVICE_NOT_CONNECTED).
        If the function fails, the return value is an error code defined in Winerror.h.
            http://msdn.microsoft.com/en-us/library/ms681381.aspx
    
    Remarks:
        The left motor is the low-frequency rumble motor. The right motor is the
        high-frequency rumble motor. The two motors are not the same, and they create
        different vibration effects.
*/
XInput_SetState(UserIndex, LeftMotorSpeed, RightMotorSpeed)
{
    global _XInput_SetState
    return DllCall(_XInput_SetState ,"uint",UserIndex ,"uint*",LeftMotorSpeed|RightMotorSpeed<<16)
}

/*
    Function: XInput_GetCapabilities
    
    Retrieves the capabilities and features of a connected controller.
    
    Parameters:
        UserIndex   -   [in] Index of the user's controller. Can be a value in the range 0–3.
        Flags       -   [in] Input flags that identify the controller type.
                                0   - All controllers.
                                1   - XINPUT_FLAG_GAMEPAD: Xbox 360 Controllers only.
        Caps        -   [out] Receives the controller capabilities.
    
    Returns:
        If the function succeeds, the return value is 0 (ERROR_SUCCESS).
        If the controller is not connected, the return value is 1167 (ERROR_DEVICE_NOT_CONNECTED).
        If the function fails, the return value is an error code defined in Winerror.h.
            http://msdn.microsoft.com/en-us/library/ms681381.aspx
*/
XInput_GetCapabilities(UserIndex, Flags, ByRef Caps)
{
    global _XInput_GetCapabilities
    
    VarSetCapacity(xiCaps,20)
    
    if ErrorLevel := DllCall(_XInput_GetCapabilities ,"uint",UserIndex ,"uint",Flags ,"uint",&xiCaps)
        Caps =
    else
        Caps := "{
        ( LTrim Join
            'Type':" NumGet(xiCaps,0,"UChar") ",
            'SubType':" NumGet(xiCaps,1,"UChar") ",
            'Flags':" NumGet(xiCaps,2,"UShort") ",
            'Gamepad':{
                'wButtons':" NumGet(xiCaps,4,"UShort") ",
                'bLeftTrigger':" NumGet(xiCaps,6,"UChar") ",
                'bRightTrigger':" NumGet(xiCaps,7,"UChar") ",
                'sThumbLX':" NumGet(xiCaps,8,"Short") ",
                'sThumbLY':" NumGet(xiCaps,10,"Short") ",
                'sThumbRX':" NumGet(xiCaps,12,"Short") ",
                'sThumbRY':" NumGet(xiCaps,14,"Short") "
            },
            'Vibration':{
                'wLeftMotorSpeed':" NumGet(xiCaps,16,"UShort") ",
                'wRightMotorSpeed':" NumGet(xiCaps,18,"UShort") "
            }
        )}"
    
    return ErrorLevel
}

/*
    Function: XInput_Term
    Unloads the previously loaded XInput DLL.
*/
XInput_Term() {
    global
    if _XInput_hm
        DllCall("FreeLibrary","uint",_XInput_hm), _XInput_hm :=_XInput_GetState :=_XInput_SetState :=_XInput_GetCapabilities :=0
}

; TODO: XInputEnable, 'GetBatteryInformation and 'GetKeystroke.