
array := Array("Release", "ServPack", "Custom")

; short-hand would be:
; array := object( 1, "This", 2, "is", 3, "an", 4, "array" )

Gui, Add, ListView, r5 w300 gMyListView, Branch|Version|Date|Path

Loop, % array.MaxIndex()
{
	   ;MsgBox, % array[ A_Index ]
	   build := array[ A_Index ]
	   
	   
	;; Find newest installer
	Loop, \\draven\Builds\SalesPad_4_%build%\*, 2, 0
	{
		 FileGetTime, Time, %A_LoopFileFullPath%, C
		 If (Time > Time_Orig)
		 {
			  Time_Orig := Time
			  Folder := A_LoopFileName
		 }
	}
	Time_Orig = 0

	msgbox % build . " : " . Folder . " : " . A_Index
	Loop, \\draven\Builds\SalesPad_4_%build%\%Folder%\*Release.exe
	{
		File := A_LoopFileName
		FullFile := A_LoopFileFullPath
		CreatedTime := A_LoopFileTimeCreated
		times .=  "`r" . CreatedTime
	}
	   
	; Create the ListView with two columns, Name and Size:
	

	; Gather a list of file names from a folder and put them into the ListView:

	   ;FormatTime, CreatedTime,CreatedTime, h:mm MM/d
	   LV_Add("", array[ A_Index ], Folder, CreatedTime, FullFile)
	   msgbox % CreatedTime
   
}
msgbox % times


LV_ModifyCol()  ; Auto-size each column to fit its contents.
LV_ModifyCol(2, "Integer")  ; For sorting purposes, indicate that column 2 is an integer.

; Display the window and return. The script will be notified whenever the user double clicks a row.
Gui, Show,,Latest Builds
return

MyListView:
if A_GuiEvent = DoubleClick
{
    LV_GetText(RowText, A_EventInfo, 4)  ; Get the text from the row's first field.
    ;ToolTip You double-clicked row number %A_EventInfo%. Text: "%RowText%"
	Run, %RowText%
	
	
	
	ExitApp
}
return

Esc::
	ExitApp

GuiClose:  ; Indicate that the script should exit automatically when the window is closed.
ExitApp