/*
IDEAS:
- Have the GUI optional. Instead can just press CapsLock to bring up tooltip that says "Enter Command", and then user types in the tooltip instead of popping the large GUI. Could still autocomplete the command and show it in the tooltip though.
- Maybe just hide the GUI instead of actually closing it every time; this would be good for tooltip mode too, since the tooltip could show the currently selected command from the window.
- Allow user to create new simple commands easily from the GUI and save them in their own file (open file/program, path, website).

- Use Ctrl+Space to copy the full command/parameter into the input textbox, and Ctrl+, to copy it with a trailing comma (easier for parameters).  Or maybe use Shift instead of Ctrl.
*/

; Use the two following commands to debug a script.
;ListVars
;Pause

#SingleInstance force	; Make it so only one instance of this script can run at a time (and reload the script if another instance of it tries to run).
#NoEnv					; Avoid checking empty variables to see if they are environment variables (better performance).

;==========================================================
; Global Variables - prefix everything with "cp" for Command Picker, so that variable/function names are not likely to conflict with user variables/function names.
;==========================================================
_cpWindowName := "Choose a command to run"
_cpCommandList := ""					; Will hold the list of all available commands.
_cpCommandSelected := ""				; Will hold the command selected by the user.
_cpSearchedString := ""					; Will hold the actual string that the user entered.
_cpActiveWindowID := ""					; Will hold the ID of the Window that was Active when this picker was launched.
_cpCommandArray := Object()				; Will hold the array of all Command objects.
_cpCommandDelimiter := "|"				; The character used to separate each command in the _cpCommandList. This MUST be the pipe character in order to work with a ListBox/ComboBox/DropDownList/Tab.

; Delimeters/Separators seen or used by the user.
_cpParameterDelimiter := ","			; The character used to separate each parameter in the AddCommand() function's parameter list and when manually typing in custom parameters into the search box. Also used to separate and each command in the AddCommands() function's command list. This MUST be a comma for the Regex whitespace removal to work properly, and it makes it easy to loop through all of the parameters using CSV.
_cpCommandParameterListSeparator := ","	; The character used to separate the command name from the parameter list when the user is typing their command.
_cpCommandDescriptionSeparator := "=>"	; The character or string used to separate the command name from the description of what the command does.
_cpCommandParameterSeparator := ","		; The character or string used to separate the command name from the command's preset parameter name/value in the Listbox.
_cpParameterNameValueSeparator := "|"	; The character used to separate a preset parameter's name from its value, in the AddCommand() function's parameter list.
_cpCommandNameValueSeparator := "|"		; The character used to separate a command's name from its value, in the AddCommands() function's command list.

; ---------------------------------------------------------
; AHK Command Picker Settings - Specify the default Command Picker Settings, then load any existing settings from the settings file.
;----------------------------------------------------------
_cpSettingsFileName := "AHKCommandPicker.settings"
_cpShowAHKScriptInSystemTray := true
_cpWindowWidthInPixels := 700
_cpFontSize := 10
_cpNumberOfCommandsToShow := 20
_cpCommandMatchMethod := "Type Ahead"
_cpShowSelectedCommandWindow := true
_cpNumberOfSecondsToShowSelectedCommandWindowFor := 2.0
_cpShowSelectedCommandWindowWhenInfoIsReturnedFromCommand := true
_cpNumberOfSecondsToShowSelectedCommandWindowForWhenInfoIsReturnedFromCommand := 4.0
CPLoadSettings()

;==========================================================
; Load Command Picker Settings From File.
;==========================================================
CPLoadSettings()
{
	; Include any global setting variables the we need.
	global _cpSettingsFileName, _cpWindowWidthInPixels, _cpNumberOfCommandsToShow, _cpShowAHKScriptInSystemTray, _cpShowSelectedCommandWindow, _cpCommandMatchMethod, _cpNumberOfSecondsToShowSelectedCommandWindowFor, _cpShowSelectedCommandWindowWhenInfoIsReturnedFromCommand, _cpNumberOfSecondsToShowSelectedCommandWindowForWhenInfoIsReturnedFromCommand
	
	; If the file exists, read in its contents and then delete it.
	If (FileExist(_cpSettingsFileName))
	{
		; Read in each line of the file.
		Loop, Read, %_cpSettingsFileName%
		{
			; Split the string at the = sign
			StringSplit, setting, A_LoopReadLine, =
			
			; If this is a valid setting line (e.g. setting=value)
			if (setting0 = 2)
			{
				; Get the setting variable's value
				_cp%setting1% = %setting2%
			}
		}
	}

	; Save the settings.
	CPSaveSettings()
	
	; Apply any applicable settings.
	CPShowAHKScriptInSystemTray(_cpShowAHKScriptInSystemTray)
}

;==========================================================
; Save Command Picker Settings To File.
;==========================================================
CPSaveSettings()
{
	; Include any global setting variables the we need.
	global _cpSettingsFileName, _cpWindowWidthInPixels, _cpNumberOfCommandsToShow, _cpShowAHKScriptInSystemTray, _cpShowSelectedCommandWindow, _cpCommandMatchMethod, _cpNumberOfSecondsToShowSelectedCommandWindowFor, _cpShowSelectedCommandWindowWhenInfoIsReturnedFromCommand, _cpNumberOfSecondsToShowSelectedCommandWindowForWhenInfoIsReturnedFromCommand
	
	; Delete and recreate the settings file every time so that if new settings were added to code they will get written to the file.
	If (FileExist(_cpSettingsFileName))
	{
		FileDelete, %_cpSettingsFileName%
	}
	
	; Write the settings to the file (will be created automatically if needed)
	; Setting name in file should be the variable name, without the "_cp" prefix.
	FileAppend, CPShowAHKScriptInSystemTray=%_cpShowAHKScriptInSystemTray%`n, %_cpSettingsFileName%
	FileAppend, WindowWidthInPixels=%_cpWindowWidthInPixels%`n, %_cpSettingsFileName%
	FileAppend, NumberOfCommandsToShow=%_cpNumberOfCommandsToShow%`n, %_cpSettingsFileName%
	FileAppend, CommandMatchMethod=%_cpCommandMatchMethod%`n, %_cpSettingsFileName%
	FileAppend, ShowSelectedCommandWindow=%_cpShowSelectedCommandWindow%`n, %_cpSettingsFileName%
	FileAppend, NumberOfSecondsToShowSelectedCommandWindowFor=%_cpNumberOfSecondsToShowSelectedCommandWindowFor%`n, %_cpSettingsFileName%
	FileAppend, ShowSelectedCommandWindowWhenInfoIsReturnedFromCommand=%_cpShowSelectedCommandWindowWhenInfoIsReturnedFromCommand%`n, %_cpSettingsFileName%
	FileAppend, NumberOfSecondsToShowSelectedCommandWindowForWhenInfoIsReturnedFromCommand=%_cpNumberOfSecondsToShowSelectedCommandWindowForWhenInfoIsReturnedFromCommand%`n, %_cpSettingsFileName%
}

;==========================================================
; Add a Dummy command to use for debugging.
;==========================================================
AddNamedCommand("Dummy Command", "DummyCommand", "A command that doesn't do anything, but can be useful for testing and debugging", "Parameter1Name|Parameter1Value, Parameter2Value,Param3Name|Param3Value,Param4Value")
DummyCommand(parameters = "")
{
	; Example of how to check if parameters were provided.
	if (parameters != "")
		MsgBox, Parameters were provided!
	
	; Example of how to loop through the parameters
	Loop, Parse, parameters, CSV
		MsgBox Item %A_Index% is '%A_LoopField%'
	
	return, "This is some text returned by the dummy command."
}

;==========================================================
; Inserts the scripts containing the commands (i.e. string + function) to run.
; The scripts we are including should add commands and their associated functions.
;
; Example:
;	AddCommand("SQL", "Launch SQL Management Studio")
;	SQL()
;	{
;		Run "C:\Program Files (x86)\Microsoft SQL Server\100\Tools\Binn\VSShell\Common7\IDE\Ssms.exe"
;		return false	; (optional) Return false to not display the command text after running the command.
;	}
;==========================================================
#Include CommandScriptsToInclude.ahk

;==========================================================
; Hotkey to launch the Command Picker window.
;==========================================================
`::
	SetCapslockState, Off				; Turn CapsLock off after it was pressed
	CPLaunchCommandPicker()	
return

;==========================================================
; Launch the Command Picker window.
;==========================================================
CPLaunchCommandPicker()
{
	; Let this function know about the necessary global variables.
	global _cpWindowName, _cpActiveWindowID
	
	; If the Command Picker Window is not already open and in focus.
	if !WinActive(_cpWindowName)
	{
		_cpActiveWindowID := WinExist("A")	; Save the ID of the Window that was active when the picker was launched.
	}
	CPPutCommandPickerWindowInFocus()
}

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; Only process the following hotkeys in this Command Picker window.
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#IfWinActive, Choose a command to run

;==========================================================
; Intercept the Up and Down actions to move through the commands in the listbox.
;==========================================================
Up::CPForwardKeyPressToListBox("Up") return
Down::CPForwardKeyPressToListBox("Down") return
PgUp::CPForwardKeyPressToListBox("PgUp") return
PgDn::CPForwardKeyPressToListBox("PgDn") return
^Home::CPForwardKeyPressToListBox("Home") return	; Ctrl+Home to jump to top of list.
^End::CPForwardKeyPressToListBox("End") return		; Ctrl+End to jump to bottom of list.

CPForwardKeyPressToListBox(key = "Down")
{
	global _cpWindowName
	
	; If the Command Picker window is active and the Edit box (i.e. search box) has focus.
	ControlGetFocus, control, %_cpWindowName%
	if (%control% = Edit1)
	{
		; Move the selected command to the previous/next command in the list.
		ControlSend, ListBox1, {%key%}, %_cpWindowName%
	}
}

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; Return hotkeys back to being processed in all windows.
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#IfWinActive
   
;==========================================================
; Create the Command Picker window if necessary and put it in focus.
;==========================================================
CPPutCommandPickerWindowInFocus()
{
	; Let this function know that all variables except the passed in parameters are global variables.
	global _cpWindowName, _cpSearchedString
	
	; If the window is already open
	if WinExist(_cpWindowName)
	{		
		; Put the window in focus, and give focus to the text box.
		WinActivate, %_cpWindowName%
		ControlFocus, Edit1, %_cpWindowName%
	}
	; Else the window is not already open
	else
	{
		; Create the window	
		CPCreateCommandPickerWindow()

		; Make sure this window is in focus before sending commands
		WinWaitActive, %_cpWindowName%
		
		; If the window wasn't opened for some reason
		if Not WinExist(_cpWindowName)
		{
			; Display an error message that the window couldn't be opened
			MsgBox, There was a problem opening "%_cpWindowName%"
		
			; Exit, returning failure
			return false
		}
	}
}

;==========================================================
; Create and show the Command Picker Window.
;==========================================================
CPCreateCommandPickerWindow()
{
	; Let this function know about the necessary global variables.
	global _cpWindowName, _cpCommandList, _cpCommandArray, _cpCommandDelimiter, _cpCommandSelected, _cpSearchedString, _cpNumberOfCommandsToShow, _cpWindowWidthInPixels, _cpFontSize, _cpShowAHKScriptInSystemTray, _cpShowSelectedCommandWindow, _cpCommandParameterSeparator, _cpParameterNameValueSeparator, _cpCommandMatchMethod, _cpCommandParameterListSeparator, _cpParameterDelimiter, _cpCommandDescriptionSeparator
	
	; Define any static variables needed for the GUI.
	static commandListBoxContents := ""	; Will hold the commands currently being shown in the command list.
	static lastKeyPressWasSearchingParameters := false	; Tells if the last search performed was on the command's preset parameters or not.

	; Create the GUI.
	Gui 1:Default
	Gui, +AlwaysOnTop +Owner +OwnDialogs ToolWindow ; +Owner avoids a taskbar button ; +OwnDialogs makes any windows launched by this one modal ; ToolWindow makes border smaller and hides the min/maximize buttons.
	Gui, font, S%_cpFontSize%	; S=Size

	; Add the controls to the GUI.
	Gui Add, Edit, w%_cpWindowWidthInPixels% h20 v_cpSearchedString gSearchForCommand
	Gui Add, ListBox, Sort v_cpCommandSelected gCommandSubmittedByListBoxClick w%_cpWindowWidthInPixels% r%_cpNumberOfCommandsToShow% hscroll vscroll
	Gui Add, Button, gCommandSubmittedByButton Default, Run Command		; default makes this the default action when Enter is pressed.
	
	; Fill the ListBox with the commands.
	gosub, FillListBoxWithAllCommands
	
	; Create and attach the Menu Bar
	Menu, FileMenu, Add, &Close Window, MenuHandler
	Menu, FileMane, Add			; Separator
	Menu, FileMenu, Add, &Exit (stop script from running), MenuHandler
	Menu, SettingsMenu, Add, Show &Settings, MenuHandler
	Menu, MyMenuBar, Add, &File, :FileMenu
	Menu, MyMenuBar, Add, &Settings, :SettingsMenu
	Gui, Menu, MyMenuBar
	
	; Show the GUI, set focus to the input box, and wait for input.
	Gui, Show, AutoSize Center, %_cpWindowName%
	GuiControl, Focus, _cpSearchedString
	
	; Display a tooltip that we are waiting for a command to be entered.
	CPShowTooltip("Enter a command")
	
	return  ; End of auto-execute section. The script is idle until the user does something.

	MenuHandler:
		; File menu commands.
		if (A_ThisMenu = "FileMenu")
		{
			if (A_ThisMenuItem = "&Close Window")
				goto, GuiClose
			else if (A_ThisMenuItem = "&Exit (stop script from running)")
				ExitApp
		}
		; Settings menu commands.
		else if (A_ThisMenu = "SettingsMenu")
		{
			; Close this window and show the Settings window. When the Settings window is closed this window will be reloaded to show any changes.
			Gui, 1:Destroy			; Close the GUI, but leave the script running.
			CPShowSettingsWindow()	; Show the Settings window so the user can change settings if they want.
		}
	return
	
	SearchForCommand:
		Gui 1:Submit, NoHide		; Get the values from the GUI controls without closing the GUI.
	
		searchingWithParameters := false	; Mark that we are searching for the command, ignoring any parameters that may be supplied.
	
		; Get the user's search string, stripping off any parameters that may have been provided.
		searchText := _cpSearchedString
		StringGetPos, firstCommandParameterSeparatorPosition, _cpSearchedString, %_cpCommandParameterListSeparator%
		if (firstCommandParameterSeparatorPosition >= 0)
		{
			searchText := SubStr(_cpSearchedString, 1, firstCommandParameterSeparatorPosition)
		}			

		; Search for the command to select based on the user's input.
		gosub, PerformSearch
		
		; If parameters are being provided, narrow the listbox contents down to just the currently selected command and any preset parameters that it might have before performing the search.
		if (firstCommandParameterSeparatorPosition >= 0)
		{
			gosub, PerformSearchForPresetParameters
			
			; Record that this search was done on the preset parameters.
			lastKeyPressWasSearchingParameters := true
		}
		else
		{
			; Record that this search was NOT done on the preset parameters.
			lastKeyPressWasSearchingParameters := false
		}			
	return

	PerformSearch:
		indexThatShouldBeSelected := 0		; Assume that there are no matches for the given user string.
		currentSelectionsText := ""			; The text of the selected command that will be run.
	
		; Do the search using whatever search method is specified in the settings.
		if (_cpCommandMatchMethod = "Incremental")
			gosub, IncrementalSearch
		else
			gosub, CamelCaseSearch
		
		; Select the command in the list, using the index if we have it (faster than using string).
		; If currentSelectedText is empty then indexThatShouldBeSelected is likely 0, but we still use the index so that NO item gets selected.
		if (indexThatShouldBeSelected > 0 || currentSelectionsText = "")
			GuiControl Choose, _cpCommandSelected, %indexThatShouldBeSelected%
		else
			GuiControl Choose, _cpCommandSelected, %currentSelectionsText%
		
		; Display the currently selected command in the tooltip, and hide it after a bit of time.
		CPShowTooltip(_cpSearchedString . " (" . currentSelectionsText . ")")
	return
	
	PerformSearchForPresetParameters:
		; If the user is trying to enter parameters for a command that doesn't exist, just exit.
		if (_cpCommandSelected = "")
			return
		
		; Get the name of the currently selected command.
		commandName := CPGetCommandName(_cpCommandSelected)

		; Create a delimited list of the command's preset parameters.
		commandParameters := ""
		commandParametersArray := _cpCommandArray[commandName].Parameters
		Loop, Parse, commandParametersArray, %_cpParameterDelimiter%
		{
			parameterNameAndValue := A_LoopField
			
			; If this preset parameter has both a name and a value, strip them out to get the name.
			StringGetPos, firstDelimiterPosition, parameterNameAndValue, %_cpParameterNameValueSeparator%
			if (firstDelimiterPosition >= 0)
			{
				parameterName := SubStr(parameterNameAndValue, 1, firstDelimiterPosition)
				parameterValue := SubStr(parameterNameAndValue, firstDelimiterPosition + 2)	; +2 because SubStr starts at position 1 (not 0), and we want to start at the character AFTER the delimiter.
			}
			else
				parameterName := parameterNameAndValue

			; Append this parameter name to the list of parameters
			parameterName := Trim(parameterName)
			commandParameters .= _cpCommandDelimiter . commandName . _cpCommandParameterSeparator . " " . parameterName
		}

		; If we have some parameters, copy them into the ListBox contents (always have the parameterless command as the first item in the listbox).
		commandListBoxContents := _cpCommandArray[commandName].ToString()
		if (commandParameters != "")
			commandListBoxContents .= commandParameters

		; Sort the list of commands alphabetically.
		Sort, commandListBoxContents, D%_cpCommandDelimiter%

		; Refresh the list of words in the ListBox.
		GuiControl, -Redraw, _cpCommandSelected		; To improve performance, don't redraw the list box until all items have been added.
		GuiControl, , _cpCommandSelected, %_cpCommandDelimiter%%commandListBoxContents%	; Put a delimiter before the contents to clear the current listbox contents.
		GuiControl, +Redraw, _cpCommandSelected
		
		; Setup the searchText to use to search for.
		; Since the user may provide multiple parameters, we only want to search on the last parameter provided.
		StringGetPos, lastCommandParameterSeparatorPosition, _cpSearchedString, %_cpCommandParameterListSeparator%, R	; Search from the Right side of the string.
		searchText := SubStr(_cpSearchedString, 1, firstCommandParameterSeparatorPosition)	; Get the command text.
		searchText .= SubStr(_cpSearchedString, lastCommandParameterSeparatorPosition + 1)	; Append the last parameter provided.

		; Search for the item to select based on the user's input, now that we have populated the listbox with the preset parameters (if any).
		searchingWithParameters := true
		gosub, PerformSearch
		
		; If no matches were found, choose the parameterless command (should always be the first item in the listbox).
		if (currentSelectionsText = "")
			GuiControl Choose, _cpCommandSelected, 1
	return

	IncrementalSearch:			; The user changed the text in the Edit box.
		; If we are not searching through a command's preset parameters.
		if (searchingWithParameters = false)
		{
			; If the last keypress was searching parameters (and now this one isn't), refresh the Listbox contents to show all commands, since they would have been changed to only show the preset parameters.
			if (lastKeyPressWasSearchingParameters)
			{
				gosub, FillListBoxWithAllCommands
			}
		}
		; Else we are searching through a command's preset parameters.
		else
		{			
			; Since we now want to search through the parameters, but the user may not have provided the full command name, modify the searchedString so it looks like they did provide the full command name.
			searchedStringContentsAfterParameterSeparator := SubStr(searchText, firstCommandParameterSeparatorPosition + 2)	; +2 because SubStr first char position is 1 (not 0), and we don't want to include the CommandParameterSeparator.
			searchText := commandName . _cpCommandParameterSeparator . searchedStringContentsAfterParameterSeparator
		}
		
		; Incremental search will need to exactly match the listbox contents, and items are never removed in incremental mode so we can always just search the listbox contents.
		itemsToSearchThrough := commandListBoxContents
		
		searchedStringLength := StrLen(searchText)	; Get the length of the string the user entered.

		; Loop through each item in the ListBox to see if the typed text matches any of the items.
		Loop Parse, itemsToSearchThrough, %_cpCommandDelimiter%
		{
			StringLeft part, A_LoopField, searchedStringLength	; We only want to compare the number of characters that the user has typed so far.
			If (part = searchText)
			{
				indexThatShouldBeSelected := A_Index
				currentSelectionsText := A_LoopField
				break
			}
		}
	return
	
	CamelCaseSearch:
		matchingCommands := ""					; Will hold all of the commands that match the search string, so we know which ones to keep in the ListBox.
		lowestWordIndexMatchedAgainst = 9999	; Used to keep track of which command matched against the string in the least number of words (as we want to select that command by default).

		; If we are not searching through a command's preset parameters.
		if (searchingWithParameters = false)
		{
			; Because items are removed from the listbox in TypeAhead mode, we actually need to search the list of commands, so that when the user backspaces, items that were removed come back into the listbox.
			itemsToSearchThrough := _cpCommandList
		}
		; Else we are searching through a command's preset parameters.
		else
		{
			; Because we always repopulate the listbox contents with all preset parameters, we want to search through the listbox contents.
			itemsToSearchThrough := commandListBoxContents
			
			StringReplace, searchText, searchText, %_cpCommandParameterListSeparator%	; Strip the command-parameter list separator out so that it doesn't mess up the search.
		}

		; Loop through each command to see if the typed text matches any of the commands.
		Loop Parse, itemsToSearchThrough, %_cpCommandDelimiter%
		{
			; Skip empty entries (somehow an empty one gets added after backspacing out the entire search string).
			if (A_LoopField = "")
				continue
			
			; Get the commandLine to process.
			commandLine := A_LoopField
			
			; If we are not searching through preset parameters.
			if (searchingWithParameters = false)
			{
				; Let's only search the command name, so that the camel-case search doesn't include the command description when matching.
				commandLine := CPGetCommandName(commandLine)
			}
			
			; Strip any spaces out of the command name, as they just get in the way of the camel case matching.
			StringReplace, commandLine, commandLine, %A_Space%, , All
			
			; Also strip out the command-parameter separator so that it doesn't interfere.
			StringReplace, commandLine, commandLine, %_cpCommandParameterSeparator%
			
			; Break each camel-case word out of the Command Line by separating them with a space.
			; Regex Breakdown:	This will match against each word in Camel and Pascal case strings, while properly handling acrynoms.
			;	(^[a-z]+)								Match against any lower-case letters at the start of the command.
			;	([0-9]+)								Match against one or more consecutive numbers (anywhere in the string, including at the start).
			;	([A-Z]{1}[a-z]+)						Match against Title case words (one upper case followed by lower case letters).
			;	([A-Z]+(?=([A-Z][a-z])|($)|([0-9])))	Match against multiple consecutive upper-case letters, leaving the last upper case letter out the match if it is followed by lower case letters, and including it if it's followed by the end of the string or a number.
			words := RegExReplace(commandLine, "((^[a-z]+)|([0-9]+)|([A-Z]{1}[a-z]+)|([A-Z]+(?=([A-Z][a-z])|($)|([0-9]))))", "$1 ")
			words := Trim(words)
			
			; Split the string into an array at each space.
			StringSplit, wordArray, words, %A_Space%
			
			; Throw the array of words into an object so that we can pass it into the function below (array can't be passed directly by itself).
			camelCaseWordsInCommandLine := {}					; Create a new object to hold the array of words.
			camelCaseWordsInCommandLine.Length := wordArray0	; Record how many words are in the array.
			camelCaseWordsInCommandLine.Words := Object()		; Will hold the array of all words in the Command.
			Loop, %wordArray0%
			{
				camelCaseWordsInCommandLine.Words[%A_Index%] := wordArray%A_Index%
			}
			
			; Get if this command matches against the searched string, and how good the match is.
			lastWordIndexMatchedAgainst := CPCommandIsPossibleCamelCaseMatch(searchText, camelCaseWordsInCommandLine)

			; If we are searching through parameters, make sure that the parameterless command is always added to the listbox, but make sure it is given a high value so that it is not chosen over another potential match.
			if (searchingWithParameters && InStr(commandLine, _cpCommandDescriptionSeparator))
				lastWordIndexMatchedAgainst := 9999
			
			; If this Command matches the search string, add it to our list of Commands to be displayed.
			if (lastWordIndexMatchedAgainst > 0)
			{
				; Add this command to the list of matching commands.
				matchingCommands .= _cpCommandDelimiter . A_LoopField
				
				; We want to select the command whose match is closest to the start of the string.
				if (lastWordIndexMatchedAgainst < lowestWordIndexMatchedAgainst)
				{
					; Record the LowestWordIndex to beat and the command that should be selected so far.
					lowestWordIndexMatchedAgainst := lastWordIndexMatchedAgainst
					currentSelectionsText := A_LoopField
				}
				; If these two commands match against the same word index, pick the one that is lowest alphabetically.
				else if(lastWordIndexMatchedAgainst = lowestWordIndexMatchedAgainst)
				{
					if (A_LoopField < currentSelectionsText)
					{
						currentSelectionsText := A_LoopField
					}
				}
			}
		}

		; If we have some matches, copy the matches into the ListBox contents (leaving the leading delimiter as a signal to overwrite the existing contents), otherwise leave a delimiter character to clear the list.
		if (matchingCommands != "")
			commandListBoxContents := matchingCommands
		else
			commandListBoxContents := _cpCommandDelimiter

		; Refresh the list of words in the ListBox.
		GuiControl, -Redraw, _cpCommandSelected		; To improve performance, don't redraw the list box until all items have been added.
		GuiControl, , _cpCommandSelected, %commandListBoxContents%
		GuiControl, +Redraw, _cpCommandSelected
	return

	GuiSize:	; The user resized the window.
	
	return


	CommandSubmittedByButton:		; The user submitted a selection using the Enter key or the Run Command button.		
	   gosub, CommandSubmitted
	return
	
	CommandSubmittedByListBoxClick:	; The user submitted a selection by clicking in the ListBox.
		; Only allow double clicks to run a command.
		if (A_GuiEvent != "DoubleClick")
			return
		
		gosub, CommandSubmitted
	return
		
	CommandSubmitted:
		; Sleep for a short period of time to allow the GUI to update before we retrieve it's values.
		; This problem seemed to be introduced with Windows 8, where the text input does not keep up with how fast the
		; user types, and Enter triggers this command befor all of the text is in the textbox and the Listbox updated.
		Sleep, 50
		
		Gui 1:Submit, NoHide			; Get the values from the GUI controls without closing the GUI.	
		commandWasSubmitted := true		; Record that the user actually wants to run the selected command (e.g. not just exit).
		
		; If the user did not specify a valid command, don't process anything.
		if (_cpCommandSelected = "")
		{
			commandWasSubmitted := false
			return
		}
		
	GuiClose:			; The window was closed (by clicking X or through task manager).
	GuiEscape:			; The Escape key was pressed.
		Gui 1:Show, Hide	; Hide the GUI.
		CPHideTooltip()	; Hide the tooltip that we were showing.
	
		; If the user just wants to close the window (i.e. they didn't submit a command), destroy it and exit.
		if (commandWasSubmitted != true)
		{
			Gui, 1:Destroy	; Close the GUI, but leave the script running.
			return
		}
		; Else the user submitted a command.

		; Strip the Description off the command to get just the Command Name.
		commandName := CPGetCommandName(_cpCommandSelected)			

		; Get each provided parameter and store it in an array.
		StringSplit, parametersArray, _cpSearchedString, %_cpCommandParameterListSeparator%

		; If parameters were provided, get their proper values (since some may be preset parameters).
		parameters := ""
		if (parametersArray0 > 1)
		{
			; Loop over each parameter that was typed by the user.
			Loop, %parametersArray0%
			{				
				; Skip the first loop since it just contains the command name that the user typed.
				if (A_Index = 1)
					continue

				; If more than one parameter was provided (command name + 1 parameter = 2), select the value in the ListBox for this parameter.
				if (parametersArray0 > 2)
				{
					; Form a new string to search the listbox with, which is just the Command Name and this one parameter.
					_cpSearchedString := commandName . _cpCommandParameterListSeparator . parametersArray%A_Index%
					
					; Select the proper parameter value in the ListBox
					gosub, PerformSearchForPresetParameters
					Gui 1:Submit, NoHide	; Get the GUI's selected ListBox value.
				}

				; If a preset parameter was chosen (i.e. the command-parameter separator is found in the ListBox's selected command, and the command-description separator is not).
				StringGetPos, positionOfCommandParameterSeparator, _cpCommandSelected, %_cpCommandParameterSeparator%
				StringGetPos, positionOfCommandDescriptionSeparator, _cpCommandSelected, %_cpCommandDescriptionSeparator%
				if (positionOfCommandParameterSeparator >= 0 && positionOfCommandDescriptionSeparator < 0)
				{
					; Get the preset parameter value
					parameterValue := CPGetPresetParameterValues(commandName, SubStr(_cpCommandSelected, positionOfCommandParameterSeparator + 2))	; +2 becaues SubStr starts at 1 (not 0), and we want to start at the character AFTER the delimiter.
				}
				; Else get the custom parameter if one was specified.
				else
				{
					parameterValue := parametersArray%A_Index%
				}
				parameterValue := Trim(parameterValue)
				
				; If a parameter was provided, add it to the list of parameters.
				if (parameterValue != "")
				{
					; If this is not the first parameter, prepend it with the separator character.
					if (parameters = "")
						parameters := parameterValue
					else
						parameters .= _cpCommandParameterListSeparator . parameterValue 
				}
			}
		}

		; Destroy the GUI before running the selected command.
		Gui, 1:Destroy	; Close the GUI, but leave the script running.

		; Run the command with the given parameters.
		CPRunCommand(commandName, parameters)
	return

	FillListBoxWithAllCommands:
		; Copy the _cpCommandList into commandListBoxContents.
		commandListBoxContents := _cpCommandList
		
		; Sort the list of commands alphabetically.
		Sort, commandListBoxContents, D%_cpCommandDelimiter%
		
		; Refresh the list of words in the ListBox.
		GuiControl, -Redraw, _cpCommandSelected		; To improve performance, don't redraw the list box until all items have been added.
		GuiControl, , _cpCommandSelected, %_cpCommandDelimiter%%commandListBoxContents%	; Insert a delimiter onto the start of the list to clear the current listbox contents.
		GuiControl, +Redraw, _cpCommandSelected
	return
}

; Shows the given Tooltip for the specified amount of time.
CPShowTooltip(tooltipText = "", durationInMilliseconds = 3000)
{
	ToolTip, %tooltipText%
	SetTimer, HideToolTip, Off		; Restart the tooltip timer.
	SetTimer, HideTooltip, %durationInMilliseconds%
	return
	
	HideTooltip:
		CPHideTooltip()
	return
}

; Clears out and hides the Tooltip.
CPHideTooltip()
{
	SetTimer HideTooltip, Off
	Tooltip
}

; Returns whether the given searchText matches against the words in the Array or not.
CPCommandIsPossibleCamelCaseMatch(searchText, camelCaseWordsInCommandLine)
{	
	; Strip any spaces out of the user's string, as they just get in the way of the camel case matching.
	StringReplace, searchText, searchText, %A_Space%, , All
	
	; Get the number of characters that will need to be checked.
	lengthOfUsersString := StrLen(searchText)

	; Call recursive function to roll through each letter the user typed, checking to see if it's part of one of the command's words.
	return CPLetterMatchesPartOfCurrentWordOrBeginningOfNextWord(searchText, 1, lengthOfUsersString, camelCaseWordsInCommandLine.Words, 1, camelCaseWordsInCommandLine.Length, 1)
}

; Recursive function to see if the searchString characters sequentially match characters in the word array, where as long as the first character in the word
; was matched again, the searchString could then match against the next sequential characters in that word, or match against the start of the next word in the array.
; searchString = the user string that was entered.
; searchCharacterIndex = the current character of the searchString that we are trying to find a match for.
; searchStringLength = the number of characters in the searchString.
; wordArray = the camel case words in the Command Name to match the searchString against.
; wordIndex = the current word in the wordArray that we are looking to match against.
; numberOfWordsInArray = the number of words in the wordArray.
; wordCharacterIndex = the current character of the wordIndex word that we are looking for a match against.
CPLetterMatchesPartOfCurrentWordOrBeginningOfNextWord(searchString, searchCharacterIndex, searchStringLength, wordArray, wordIndex, numberOfWordsInArray, wordCharacterIndex)
{	
	; If all of the characters in the search string were matched, return true that this command is a possible match.
	if (searchCharacterIndex > searchStringLength)
	{
		; Return the index of the word that was last matched against.
		return %wordIndex%
	}

	; If we were asked to look against a word that doesn't exist, or past the last character in the word, just return false since we can't go any further on this path.
	if (wordIndex > numberOfWordsInArray || wordCharacterIndex > StrLen(wordArray%wordIndex%))
	{
		return 0
	}
	
	; Get the character at the specified character index
	character := SubStr(searchString, searchCharacterIndex, 1)
	
	; If the character matches in this word, then keep going down this path.
	if (character = SubStr(wordArray%wordIndex%, wordCharacterIndex, 1))
	{		
		; See if the next character matches the next character in the current word, or the start of the next word.
		match1 := CPLetterMatchesPartOfCurrentWordOrBeginningOfNextWord(searchString, searchCharacterIndex + 1, searchStringLength, wordArray, wordIndex, numberOfWordsInArray, wordCharacterIndex + 1)
		match2 := CPLetterMatchesPartOfCurrentWordOrBeginningOfNextWord(searchString, searchCharacterIndex + 1, searchStringLength, wordArray, wordIndex + 1, numberOfWordsInArray, 1)
		
		; If one or both of the paths returned a match.
		if (match1 > 0 || match2 > 0)
		{
			; Return the match with the lowest word index above zero (i.e. the one that matched closest to the start of the (array) string).
			if (match1 > 0 && match2 > 0)
				return match1 < match2 ? match1 : match2	; Returns the Min out of match1 and match2.
			else
				return match1 < match2 ? match2 : match1	; Returns the Max out of match1 and match2, since one of them is zero.
		}
		; Else neither path found a match so return zero.
		else
			return 0
	}
	; Otherwise the character doesn't match the current word.
	else
	{
		; See if this character matches the start of the next word.
		return CPLetterMatchesPartOfCurrentWordOrBeginningOfNextWord(searchString, searchCharacterIndex, searchStringLength, wordArray, wordIndex + 1, numberOfWordsInArray, 1)
	}
}

;==========================================================
; Run the given command.
;==========================================================
CPRunCommand(commandName, parameters)
{
	global _cpCommandArray, _cpShowSelectedCommandWindow, _cpShowSelectedCommandWindowWhenInfoIsReturnedFromCommand
	static _cpListOfFunctionsCurrentlyRunning, _cpListOfFunctionsCurrentlyRunningDelimiter := "|"

	; If the Command to run doesn't exist, display error and exit.
	if (!_cpCommandArray[commandName])
	{
		MsgBox, Command "%commandName%" does not exist.
		return
	}

	; Get the Command's Function to call.
	commandFunction := _cpCommandArray[commandName].FunctionName

	; If the Function to call doesn't exist, display an error and exit.
	if (!IsFunc(commandFunction))
	{	
		MsgBox Function "%commandFunction%" does not exist.
		return
	}

	; If we are already running the given function then exit with an error message, as running the same function concurrently may crash the AHK script.
	Loop Parse, _cpListOfFunctionsCurrentlyRunning, %_cpListOfFunctionsCurrentlyRunningDelimiter%
	{
		; Skip empty entries (somehow an empty one gets added after backspacing out the entire search string).
		if (A_LoopField = commandFunction)
		{
			CPDisplayTextOnScreen("COMMAND NOT CALLED!", "'" . commandName . "' is currently running so it will not be called again.")
			return
		}
	}

	; Record that we are running this function.
	_cpListOfFunctionsCurrentlyRunning .= commandFunction . _cpListOfFunctionsCurrentlyRunningDelimiter

	; If no parameters were given, but this command provides a default parameter, use the default parameter value.
	if (parameters = "" && _cpCommandArray[commandName].DefaultParameterValue != "")
		parameters := _cpCommandArray[commandName].DefaultParameterValue

	; Call the Command's function, only passing in parameters if they were supplied (so that default parameter values will be used by functions).
	if (parameters = "")
		textReturnedFromCommand := %commandFunction%()
	else
		textReturnedFromCommand := %commandFunction%(parameters)

	; Now that we are done running the function, remove it from our list of functions currently running.
	functionNameAndDelimeter := commandFunction . _cpListOfFunctionsCurrentlyRunningDelimiter
	StringReplace, _cpListOfFunctionsCurrentlyRunning, _cpListOfFunctionsCurrentlyRunning, %functionNameAndDelimeter%

	;~ ; Example of how to loop through the parameters
	;~ For index, value in parameters
		;~ MsgBox % "Item " index " is '" value "'"

	; If the setting to show which command was ran is enabled, and the command did not explicitly return telling us to not show the text, display the command text.
	if ((_cpShowSelectedCommandWindow || (_cpShowSelectedCommandWindowWhenInfoIsReturnedFromCommand && parameters != "")) && textReturnedFromCommand != false)
	{
		; Get the command's text to show.
		command := _cpCommandArray[commandName].ToString()
		
		; Display the Command's text on the screen, as well as any text returned from the command (i.e. the textReturnedFromCommand).
		CPDisplayTextOnScreen(command, textReturnedFromCommand)
	}
}

;==========================================================
; Parse the given command to pull the Command Name from it.
;==========================================================
CPGetCommandName(command)
{
	; Let this function know about the necessary global variables.
	global _cpCommandDescriptionSeparator, _cpCommandParameterSeparator
	
	; We're not sure if we are being given the Command+Description or Command+Parameter, so try and split against both.
	
	; Replace each Command-Description separator string with an accent symbol so that it is easy to split against (since we can only split against characters, not strings).
	StringReplace, command, command, %_cpCommandDescriptionSeparator%, ``, All
	
	; Replace each Command-Parameter separator string with an accent symbol so that it is easy to split against (since we can only split against characters, not strings).
	StringReplace, command, command, %_cpCommandParameterSeparator%, ``, All
	
	; Split the string at the accent symbol, and strip spaces and tabs off each element.
	StringSplit, commandArray, command,``, %A_Space%%A_Tab%
	
	; return the first element of the array, as that should be the command name.
	return %commandArray1%
}

;==========================================================
; Retrieves a preset parameter's value, given its Name and the command it is on.
;==========================================================
CPGetPresetParameterValues(commandName, presetParameterNames)
{
	; Let this function know about the necessary global variables.
	global _cpCommandArray, _cpParameterDelimiter, _cpParameterNameValueSeparator

	; String to hold the parameter values to be returned.
	parameterValues := ""

	; Loop through each of the given parameter Names.
	Loop, Parse, presetParameterNames, %_cpParameterDelimiter%
	{
		; Trim any whitespace off the preset parameter name so that we can match against it properly.
		presetParameterName := Trim(A_LoopField)
		
		; Variable to tell if we found a value for this presetParameterName or not.
		matchFound := false
		
		; Get the command's preset parameters and loop through each of them.
		presetParameters := _cpCommandArray[commandName].Parameters
		Loop, Parse, presetParameters, %_cpParameterDelimiter%
		{
			parameterNameAndValue := A_LoopField

			; If this preset parameter has both a name and a value, strip them out to get the value.
			StringGetPos, firstDelimiterPosition, parameterNameAndValue, %_cpParameterNameValueSeparator%
			if (firstDelimiterPosition >= 0)
			{
				parameterName := Trim(SubStr(parameterNameAndValue, 1, firstDelimiterPosition))
				parameterValue := SubStr(parameterNameAndValue, firstDelimiterPosition + 2)	; +2 because SubStr starts at position 1 (not 0), and we want to start at the character AFTER the delimiter.
			}
			else
			{
				parameterName := Trim(parameterNameAndValue)
				parameterValue := parameterNameAndValue
			}

			; If this is the parameter that we are looking for, append it to the parameter list to be returned and move on to the next parameter to process.
			if (presetParameterName = parameterName)
			{
				parameterValues := CPAppendParameterValueToEndOfList(parameterValues, parameterValue)
				matchFound := true
				break
			}
		}
		
		; If we couldn't find the parameter name in the list of preset parameters, assume this is a custom parameter and append it to the end of the list.
		if (matchFound = false)
			parameterValues := CPAppendParameterValueToEndOfList(parameterValues, presetParameterName)
	}

	; Return the list of parameter values that corresond to the list of parameter names we were given.
	return parameterValues
}

; Returns the given parameterList with the given parameterValue appended to the end of it, separated by the parameter delimiter if necessary.
CPAppendParameterValueToEndOfList(parameterList, parameterValue)
{
	global _cpParameterDelimiter
	
	; If the list is empty right now, just set it to this value, otherwise append this value to the end of the list, separating it from the previous paramter value with the delimiter.
	if (parameterList = "")
		parameterList := parameterValue
	else
		parameterList .= _cpParameterDelimiter . parameterValue
	
	return parameterList
}

;==========================================================
; Displays the Settings window to allow user to change settings.
;==========================================================
CPShowSettingsWindow()
{
	; Let this function know about the necessary global variables.
	global _cpWindowName, _cpNumberOfCommandsToShow, _cpWindowWidthInPixels, _cpFontSize, _cpShowAHKScriptInSystemTray, _cpCommandMatchMethod, _cpShowSelectedCommandWindow, _cpNumberOfSecondsToShowSelectedCommandWindowFor, _cpShowSelectedCommandWindowWhenInfoIsReturnedFromCommand, _cpNumberOfSecondsToShowSelectedCommandWindowForWhenInfoIsReturnedFromCommand
	
	; Define any static variables needed for the GUI.
	static commandMatchMethodDescription
	
	Gui 2:Default	; Specify that these controls are for window #2.
	
	; Create the GUI.
	Gui, +AlwaysOnTop +Owner ToolWindow ; +Owner avoids a taskbar button ; +OwnDialogs makes any windows launched by this one modal ; ToolWindow makes border smaller and hides the min/maximize buttons.

	; Add the controls to the GUI.
	Gui, Add, Checkbox, v_cpShowAHKScriptInSystemTray Checked%_cpShowAHKScriptInSystemTray%, Show AHK script in the system tray
	
	Gui, Add, GroupBox, x10 w500 r8, Command Picker Window Options:
		Gui, Add, Text, yp+25 x20, Number of commands to show:
		Gui, Add, Edit, x+5
		Gui, Add, UpDown, v_cpNumberOfCommandsToShow Range1-50, %_cpNumberOfCommandsToShow%
		
		Gui, Add, Text, yp+25 x20, Font size:
		Gui, Add, Edit, x+5
		Gui, Add, UpDown, v_cpFontSize Range5-25, %_cpFontSize%
		
		Gui, Add, Text, yp+25 x20, Window width (in pixels):
		Gui, Add, Edit, x+5
		Gui, Add, UpDown, v_cpWindowWidthInPixels Range100-2000, %_cpWindowWidthInPixels%
		
		Gui, Add, Text, yp+25 x20, Command search method:
		Gui, Add, DropDownList, x+5 v_cpCommandMatchMethod gCommandMatchMethodChanged Sort, Type Ahead|Incremental
		Gui, Add, Text, yp+25 x40 vcommandMatchMethodDescription w450 h45,
	
	;gui, add, text, xm w500 0x10  ;Horizontal Line
	
	Gui, Add, GroupBox, x10 w500 r3, Selected Command Window Options:
		Gui, Add, Checkbox, yp+25 x20 v_cpShowSelectedCommandWindow Checked%_cpShowSelectedCommandWindow% gShowSelectedCommandWindowToggled, Show selected command window (after picker closes) for
		Gui, Add, Edit, x+0 w50 v_cpNumberOfSecondsToShowSelectedCommandWindowFor, %_cpNumberOfSecondsToShowSelectedCommandWindowFor%
		;~ Gui, Add, UpDown, v_cpNumberOfSecondsToShowSelectedCommandWindowFor Range1-10, %_cpNumberOfSecondsToShowSelectedCommandWindowFor%
		Gui, Add, Text, x+5, seconds.
		Gui, Add, Checkbox, yp+25 x20 v_cpShowSelectedCommandWindowWhenInfoIsReturnedFromCommand Checked%_cpShowSelectedCommandWindowWhenInfoIsReturnedFromCommand% gShowSelectedCommandWindowWhenInfoIsReturnedFromCommandToggled, Show selected command window when command returns info for 
		Gui, Add, Edit, x+0 w50 v_cpNumberOfSecondsToShowSelectedCommandWindowForWhenInfoIsReturnedFromCommand, %_cpNumberOfSecondsToShowSelectedCommandWindowForWhenInfoIsReturnedFromCommand%
		Gui, Add, Text, x+5, seconds.
	
	Gui, Add, Button, gSettingsCancelButton xm, Cancel
	Gui, Add, Button, gSettingsSaveButton x+400, Save
	
	GuiControl, Choose, _cpCommandMatchMethod, %_cpCommandMatchMethod%
	gosub, CommandMatchMethodChanged	; Display the description of the currently selected Command Match Method.
	
	; Show the GUI, set focus to the input box, and wait for input.
	Gui, Show, AutoSize Center, %_cpWindowName% - Settings
	
	return  ; End of auto-execute section. The script is idle until the user does something.
	
	CommandMatchMethodChanged:
		Gui 2:Submit, NoHide	; Get the values from the GUI controls without closing the GUI.

		; Update the shown description based on which search method is selected.
		if (_cpCommandMatchMethod = "Type Ahead")	
			GuiControl, , Static5, - Matches against Camel/Pascal Casing of any part of the command name.`n- Filters the list as you type to only show possible matches.`nE.g. 'WebBro', 'WB', 'B', and 'Brow' would all match against a 'WebBrowser' command.
		else
			GuiControl, , Static5, - Only matches against the command name exactly.`n- Will not filter the list as you type.`nE.g. 'WebBro' would match against a 'WebBrowser' command.
	return
	
	ShowSelectedCommandWindowToggled:
		Gui 2:Submit, NoHide	; Get the values from the GUI controls without closing the GUI.
		
		; If ShowSelectedCommandWindow is checked, also check off the ShowSelectedCommandWindowWhenInfoIsReturnedFromCommand checkbox.
		if (_cpShowSelectedCommandWindow)
			GuiControl, , Button5, 1
	return
	
	ShowSelectedCommandWindowWhenInfoIsReturnedFromCommandToggled:
		Gui 2:Submit, NoHide	; Get the values from the GUI controls without closing the GUI.
		
		; If ShowSelectedCommandWindowWhenInfoIsReturnedFromCommand is unchecked, also uncheck the ShowSelectedCommandWindow checkbox.
		if (_cpShowSelectedCommandWindowWhenInfoIsReturnedFromCommand = false)
			GuiControl, , Button4, 0
	return
		
	SettingsSaveButton:		; Settings Save button was clicked.
		Gui 2:Submit, NoHide	; Get the values from the GUI controls without closing the GUI.
		CPSaveSettings()	; Save the settings before loading them again.
	
	SettingsCancelButton:	; Settings Cancel button was clicked.
	2GuiClose:				; The window was closed (by clicking X or through task manager).
	2GuiEscape:				; The Escape key was pressed.
		CPLoadSettings()	; If user pressed Cancel the old settings will be loaded. If they pressed Save the saved settings will be loaded.
		Gui, 2:Destroy		; Close the GUI, but leave the script running.
		CPLaunchCommandPicker()	; Re-launch the Command Picker.
	return	
}

;==========================================================
; Displays the given text on the screen for a given duration.
;==========================================================
CPDisplayTextOnScreen(title, text = "")
{
	; Import any required global variables.
	global _cpNumberOfSecondsToShowSelectedCommandWindowFor, _cpNumberOfSecondsToShowSelectedCommandWindowForWhenInfoIsReturnedFromCommand
	
	titleFontSize := 24
	textFontSize := 16
	
	; Shrink the margin so that the text goes up close to the edge of the window border.
	windowMargin := titleFontSize * 0.1
	
	Gui 3:Default	; Specify that these controls are for window #3.
	
	; Create the transparent window to display the text
	backgroundColor = DDDDDD  ; Can be any RGB color (it will be made transparent below).
	Gui +LastFound +AlwaysOnTop -Caption +ToolWindow +Border  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
	Gui, Margin, %windowMargin%, %windowMargin%
	Gui, Color, %backgroundColor%
	Gui, Font, s%titleFontSize% bold
	Gui, Add, Text,, %title%
	Gui, Font, s%textFontSize% norm
	if (text != "")
		Gui, Add, Text,, %text%
	WinSet, TransColor, FFFFFF 180	; Make all pixels of this color transparent (shouldn't be any with color FFFFFF) and make all other pixels semi-transparent.
	Gui, Show, AutoSize Center NoActivate  ; NoActivate avoids deactivating the currently active window.
	
	; Set the window to close after the given duration.
	if (text = "")
		durationToShowWindowForInMilliseconds := _cpNumberOfSecondsToShowSelectedCommandWindowFor * 1000
	else
		durationToShowWindowForInMilliseconds := _cpNumberOfSecondsToShowSelectedCommandWindowForWhenInfoIsReturnedFromCommand * 1000
	SetTimer, CloseWindow, %durationToShowWindowForInMilliseconds%
	;SetTimer, FadeOutText, 200	; Update every 200ms.
	return

	FadeOutText:
		
	return

	CloseWindow:
		SetTimer, CloseWindow, Off		; Make sure the timer doesn't fire again.
		Gui, 3:Destroy					; Close the GUI, but leave the script running.
	return
}


;==========================================================
; Adds the given command to our global list of commands.
;==========================================================
AddCommand(functionName, descriptionOfWhatFunctionDoes = "", parameterList = "", defaultParameterValue = "")
{
	AddNamedCommand(functionName, functionName, descriptionOfWhatFunctionDoes, parameterList, defaultParameterValue)
}

; commandName = The name of the command to appear in the Command Picker.
; functionName = The function to call when this command is selected to run.
; descriptionOfWhatFunctionDoes = A user-friendly message that will appear in the Command Picker telling what the command does.
; parameterList = A pre-set list of parameters to choose from in the Command Picker when this command is selected.
;				  Parameter values should be separated by a comma, and if you would like your parameter to show a different name in the GUI, separate the name from the value with a pipe character (|) (e.g. "Name1|Value1, Value2, Name3|Value3").
; defaultParameterValue = The parameter value that will be passed to the function when no other parameter is given.
AddNamedCommand(commandName, functionName, descriptionOfWhatFunctionDoes = "", parameterList = "", defaultParameterValue = "")
{
	global _cpCommandList, _cpCommandArray, _cpCommandDelimiter, _cpCommandDescriptionSeparator, _cpCommandParameterSeparator, _cpCommandParameterListSeparator
	
	; Trim all of the given values.
	commandName := Trim(commandName)
	functionName := Trim(functionName)
	descriptionOfWhatFunctionDoes := Trim(descriptionOfWhatFunctionDoes)
	parameterList := Trim(parameterList)
	defaultParameterValue := Trim(defaultParameterValue)
	
	; The Command Names should be unique, so make sure it is not already in the list.
	if (_cpCommandArray[commandName])
	{
		MsgBox, The command '%commandName%' has already been added to the list of commands. Command names should be unique.
		return
	}
	
	; Make sure the Command Name does not contain any special strings that we parse on.
	if (InStr(commandName, _cpCommandDescriptionSeparator))
	{
		MsgBox, The command '%commandName%' is not allowed to contain the special string '%_cpCommandDescriptionSeparator%'. You must remove this string from the command's name before it will be allowed.
		return
	}
	if (InStr(commandName, _cpCommandParameterSeparator))
	{
		MsgBox, The command '%commandName%' is not allowed to contain the special string '%_cpCommandParameterSeparator%'. You must remove this string from the command's name before it will be allowed.
		return
	}
	if (InStr(commandName, _cpCommandParameterListSeparator))
	{
		MsgBox, The command '%commandName%' is not allowed to contain the special string '%_cpCommandParameterListSeparator%'. You must remove this string from the command's name before it will be allowed.
		return
	}
	
	; Remove any whitespace around the parameter.
	; Ideally this regex would be the following, but it breaks at run-time since ',' is a special character:
	; RegExReplace(parameters, "(\s*%_cpParameterDelimiter%\s*)", "%_cpParameterDelimiter%")
	parameterList := RegExReplace(parameterList, "(\s*,\s*)", ",")

	; Create the command object and fill its properties.
	command := {}
	command.CommandName := commandName
	command.FunctionName := functionName
	command.Description := descriptionOfWhatFunctionDoes
	command.Parameters := parameterList
	command.DefaultParameterValue := defaultParameterValue
	command.ToString := Func("CPCommand_ToString")
	
	; Add the command into the Command Array.
	_cpCommandArray[commandName] := command
	
	; Add the command into our delimited list of commands string.
	commandString := commandName . " " . _cpCommandDescriptionSeparator . " " . descriptionOfWhatFunctionDoes
	if (_cpCommandList = "")
		_cpCommandList := commandString
	else
		_cpCommandList .= _cpCommandDelimiter . commandString
}

; Defines the ToString() function for our Command objects.
CPCommand_ToString(this)
{	global _cpCommandDescriptionSeparator
	return this.CommandName . " " . _cpCommandDescriptionSeparator . " " . this.Description
}

; Calls the AddNamedCommand() function for each command in the commandList.
; Each command in the list will call the given functionName, supplying the command's specific value as a parameter to the function.
; commandList = The commands to show up in the picker that will call the function, separated with _cpParameterDelimiter (a comma by default).
;				Separate the command name that appears in the picker and the value to pass to the function with _cpCommandNameValueSeparator (a pipe character | by default).
;				If no pipe character is provided, the given value will be both shown in the picker and passed to the function.
; prefix = The prefix to add to the beginning of all the command names in the commandList.
; postfix = The postfix to add to the end of all the command names in the commandList.
AddCommandsWithPrePostfix(functionName, descriptionOfWhatFunctionDoes = "", commandList = "", prefix = "", postfix = "")
{	
	global _cpCommandNameValueSeparator, _cpParameterDelimiter
	
	; Trim the given values that won't be passed explicitly into AddNamedCommand to be trimmed.
	commandList := Trim(commandList)
	prefix := Trim(prefix)
	postfix := Trim(postfix)
	
	; Loop through each command in the commandList
	Loop, Parse, commandList, %_cpParameterDelimiter%
	{
		commandNameAndValue := A_LoopField
		
		; If this command has both a name and a value, strip them out.
		StringGetPos, firstDelimiterPosition, commandNameAndValue, %_cpCommandNameValueSeparator%
		if (firstDelimiterPosition >= 0)
		{
			commandName := SubStr(commandNameAndValue, 1, firstDelimiterPosition)
			commandValue := SubStr(commandNameAndValue, firstDelimiterPosition + 2)	; +2 because SubStr starts at position 1 (not 0), and we want to start at the character AFTER the delimiter.
		}
		; Otherwise use the value for both.
		else
		{
			commandName := commandNameAndValue
			commandValue := commandNameAndValue
		}

		; Add this command to the list of cmmands.
		commandName := prefix . Trim(commandName) . postfix
		commandValue := Trim(commandValue)
		AddNamedCommand(commandName, functionName, descriptionOfWhatFunctionDoes, commandValue, commandValue)
	}
}

AddCommands(functionName, descriptionOfWhatFunctionDoes = "", commandList = "")
{
	AddCommandsWithPrePostfix(functionName, descriptionOfWhatFunctionDoes, commandList)
}

;~ ; Example of how to add a named command.
;~ AddNamedCommand("FF", "FireFox", "Opens Firefox", "xnaparticles.com, dpsf.com, digg.com")
;~ FireFox(website = "")
;~ {
	;~ ; Code to open website in firefox goes here.
;~ }

;~ ; Example of how to use AddCommands()
;~ AddCommands("OpenDirectory", "Opens the specified directory in Windows Explorer", "exploreC|C:\, exploreDPSF|C:\DPSF, C:\Windows")
;~ OpenDirectory(path = "")
;~ {
	;~ Run, explore %path%
;~ }

;==========================================================
; Shows or Hides the Tray Icon for this AHK Script.
;==========================================================
CPShowAHKScriptInSystemTray(show)
{
	; If we should show the Tray Icon.
	if (show)
		menu, tray, Icon
	; Else hide the Tray Icon.
	else
		menu, tray, NoIcon
}

;==========================================================
; Adds the given parameter to parameter string
;==========================================================
AddParameterToString(ByRef parametersString, parameterToAdd)
{	global _cpParameterDelimiter
	if (parametersString = "")
		parametersString := parameterToAdd
	else
		parametersString .= _cpParameterDelimiter . parameterToAdd
}

