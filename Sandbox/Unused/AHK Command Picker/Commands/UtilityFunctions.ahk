;==========================================================
; Create the window if necessary and put it in focus.
;
; windowName = Name of the window to put in focus.
; applicationPath = Path to the application to launch if the windowName window is not found.
; titleMatchMode = The title match mode to use when looking for the windowName window.
;					1 = Match the start of window's title.
;					2 = Match any part of the window's title.
;					3 = Match the window's title exactly.
;					New = Open a new instance of the application, ignoring currently running instances.
;==========================================================
PutWindowInFocus(windowName, applicationPath = "", titleMatchMode = "")
{
	;~ ; Check if we are already searching for the given Window Name, and if we are just exit, as looking for the 
	;~ ; same window name simultaneously may cause a deadlock and cause the AHK script to crash.
	;~ static PWIFWindowNamesBeingSearchedFor, PWIFDelimiter := "|"
	;~ Loop Parse, PWIFWindowNamesBeingSearchedFor, %PWIFDelimiter%
	;~ {
		;~ ; Skip empty entries (somehow an empty one gets added after backspacing out the entire search string).
		;~ if (A_LoopField = windowName)
		;~ {
			;~ MsgBox, Will not open '%windowName%' because already looking for '%A_LoopField%', so exiting.
			;~ return 0
		;~ }
	;~ }
;~ MsgBox, Before addition, %PWIFWindowNamesBeingSearchedFor%
	;~ PWIFWindowNamesBeingSearchedFor .= windowName . PWIFDelimiter
;~ MsgBox, After addition, %PWIFWindowNamesBeingSearchedFor%
	
	; Store the current values for the global modes, since we will be overwriting them.
	previousTitleMatchMode := A_TitleMatchMode
	previousDetectHiddenWindowsMode := A_DetectHiddenWindows

	; Used to tell when we have succeeded and stop trying.
	windowActivated := false

	; If the user did not specify a specific match mode to use, try them all starting with the most specific ones.
	if (titleMatchMode = "")
	{
		SetTitleMatchMode, 3	; Start by trying to match the window's title exactly.
		gosub, PWIFTryActivateWindow
	
		if (!windowActivated)
		{
			SetTitleMatchMode, 1	; Next try to match the start of the window's title.
			gosub, PWIFTryActivateWindow
		}
		
		if (!windowActivated)
		{
			SetTitleMatchMode, 2	; Next try to match any part of the window's title.
			gosub, PWIFTryActivateWindow
		}

		if (!windowActivated)
		{
			DetectHiddenWindows, On		; Lastly try searching hidden windows as well.
			gosub, PWIFTryActivateWindow
		}
	}
	else
	{
		; If we do want to try and match against an existing window.
		if (titleMatchMode != "New")
		{
			SetTitleMatchMode, %titleMatchMode%		; Try to activate the window using the specified match mode.
			gosub, PWIFTryActivateWindow
		}
	}

	; If the window is not already open.
	if (!windowActivated)
	{	
		; If we were given a program to launch as a backup in case the wanted window wasn't found, then try and launch it.
		if (applicationPath != "")
		{
			; Create the window.
			Run, %applicationPath%

			; Make sure this window is in focus before sending commands.
			WinWaitActive, %windowName%,, 30

			; If the window wasn't opened for some reason.
			IfWinNotExist, %windowName%
			{
				; Display an error message that the window couldn't be opened.
				MsgBox, There was a problem opening "%windowName%"
			}
			; Else the program was launched and the window opened.
			else
			{
				WinShow		; Show the window.
				windowActivated := true		; Record that the window was successfully brought into focus.
			}
		}
	}
	
	; Restore the previous global modes that we might have changed.
	SetTitleMatchMode, %previousTitleMatchMode%
	DetectHiddenWindows, %previousDetectHiddenWindowsMode%
	
;~ MsgBox, Before removal, %PWIFWindowNamesBeingSearchedFor%
	;~ ; Now that we are about to exit, remove this Window Name from our list of Window Names being search for.
	;~ windowNameAndDelimeter := windowName . PWIFDelimiter
	;~ StringReplace, PWIFWindowNamesBeingSearchedFor, PWIFWindowNamesBeingSearchedFor, %windowNameAndDelimeter%
;~ MsgBox, After removal, %PWIFWindowNamesBeingSearchedFor%
	
	; Return the handle of the window that was activated.
	if (windowActivated)
	{
		return WinExist("A")
	}
	
	; Else the window was not activated, so return 0 (i.e. false).
	return 0
	
	; Tries to put the window in focus if it already exists.
	PWIFTryActivateWindow:
		; If the window is already open.
		IfWinExist, %windowName%
		{			
			; Put the window in focus.
			WinActivate
			WinShow
			
			; Not all apps Restore properly when using WinShow and the app is Minimized (e.g. apps minimized using TrayIt!), so explicitly restore windows that are still minimized.
			WinGet, isMinimized, MinMax
			if (isMinimized = -1)
				WinRestore
			
			; Record success.
			windowActivated := true
		}
	return
}

;==========================================================
; Returns true if the given targetItem is found in the itemList, false if not.
;
; itemList = a string containing a list of items, each separated by the itemDelimiter. This is passed ByRef in order to allow us to modify the string list.
;	NOTE: It is not possible to pass Clipboard, built-in variables, or environment variables to a function's ByRef parameter
; targetItem = the string that we are checking is in the list.
; itemDelimiter = the string or character separating each item in the itemList. If none is provided the _cpParameterDelimiter will be used (a comma by default).
; removeTargetItem = if true and the targetItem is found, it will be removed from the itemList (which is passed in by reference).
;==========================================================
StringListContains(ByRef itemList, targetItem, itemDelimiter = "", removeTargetItem = false)
{
	global _cpParameterDelimiter
	
	; If no delimiter was supplied, use the default parameter delimiter.
	if (itemDelimiter = "")
		itemDelimiter := _cpParameterDelimiter
	
	; Trim whitespace off of the target item
	targetItem := Trim(targetItem)
	
	; Loop through each item in the list and return true if the target is found in it.
	Loop, Parse, itemList, %itemDelimiter%
	{
		if (Trim(A_LoopField) = targetItem)
		{
			; Remove the item from the list if specified to do so.
			if (removeTargetItem)
			{
				; We don't know if this item is first, last, or the only item in the list, so try and remove the itemDelimiter with the item.
				; ErrorLevel will be set to 1 if the string to replace is not found.
				StringReplace, itemList, itemList, %A_LoopField%%itemDelimiter%	
				if (ErrorLevel = 1)
					StringReplace, itemList, itemList, %itemDelimiter%%A_LoopField%
				if (ErrorLevel = 1)
					StringReplace, itemList, itemList, %A_LoopField%
			}
			return true
		}
	}

	; The item was not found in the list, so return false.
	return false
}

StringListContainsAndRemove(ByRef itemList, targetItem, itemDelimiter = "")
{
	return StringListContains(itemList, targetItem, itemDelimiter, true)
}

;==========================================================
; Returns true if the given targetItem is found in the itemList, false if not.
;
; itemList = an array containing a list of items.
; targetItem = the item that we are checking is in the list.
;==========================================================
ArrayContains(itemList, targetItem)
{
	global _cpParameterDelimiter
	
	; If no delimiter was supplied, use the default parameter delimiter.
	if (itemDelimiter = "")
		itemDelimiter := _cpParameterDelimiter
	
	; Trim whitespace off of the target item
	targetItem := Trim(targetItem)
	
	; Loop through each item in the list and return true if the target is found in it.
	For index, value in parameters
	{
		if (Trim(value) = targetItem)
			return true
	}

	; The item was not found in the list, so return false.
	return false
}

;==========================================================
; Pastes the given text into the currently active window.
; This can be better than just using "SendInput, Text to paste", especially for long strings, because the entire string will pasted at once rather than waiting for it all to be typed out.
;
; textToPaste = the text to paste to the window.
; pasteKeys = the keys to simulate pressing in order to paste text. Ctrl+v is the default, but other windows may have different keys to paste text (e.g. Git Bash uses the Insert key to paste text).
;==========================================================
PasteText(textToPaste = "", pasteKeys = "^v")
{
	if (pasteKeys = "git")
		pasteKeys = {Insert}
	else if (pasteKeys = "gitEnter")
		pasteKeys = {Insert}{Enter}
	else if (pasteKeys = "cmd")
		pasteKeys = !{Space}ep
	else if (pasteKeys = "cmdEnter")
		pasteKeys = !{Space}ep{Enter}
	
	clipboardBackup := ClipboardAll	; Backup whatever is currently on the Clipboard, including pictures and anything else.
	Clipboard := textToPaste
	SendInput, %pasteKeys%			; Paste from the clipboard so all the text appears there instantly.
	Sleep, 200						; Have to sleep so that we don't overwrite the Clipboard text before we've pasted it.
	Clipboard := clipboardBackup	; Restore whatever was on the Clipboard.
	clipboardBackup := ""			; Clear the variable's contents to free memory, as there could be lots of data on the clipboard.
}

;==========================================================
; Displays the given message in a Message Box, but only if the global variable DebugMsgBox_ShowMessages is not false.
; Toggling the DebugMsgBox_ShowMessages variable to true/false is a quick way to show/not show messages sent to this function (e.g. messages used for debugging).
;==========================================================
DebugMsgBox(message = "")
{	global DebugMsgBox_ShowMessages
	if (%DebugMsgBox_ShowMessages% != false)
		MsgBox, %message%
}
