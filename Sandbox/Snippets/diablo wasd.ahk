/*

                                                                                                        WASD TEST SCRIPT
                                                                        Authors: Ever1ast, Jared Sigley aka Yelgis, Soda
                                                                                        Based on code by Desi Quintans

Description:

This script enables traditional WASD movements for Diablo III. 

The default keys are:
North - W
West - A
South - S
East - D

The keys can be combined to produce a total of 8 directions (4 ordinal and 4 diagonal). The directions are relative to the 
screen, meaning north is moving towards the top of the screen, west is moving towards the left of the screen, and so on.



Use Instructions:
1) Run this script with AutoHotKey
2) Start Diablo III within 60 seconds of step 1
3) If this is your first time running this script remove bindings for the "W" "A" "S" and "D" keys in Diablo III. If any 
        action is bound to one of the keys used for movement by this script the action would be performed in addition to the 
        movement. Keep in mind if you edit this script to use another keyset the same rule applies to those keys
4) Bind the F12 key on your keyboard to the Move action.

NOTE:
If you change the resolution of the game at any point after running the script, you must reload the script for it to function properly

*/



#NoEnv                                                  ; Prevents bugs caused by environmental variables matching those in the script
#Persistent                                             ; Allows the script to stay active and makes it single-instance
#MaxHotkeysPerInterval, 200      ; Safeguard to prevent accidental infinite-looping of events
SendMode Input                                  ; Avoids the possible limitations of SendMode Play, increases reliability.
SetWorkingDir %A_ScriptDir%      ; Sets the script's working directory
SetDefaultMouseSpeed, 0          ; For character movement without moving the cursor
SetTitleMatchMode, 3                    ; Window title must exactly match Winactive("Diablo III")



; BEGIN config section -- you can change the variables below to your specific needs

mkey = F12                      ; key bound to Move command in game
y_offset = 10           ; distance from character to issue move command on the y-axis (used to calculate the x_offset to maintain aspect ratios)

; END config section

OnExit, Agent_Kill

WinWaitActive, Diablo III, , 60         ; this command waits for Diablo III to be the active window to get window information
if ErrorLevel
{
        MsgBox, Diablo III not started within the allotted time. Please run the script again then start Diablo III
        ExitApp
}
else
{
                Sleep 500
                WinGetPos, win_x, win_y, width, height, A
                x_center := win_x + width / 2
                compensation := (width / height) == (16 / 10) ? 1.063829 : 1.063711
                y_center := win_y + height / 2 / compensation
                offset_mod := y_offset / height
                x_offset := width * offset_mod
                                
}

SetTimer, WASD_Handler, 10
return



Agent_Kill:             ; kills Agent.exe if it is still running after Diablo and the script close
        if !WinExist("Diablo III")
        {
                Process, Close, Agent.exe 
        }
        ExitApp
return



WASD_Handler:
        if !WinActive("Diablo III") 
        {
                if !WinExist("Diablo III")              ; closes the script down if Diablo is no longer running
                {       
                        ExitApp
                }
                return
        }


        
        if GetKeyState("Shift", "P")            ; this if/loop lets Shift still function as a stand still key
        {
                Loop
                {
                        GetKeyState, state, Shift, P
                        if state = U  
                        break                           
                }
        }
        else if GetKeyState("w", "P") || GetKeyState("s", "P") || GetKeyState("a", "P") || GetKeyState("d", "P")
        {
                if GetKeyState("w", "P")
                {
                        y_final := y_center - y_offset
                }
                else if GetKeyState("s", "P")
                {
                        y_final := y_center + y_offset
                }
                else
                {
                        y_final := y_center
                }
                                
                if GetKeyState("a", "P")
                {
                        x_final := x_center - x_offset
                }
                else if GetKeyState("d", "P")
                {
                        x_final := x_center + x_offset
                }
                else
                {
                        x_final := x_center
                }
                
                MouseGetPos, x_initial, y_initial
                MouseMove, %x_final%, %y_final%, 0                      
                Send {%mkey%}
                MouseMove, %x_initial%, %y_initial%, 0
        }
        
        
        
return


; Copyright (c) 2012, Ever1ast, Jared Sigley aka Yelgis, Soda
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without modification, are permitted provided 
; that the following conditions are met:
;
; - Redistributions of source code must retain the above copyright notice, this list of conditions and the ;   following disclaimer.
; - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the ;   following disclaimer in the documentation and/or other materials provided with the distribution.
;
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED ; WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
; PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR 
; ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED 
; TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
; HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING 
; NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
; POSSIBILITY OF SUCH DAMAGE.