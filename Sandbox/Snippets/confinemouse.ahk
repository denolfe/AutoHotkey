; the '*' is Wildcard: Fire the hotkey even if extra modifiers are being held down. 
*ScrollLock:: ; Hotkey will toggle status, scroll-lock key
Confine := !Confine

ClipCursor( Confine, 0, 0, A_screenwidth, A_screenheight)
Return


ClipCursor( Confine=True, x1=0 , y1=0, x2=1, y2=1 ) {
 VarSetCapacity(R,16,0),  NumPut(x1,&R+0),NumPut(y1,&R+4),NumPut(x2,&R+8),NumPut(y2,&R+12)
Return Confine ? DllCall( "ClipCursor", UInt,&R ) : DllCall( "ClipCursor" )
}

; for reference, I got the script from here

;Is there a way to use AHK to effectively ignore the y-axis while still retaining full x-axis ;functionality? 
;
;http://www.autohotkey.com/forum/topic42365.html&highlight=draw+mouse