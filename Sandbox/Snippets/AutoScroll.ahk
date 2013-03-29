;http://www.autohotkey.com/community/viewtopic.php?t=47054

~*Alt::
    Loop
    {
       If !GetKeyState("Alt","P")
          break
       MouseGetPos, ax,ay
       Sleep, 50
       MouseGetPos,bx,by
       Send % (ay<by ? "{WheelDown " : "{WheelUp ") . round(Abs(ay-by)/(GetKeyState("Shift","P") ? 10 : 1)) . "}"
       Send % (ax<bx ? "{WheelRight " : "{WheelLeft ") . round(Abs(ax-bx)/(GetKeyState("Shift","P") ? 10 : 1)) . "}"
    }
Return