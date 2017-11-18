#If WinActive("ahk_exe TslGame.exe")
  +LAlt::
    SendInput, {Ctrl Down} 
    SendInput, {Space Down}
    While GetKeyState("LAlt","p") 
      Sleep 1
    SendInput, {Space Up} 
    Send, {Ctrl up}
  return

  LWin::Return     
#If
