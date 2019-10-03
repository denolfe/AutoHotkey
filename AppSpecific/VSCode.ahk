#If MouseIsOver("ahk_exe Code.exe")
  ^MButton::
    Send, {LButton}
    WinGet, isMaxed, MinMax, A
    If (isMaxed)
    {
      Send #{Down}
      Monitor_MoveOptimal()
    }
    Else
      Monitor_MoveOptimal()
    Return
#If
