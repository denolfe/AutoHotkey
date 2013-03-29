; Title:     Dock 
;            *Dock desired top level windows (dock clients) to any top level window (dock host)* 
;
; 
;
;			 Using dock module you can glue your or third-party windows to any top level window.
;			 Docked windows in module terminology are called Clients and the window that keeps their 
;			 position relative to itself is called Host. Once Clients are connected to the Host, this
;			 group of windows will behave like single window - moving, sizing, focusing, hiding and other
;			 OS events will be handled by the module so that the "composite window" behaves like the single window.
;
;			 Module uses system hook to monitor windows changes, so it's idle when it is not arranging windows.
; 
;---------------------------------------------------------------------------------------------------------------------------------- 
; Function:  Dock 
;            Instantiate dock of given client upon host. Multiple clients per one host are supported. 
; 
; 
; Parameters: 
; 
;            pClientId   - HWND of the Client GUI. Dock is created or updated (if already exists) for that hwnd.    
;            pDockDef   - Dock definition, see bellow. To remove dock client pass "-". 
;                       If you pass empty string, client will be docked to the host according to its current position relative to the host. 
;            reset      - internal parameter, do not use. 
; 
; Globals: 
;            Dock_HostID   - Sets docking host 
;         Dock_OnHostDeath - Sets label that will be called when host dies. Afterwards, module will disable itself using Dock_Toggle(false).
;
; Dock definition:  
;			Dock definition is string containing unordered white space separated parameters which describe Client's position relative to the Host. The big number of parameters allow
;			for fine tuning of Client's position and basically every setup is possible. Parameters are grouped into 4 classes - x, y, w & h parameters.
;			Classes and their parameters are optional.
;			
;> 		Syntax:		x(hw,cw,dx)  y(hh,ch,dy)  w(hw,dw)  h(hh,dh)  t
;
; 
;            o The *X* coordinate of the top, left corner of the client window is computed as 
;            *HostX + hw*HostWidth + cw*ClientWidth + dx*, with the parameters hw, cw & dx (shorten from host width and client width multipliers, delta x).
; 
;            o The *Y* coordinate of the top, left corner of the client window is computed as 
;            *HostY + hh*HostHeight + ch*ClientHeight + dy*, with the parameters hh, ch and dy.
; 
;            o The width *W* of the client window is computed as *hw*HostWidth + dw*, with the parameters hw & wd.
; 
;            o The height *H* of the client window is computed as *hh*HostHeight + dh*, with the parameters hh & hd.
;
;			 o The topmost state of the client is *T*. Specify this option to to set the Client always on top the Host. This allows client to be positioned inside the Host.
;
;			If you omit any of the class parameters it will default to 0. So, the following expressions all have the same effect :
;> 		    x(0,0,0) = x(0,0) = x(0,0,) = x(0) = x(0,)= x(0,,) = x() = x(0,,0) = x(,0,0) = x(,,0) = ...
;>			y(0,1,0) = y(0,1) = y(,1) = y(,1,) = y(,1,0) = ...
;
;			Keep in mind that x() is not the same as omitting x entirely. First case is equal to x(0,0,0) so it will set Client's X coordinate to be equal as Host's. 
;			In second case, x coordinate of the client will not be touched by the Dock module but Client will keep whatever x it had before.
;			
; 
; Returns: 
;            "OK" or "Err" with text describing last successful or failed action.
;
; Remarks:
;			You must set DetectHiddenWindows if Host is practicing hiding. Otherwise, Dock will treat Host hiding as death.
;			All clients will be hidden once host is terminated or it becomes hidden itself.
;
;			Use SetBatchLines, -1 with dock module for fluid client movement. You will experience delay in clients moving otherwise.
;			However, if CPU usage is very high, you might experience a delay in client movement anyway.
;
;			If you are using *Gui, Show* command immediately before registering client, make sure you specify *NoActivate* flag.
;
;			"Topmost" feature can be used to create additional caption buttons. Caption buttons are topmost clients containing only 1 button
;			and docked to the Host so that they appear in its caption. To setup caption button, only X class is needed. For instance
;			"x(1,0,-100)" can be used to set caption button 100 pixels from the right edge of the Host's caption.
; 
; Example: 
;>      Dock(Client1ID, "x(0,-1,-10)  y(0,0,0)  w(0,63)  h(1,0)")   ;top left, host height 
;>      Dock(Client2ID, "x() y(,-1,-5) w(1)  h(,30)")				;top above, host width, short definition
;> 		Dock(hTitleBtn, "x(1,0,-80), y(0,0,5) w(0,20) h(0,15) t")   ;add title button, topmost client docked inside Host, on title, with 20x15 size
;
Dock(pClientID, pDockDef="", reset=0) {                    ;Reset is internal parameter, used by Dock_Shutdown 
   local cnt, new, cx, cy, hx, hY, t, hP
   static init=0, idDel, classes="x|y|w|h"

    if (reset)                                             ;Used by Dock Shutdown to reset the function 
		return init := 0 

	if !init
		Dock_aClient[0] := 0

   cnt := Dock_aClient[0] 

   ;remove dock client ? 
   if (pDockDef="-") and (Dock_%pClientID%){ 

      idDel := Dock_%pClientID% 

      loop, parse, classes, |
		loop, 3
         Dock_%pClientID%_%A_LoopField%%A_Index% := ""
	  Dock_%pClientID% := ""			; don't remove t Dock_%pClientID%_t := 
       
      ;move last one to the place of the deleted one 
      Dock_aClient[%idDel%] := Dock_aClient[%cnt%], Dock_aClient[%cnt%] := "", Dock_aClient[0]-- 
      return "OK - Remove" 
   } 

   if pDockDef = 
   { 
      WinGetPos hX, hY,,, ahk_id %Dock_HostID% 
      WinGetPos cX, cY,,, ahk_id %pClientID% 
      pDockDef := "x(0,0," cX - hX ")  y(0,0," cY - hY ")"
   } 

   ;add new dock client if it not exists, or update its dock settings if it exists 
	loop, parse, pDockDef, %A_Space%%A_Tab%
	   if (A_LoopField != "") {
			t := A_LoopField, c := SubStr(t,1,1)
			if c not in x,y,w,h,t
				return "ERR: Bad dock definition"

			if c = t
			{
				 Dock_%pClientID%_t := 1
			}
			else {			
				t := SubStr(t,3,-1)
				StringReplace, t, t,`,,|,UseErrorLevel
				t .= !ErrorLevel ? "||" : (ErrorLevel=1 ? "|" : "")
				loop, parse, t,|,%A_Space%%A_Tab% 
					Dock_%pClientID%_%c%%A_Index% := A_LoopField ? A_LoopField : 0
			}
	   }

	if !Dock_%pClientID% {
		Dock_%pClientID%   := ++cnt, 
		Dock_aClient[%cnt%] := pClientId 
		Dock_aClient[0]++ 
	}

   ;start the dock if its not already started
   If !init { 
      init++, Dock_hookProcAdr := RegisterCallback("Dock_HookProc")
      Dock_Toggle(true)	 
   } 

   Dock_Update()
   return "OK" 
}       


;----------------------------------------------------------------------------------------------------- 
;Function:  Dock_Shutdown 
;			Uninitialize dock module. This will clear all clients and internal data and unregister hooks. 
;			Dock_OnHostDeath, Dock_HostId are kept on user values. 
; 
Dock_Shutdown() { 
   local cID 

   Dock_Toggle(false) 
   DllCall("GlobalFree", "UInt", Dock_hookProcAdr), Dock_hookProcAdr := "" 
   Dock(0,0,1)         ;reset dock function 

   ;erase clients 
   loop, % Dock_aClient[0] 
   { 
      cId := Dock_aClient[%A_Index%], Dock_aClient[%A_Index%] := "" 
      Dock_%cID% := "" 
      loop, 10 
         Dock_%cID%_%A_Index% := "" 
   }
}

;----------------------------------------------------------------------------------------------------- 
;Function: Dock_Toggle 
;          Toggles the dock module ON or OFF.
; 
;Parameters: 
;         enable - Set to true to set the dock ON, set to FALSE to turn it OFF. Skip to toggle. 
; 
;Remarks: 
;         Use Dock_Toggle(false) to suspend the dock module (to unregister hook), leaving its internal data in place. 
;         This is different from Dock_Shutdown as latest removes module completely from memory and 
;         unregisters its clients. 
;          
;         You can also use this function to temporary disable module when you don't want dock update routine to interrupt your time critical sections. 
;
Dock_Toggle( enable="" ) { 
   global 

   if Dock_hookProcAdr = 
      return "ERR - Dock must be loaded." 

   if enable = 
      enable := !Dock_hHook1 
   else if (enable && Dock_hHook1)
		return	"ERR - Dock already enabled"

   if !enable 
      API_UnhookWinEvent(Dock_hHook1), API_UnhookWinEvent(Dock_hHook2), API_UnhookWinEvent(Dock_hHook3), Dock_hHook3 := Dock_hHook1 := Dock_hHook2 := "" 
   else  { 
      Dock_hHook1 := API_SetWinEventHook(3,3,0,Dock_hookProcAdr,0,0,0)				; EVENT_SYSTEM_FOREGROUND 
      Dock_hHook2 := API_SetWinEventHook(0x800B,0x800B,0,Dock_hookProcAdr,0,0,0)	; EVENT_OBJECT_LOCATIONCHANGE 
	  Dock_hHook3 := API_SetWinEventHook(0x8002,0x8003,0,Dock_hookProcAdr,0,0,0)	; EVENT_OBJECT_SHOW, EVENT_OBJECT_HIDE

      if !(Dock_hHook1 && Dock_hHook2 && Dock_hHook3) {	   ;some of them failed, unregister everything
         API_UnhookWinEvent(Dock_hHook1), API_UnhookWinEvent(Dock_hHook2), API_UnhookWinEvent(Dock_hHook3) 
         return "ERR - Hook failed" 
      } 

	 Dock_Update() 
   } 
   return enable
} 
;==================================== INTERNAL ====================================================== 
Dock_Update() { 
   local hX, hY, hW, hh, W, H, X, Y, cx, cy, cw, ch, fid, wd, cid 
   static gid=0   ;fid & gid are function id and global id. I use them to see if the function interupted itself. 

   wd := A_WinDelay 
   SetWinDelay, -1 
   fid := gid += 1 
   WinGetPos hX, hY, hW, hH, ahk_id %Dock_HostID% 
;   OutputDebug %hX% %hY% %hW% %hH%	 %event%

   ;xhw,xw,xd,  yhh,yh,yd,  whw,wd,  hhh,hd 
	loop, % Dock_aClient[0] 
	{ 
		cId := Dock_aClient[%A_Index%] 
		WinGetPos cX, cY, cW, cH, ahk_id %cID% 
		W := Dock_%cId%_w1*hW + Dock_%cId%_w2,  H := Dock_%cId%_h1*hH + Dock_%cId%_h2 
		X := hX + Dock_%cId%_x1*hW + Dock_%cId%_x2* (W ? W : cW) + Dock_%cId%_x3
		Y := hY + Dock_%cId%_y1*hH + Dock_%cId%_y2* (H ? H : cH) + Dock_%cId%_y3

		if (fid != gid) 				;some newer instance of the function was running, so just return (function was interupted by itself). Without this, older instance will continue with old host window position and clients will jump to older location. This is not so visible with WinMove as it is very fast, but SetWindowPos shows this in full light. 
			break

;		DllCall("SetWindowPos", "uint", cId, "uint", 0, "uint", X ? X : cX, "uint", Y ? Y : cY, "uint", W ? W : cW, "uint", H ? H :cH, "uint", 1044) ;4 | 0x10 | 0x400 
		WinMove ahk_id %cId%,,X ? X:"" ,Y ? Y:"", W ? W : "" ,H ? H : "" 
	}      
	SetTimer, Dock_SetZOrder, -40		;set z-order in another thread (protects also from spaming z-order changes when host is rapidly moved).
	SetWinDelay, %wd% 
}

Dock_SetZOrder: 
;    OutputDebug setzorder
	loop, % Dock_aClient[0]  
	{
	  _ := Dock_aClient[%A_Index%], _ := Dock_%_%_t
	  if !_
	      DllCall("SetWindowPos", "uint", Dock_aClient[%A_Index%], "uint", Dock_HostID, "uint", 0, "uint", 0, "uint", 0, "uint", 0, "uint", 19 | 0x4000 | 0x40)
	  else 
		;Set owned clients if they are not already set. Host may not exist here.
		if !DllCall("GetWindowLong", "uint", Dock_aClient[%A_Index%], "int", -8) and WinExist("ahk_id " Dock_HostId)
		{
			DllCall("SetWindowLong", "uint", Dock_aClient[%A_Index%], "int", -8, "uint", Dock_HostId)
			_ := DllCall("GetWindow", "uint", Dock_HostId, "uint", 3) ;use hwndprev 
			DllCall("SetWindowPos", "uint", Dock_aClient[%A_Index%], "uint", _, "uint", 0, "uint", 0, "uint", 0, "uint", 0, "uint", 0x40 | 19 | 0x4000) ;SWP_SHOWWINDOW ..., no activate
		}

	}

return 

Dock_SetZOrder_OnClientFocus:
    ;OutputDebug setzorder on focus

	;Set host just bellow focused client.
	res := DllCall("SetWindowPos", "uint", Dock_HostID, "uint", Dock_AClient, "uint", 0, "uint", 0, "uint", 0, "uint", 0, "uint", 19) ;SWP_NOACTIVATE | SWP_NOMOVE | SWP_NOSIZE ...

	;Set the non-T children , T children are handled normaly by OS as owned.
	loop, % Dock_aClient[0]
	{
		_ := Dock_aClient[%A_Index%], _ := Dock_%_%_t
		if !_
			 DllCall("SetWindowPos", "uint", Dock_aClient[%A_Index%], "uint", Dock_HostID, "uint", 0, "uint", 0, "uint", 0, "uint", 0, "uint", 19) ;SWP_NOACTIVATE | SWP_NOMOVE | SWP_NOSIZE
	}
return 

;-----------------------------------------------------------------------------------------
; Events :
;			3	  - Host is set to foreground
;			32779 - Location change
;			32770 - Show
;			32771 - Hide (also called on exit)
;
Dock_HookProc(hWinEventHook, event, hwnd, idObject, idChild, dwEventThread, dwmsEventTime ) { 
	local e, cls, style

	if idObject or idChild
		return
	WinGet, style, Style, ahk_id %hwnd%
	if (style & 0x40000000)					;RETURN if hwnd is child window, for some reason idChild may be 0 for some children ?!?! ( I hate ms )
		return

;	WINGETCLASS, cls, ahk_id %hwnd%
;	if cls in #32768,#32771,#32772,#32769,SysShadow,tooltips_class32		;skip some windows classes, just to speed it up
;		return

	;outputdebug % cls " " hwnd " " event
	if (event = 3) 
	{
		;check if client is taking focus
		loop, % Dock_aClient[0]
 		  if (hwnd = Dock_aClient[%A_Index%]){
			Dock_AClient := hwnd
			gosub Dock_SetZOrder_OnClientFocus
			return
		}		
	}

	If (hwnd != Dock_HostID){
      if !WinExist("ahk_id " Dock_HostID) && IsLabel(Dock_OnHostDeath)
	  {
 		 Dock_Toggle(false)
		 gosub %Dock_OnHostDeath% 
 		 loop, % Dock_aClient[0]
			DllCall("ShowWindow", "uint", Dock_aClient[%A_Index%], "uint",  0)
	  }
	  return 
	} 

	
	if event in 32770,32771
	{
	   e := (event - 32771) * -5
	   loop, % Dock_aClient[0]
			DllCall("ShowWindow", "uint", Dock_aClient[%A_Index%], "uint",  e)
	}

	Dock_Update() 
} 




API_SetWinEventHook(eventMin, eventMax, hmodWinEventProc, lpfnWinEventProc, idProcess, idThread, dwFlags) { 
   DllCall("CoInitialize", "uint", 0) 
   return DllCall("SetWinEventHook", "uint", eventMin, "uint", eventMax, "uint", hmodWinEventProc, "uint", lpfnWinEventProc, "uint", idProcess, "uint", idThread, "uint", dwFlags) 
} 

API_UnhookWinEvent( hWinEventHook ) { 
   return DllCall("UnhookWinEvent", "uint", hWinEventHook) 
} 

;--------------------------------------------------------------------------------------------------------------------- 
; Group: Presets
;		 This section contains some common docking setups. You can just copy/paste dock definition strings in your script.
;
;		x(,-1) y()						- top left, own size
;		x(,-1,10) y()					- top left, own size, 10px padding 
;		x(,-1)  y() h(1)				- top left, use host's height, keep own width
;		x(,-1,20) y() w(,50) h(1)		- top left, use host's height, set width to 50 and padding to 20px
;		x(,-1)  y(.5,-.5)				- middle left, keep own size
;			
;		x(,-1)  y(1,-1) w(,20) h(,20)	- bottom left, fixed width & height to 20px
;		x(,-1)  y(1,-1) h(.5)			- bottom left, keep height half of the Host's height, keep own width
;		x(1,-1) y(1)  w(.25) h(.25)		- bottom right, width and height 1/5 of the Host
;		
;		x()	y(1) w(1) h(,100)			- below the host, use host's width, height = 100
;		x()	y(,-1,-5) w(1)   			- above the host, use host's width, keep own height, 5px padding
;		x(.5,-.5) y(,-1) w(,200) h(,30)	- center above the host, width=200, height=30
;		x(.5,-.5) y(1) w(0.3) h(,30)	- center bellow the host, use 1/3 Host's width, height=30
;		
;		x(1) y()						- top right, own size
;		x(1) y() w(,40) h(1)			- top right, use host's height, width = 40
;       x(1) y(.5,-.5)					- middle right, keep own size

;--------------------------------------------------------------------------------------------------------------------- 
; Group: About 
;      o Ver 2.0 b3 by majkinetor. See http://www.autohotkey.com/forum/topic19400.html 
;	   o Thank You's: Laszlo, JGR, Joy2World, bmcclure 
;      o Licenced under Creative Commons Attribution-Noncommercial <http://creativecommons.org/licenses/by-nc/3.0/>.