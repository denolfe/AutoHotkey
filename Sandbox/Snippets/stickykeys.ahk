    stickykeys = 0
    
    F9::
		stickykeys:=!stickykeys
		Traytip, Sticky Keys, % (stickykeys) ? "On" : "Off"
		return
  
    #If stickykeys
    
    	*$Shift::
    		key = 0
    		Input, key, L1 M
    		SendInput {Shift Down}{%key%}{Shift Up}
    	return
    
    	*$Ctrl::
    		key = 0
    		Input, key, L1 M
    		SendInput {Ctrl Down}{%key%}{Ctrl Up}
    	Return
    
    	*$Alt::
    		key = 0
    		Input, key, L1 M
    		SendInput {Alt Down}{%key%}{Alt Up}
    	Return
    #If