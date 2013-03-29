#MaxHotkeysPerInterval 200

the_mode=1 ;which mode we are currently on (1-3)
num_modes=3 ;the number of modes
combodone=0 ;whether or not we've performed a combo since pressing the right mouse button down
alttabstart=0 ;whether or not we have started switching windows in mode 2
mode_names1=VOLUME ;these are the names for the modes and are used to display in the tooltip
mode_names2=WINDOW
mode_names3=TAB

*RButton::
   if (not GetKeyState("LButton")){ ;if the right button is not held down, have the left button act normally
      Send {Blind}{RButton Down}
      KeyWait RButton
      Send {Blind}{RButton Up}
   }
   else { ;the right button is being held down, so we want to switch modes.
      if (the_mode==num_modes){ ;if we were on mode 3, reset the mode counter so the next mode will be 1 again
         the_mode=0
      }
      combodone=1 ;we did a combo, so prevent the right click menu from showing upon completion
      the_mode := the_mode+1 ;switch to the next mode
      mode_name:=mode_names%the_mode% ;get the mode name corresponding to the new mode
      ToolTip %the_mode%: %mode_name% ;display the new mode number and name in the tooltip
   }
   return


WheelDown::
   if ((not GetKeyState("RButton")) or alttabstart==1){ ;if right button is not held down or we are trying to switch windows with win-tab, send scroll down
      Send {Blind}{WheelDown}
   }
   else { ;right button is held down
      combodone=1
      if (the_mode==1){ ;mode 1:lower the volume
         Send {Volume_Down 2}
      }
      else if (the_mode==2){ ;mode 2: hold down windowskey and hit tab
         if (alttabstart==0){
            SendInput {LWin Down}{Tab}
            alttabstart=1
         }
   
      }
      else if (the_mode==3){ ;send ctrl-tab to switch to the next tab
         Send ^{Tab}
      }

   }
   return

WheelUp::
   if ((not GetKeyState("RButton")) or alttabstart==1){ ;if right button is not held down or we are trying to switch windows with win-tab, send scroll up
      Send {Blind}{WheelUp}
   }
   else {
      combodone=1
      if (the_mode==1){ ;mode 1: raise the volume
         Send {Volume_Up 2}
      }
      else if (the_mode==2){ ;mode 2: hold down windowskey and hit tab
         if (alttabstart==0){
            SendInput {LWin Down}{Tab}
            alttabstart=1
         }
   
      }
      else if (the_mode==3){ ;mode 3: send ctrl-shift-tab to switch to previous tab
         Send ^+{Tab}
      }

   }
   return

*LButton:: ;when right mouse button is held down:
   Send {Blind}{LButton Down} ;send right mouse button down. (needed to right-button drag)
   mode_name:=mode_names%the_mode% ;get the mode name
   ToolTip %the_mode%: %mode_name% ;display the mode number and name in a tooltip
   KeyWait LButton ;wait for the right mouse button to be released
   ToolTip ;get rid of the tooltip
   if(alttabstart==1){ ;if we were in window mode, reset alttabstart and send windowskey up
      alttabstart=0
      SendInput {LWin Up}
   }
   Send {Blind}{LButton Up} ;send right mouse button up, as the the button was just released.
   if(combodone==1){ ;if a combo was done (right button + scroll/left click) hit escabe to get rid of the right click menu
      combodone=0
      SendInput {Esc}
   }
   return
