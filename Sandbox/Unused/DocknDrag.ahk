#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#WinActivateForce
#SingleInstance force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode, 2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
; 'Dock'nDrag'
; By David Tong 03-02-2009.
;
; Primary Functions:
;  1. CapsLock+left-drag from the central rectangle to move a window without resizing it.
;  2. CapsLock+left-drag a window by corner or side to resize it. Select either '‘Easy Window 
;     Dragging' or 'NiftyWindows' modes of dragging and resizing.  
;  3. CapsLock+rightclick in centre of the strip along an edge to 'dock' a nearby window to it
;     Afterwards both windows move or resize as one. Do the same in centre of either window
;     to uncouple. [Great for using a Help window at same time as AHK ScITE editor].
;  4. Works with multiple monitors. Boundary limits ensure a coupled window is not stranded on 
;     a non-existent monitor. 
;  5. Max width (height) of a coupled window is that of the monitor. Minimum for either partner 
;     is set by a parameter.
;  6. When stretching a window in any direction, after it reaches maximum size the whole 
;     window starts moving. This is more ergonomic than EWD or NiftyW which do this only when
;     pulling up or to the left, but not down or to the right.
;  7. Supports multiple monitors and ensures partnered window is not accidentally left 
;     stranded on a non-existent monitor.
;  8. Tested in XP and Vista. 

;  Extra Functions:
;  1. CapsLock+Leftclick in left-hand side of title bar of Windows Explorer closes it and opens 
;     same folder in Directory Opus. (Useful because Picasa and Copernic Desktop Search 
;     don't respect default browser settings).
;  2.  Keeps CapsLock off to avoid typing in caps by mistake. [No longer done as standard]
;  3.  As a precaution while testing I included CapsLock+RControl as a hotkey to force an exit
;      if the script becomes unresponsive but with CapsLock activated.

; Acknowledgements: 
; Basic window dragging functions inspired by ‘Easy Window Dragging - KDE style’ 
; by Jonny, and NiftyWindows (both in Script Showcase) and similar variants. 
; I cribbed lots of code from the many great scripts on the AHK forum, in particular
; WindowPad by Lexikos. Most thanks of all of course to Chris M. for developing 
; AutoHotkey in the first place.

SetBatchLines , 20ms ; If too low, non-dragged windows take too long to redraw.
SetWinDelay , 10     ; If too low the dragged window leaves too much of a trail.

#NoEnv
SendMode Input  
SetWorkingDir %A_ScriptDir%
#NoTrayIcon 
#SingleInstance , ;ignore

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set up user options:
;
; Define minimum width limit for windows.
   MinDimx := 200   ;Min window width  
   MinDimy := 200   ;Min window height

; Define the criterion for selecting a partner window when coupling two together.
; In all cases only visible windows on the same monitor are selected, and only those 
; whose centres are on the same side of target centre as the side of target that 
; you click on.
;
;     'Area' chooses the window with greatest area.
;   'Centre' chooses the window whose centre is nearest to the centre of target window.
;   'Edge' [recommended] Selects the one whose edge-to-be-shared is nearest to the 
;   edge you clicked.

   Criterion := edge   
    
; If DragMode=1, each edge has three clickable sections allowing dragging by side or corner
; like on a normal window.  (Same mode as used in NiftyWindows).
; If DragMode<>1, four clickable quadrants giving corner-dragging modes only as in ‘Easy 
; Window Dragging - KDE style’.
    
    DragMode = 1  ; set to 1 or 0 (or blank) as desired
    
; Define the hotkeys:

    Modifier := "CapsLock `& " ; Other examples: "!", "+", "Insert `& ", etc.
    DragButton := "LButton"
    DockButton := "RButton"
    EmergencyButton := "RControl"

; End of user setup section
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;
; Might want to alter the next two lines and CheckCapslock: if using Insert, ScrollLock, etc
IfInString , Modifier, CapsLock 
        Settimer, CheckCapslock, 200
        
FullDragButton = %Modifier%%DragButton%
FullDockButton = %Modifier%%DockButton%
FullEmergencyButton = %Modifier%%EmergencyButton%

Hotkey , %FullDragButton% , Resizer
Hotkey , %FullDockButton% , WinDock
Hotkey , %FullEmergencyButton% , Finish
Return

;;;;;;;;;;;;;;;;;;;;
Finish:  ; Used for emergency exit if script stalls with CapsLock activated.Gosub , CheckCapslock
Gosub , CheckCapslock
SoundBeep 2000, 500
ExitApp
;;;;;;;;;;;;;;;;;
; Make sure Capslock is not left in an activated state.
CheckCapslock:
GetKeyState , caps , CapsLock , T ; 'D' means key is 'on', 'U' means 'off'.
IfEqual , caps , D
   {
      sleep 20      ; used to use 100
      SetCapsLockState , OFF    
   }
Return
;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
; Combines two windows as a pair so they can be moved and resized as one.
;
WinDock: 
; Action depends on which of the nine cells (in a 3x3 grid) you clicked in.
; Top left-hand cell is row 1, column 1. Bottom right is 3,3.
;    -----------------
;   | 1,1 | 1,2 | 1,3 |
;    -----------------
;   | 2,1 | 2,1 | 2,3 |
;    -----------------
;   | 3,1 | 3,2 | 3,3 |
;    -----------------

; Click in cell:
;   1,2 to couple another window to top edge.
;   3,2 to couple another window to bottom edge.
;   2,1 to couple another window to lefthand edge.
;   2,3 to couple another window to righthand edge.
;   2,2 to uncouple a coupled pair.
;   1,1 and within title bar of Windows Explorer to close Explorer and open
;       same folder in Directory Opus.

CoordMode , Mouse , Screen   
MouseGetPos ,xx , yy , ID1, Ctrl, 1   ; defines window that you clicked in

; Next command required else first right-click on desktop gives 
; context menu with some items missing (those for Directory Opus).
WinActivate , ahk_id %ID1%  

;  Ignore clicks on desktop
WinGetClass , clss, ahk_id %ID1%
If clss = Progman   
    Return
Gosub , ClearContextPopup  ; Clear unwanted right-click pop-up menus

; Find which cell in the target window was clicked in.
Get_Cell(Column,Row)  


; Store a shortlist of acceptable windows in Item1, Item2, etc
WinGetPos , My_x, My_y, My_w, My_h , ahk_id %ID1%  ;details for current window
My_mon := GetMonitorAt(My_x+My_w/2, My_y+My_h/2) ; Using which monitor?
Gosub , CalcMonStats    ; loads My_monRight, etc
GoSub, Sort           

; Do work as defined by the cell. 

; LatVert = +1 defines lateral coupling, +1 defines vertical (also used in Resizer).
; LftRght = +1 for coupling to right (or up) and -1 for left (or down)

If (Column=1 and Row=1)
{
    If IsOverTitleBar(xx, yy, ID1)
        Gosub, DoExplorer
}
Else If (Row=2 and Column=2) 
{
    If (ID1 = Master) or (ID1 = Slave)
        Gosub, UnCouple
    Return
}
Else If (Column=1 and Row=2)
{
    LatVert := 1                        ; lateral
    LftRght := -1                       ; to left
    Winid := FindWin(LatVert, LftRght)  ; returns selected id from the list.
    IfEqual , Winid ,, Return           ; skip if no suitable window
    Gosub , Coupled                     ; announce coupled state
   
   ; Master - leave gap for partner and extend other edge to monitor limit
    newmx := My_x
    If (My_x < (My_monLeft+MinDimx))      ;NB outer brackets are essential here!
        newmx := My_monLeft+MinDimx   
    newmw := My_monRight-newmx  

    ; Partner - move to gap and match height to Master. 
    newpx := My_monLeft
    newpw := Newmx-My_monLeft  
    WinMove , ahk_id %Master% ,, %newmx% ,, %newmw% ,  
    WinMove , ahk_id %Winid% ,, %newpx% ,My_y, %newpw% , My_h  
    Return
}
Else If (Column=3 and Row=2)
{
    LatVert := 1                        ; lateral  
    LftRght := 1                        ; to right
    Winid := FindWin(LatVert, LftRght)  ; returns selected id from the list.
    IfEqual , Winid ,, Return           ; skip if no suitable window
    Gosub , Coupled                     ; announce coupled state
    
   ; Master - leave gap for partner and extend other edge to monitor limit
    newmx := My_monLeft
    newmw := My_w+(My_x-My_monLeft)  
    If (My_monRight-(My_x+My_w)) < MinDimx 
        newmw := MaxDimx-MinDimx
        
    ; Move Partner into gap and match height to Master. 
    newpx := My_monLeft+newmw     ; newmw value on right refers to main window
    newpw := MaxDimx-newmw    ; same here
    WinMove , ahk_id %Master% ,, %newmx% ,, %newmw% , 
    WinMove , ahk_id %Slave% ,, %newpx% , My_y, %newpw% ,My_h  
    return
}
Else If (Row=1 and Column=2) 
{
    LatVert := -1                       ; vertical 
    LftRght := +1                       ; upward 
    Winid := FindWin(LatVert, LftRght)  ; returns selected id from the list.
    IfEqual , Winid ,, Return           ; skip if no suitable window
    Gosub , Coupled                     ; announce coupled state
   
   ; Master - leave gap for partner and extend other edge to monitor limit
    newmy := My_y
    If (My_y<MinDimy)
        newmy := MinDimy   
    newmh := MaxDimy-newmy 
    
    ; Move Partner into gap and match height to Master. 
    newpy := My_monTop
    newph := MaxDimy-newmh
    WinMove , ahk_id %Master% ,,  ,%newmy%,  , %newmh% 
    WinMove , ahk_id %Slave% ,,%My_x%,%newpy%, %My_w% ,%newph%  
    Return
}
Else If (Row=3 and Column=2) 
{
    LatVert := -1                       ; vertical
    LftRght := -1                       ; downward
    Winid := FindWin(LatVert, LftRght)  ; returns selected id from the list.
    IfEqual , Winid ,, Return           ; skip if no suitable window
    Gosub , Coupled                     ; announce coupled state

    ; Master - leave gap for partner and extend other edge to monitor limit
    newmy := My_monTop
    newmh := My_h+ My_y        
    If (MaxDimy-newmh)<MinDimy
        newmh := MaxDimy- MinDimy  
        
    ; Move Partner into gap and match height to Master. 
    newpy := -(My_monTop - newmh)     
    newph := MaxDimy-newmh
    WinMove , ahk_id %Master% ,,  ,%newmy%,  , %newmh% 
    WinMove , ahk_id %Slave% ,,%My_x%,%newpy%, %My_w% ,%newph%  
    Return
}
Return
;;;;;;;;;;

;;;;;;;;;;
; Clears spurious Right-Click menus
;
;  Not so easy to find a method that works with all windows. For example, 
;  sending 'ControlSend,,{ESC}, ahk_id %ID1%' to Word2003 makes it crash. 
;  This seems ok with everything so far: 
;
ClearContextPopup:
WinActivate , ahk_id %ID1%  
WinWaitActive , ahk_id %ID1% 
sleep ,100
send , {alt}
sleep ,100
send , {esc}
Return
;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;
; Closes an open Explorer window and re-opens same folder in DOpus as a new tab.  
; (Useful with Picasa and Copernic which insist on using Explorer instead of DOpus).

DoExplorer:
WinGet, Prcs , ProcessName, ahk_id %ID1%
WinGetTitle , Ttle, ahk_id %ID1%
If Prcs contains explorer
{
    Ttle1 = "%Ttle%" ; DOpus command line wants it in quotes
    run , "C:\Program Files\GPSoftware\Directory Opus\dopusrt.exe" /CMD Go %Ttle1% Newtab
    WinClose , ahk_id %ID1%
}
Return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;
; Get work area (excludes taskbar-reserved space).
; Copied from WindowPad. Modified to suit DAT work area
CalcMonStats:
; Get work area less a guard-band to minimise accidental triggering of
; popup toolbars on three sides of main monitor
SysGet, My_mon, MonitorWorkArea, %My_mon%
IfEqual , My_mon , 1
{
    My_monRight := My_monRight  ;- 25
    My_monTop := My_monTop      ;+ 25
    My_monLeft := My_monLeft    ;+ 25
}
MaxDimx  := My_monRight - My_monLeft
MaxDimy := My_monBottom - My_monTop
return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;
; Returns the id of a window that meets the selection criteria.
; LatVert = +1 means 'lateral' and -1, 'vertical' coupling
; 
; LftRght defines direction, seen from centre of Master window, in which
; to look for a target window. 
; If LatVert=+1: LftRght = +1 means look right and -1 means look left
; If LatVert=-1, LftRght = +1 means look up and -1 means look down.
;  
; For example: If LatVert=+1 and LftRght = +1, a window will be selected 
; whose right edge [see note] is nearest to the left edge of the Master 
; (in either direction), and whose centre is to the right of 
; the centre of the Master. 
;
; Note: Instead of selecting by 'edge' you can select on 'area' or 
; 'centre' by setting the variable 'Criterion').

FindWin(LatVert, LftRght)  
{
    global ID1, Item, Item1, Item2, Item3, Item4, Item5, Criterion ; Assumes max of 5 candidates.
    
    WinGetPos , My_x, My_y, My_w, My_h , ahk_id %ID1%

    ;  Discard unsuitable windows and store parameters for shortlist candidates
    {
        My_centrex := (My_x+My_w/2)
        My_centrey := (My_y+My_h/2)   ; missed off until 24-01-2009 12:18
        index := ""         ; count selected windows
        Loop , %Item%        
            {
                this_Item := Item%A_Index%  
                WinGetPos , this_x, this_y, this_w, this_h , ahk_id %this_Item%
                This_centrex := (this_x+this_w/2)
                This_centrey := (this_y+this_h/2)
                
                If ((LatVert = +1) 
                    and ((-LftRght+1)/2*this_centrex + (LftRght+1)/2*My_centrex)
                        >((LftRght+1)/2*this_centrex + (-LftRght+1)/2*My_centrex))
                or ((LatVert = -1)
                    and ((LftRght+1)/2*this_centrey + (-LftRght+1)/2*My_centrey)
                        >((-LftRght+1)/2*this_centrey + (LftRght+1)/2*My_centrey))        
                    {
                        Item%A_Index% := ""     ; wrong side of my window so discard
                        continue                
                    }
                index++                     
                Item%A_Index% := ""     
                
                If (LatVert = +1) {
                    EdgeSep := Abs(This_x - My_x + (-LftRght+1)/2*This_w - (LftRght+1)/2*My_w)   
                    CentreSep := Abs(My_centrex-this_centrex)    ; Centre-to-centre separation  
                }
                If (LatVert = -1) {
                    EdgeSep := Abs(This_y - My_y + (LftRght+1)/2*This_h - (-LftRght+1)/2*My_h)
                    CentreSep := Abs(My_centrey-this_centrey)    ; Centre-to-centre separation 
                }
                Area := (this_w * this_h)                   ; area
                Item%index% = %this_Item%%A_Space%%CentreSep%%A_Space%%Area%%A_Space%%EdgeSep% ; store results
            }
    }
    ;  Select the best candidate
    Item:= index        ; number of candidates  
    Dmin := 10000       ; Start high. Will drop to lowest value after loop
    Dmax := 0           ; Start at zero. Will rise to higher value after loop
    Loop , %Item%       
        {
            this_Item := Item%A_Index% 
            StringSplit , string , this_Item, %A_Space% 
            If (Criterion = edge)  {     ; select on edge-to-edge separation
                If (string4 < Dmin)  {
                    Dmin := string4
                    Item1 := string1
                    }
                    Continue
                }
            If (Criterion = area)  {      ; select for largest area
                If (string3 > Dmax)  {
                    Dmax := string3
                    Item1 := string1
                    }
                    Continue
                }    
            If (Criterion = centre) {    ; select for nearest centre
                If (string2 < Dmin)  {
                    Dmin := string2
                    Item1 := string1
                    }
                    Continue
                }    
        }
    Return, Item1                       ; returns id of chosen window 
}
;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;
Sort:
; Lists other windows on same monitor that have style 0x16CF0000 or 0x14CF0000.  
; 
WinGet, Item, list,,, Program Manager   
index := ""                             ; count number in selection
Loop, %Item%                            ;  loop thro' all current windows
{
    this_Item := Item%A_Index%  ; Item1 contains id of first window, etc
    WinGet, this_style , style , ahk_id %this_Item% ; get 'Style' of the window
    If ((this_Style <> 0x16CF0000) and (this_Style <> 0x14CF0000)) or (this_Item = ID1)
    {
        Item%A_Index% := ""     
        continue                        ; wrong style or is Master window
    }
    WinGetPos , this_x, this_y, this_w, this_h , ahk_id %this_Item%
    this_mon := GetMonitorAt(this_x+this_w/2, this_y+this_h/2) ; which monitor?
    If  (this_mon <> My_mon)
        {
        Item%A_Index% := ""     
        continue                        ; window is on wrong monitor
        }
    index++                             ; increment pointer 
    Item%index% = %this_Item%        
}
    Item:= index    ; store revised total of windows 
Return

;;;;;;;;;;;;;;;;;;;;;
; Determine which cell the mouse is in. Use a 3x3 grid.  Columns are 1,2,3 (top to 
; bottom) and rows are 1,2,3 (left to right). 

Get_Cell(ByRef Column, ByRef Row)
{
    CoordMode, Mouse, Screen
    MouseGetPos,X1,Y1,id
    WinGet,Win,MinMax,ahk_id %id%
    If Win
        return
    ; Get the initial window position and size.
    WinGetPos, WinX1, WinY1, WinW, WinH, ahk_id %id%

    Div := 3  ; e.g. Div=4 makes outer cells 1/4 as wide as the window. 
    PW := Abs(WinW/Div)
    PH := Abs(WinH/Div)
    If ((WinX1 < X1) and (X1 < WinX1 + PW))
        Column := 1
    If ((WinX1 + PW < X1) and (X1 < WinX1 + WinW - PW))
        Column := 2
    If ((WinX1 + WinW - PW < X1) and (X1 < WinX1 + WinW))
        Column := 3
        
    If ((WinY1 < Y1) and (Y1 < WinY1 + PH))
        Row := 1
    If ((WinY1 + PH < Y1) and (Y1 < WinY1 + WinH - PH))
        Row := 2
    If ((WinY1 + WinH - PH < Y1) and (Y1 < WinY1 + WinH))
        Row := 3         
    Return
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Called when two windows first couple together
Coupled:
    Master :=  ID1  ; Resizer uses this to see if it's dealing with a Master window.
    Slave := winid
    Coupled := 1
    ; Promote partner to number two window. Avoids having a third window sandwiched
    ; between Master and partner.  Also makes both windows blink when coupled. 
    WinActivate , ahk_id %Slave%    
    WinActivate , ahk_id %Master%
    #Persistent
    ToolTip , Linking On
    SetTimer , TooltipOff , 1000
    SoundBeep, 800, 25  
    SoundBeep, 1200,  25  
Return

; Called when two windows uncouple
UnCouple:
    If (Coupled = 0)
        Return
    Master := ""
    Slave := ""     
    Coupled := 0
    #Persistent
    ToolTip , Linking Off
    SetTimer , TooltipOff , 1000
    SoundBeep, 1200,  25  
    SoundBeep, 800,  25  
Return

; Clear tooltip
TooltipOff:
    SetTimer , TooltipOff , Off
    ToolTip
Return
;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Resizer:
    ; Get the initial mouse position, target window info, monitor limits
    CoordMode, Mouse, Screen            
    MouseGetPos,KDE_X1,KDE_Y1,KDE_id
    WinGetPos,KDE_WinX1,KDE_WinY1, DimMx, DimMy,ahk_id %KDE_id%
    My_mon := GetMonitorAt(KDE_WinX1+DimMx/2, KDE_WinY1+DimMy/2) ; From WindowPad by Lexikos 
    Gosub , CalcMonStats    ; gets My_monRight, etc
    WinActivate , ahk_id %KDE_id%

    ; Set flag to show window is part of a coupled pair
    OneOfPair := (Coupled = 1) and ((KDE_id = Master) or (KDE_id = Slave)) ? 1:0
    ; Uncouple if either window has been minimised, maximised, or closed.
    WinGet,SGone,MinMax,ahk_id %Slave%    
    WinGet,MGone,MinMax,ahk_id %Master%   
    If (OneOfPair = 1) and ((SGone <> 0) or (MGone <> 0)) {
        OneOfPair := 0
        Gosub , UnCouple
    }    
    ; Abort if selected window is full-screen or minimised
    WinGet,KDE_Win,MinMax,ahk_id %KDE_id%  
        IfNotEqual , KDE_Win, 0 , Return    

    ; If one of a couple, make sure both are in consecutive z-order.
    ; Avoids a third window being sandwiched between a coupled pair. Also 
    ; indicates paired state by making both task bars blink when selected by
    ; this routine.
    If (Coupled = 1) and (KDE_id = Master) {
            WinActivate , ahk_id %Slave%
            WinActivate , ahk_id %Master%
            }
    If (Coupled = 1) and (KDE_id = Slave) {
            WinActivate , ahk_id %Master%
            WinActivate , ahk_id %Slave%
            }
    ; If clicking in what was previously the Slave, swap Master and Slave
    If (Coupled = 1) and (Slave = KDE_id)
        Swap(Master, Slave)

    WinGetPos,KDE_P_x,KDE_P_y, DimPx, DimPy,ahk_id %Slave%  ; used during limit checks

    ; Find which of the nine cells in the target window received the click.
    Get_Cell(Column,Row)  
    If (Column=2) and (Row=2)   ; Centre cell, so do move without resizing.
    {
        Loop    
        {
         GetKeyState,KDE_Button,%DragButton% ,P    
            If KDE_Button = U               ;  Abort if button was released.
                break
            MouseGetPos,KDE_X2,KDE_Y2       ; current mouse position.
            KDE_X2 -= KDE_X1                ; offset from  initial position.
            KDE_Y2 -= KDE_Y1            
            newx := (KDE_WinX1 + KDE_X2)    ; Apply offset to window 
            newy := (KDE_WinY1 + KDE_Y2)
                       
            ; If Partner exists, stop dragging before it leaves valid monitor
            If (OneOfPair = 1)
            {
                Mon_P := GetMonitorAt(KDE_P_x + KDE_X2+ DimPx/2, KDE_P_y+ KDE_Y2+ DimPy/2, 0)
                IfEqual , Mon_P, 0, Continue     
                WinMove,ahk_id %Slave%,, KDE_P_x + KDE_X2, KDE_P_y + KDE_Y2
            }    
            WinMove,ahk_id %KDE_id%,, newx, newy
        }
        return
    }
    Else    ; Do resizing
    {      
        ; Use the quadrants, North-West, NE, SE, and SW to set the basic 
      ; directions in which the Master window can be dragged. These are
        ; refined later according to which of the eight peripheral cells was clicked.
        
        WestEast := KDE_X1 < KDE_WinX1+ DimMx/2 ? 1:-1      ; ie, Left-Right
        NorthSouth := KDE_Y1 < KDE_WinY1+ DimMy/2 ? 1:-1     ;ie, Up-Down

        ; Set max width (height) parameter to leave space for Slave if present, and
        ; Set 'Master Near' flag to show if Master or Slave nearest to top-left of monitor.
        MaxDim2x := MaxDimx ; used in limit calculation for Master
        MaxDim2y := MaxDimy
        If (OneOfPair = 1) and (LatVert = 1) {
            MaxDim2x := MaxDimx-MinDimx
            MasterNear := (KDE_Winx1+ DimMx/2) > (KDE_P_x + DimPx/2) ? 1:-1
            }
        If (OneOfPair = 1) and (LatVert = -1) {
            MaxDim2y := MaxDimy-MinDimy
            MasterNear := (KDE_Winy1+ DimMy/2) > (KDE_P_y + DimPy/2) ? 1:-1
            }            
        Loop
        {
         GetKeyState,KDE_Button,%DragButton% ,P 
            If KDE_Button = U                       ; Abort if button was released.
                break
            MouseGetPos,KDE_X2,KDE_Y2               ; Get current mouse position.
        
            KDE_X2 -= KDE_X1                        ; offset from initial mouse position.
            KDE_Y2 -= KDE_Y1
            KDE_X1 := (KDE_X2 + KDE_X1)     ; Reset initial position for next iteration.
            KDE_Y1 := (KDE_Y2 + KDE_Y1)
            
            ; Implement drag mode choice (quadrants or cells).  
            If (DragMode = 1) and (Column=2)   ; Forces lateral-only dragging for Col2
                KDE_X2 := 0        
            If (DragMode = 1) and (Row=2)      ; Forces vertical-only dragging for Row2
                KDE_Y2 := 0
               
            ; Calculate shifts based on quadrant
            DeltaMX := (WestEast+1)/2*KDE_X2
            DeltaMY :=  (NorthSouth+1)/2*KDE_Y2
            DeltaDimMx := -WestEast*KDE_X2           
            DeltaDimMy := -NorthSouth*KDE_Y2
           
            ; Apply limits on maximum size
            StretchLimit("y", "NorthSouth")
            StretchLimit("x", "WestEast")
            
            KDE_WinX1 += DeltaMX
            KDE_WinY1 += DeltaMY
            DimMx  += DeltaDimMx
            DimMy  += DeltaDimMy
                
           ; Apply limits on minimum size
            ShrinkLimit("x", "WestEast")
            ShrinkLimit("y", "NorthSouth")
            
            ; Calculate dimensions of Slave if it exists
            IfNotEqual ,OneOfPair ,0        
            {
                ; LatVert previously set to +1 for lateral coupling and -1 for vertical coupling,  
                If (latvert = 1) {      ; lateral coupling 
                    abs := "x"
                    ord := "y"
                    }
                If (latvert = -1) {     ; vertical coupling
                    abs := "y"
                    ord := "x"
                }
                KDE_P_%abs% := KDE_Win%abs%1+ DimM%abs% - MaxDim%abs%*(1+MasterNear)/2
                KDE_P_%ord% := KDE_Win%ord%1
                DimP%abs% := MaxDim%abs% - DimM%abs%  
                DimP%ord% := DimM%ord%

                ; Abort if centre of Slave would be on non-existent monitor (Mon_P = 0)
                Mon_P := GetMonitorAt(KDE_P_x+ DimPx/2, KDE_P_y+ DimPy/2, 0)
                IfEqual , Mon_P, 0, Continue     
                WinMove ,ahk_id %Slave%,, KDE_P_x , KDE_P_y, DimPx, DimPy  
            }
            WinMove,ahk_id %KDE_id%,, KDE_WinX1 , KDE_WinY1,  DimMx,  DimMy
        }
        return
    }
;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;
; Apply maximum width or height limits
StretchLimit(axis, Dir)
{
    If (DimM%axis% > MaxDim2%axis%) and (DeltaDimM%axis% >0) {
        DeltaM%axis% := -(%Dir%-1)/2*DeltaDimM%axis% +(%Dir%+1)/2*DeltaM%axis%
        DeltaDimM%axis% :=0
    }
}

; Apply minimum width or height limits  
ShrinkLimit(axis, Dir)
{       
    If (DimM%axis% < MinDim%axis%) and (DeltaDimM%axis% <0) {  
        DimM%axis%  -= DeltaDimM%axis% 
        KDE_Win%axis%1 += -(%Dir%-1)/2*DeltaDimM%axis% 
        }
} 

; Exchange Master and Slave titles
Swap(ByRef Master, ByRef Slave)
{
    temp := Master
    Master := Slave
    Slave := temp
}
;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;
; Get the index of the monitor containing the specified x and y co-ordinates.
; (From WindowPad by Lexikos)

GetMonitorAt(x, y, default=1)
{
    SysGet, m, MonitorCount
    ; Iterate through all monitors.
    Loop, %m%
    {   ; Check if the window is on this monitor.
        SysGet, Mon, Monitor, %A_Index%
        if (x >= MonLeft && x <= MonRight && y >= MonTop && y <= MonBottom)
            return A_Index
    }

    return default
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This function is from http://www.autohotkey.com/forum/topic22178.html
IsOverTitleBar(x, y, hWnd) { 
   SendMessage, 0x84,, (x & 0xFFFF) | (y & 0xFFFF) << 16,, ahk_id %hWnd% 
   if ErrorLevel in 2,3,8,9,20,21 
      return true 
   else 
      return false 
}
;;;;;;;;;;;;;;;;;;;;;;;;
