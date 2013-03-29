;==========================================================
; Use Alt+Left Mouse Button to move a window
;==========================================================
Alt & LButton::
                CoordMode, Mouse  ; Go by absolute coordinates
                MouseGetPos, MouseStartX, MouseStartY, MouseWin ; Get the mouses' starting position within the window, as an anchor.
                SetTimer, WatchMouse, 10 ; Track the mouse as it is dragged, and run the WatchMouse event every 10 ms.

WatchMouse:
                GetKeyState, LButtonState, LButton, P
                if LButtonState = U  ; If Left Mouse Button is released, stop dragging
                {
                                SetTimer, WatchMouse, off
                                return
                }
                ; Otherwise, reposition the window as the mouse moves
                CoordMode, Mouse ; Get coordinates relative to the Mouse
                MouseGetPos, MouseX, MouseY ; Get current mouse X and Y
                WinGetPos, WinX, WinY,,, ahk_id %MouseWin% ; Get current window X and Y, and the ID of the window that must be moved
                SetWinDelay, -1   ; Makes the move faster/smoother
                NewWinX := WinX + MouseX - MouseStartX
                NewWinY := WinY + MouseY - MouseStartY
                WinMove, ahk_id %MouseWin%,, %NewWinX%, %NewWinY% ; Move the window by ID to the new location
                MouseStartX := MouseX  ; Set a new mouse anchor.
                MouseStartY := MouseY
return

;==========================================================
; Ctrl+Win+v to do a text-only paste from the clipboard (excludes images, etc. on the clipboard and only text is pasted).
;==========================================================
^#v::
   PasteText(Clipboard)	; ClipboardAll contains everything including images; Clipboard will only be the text on the clipboard.
Return