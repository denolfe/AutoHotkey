;=================================================
;==     Lightning Renamer by no1readsthese      ==
;==                Version 1.5                  ==
;=================================================

;=================================================
;==Features=======================================
;== - Options:                                  ==
;==      Spacing                                ==
;==      Case Correction                        ==
;==      String Replacement                     ==
;==      Insert String                          ==
;==      Insert Counter                         ==
;==      Bracket Deletion                       ==
;==      Character Deletion                     ==
;==      Amber's Counter                        ==
;==      Rename From List                       ==
;==      Regular Expression                     ==
;==      Custom Rename                          ==
;== - Use Batches To Set Up Multiple Renaming   ==
;==    Options                                  ==
;== - Undo Button To Undo Stuff                 ==
;== - You Can Use The Command Line Or           ==
;==    Drag `n Drop Files And Folders On To     ==
;==    The Script File (Not Gui) To Rename      ==
;==    Using The Default Batch Without Opening  ==
;==    The GUI                                  ==
;=================================================
;==Wish List======================================
;== - MP3 Tag Info Option To Work               ==
;== - An Option To Apply The Changes To         ==
;==    The Extention                            ==
;== - Optimize Algorithms For Speed             ==
;== - Any Suggestions Are Appreciated           ==
;=================================================
;=================================================

/* 
Change Log:
v1.0
   - Inital Release
v1.1
   - Multiple Batches
   - Real Time Preview For Custom Option
   - Changed Delete/DeleteAll To Clear/ClearAll
   - Added "Clear Dead" Button
v1.2
   - Added Amber's Counter Option
v1.3
   - Files Renamed To An Existing File's Name Will Be Renamed With '_1' Or Something Similar At The End
   - Real Time Preview For Regular Expression Option
   - Added Rename From List Option
   - Fixed Some Minor Bugs
v1.4
   - Added Undo Button
   - Fixed '0 Read As Blank' Bug
v1.5
   - Fixed Renaming Conflict Bug
*/

/*
Thanks To:
 - Keybored For Suggestions
 - Razlin For Reporting Bugs
 - TBetti For Suggestions and Reporting Bugs
*/

;=================================================
;================Auto-Execute=====================
;=================================================

#NoTrayIcon
#NoEnv
#SingleInstance OFF
SetWorkingDir, %A_ScriptDir%
If 0>0
  {
    GoSub, ProcessCommandLine
    ExitApp
  }
ScriptName:="Lightning Renamer 1.5"
Gosub, ReadINIFile
Gosub, BuildGUI
Return

;=================================================
;==================Build Gui======================
;=================================================

BuildGUI:
  FileLabel := "  Files  "
  ActionLabel := "  Actions  "
  BatchLabel := "  Batch Rename  "
  Blank := "                  "
  B := "             "
  TemplateHelp=
    (
Notes:
    - `%name`% = Original File Name (Without Extention)
    - `%ext`% = Original Extention (With the Dot)
    - `%list`% = Items Off of the List Described in the Rename Using A List Section
    - `%num`% = Counter Described in the Insertion Section ( Starting at
    )
  RegExNotes=
    (
Notes:
    - 'Regular Expression' Field Should Contain a Perl-Compatible Regular Expression (PCRE) Pattern
      That Includes the Extention
    - 'New Name' Field Should Contain the File's New Name Implimenting Backreferences
      ie: $1 - $9 and ${10} +
    - Can Be Used as RegExReplace By Placing the Replacement String in the New Name Field
    - For More, See
    )
  AmberText=
    (
- Click The Button To Open The Renaming Window
- Drag N' Drop Files On Renaming Window To Rename Using The Counter Below
- The Renamed File Will Be Taken Off The File List 
- Counter Resets When Renaming Window Is Closed
`nCounter:
    )
  ListNotes=
    (
Notes:
    - Each Line From This List Will Be Used As A Name For A File. Items Are Used Sequentially
    - If Lines Are Empty Or If There Are Not Enough Line, The Corresponding Files Will Not Be Renamed
    )
  PreviousAction =
  AList:="start,Spacing,Case Correction,String Replacement,Insertion,Bracket Deletion,Character Deletion,Amber's Counter,Rename From List,Regular Expression,Custom,"
  StringSplit, ArrayList, AList, `,
  cnt:=ArrayList%0%
  StringReplace, ListOfBatchNames, ListOfBatchNames, ||, |, All
  StringReplace, ListOfBatchNames, ListOfBatchNames, |, ||

  ; Menus
  Menu, FileContextMenu, Add, Clear Selected, ClearFileListRows
  Menu, FileContextMenu, Add, Clear Dead, ClearDeadFileListRows
  Menu, FileContextMenu, Add, Clear All, ClearAllFileListRows
  Menu, FileContextMenu, Add
  Menu, FileContextMenu, Add, Properties, ContextProperties
  Menu, StringReplaceContextMenu, Add, Edit, EditSRL
  Menu, StringReplaceContextMenu, Add
  Menu, StringReplaceContextMenu, Add, Move Up, MoveUpSRL
  Menu, StringReplaceContextMenu, Add, Move Down, MoveDownSRL
  Menu, StringReplaceContextMenu, Add
  Menu, StringReplaceContextMenu, Add, Remove, RemoveSRL
  Menu, StringReplaceContextMenu, Add, Remove All, ClearSRL
  Menu, BatchContextMenu, Add, Move Up, MoveUpBL
  Menu, BatchContextMenu, Add, Move Down, MoveDownBL
  Menu, BatchContextMenu, Add
  Menu, BatchContextMenu, Add, Remove, RemoveBL
  Menu, BatchContextMenu, Add, Remove All, RemoveAllBL
  Menu, BatchNameContextMenu, Add, Load, LoadBatch
  Menu, BatchNameContextMenu, Add, Rename, RenameBatchName
  Menu, BatchNameContextMenu, Add
  Menu, BatchNameContextMenu, Add, Delete, DeleteBatch
  Menu, UndoContextMenu, Add, Undo Last, UndoLastRename
  Menu, UndoContextMenu, Add, Undo Session, UndoSession
  Menu, FileContextMenu, Default, Properties
  Menu, StringReplaceContextMenu, Default, Edit
  Menu, BatchContextMenu, Default, Remove
  Menu, BatchNameContextMenu, Default, Load

  ; Outside of Tabs
  Gui, Add, GroupBox, x5 y365 w690 h80, Preview
  Gui, Add, Text, xp+15 yp+25, Current File Name:`n`nNew File Name:
  Gui, Add, Text, x130 y390 w425 h50 vPreviewBatchShow
  Gui, Add, Button, x+5 yp+10 w40 h35 Disabled vUndoButton gUndoLastRename, Undo
  Gui, Add, Tab2, x5 y5 w690 h350 vTabs, %FileLabel%||%ActionLabel%|%BatchLabel%


  ; Inside File Tab
    Gui, Tab, 1
        Gui, Add, Button, x15 y40 w90 h20 gGUIFiles, Add Files
        Gui, Add, Button, x115 y40 w90 h20 gGUIFolder, Add Folder
        Gui, Add, Checkbox, x230 y40 h20 vSubFolder Checked%SubFolder%, Include Sub-Folders
        Gui, Add, Button, x395 y40 w90 h20 gClearFileListRows, Clear Sel.
        Gui, Add, Button, xp+100 y40 w90 h20 gClearDeadFileListRows, Clear Dead
        Gui, Add, Button, x595 y40 w90 h20 gClearAllFileListRows, Clear All
        Gui, Add, ListView, x15 y70 w670 h270 vFileList NoSortHdr, File Name|Folder|Type
        LV_ModifyCol(1, 100)
        LV_ModifyCol(2, 200)
        LV_ModifyCol(3, 40)
        Gui, Add, Button, x605 y385 w80 h50 gRenameBatchButton, Rename`nFiles

        ; Inside Action Tab
          Gui, Tab, 2
          Gui, Add, ListBox, x15 y40 w150 h270 vActionList gActionList, Spacing||Case Correction|String Replacement|Insertion|Bracket Deletion|Character Deletion|Amber's Counter|Rename From List|Regular Expression|Custom
          Gui, Add, Button, x45 y310 w90 h30 vAddToBatch gAddGUI, Add To Batch
          Gui, Add, Text, x130 y390 w425 h50 vPreviewShow
          Gui, Add, Button, x605 y385 w80 h50 vRenameButton gRenameButton, Rename`nFiles

          ; Spacing Options
          Gui, Add, GroupBox, x175 y40 w510 h130 vSpaceGroup
          Gui, Add, Checkbox, x185 y60 h30 vDelExtraSpace gPreview Checked%DelExtraSpace%, Remove Extra Spacing
          Gui, Add, Checkbox, x185 yp+30 h30 vDotToSpace gPreview Checked%DotToSpace%, . (dot) => Space
          Gui, Add, Checkbox, x295 yp h30 vCommaToSpace gPreview Checked%CommaToSpace%, , (comma) => Space
          Gui, Add, Checkbox, x425 yp h30 vUnderToSpace gPreview Checked%UnderToSpace%, _ => Space
          Gui, Add, Checkbox, x185 yp+30 h30 vSkipNumSeq gPreview Checked%SkipNumSeq%, Skip Number Sequences (ex. 1.2.3)

          ; Case Correction
          Gui, Add, Radio, x185 y60 h30 vCapFirst gPreview Checked%CapFirst%, Capitalize first word
          Gui, Add, Radio, xp yp+30 h30 vCapAll gPreview Checked%CapAll%, Capitalize Every Word
          Gui, Add, Radio, xp yp+30 h30 vUppercase gPreview Checked%Uppercase%, ALL UPPER CASE
          Gui, Add, Radio, xp yp+30 h30 vLowercase gPreview Checked%Lowercase%, all Lower case
          Gui, Add, Radio, xp yp+30 h30 vInvertCase gPreview Checked%InvertCase%, iNVERT cASE

          ; Brackets Options
          Gui, Add, Text, x185 y60 vBracketText1, Bracket Type:
          Gui, Add, Radio, x205 y80 vSquareBracket gPreview Checked%SquareBracket%, [ ... ]
          Gui, Add, Radio, x255 y80 vCurlyBracket gPreview Checked%CurlyBracket%, { ... }
          Gui, Add, Radio, x305 y80 vRoundBracket gPreview Checked%RoundBracket%, ( ... )
          Gui, Add, Checkbox, x185 y120 vOpenBracket gPreview Checked%OpenBracket%, Include Open Brackets:  ' ... ] '  or  ' [ ... '
          Gui, Add, Text, x185 yp+40 vBracketText2, Start from:
          Gui, Add, Radio, x205 yp+20 vStartLeft gPreview Checked%StartLeft%, Left Side
          Gui, Add, Radio, x290 yp vStartRight gPreview Checked%StartRight%, Right Side
          Gui, Add, Text, x185 yp+40 vBracketText3, Number of Bracket Blocks to Delete:
          Gui, Add, Radio, x205 yp+20 vDelAllBracket gPreview Checked%DelAllBracket%, Delete All
          Gui, Add, Radio, x330 yp vDelNumBracket gPreview Checked%DelNumBracket%, Delete Only
          Gui, Add, Edit, x350 yp+20 w40 vNumBracket gPreview Limit2
          Gui, Add, UpDown, vNumBracket2 Range1-99, %NumBracket%
          Gui, Add, Text, x340 yp+30 vBracketText4, Bracket Block

          ; String Replacement Options
          Gui, Add, Text, x175 y40 vStringReplaceText, Search For:%Blank% %B% %B%Replaced By:
          Gui, Add, Edit, x190 y60 w150 vSearchField
          Gui, Add, Edit, x380 y60 w150 vReplaceField
          Gui, Add, Button, x580 y50 w90 h25 vAddStringReplace gAddStringReplace, Add
          Gui, Add, ListView, x180 y110 w380 h230 vStringReplaceList Grid NoSortHdr -Multi, Search For|Replace By
          LV_ModifyCol(1, 187)
          LV_ModifyCol(2, 187)
          Gui, Add, Checkbox, x580 y110 vReplaceAll gPreview Checked%ReplaceAll%, Replace `nAll Occurrences
          Gui, Add, Checkbox, x580 y150 vReplaceWithCase gPreview Checked%ReplaceWithCase%, Case Sensitive
          Gui, Add, Button, x608 y170 w30 h30 vMoveUpSRL gMoveUpSRL, /\
          Gui, Add, Button, x608 y205 w30 h30 vMoveDownSRL gMoveDownSRL, \/
          Gui, Add, Button, x578 y310 w90 h30 vClearSRL gClearSRL, Remove All
          Gui, Add, Button, x578 yp-35 w90 h30 vRemoveSRL gRemoveSRL, Remove
          Gui, Add, Button, x578 yp-35 w90 h30 vEditSRL gEditSRL, Edit

          ; Insertion Options
          Gui, Add, GroupBox, x175 y40 w510 h80 vInsertStringGroup, %Blank%
          Gui, Add, GroupBox, x175 y130 w510 h80 vInsertCounterGroup, %Blank%
          Gui, Add, Radio, x185 y36 vInsertStringRadio gPreview Checked%InsertStringRadio%, Insert String:
          Gui, Add, Radio, x185 y126 vInsertCounterRadio gPreview Checked%InsertCounterRadio%, Insert Counter:
          Gui, Add, Text, x185 y60 vInsertStringText, String to Insert:
          Gui, Add, Edit, x205 y80 w400 vInsertString gPreview, %InsertString%
          Gui, Add, Text, x185 y150 vInsertCounterText, Start At:%B%%B%Number of Digits:%B%   Increment by:
          Gui, Add, Edit, x200 y170 w50 vCounterStart gPreview
          Gui, Add, UpDown, vCounterStart2, %CounterStart%
          Gui, Add, Edit, x320 y170 w50 vCounterDigits gPreview
          Gui, Add, UpDown, vCounterDigits2 Range1-10, %CounterDigits%
          Gui, Add, Edit, x450 y170 w50 vCounterIncrement gPreview
          Gui, Add, UpDown, vCounterIncrement2 Range1-1000000, %CounterIncrement%
          Gui, Add, Checkbox, xp+90 y150 vAddSpaceBefore gPreview Checked%AddSpaceBefore%, Add a Space Before
          Gui, Add, Checkbox, xp yp+30 vAddSpaceAfter gPreview Checked%AddSpaceAfter%, Add a Space After
          Gui, Add, Text, x185 y240 vInsertAtPositionText, At Position:
          Gui, Add, Edit, x200 y260 w50 vInsertAtPosition gPreview
          Gui, Add, UpDown, vInsertAtPosition2, %InsertAtPosition%
          Gui, Add, Radio, x280 y260 vInsertFromBeginning gPreview Checked%InsertFromBeginning%, From Beginning
          Gui, Add, Radio, x400 y260 vInsertFromEnd gPreview Checked%InsertFromEnd%, From End

          ; Char Deletion Options
          Gui, Add, Text, x185 y60 vCharDel, Number of Characters to Delete:
          Gui, Add, Edit, xp+25 yp+20 w50 vCharDelCount gPreview
          Gui, Add, UpDown, vCharDelCount2 Range1-100, %CharDelCount%
          Gui, Add, Radio, x185 y170 vDelAfter gPreview Checked%DelAfter%, After the String:
          Gui, Add, Radio, x320 yp vDelBefore gPreview Checked%DelBefore%, Before the String:
          Gui, Add, Radio, x185 y115 vDelFromPositionText gPreview Checked%DelFromPositionText%, From Position:
          Gui, Add, Edit, xp+25 yp+20 w50 vDelFromPosition gPreview
          Gui, Add, UpDown, vDelFromPosition2, %DelFromPosition%
          Gui, Add, Radio, x280 yp+3 vDelFromBeginning gPreview Checked%DelFromBeginning%, From Beginning
          Gui, Add, Radio, xp+130 yp vDelFromEnd gPreview Checked%DelFromEnd%, From End
          Gui, Add, Edit, x210 y190 w400 vDelFromString gPreview, %DelFromString%

          ; Regular Expression Options
          Gui, Add, Text, x185 y60 VRegExText1, Regular Expression:
          Gui, Add, Edit, xp+25 yp+30 w370 vRegEx gPreview, %RegEx%
          Gui, Add, Text, xp-25 yp+40 vRegExText2, New Name:
          Gui, Add, Edit, xp+25 yp+30 w370 vRegExNewName gPreview, %RegExNewName%
          Gui, Add, Text, xp-25 yp+50 vRegExHelp1, %RegExNotes%
          Gui, Font, underline
          Gui, Add, Text, xp+89 yp+78 vRegExHelp2 gRegExHelp cBlue, Help
          Gui, Font, Norm

          ; Custom Options
          Gui, Add, Text, x185 y60 vTemplateText, Template:
          Gui, Add, Edit, xp+25 yp+30 w400 vTemplate gPreview, %Template%
          Gui, Add, Text, x185 y140 w500 h200 vTemplateNotes, %TemplateHelp%

          ; Amber's Counter
          Gui, Add, Text, x185 y55 vAmberCounterText, %AmberText%
          Gui, Add, Button, x535 y385 w150 h50 vAmberButton gAmberGUI, Open Renaming Window

          ;Rename From List Option
          Gui, Add, Button, x175 y45 w90 h20 vListClear gListOptionButtons, Clear
          Gui, Add, Button, x+10 yp w90 h20 vListOpen gListOptionButtons, Open...
          Gui, Add, Button, x+10 yp w90 h20 vListSave gListOptionButtons, Save...
          Gui, Add, Edit, x175 y+10 w510 h175 -Wrap vListOfNames gPreview
          Gui, Add, Checkbox, xp y+10 vListOriginalExt Checked%ListOriginalExt% gPreview, Keep Original Extention
          Gui, Add, Checkbox, xp y+10 vListExt Checked%ListExt% gPreview, Use Items As Extentions
          Gui, Add, Text, xp y+10 vListText, %ListNotes%

          ; Inside Batch Tab
            Gui, Tab, 3
            Gui, Add, ListView, x15 y40 w630 r7 vBatchList NoSortHdr -Multi, Default
            Gui, Add, Button, xp+640 yp+40 w30 h30 gMoveUpBL, /\
            Gui, Add, Button, xp yp+40 w30 h30 gMoveDownBL, \/
            Gui, Add, Button, x450 yp+85 w90 h30 gRemoveBL, Remove
            Gui, Add, Button, xp+100 yp w90 h30 gRemoveAllBL, Remove All
            Gui, Add, Text, x370 yp+50, Notes:`n    - There Can Be Only 1 Counter Per Batch

            Gui, Add, GroupBox, x15 y195 w335 h150, Stored Batches
            Gui, Add, ListBox, xp+10 yp+20 w250 h125 vBatchNameList, %ListOfBatchNames%
            Gui, Add, Button, xp+258 yp+5 w60 h20 gLoadBatch, Load
            Gui, Add, Button, xp yp+35 w60 h20 vRenameBatchNameButton gRenameBatchName, Rename
            Gui, Add, Button, xp yp+50 w60 h20 vDelBatchButton gDeleteBatch, Delete

            Gui, Add, Button, x605 y385 w80 h50 gRenameBatchButton, Rename`nFiles

  Gui, Tab
  Gosub, LoadSRL
  GoSub, LoadBatch
  Gosub, ActionList
  cnt:=1
  Gui, ListView, FileList
  Gui, Show, Center w700 h450, %ScriptName%
Return

GuiContextMenu:
  If A_GuiControl=FileList
    Menu, FileContextMenu, Show, %A_GuiX%, %A_GuiY%
  Else If A_GuiControl=StringReplaceList
    Menu, StringReplaceContextMenu, Show, %A_GuiX%, %A_GuiY%
  Else If A_GuiControl=BatchList
    Menu, BatchContextMenu, Show, %A_GuiX%, %A_GuiY%
  Else If A_GuiControl=BatchNameList
    Menu, BatchNameContextMenu, Show, %A_GuiX%, %A_GuiY%
/*
  Else If A_GuiControl=UndoButton
    {
	  GuiControlGet, Temp, Enabled, UndoButton
	  Menu, UndoContextMenu, % (Temp ? "Enable" : "Disable") , Undo Last
	  Menu, UndoContextMenu, Show, %A_GuiX%, %A_GuiY%
	}
*/
Return

GuiDropFiles:
  Gui, ListView, FileList
  GuiControl, -Redraw, FileList
  Gui, Submit, NoHide
  FileList = %A_GuiEvent%
  Loop, Parse, FileList, `n
    {
      FileGetAttrib, test, %A_LoopField%
      IfInString, test, D
          Loop, %A_LoopField%\*,0,%SubFolder%
              LV_Add("", A_LoopFileName, A_LoopFileDir, A_LoopFileExt)
      Else
        {
          SplitPath, A_LoopField, FileName, FilePath, FileExt
          LV_Add("", FileName, FilePath, FileExt)
        }
    }
  GuiControl, +Redraw, FileList
  LV_ModifyCol(1, "AutoHdr")
  LV_ModifyCol(2, "AutoHdr")
  GuiControl,, Tabs, |%FileLabel%||%ActionLabel%|%BatchLabel%
  Gosub, PreviewAll
Return

RegExHelp:
  HelpDialog=
    (
Examples:
`n**Swapping Artist and Title From MP3 File Names:
`n   - Regular Expression -
       ( .* )  -  ( .* )\.mp3 
`n   - New Name -
       $2 - $1.mp3
`n`n`n**Extract Episode Number and Title From Series Video Files With 
  Episode Number as SnnEmm Followed by Title:
`n   - Regular Expression -
       Robot\.Chicken\.S( [ 0-9 ] { 2 } )E( [ 0-9 ] { 2 } )\.( .* )\.XViD\.avi      `n 
   - New Name -
       Robot Chicken  -  $1$2  -  $3.avi 
`n`n`nStill Don't Get It? 
Google ' Perl-Compatible Regular Expression (PCRE) ' or ' RegEx '`n`n
    )
  Gui, 2: +Owner1 +ToolWindow
  Gui, +Disabled
  Gui, 2:Add, Text, x20 y20, %HelpDialog%
  Gui, 2:Show,, Help
Return

AddGUI:
  Gui, Submit, NoHide
  StringReplace, ListOfBatchNames, ListOfBatchNames, ||, |, All
  StringReplace, ListOfBatchNames, ListOfBatchNames, |, |, UseErrorLevel
  Temp:=ErrorLevel
  StringReplace, ListOfBatchNames, ListOfBatchNames, %BatchNameList%|, %BatchNameList%||

  Gui, 3: +Owner1 +ToolWindow -SysMenu
  Gui, +Disabled
  Gui, 3:Add, Text,, Add To:
  Gui, 3:Add, ListBox, xp+20 yp+45 w150 r%Temp% vExistBatchName, %ListOfBatchNames%
  Gui, 3:Add, Edit, xp y+35 w150 vNewBatchName, New Batch
  Gui, 3:Add, GroupBox,xp-20 yp+30 w170
  Gui, 3:Add, Button, xp+90 yp+15 w70 h30 g3GuiClose, Cancel
  Gui, 3:Add, Button, xp-80 yp w70 h30 gAddToBatch, OK
  Gui, 3:Add, Radio, xp-10 yp-70 vAddToNew, New Batch
  Gui, 3:Add, Radio, xp ym+20 vAddToExist Checked, Existing Batch
  Gui, 3:Show,, %A_Space%
Return

3GuiClose:
2GuiClose:
  Gui, 1:-Disabled
  Gui, Destroy
Return

AmberGUI:
  Gui, Submit
  Counter:=CounterStart-1
  IncrementCounter(Counter, CounterDigits, CounterIncrement, AddSpaceBefore, AddSpaceAfter)
  Gui, 4:+ToolWindow +AlwaysOnTop
  Gui, 4:Add, Text, xp y90 w240 Center vAmberGUIText, % "Next File Number:" . ((!AddSpaceBefore) ? " " : "") . Counter
  Gui, 4:Show, w250 h200
Return

4GuiDropFiles:
  Gui, 1:Default
  Gui, ListView, FileList
  Loop, Parse, A_GuiEvent, `n
    {
      FileGetAttrib, test, %A_LoopField%
      IfInString, test, D
        Continue
      SplitPath, A_LoopField, FullFileName, FilePath, FileExt, FileName
      Loop % LV_GetCount()
        {
          LV_GetText(Temp1, A_Index, 1)
          IfNotEqual, FullFileName, %Temp1%
            Continue
          LV_GetText(Temp2, A_Index, 2)
          IfNotEqual, FilePath, %Temp2%
            Continue
          LV_Delete(A_Index)
          Break
        }
      FileName:=InsertString(FileName, Counter, InsertAtPosition, InsertFromBeginning)
      FileMove, %A_LoopField%, %FilePath%\%FileName%.%FileExt%
      IncrementCounter(Counter, CounterDigits, CounterIncrement, AddSpaceBefore, AddSpaceAfter)
    }
  Gui, 4:Default
  GuiControl,, AmberGUIText, % "Next File Number:" . ((AddSpaceBefore) ? "" : " ") . Counter
Return

4GuiClose:
  Gui, Destroy
  Gui, 1:Default
  Gui, Show
Return

;=================================================
;====================Previews=====================
;=================================================

PreviewAll:
  Gosub, PreviewBatch
  Gosub, Preview
Return

Preview:
  Gui, Submit, NoHide
  LV_GetText(FullFileName, 1, 1)
  LV_GetText(FullFilePath, 1, 2)
  If Not FullFileName
    {
      GuiControl, Text, PreviewShow,
      Return
    }
  If PreviewBatch
    {
      Gosub, BatchCounter
      Gosub, BatchRename
    }
  Else
    {
      Counter:=CounterStart-1
      Gosub, RenameFile
    }
  List:=ListOfNames
  PreviewNew:=NewName
  PreviewOld:=FullFileName
  If PreviewBatch
      GuiControl, Text, PreviewBatchShow, %PreviewOld%`n`n%PreviewNew%
  Else
      GuiControl, Text, PreviewShow, %PreviewOld%`n`n%PreviewNew%
Return

PreviewBatch:
  PreviewBatch:=1
  Gosub, Preview
  PreviewBatch:=0
Return

;=================================================
;==================Rename Action==================
;=================================================

RenameButton:
  Gui, +OwnDialogs
  Gui, Submit, NoHide
  Gui, ListView, FileList
  GoSub, ClearDeadFileListRows
  ListLength:=LV_GetCount()
  If Not ListLength
    {
      MsgBox, No Files. Please Add Atleast 1 File To Rename
      Return
    }
  If Not BatchButton
      Counter:=CounterStart-1
  List:=ListOfNames
  NumOfFilesRenamed:=0
  BackupRename:=0
  GuiControl, -Redraw, FileList
  Loop %ListLength%
    {
      LV_GetText(FullFileName, A_Index, 1)
      LV_GetText(FullFilePath, A_Index, 2)
      If BatchButton
          Gosub, BatchRename
      Else
          Gosub, RenameFile
      OldFilePath:=FullFilePath "\" FullFileName
      NewFilePath:=FullFilePath "\" NewName
      If !(OldFilePath == NewFilePath)
        {
		  If (OldFilePath != NewFilePath) && FileExist(NewFilePath)
		    {
			  SplitPath, NewName,,, FileExt, FileName
		      Loop
			    {
			      NewFilePath := FullFilePath "\" FileName "_" A_Index "." FileExt
			  	  IfNotExist, %NewFilePath%
				    Break
			    }
			}
          FileMove, %OldFilePath%, %NewFilePath%
          LV_Modify(A_Index, "", NewName, FullFilePath)
          NumOfFilesRenamed++
        }
	  BackupRename := (BackupRename) ? (BackupRename "`n" NewFilePath ">" OldFilePath) : (NewFilePath ">" OldFilePath)
    }
  LV_ModifyCol(1, "AutoHdr")
  LV_ModifyCol(2, "AutoHdr")
  LV_ModifyCol(3, 40)
  GuiControl, +Redraw, FileList
  BackupSession:=BackupRename BackupSession
  If NumOfFilesRenamed
    GuiControl, Enable, UndoButton
  Gosub, PreviewAll
  MsgBox,, %A_Space%, Done!`n%NumOfFilesRenamed% Files Renamed!
Return

RenameBatchButton:
  Gui, ListView, BatchList
  ListLength:=LV_GetCount()
  If Not ListLength
    {
      Gui, +OwnDialogs
      MsgBox, Nothing To Do. Please Add Atleast 1 Action To Batch
      Return
    }
  Gosub, BatchCounter
  Gui, ListView, FileList
  BatchButton:=1
  Gosub, RenameButton
  BatchButton:=0
Return

UndoLastRename:
  Undo( "Last", BackupRename)
Return

UndoSession:
  Undo( "Session", BackupSession)
Return

Undo( Type, Backup)
{
  Gui, ListView, FileList
  GuiControl, -Redraw, FileList
  LV_Delete()
  If Type = Last
    {
      Loop, Parse, Backup, `n
        {
	      StringSplit, FileNames, A_LoopField, >
    	  SplitPath, FileNames2, FullFileName, FilePath, FileExt, FileName
	      If !(FileNames1==FileNames2)
	        {
	    	  If (FileNames1!=FileNames2) && FileExist(FileNames2)
		      Loop
		        {
		          FileNames2 := FilePath "\" FileName "_" A_Index "." FileExt
			      IfNotExist, %FileNames2%
		            Break
		        }
	          FileMove, %FileNames1%, %FileNames2%
		    }
	      LV_Add( "", FullFileName, FilePath, FileExt)
	    }
	  Message:= "Files Restored!"
    }
  Else If Type = Session
    {
	  ;stuff
	  Message:= "Session Reset`nAll Files Restored"
	}
  LV_ModifyCol(1, "AutoHdr")
  LV_ModifyCol(2, "AutoHdr")
  LV_ModifyCol(3, 40)
  GuiControl, +Redraw, FileList
  GuiControl, Disable, UndoButton
  Gosub, PreviewAll
  Gui, +OwnDialogs
  MsgBox,, %A_Space%, Done!`n%Message%
}

RenameFile:
  SplitPath, FullFileName,,, FileExt, FileName
  NewName:=FileName
  If ActionList=Spacing
    {
      NewName:=SpaceCorrection(FileName, DelExtraSpace, DotToSpace, CommaToSpace, UnderToSpace, SkipNumSeq)
    }
  Else If ActionList=Case Correction
    {
      NewName:=CaseCorrection(FileName, CapFirst, CapAll, Uppercase, Lowercase, InvertCase)
    }
  Else If ActionList=Bracket Deletion
    {
      NewName:=DeleteBrackets(FileName, SquareBracket, CurlyBracket, RoundBracket, OpenBracket, StartLeft, DelAllBracket, NumBracket)
    }
  Else If ActionList=String Replacement
    {
      Gosub, StringReplacement
    }
  Else If ActionList=Insertion
    {
      If InsertStringRadio
          NewName:=InsertString(FileName, InsertString, InsertAtPosition, InsertFromBeginning)
      Else If InsertCounterRadio
          NewName:=InsertCounter(FileName, Counter, CounterDigits, CounterIncrement, AddSpaceBefore, AddSpaceAfter, InsertAtPosition, InsertFromBeginning, InsertFromEnd)
    }
  Else If ActionList=Character Deletion
    {
      NewName:=DeleteCharacter(FileName, CharDelCount, DelFromPositionText, DelBefore, DelFromPosition, DelFromBeginning, DelFromString)
    }
  Else If ActionList=Amber's Counter
    {
      NewName:=InsertCounter(FileName, Counter, CounterDigits, CounterIncrement, AddSpaceBefore, AddSpaceAfter, InsertAtPosition, InsertFromBeginning, InsertFromEnd)
    }
  Else If ActionList=Rename From List
    {
      NewName:=ListRenaming(FileName, FileExt, List, ListOriginalExt, ListExt)
      Return
    }
  Else If ActionList=Regular Expression
    {
      FileName:=RegExReplace(FullFileName, RegEx, RegExNewName)
      NewName:=DeleteIllegalChars(FileName)
      Return
    }
  Else If ActionList=Custom
    {
      IncrementCounter(Counter, CounterDigits, CounterIncrement)
      ListItem:=NextItemInList(List)
      NewName:=CustomTemplate(FileName, FileExt, FullFilePath, Template, Counter, ListItem)
      Return
    }
  NewName:=NewName "." FileExt
Return

BatchCounter:
  Gui, ListView, BatchList
  Loop % LV_GetCount()
    {
      LV_GetText(Temp1, A_Index, 1)
      IfInString, Temp1, Insert Counter
        {
          Temp3:=RegExMatch(Temp1, "([0-9]{1,2})", TempStart)
          Counter:=TempStart-1
          Break
        }
    }
  Gui, ListView, FileList
Return

BatchRename:
  SplitPath, FullFileName,,, FileExt, FileName
  Gui, ListView, BatchList
  Loop % LV_GetCount()
    {
      LV_GetText(BatchString, A_Index, 1)
      FileName:=ProccessBatchString(BatchString, FileName, Counter)
    }
  NewName:=FileName "." FileExt
  Gui, ListView, FileList
Return

ProccessBatchString(BatchString, FileName, ByRef Counter)
  {
    Loop 7
        TempArray%A_Index% := ""
    Loop, Parse, BatchString, :, %A_Space%
      {
        If A_Index=1
          {
            BatchType:=A_LoopField
            Continue
          }
        BatchDetail:=A_LoopField
        If BatchType=Spacing
          {
            IfInString, BatchDetail, Delete Extra Spacing
                TempArray1:=1
            IfInString, BatchDetail, Dot To Space
                TempArray2:=1
            IfInString, BatchDetail, Comma To Space
                TempArray3:=1
            IfInString, BatchDetail, UnderScore To Space
                TempArray4:=1
            IfInString, BatchDetail, Skip Number Sequences
                TempArray5:=1
            FileName:=SpaceCorrection(FileName, TempArray1, TempArray2, TempArray3, TempArray4, TempArray5)
          }
        Else If BatchType=Case Correction
          {
            If BatchDetail=Capitalize First word
                TempArray1:=1
            Else If BatchDetail=Capitalize Every Word
                TempArray2:=1
            Else If BatchDetail=ALL Upper CASE
                TempArray3:=1
            Else If BatchDetail=all Lower case
                TempArray4:=1
            Else If BatchDetail=iNVERT cASE
                TempArray5:=1
            FileName:=CaseCorrection(FileName, TempArray1, TempArray2, TempArray3, TempArray4, TempArray5)
          }
        Else If BatchType=Bracket Deletion
          {
            IfInString, BatchDetail, [ ... ]
                TempArray1:=1
            Else IfInString, BatchDetail, { ... }
                TempArray2:=1
            Else
                TempArray3:=1
            IfInString, BatchDetail, Open Bracket
                TempArray4:=1
            IfInString, BatchDetail, Left To Right
                TempArray5:=1
            IfInString, BatchDetail, Delete All
                TempArray6:=1
            Else
                Temp:=RegExMatch(BatchDetail,"([0-9]{1,2})", TempArray7)
            FileName:=DeleteBrackets(FileName, TempArray1, TempArray2, TempArray3, TempArray4, TempArray5, TempArray6, TempArray7)
          }
        Else If BatchType=String Replacement
          {
            TempEx := """(.*?)"" With ""(.*?)"""
            Temp:=RegExMatch(BatchDetail, TempEx, TempArray)
            IfInString, BatchDetail, Replace All Occurrences
                TempArray3:=1
            IfInString, BatchDetail, Case Sensitive
                StringCaseSense, ON
            StringReplace, FileName, FileName, %TempArray1%, %TempArray2%, %TempArray3%
            StringCaseSense, OFF
          }
        Else If BatchType=Insert Counter
          {
            TempEx := "([0-9]{1,2}) Digits Long, by ([0-9]{1,2}), At Position ([0-9]{1,2})"
            Temp:=RegExMatch(BatchDetail, TempEx, TempArray)
            IfInString, BatchDetail, Beginning
                TempArray4:=1
            IfInString, BatchDetail, Before
                TempArray5:=1
            IfInString, BatchDetail, After
                TempArray6:=1
            FileName:=InsertCounter(FileName, Counter, TempArray1, TempArray2, TempArray5, TempArray6, TempArray3, TempArray4)
          }
        Else If BatchType=Insert String
          {
            TempEx := """(.*)"" At Position ([0-9]{1,2})"
            Temp:=RegExMatch(BatchDetail, TempEx, TempArray)
            IfInString, BatchDetail, From Beginning
                TempArray3:=1
            FileName:=InsertString(FileName, TempArray1, TempArray2, TempArray3)
          }
        Else If BatchType=Character Deletion
          {
            Temp:=RegExMatch(BatchDetail, "Delete ([0-9]{1,2}) Characters", TempArray)
            IfInString, BatchDetail, Characters From Position
              {
                TempArray2:=1
                Temp:=RegExMatch(BatchDetail, "Position ([0-9]{1,2})", TempEx)
                TempArray4:=TempEx1
                IfInString, BatchDetail, From Beginning
                    TempArray5:=1
              }
            Else 
              {
                IfInString, BatchDetail, Characters Before
                    TempArray3:=1
                Temp:=RegExMatch(BatchDetail, """(.*)""", TempArray6)
                StringReplace, TempArray6, TempArray6, ",, All ;"
              }
            FileName:=DeleteCharacter(FileName, TempArray1, TempArray2, TempArray3, TempArray4, TempArray5, TempArray6)
          }
      }
    Return FileName
  }

;=================================================
;=================Command Line====================
;=================================================

ProcessCommandLine:
  SplitPath, A_ScriptName,,,, ScriptsName
  INIFile:=ScriptsName ".ini"
  IniRead, DefaultBatch, %INIFile%, Batch, DefaultBatch, %A_Space%
  IniRead, SubFolder, %INIFile%, Settings, SubFolder, 0
  If Not DefaultBatch
      Return
  NumOfFilesRenamed:=0
  Loop, Parse, DefaultBatch, ?
      IfInString, A_LoopField, Insert Counter
        {
          Temp3:=RegExMatch(Temp1, "([0-9]{1,2})", TempStart)
          Counter:=TempStart-1
          Break
        }
  Loop, %0%
    {
      Parameter:=%A_Index%
      FileGetAttrib, test, %Parameter%
      IfInString, test, D
          ProcessFolder(Parameter, DefaultBatch, Counter, NumOfFilesRenamed, SubFolder)
      Else
          ProcessFile(Parameter, DefaultBatch, Counter, NumOfFilesRenamed)
    }
  MsgBox, Done!`n%NumOfFilesRenamed% Files Renamed!
Return

ProcessFolder(Folder, Batch, ByRef Counter, ByRef NumOfFilesRenamed, SubFolder)
  {
    Loop, %Folder%\*, 0, %SubFolder%
      {
        SplitPath, A_LoopFileName,,,, FileName
        Loop, Parse, Batch, ?
            FileName:=ProccessBatchString(A_LoopField, FileName, Counter)
        NewFilePath:=A_LoopFileDir "\" FileName "." A_LoopFileExt
        If !(A_LoopFileFullPath == NewFilePath)
          {
		  	If (A_LoopFileFullPath != NewFilePath) && FileExist(NewFilePath)
		      {
			    SplitPath, NewName,,, FileExt, FileName
		        Loop
			      {
			        NewFilePath := FullFilePath "\" FileName "_" A_Index "." FileExt
			  	    IfNotExist, %NewFilePath%
				      Break
			      }
			  }
            FileMove, %A_LoopFileFullPath%, %NewFilePath%
            NumOfFilesRenamed++
          }
      }
  }

ProcessFile(GivenPath, Batch, ByRef Counter, ByRef NumOfFilesRenamed)
  {
    Loop %GivenPath%
        File=%A_LoopFileLongPath%
    SplitPath, File,, FilePath, FileExt, FileName
    Loop, Parse, Batch, ?
        FileName:=ProccessBatchString(A_LoopField, FileName, Counter)
    NewFilePath:=FilePath "\" FileName "." FileExt
    If !(File == NewFilePath)
      {
	    If (File != NewFilePath) && FileExist(NewFilePath)
		  {
		    SplitPath, NewName,,, FileExt, FileName
		    Loop
			  {
			    NewFilePath := FullFilePath "\" FileName "_" A_Index "." FileExt
			    IfNotExist, %NewFilePath%
				  Break
			  }
	      }
        FileMove, %File%, %NewFilePath%
        NumOfFilesRenamed++
      }
  }

;=================================================
;===================Batch Tab=====================
;=================================================

AddToBatch:
  Gui, 3: Submit, NoHide
  If AddToNew
	If StrLen(NewBatchName) != 0
      Loop, Parse, ListOfBatchNames, |
        {
  	      If !A_LoopField
	        Continue
	      If (A_LoopField = NewBatchName)
	        {
			  Gui, 3:+OwnDialogs
		      Msgbox,, %A_Space%, "%NewBatchName%" Already Exist
		      Gui, 3:-OwnDialogs
	          Return
		    }
	    }
	Else
	  {
	    Gui, 3:+OwnDialogs
	    Msgbox,, %A_Space%, The New Batch Must Have A Name
		Gui, 3:-OwnDialogs
	    Return
	  }
  GoSub, 3GuiClose
  Gui 1:Default
  GoSub, SaveCurrentBatch
  If AddToExist
      If CurrentBatch=%ExistBatchName%
        {
          GoSub, ActionToBatch
          Return
        }
  Gui, ListView, BatchList
  LV_Delete()
  StringReplace, ListOfBatchNames, ListOfBatchNames, ||, |, All
  GuiControl, -Redraw, BatchList
  If AddToNew
    {
      ListOfBatchNames:=ListOfBatchNames NewBatchName "||"
      If StoredBatches
          StoredBatches:=StoredBatches "?" NewBatchName "?"
      Else
          StoredBatches:=NewBatchName "?"
      LV_ModifyCol(1, "AutoHdr", NewBatchName)
    }
  Else
    {
      StringReplace, ListOfBatchNames, ListOfBatchNames, %ExistBatchName%|, %ExistBatchName%||
      If ExistBatchName=Default
          BatchString:=DefaultBatch
      Else
          BatchString:=ProcessStoredBatches(StoredBatches, "Load", ExistBatchName)
      Loop, Parse, BatchString, ?
          If A_LoopField
              LV_Add("", A_LoopField)
      LV_ModifyCol(1, "AutoHdr", ExistBatchName)
    }
  GuiControl, +Redraw, BatchList
  GuiControl,, BatchNameList, |%ListOfBatchNames%
  GoSub, ActionToBatch
Return

ActionToBatch:
  Gui, Submit, NoHide
  If ActionList=Spacing
    {
      If Not DelExtraSpace && Not DotToSpace && Not CommaToSpace && Not UnderToSpace
          Return
      BatchString := "Spacing: "
      If DelExtraSpace
          BatchString := BatchString "Delete Extra Spacing, "
      If DotToSpace
          BatchString := BatchString "Dot To Space, "
      If CommaToSpace
          BatchString := BatchString "Comma To Space, "
      If UnderToSpace
          BatchString := BatchString "UnderScore To Space, "
      If SkipNumSeq && DotToSpace
          BatchString := BatchString "Skip Number Sequences, "
      StringTrimRight, BatchString, BatchString, 2
    }
  Else If ActionList=Case Correction
    {
      If CapFirst
          BatchString := "Case Correction: Capitalize first word"
      Else If CapAll
          BatchString := "Case Correction: Capitalize Every Word"
      Else If Uppercase
          BatchString := "Case Correction: ALL Upper CASE"
      Else If Lowercase
          BatchString := "Case Correction: all Lower case"
      Else
          BatchString := "Case Correction: iNVERT cASE"
    }
  Else If ActionList=Bracket Deletion
    {
      If DelAllBracket
          BatchString := "Bracket Deletion: Delete All "
      Else
          BatchString := "Bracket Deletion: Delete " NumBracket " "
      If SquareBracket
          BatchString := BatchString "[ ... ] Blocks, "
      Else If CurlyBracket
          BatchString := BatchString "{ ... } Blocks, "
      Else
          BatchString := BatchString "( ... ) Blocks, "
      If OpenBracket
          BatchString := BatchString "Including Open Bracket Blocks, "
      If StartLeft
          BatchString := BatchString "From Left To Right"
      Else
          BatchString := BatchString "From Right To Left"
    }
  Else If ActionList=String Replacement
    {
      BatchString:=""
      Gui, ListView, StringReplaceList
      ListLength:=LV_GetCount()
      If NOT ListLength
        {
          Gui, ListView, FileList
          Return
        }
      Loop %ListLength%
        {
          LV_GetText(SearchString, A_Index, 1)
          LV_GetText(ReplaceString, A_Index, 2)
          ReplaceString := DeleteIllegalChars(ReplaceString)
          BatchString := BatchString "String Replacement: Replace """ SearchString """ With """ ReplaceString """"
          If ReplaceAll
              BatchString := BatchString ", Replace All Occurrences"
          If ReplaceWithCase
              BatchString := BatchString ", Case Sensitive"
          If ListLength!=%A_Index%
              BatchString := BatchString "?"
        }
    }
  Else If ActionList=Insertion
    {
      If InsertStringRadio
        {
          If Not InsertString
              Return
          InsertString := DeleteIllegalChars(InsertString)
          BatchString := "Insert String: """ InsertString """ At Position " InsertAtPosition ", From Beginning" 
          If InsertFromEnd
              StringReplace, BatchString, BatchString, Beginning, End
        }
      Else If InsertCounterRadio
        {
          GoSub, CheckCounter
          If MultCounters
              Return
          BatchString := "Insert Counter: Starting At " CounterStart ", " CounterDigits " Digits Long, by " CounterIncrement ", At Position " InsertAtPosition ", From Beginning" 
          If InsertFromEnd
              StringReplace, BatchString, BatchString, Beginning, End
          If AddSpaceBefore && AddSpaceAfter
              BatchString := BatchString ", Add A Space Before And After"
          Else If AddSpaceBefore
              BatchString := BatchString ", Add A Space Before"
          Else
              BatchString := BatchString ", Add A Space After"
        }
    }
  Else If ActionList=Character Deletion
    {
      If DelFromPositionText
        {
          BatchString := "Character Deletion: Delete " CharDelCount " Characters From Position " DelFromPosition ", From Beginning"
          If DelFromEnd
              StringReplace, BatchString, BatchString, Beginning, End
        }
      Else If DelBefore
          BatchString := "Character Deletion: Delete " CharDelCount " Characters Before """ DelFromString """" 
      Else
          BatchString := "Character Deletion: Delete " CharDelCount " Characters After """ DelFromString """"
    }
  Gui, ListView, BatchList
  Loop, Parse, BatchString, ?
      LV_Add("", A_LoopField)
  LV_ModifyCol(1, "AutoHdr")
  Gui, ListView, FileList
  BatchString:=""
  GoSub, PreviewBatch
  GuiControl,, Tabs, |%FileLabel%|%ActionLabel%|%BatchLabel%||
Return

CheckCounter:
  Gui, ListView, BatchList
  MultCounters:=0
  Loop % LV_GetCount()
    {
      LV_GetText(Temp1, A_Index, 1)
      IfInString, Temp1, Insert Counter
        {
          MultCounters:=1
          Break
        }
    }
  Gui, ListView, FileList
Return

MoveUpBL:
  Gui, ListView, BatchList
  FocusedRowNumber := LV_GetNext(0, "F")
  MoveRowNumber:= FocusedRowNumber-1
  If FocusedRowNumber=1
    {
      Gui, ListView, FileList
      Return
    }
  GuiControl, -Redraw, BatchList
  LV_GetText(Temp1, FocusedRowNumber, 1)
  LV_GetText(Temp2, MoveRowNumber, 1)
  LV_Modify(FocusedRowNumber, "", Temp2)
  LV_Modify(MoveRowNumber, "Select Focus", Temp1)
  GuiControl, +Redraw, BatchList
  Gui, ListView, FileList
  Gosub, PreviewBatch
Return

MoveDownBL:
  Gui, ListView, BatchList
  FocusedRowNumber := LV_GetNext(0, "F")
  MoveRowNumber:= FocusedRowNumber+1
  Length:=LV_GetCount()
  If Length<=%FocusedRowNumber%
    {
      Gui, ListView, FileList
      Return
    }
  GuiControl, -Redraw, BatchList
  LV_GetText(Temp1, FocusedRowNumber, 1)
  LV_GetText(Temp2, MoveRowNumber, 1)
  LV_Modify(FocusedRowNumber, "", Temp2)
  LV_Modify(MoveRowNumber, "Select Focus", Temp1)
  GuiControl, +Redraw, BatchList
  Gui, ListView, FileList
  Gosub, PreviewBatch
Return

RemoveBL:
  Gui, ListView, BatchList
  GuiControl, -Redraw, BatchList
  RowNumber = 0
  Loop
    {
      RowNumber := LV_GetNext(RowNumber - 1)
      If not RowNumber
          Break
      LV_Delete(RowNumber)
    }
  LV_ModifyCol(1, "AutoHdr")
  GuiControl, +Redraw, BatchList
  Gui, ListView, FileList
  Gosub, PreviewBatch
Return

RemoveAllBL:
  Gui, ListView, BatchList
  GuiControl, -Redraw, BatchList
  LV_Delete()
  LV_ModifyCol(1, "AutoHdr")
  GuiControl, +Redraw, BatchList
  Gui, ListView, FileList
  Gosub, PreviewBatch
Return

SaveCurrentBatch:
  Gui, ListView, BatchList
  LV_GetText(CurrentBatch,0,1)
  BatchString:=""
  Loop % LV_GetCount()
    {
      LV_GetText(Temp, A_Index, 1)
      BatchString:=BatchString Temp "?"
    }
  Gui, ListView, FileList
  If cnt>2
      Return
  If CurrentBatch=Default
      DefaultBatch:=BatchString
  Else
      StoredBatches:=ProcessStoredBatches(StoredBatches, "Save", CurrentBatch, BatchString)
Return

DeleteBatch:
  Gui, Submit, NoHide
  GoSub, SaveCurrentBatch
  If BatchNameList=Default
      Return
  Gui, ListView, BatchList
  GuiControl, -Redraw, BatchList
  LV_Delete()
  Loop, Parse, DefaultBatch, ?
      If A_LoopField
          LV_Add("", A_LoopField)
  GuiControl, +Redraw, BatchList
  LV_ModifyCol(1, "AutoHdr", "Default")
  Gui, ListView, FileList
  StringReplace, ListOfBatchNames, ListOfBatchNames, ||, |, All
  StringReplace, ListOfBatchNames, ListOfBatchNames, |%BatchNameList%|, |, All
  StringReplace, ListOfBatchNames, ListOfBatchNames, |, ||
  GuiControl,, BatchNameList, |%ListOfBatchNames%
  StoredBatches:=ProcessStoredBatches(StoredBatches, "Delete", BatchNameList)
Return

RenameBatchName:
  Gui, Submit, NoHide
  If BatchNameList=Default
      Return
  InputBox, NewBatchName, %A_Space%, `n               Enter The New Name For "%BatchNameList%",,,150,,,,,%BatchNameList%
  If ErrorLevel || Not NewBatchName
      Return
  GoSub, LoadBatch
  If BatchNameList=%NewBatchName%
      Return
  Gui, ListView, BatchList
  LV_ModifyCol(1, "AutoHdr", NewBatchName)
  Gui, ListView, FileList
  StoredBatches:=ProcessStoredBatches(StoredBatches, "Rename", BatchNameList, NewBatchName)
  StringReplace, ListOfBatchNames, ListOfBatchNames, ||, |, All
  StringReplace, ListOfBatchNames, ListOfBatchNames, |%BatchNameList%|, |%NewBatchName%||, All
  GuiControl,, BatchNameList, |%ListOfBatchNames%
Return

LoadBatch:
  Gui, Submit, NoHide
  GoSub, SaveCurrentBatch
  If BatchNameList=%CurrentBatch% && cnt=1
    {
      Gui, ListView, FileList
      Return
    }
  If BatchNameList=Default
      BatchString:=DefaultBatch
  Else
      BatchString:=ProcessStoredBatches(StoredBatches, "Load", BatchNameList)
  Gui, ListView, BatchList
  GuiControl, -Redraw, BatchList
  LV_Delete()
  Loop, Parse, BatchString, ?
      If A_LoopField
          LV_Add("", A_LoopField)
  GuiControl, +Redraw, BatchList
  LV_ModifyCol(1, "AutoHdr", BatchNameList)
  Gui, ListView, FileList
Return

ProcessStoredBatches(StoredBatches, Action, ParamBatch, Param="")
  {
    If Not StoredBatches
        Return ""
    StringSplit, Batch, StoredBatches, ?
    StoredBatches:=""
    Loop %Batch0%
      {
        TempBatch:=Batch%A_Index%
        If Not TempBatch
            Continue
        StringSplit, SubBatch, TempBatch, ?
        If SubBatch1=%ParamBatch%
          {
            If Action=Load
                Return SubBatch2
            Else If Action=Exist
                Return 1
            Else If Action=Save
                TempBatch:=ParamBatch "?" Param
            Else If Action=Rename
                TempBatch:=Param "?" SubBatch2
            Else If Action=Delete
                Continue
          }
        If StoredBatches
            StoredBatches:=StoredBatches "?" TempBatch
        Else
            StoredBatches:=TempBatch
      }
    If Action=Exist
        Return 0
    Return StoredBatches
  }

;=================================================
;===================INI File======================
;=================================================

ReadINIFile:
  SplitPath, A_ScriptName,,,, ScriptsName
  INIFile:=ScriptsName ".ini"

  IniRead, LastFileDir, %INIFile%, Settings, LastFileDir, %A_Desktop%
  IniRead, LastFolderDir, %INIFile%, Settings, LastFolderDir, %A_Desktop%
  IniRead, SubFolder, %INIFile%, Settings, SubFolder, 0

  IniRead, DelExtraSpace, %INIFile%, Settings, DelExtraSpace, 0
  IniRead, DotToSpace, %INIFile%, Settings, DotToSpace, 0
  IniRead, CommaToSpace, %INIFile%, Settings, CommaToSpace, 0
  IniRead, UnderToSpace, %INIFile%, Settings, UnderToSpace, 0
  IniRead, SkipNumSeq, %INIFile%, Settings, SkipNumSeq, 0

  IniRead, CapFirst, %INIFile%, Settings, CapFirst, 1
  IniRead, CapAll, %INIFile%, Settings, CapAll, 0
  IniRead, Uppercase, %INIFile%, Settings, Uppercase, 0
  IniRead, Lowercase, %INIFile%, Settings, Lowercase, 0
  IniRead, InvertCase, %INIFile%, Settings, InvertCase, 0

  IniRead, ReplaceAll, %INIFile%, Settings, ReplaceAll, 1
  IniRead, ReplaceWithCase, %INIFile%, Settings, ReplaceWithCase, 0

  IniRead, InsertStringRadio, %INIFile%, Settings, InsertStringRadio, 1
  IniRead, InsertCounterRadio, %INIFile%, Settings, InsertCounterRadio, 0
  IniRead, InsertString, %INIFile%, Settings, InsertString, %A_Space%
  IniRead, CounterStart, %INIFile%, Settings, CounterStart, 1
  IniRead, CounterDigits, %INIFile%, Settings, CounterDigits, 2
  IniRead, CounterIncrement, %INIFile%, Settings, CounterIncrement, 1
  IniRead, AddSpaceBefore, %INIFile%, Settings, AddSpaceBefore, 0
  IniRead, AddSpaceAfter, %INIFile%, Settings, AddSpaceAfter, 0
  IniRead, InsertAtPosition, %INIFile%, Settings, InsertAtPosition, 0
  IniRead, InsertFromBeginning, %INIFile%, Settings, InsertFromBeginning, 1
  IniRead, InsertFromEnd, %INIFile%, Settings, InsertFromEnd, 0

  IniRead, SquareBracket, %INIFile%, Settings, SquareBracket, 1
  IniRead, CurlyBracket, %INIFile%, Settings, CurlyBracket, 0
  IniRead, RoundBracket, %INIFile%, Settings, RoundBracket, 0
  IniRead, OpenBracket, %INIFile%, Settings, OpenBracket, 1
  IniRead, StartLeft, %INIFile%, Settings, StartLeft, 1
  IniRead, StartRight, %INIFile%, Settings, StartRight, 0
  IniRead, DelAllBracket, %INIFile%, Settings, DelAllBracket, 1
  IniRead, DelNumBracket, %INIFile%, Settings, DelNumBracket, 0
  IniRead, NumBracket, %INIFile%, Settings, NumBracket, 1

  IniRead, CharDelCount, %INIFile%, Settings, CharDelCount, 1
  IniRead, DelFromPositionText, %INIFile%, Settings, DelFromPositionText, 1
  IniRead, DelFromPosition, %INIFile%, Settings, DelFromPosition, 0
  IniRead, DelFromBeginning, %INIFile%, Settings, DelFromBeginning, 1
  IniRead, DelFromEnd, %INIFile%, Settings, DelFromEnd, 0
  IniRead, DelBefore, %INIFile%, Settings, DelBefore, 0
  IniRead, DelAfter, %INIFile%, Settings, DelAfter, 0
  IniRead, DelFromString, %INIFile%, Settings, DelFromString, %A_Space%ListOriginalExt

  IniRead, ListOpenDir, %INIFile%, Settings, ListOpen, %A_Desktop%
  IniRead, ListSaveDir, %INIFile%, Settings, ListSave, %A_Desktop%
  IniRead, ListOriginalExt, %INIFile%, Settings, ListOriginalExt, 0
  IniRead, ListExt, %INIFile%, Settings, ListExt, 0
  
  IniRead, RegEx, %INIFile%, Settings, RegEx, %A_Space%
  IniRead, RegExNewName, %INIFile%, Settings, RegExNewName, %A_Space%

  IniRead, Template, %INIFile%, Settings, Template, `%name`%`%ext`%

  IniRead, DefaultBatch, %INIFile%, Batch, DefaultBatch, %A_Space%
  IniRead, StoredBatches, %INIFile%, Batch, StoredBatches, %A_Space%
  IniRead, ListOfBatchNames, %INIFile%, Batch, ListOfBatchNames, Default||
Return

GuiClose:
  Gui, Submit
  IniWrite, %LastFileDir%, %INIFile%, Settings, LastFileDir
  IniWrite, %LastFolderDir%, %INIFile%, Settings, LastFolderDir
  IniWrite, %SubFolder%, %INIFile%, Settings, SubFolder

  IniWrite, %DelExtraSpace%, %INIFile%, Settings, DelExtraSpace
  IniWrite, %DotToSpace%, %INIFile%, Settings, DotToSpace
  IniWrite, %CommaToSpace%, %INIFile%, Settings, CommaToSpace
  IniWrite, %UnderToSpace%, %INIFile%, Settings, UnderToSpace
  IniWrite, %SkipNumSeq%, %INIFile%, Settings, SkipNumSeq

  IniWrite, %CapFirst%, %INIFile%, Settings, CapFirst
  IniWrite, %CapAll%, %INIFile%, Settings, CapAll
  IniWrite, %Uppercase%, %INIFile%, Settings, Uppercase
  IniWrite, %Lowercase%, %INIFile%, Settings, Lowercase
  IniWrite, %InvertCase%, %INIFile%, Settings, InvertCase

  IniWrite, %ReplaceAll%, %INIFile%, Settings, ReplaceAll
  IniWrite, %ReplaceWithCase%, %INIFile%, Settings, ReplaceWithCase
  Gosub, SaveSRL

  IniWrite, %InsertStringRadio%, %INIFile%, Settings, InsertStringRadio
  IniWrite, %InsertCounterRadio%, %INIFile%, Settings, InsertCounterRadio
  IniWrite, %InsertString%, %INIFile%, Settings, InsertString
  IniWrite, %CounterStart%, %INIFile%, Settings, CounterStart
  IniWrite, %CounterDigits%, %INIFile%, Settings, CounterDigits
  IniWrite, %CounterIncrement%, %INIFile%, Settings, CounterIncrement
  IniWrite, %AddSpaceBefore%, %INIFile%, Settings, AddSpaceBefore
  IniWrite, %AddSpaceAfter%, %INIFile%, Settings, AddSpaceAfter
  IniWrite, %InsertAtPosition%, %INIFile%, Settings, InsertAtPosition
  IniWrite, %InsertFromBeginning%, %INIFile%, Settings, InsertFromBeginning
  IniWrite, %InsertFromEnd%, %INIFile%, Settings, InsertFromEnd

  IniWrite, %SquareBracket%, %INIFile%, Settings, SquareBracket
  IniWrite, %CurlyBracket%, %INIFile%, Settings, CurlyBracket
  IniWrite, %RoundBracket%, %INIFile%, Settings, RoundBracket
  IniWrite, %OpenBracket%, %INIFile%, Settings, OpenBracket
  IniWrite, %StartLeft%, %INIFile%, Settings, StartLeft
  IniWrite, %StartRight%, %INIFile%, Settings, StartRight
  IniWrite, %DelAllBracket%, %INIFile%, Settings, DelAllBracket
  IniWrite, %DelNumBracket%, %INIFile%, Settings, DelNumBracket
  IniWrite, %NumBracket%, %INIFile%, Settings, NumBracket

  IniWrite, %CharDelCount%, %INIFile%, Settings, CharDelCount
  IniWrite, %DelFromPositionText%, %INIFile%, Settings, DelFromPositionText
  IniWrite, %DelFromPosition%, %INIFile%, Settings, DelFromPosition
  IniWrite, %DelFromBeginning%, %INIFile%, Settings, DelFromBeginning
  IniWrite, %DelFromEnd%, %INIFile%, Settings, DelFromEnd
  IniWrite, %DelBefore%, %INIFile%, Settings, DelBefore
  IniWrite, %DelAfter%, %INIFile%, Settings, DelAfter
  IniWrite, %DelFromString%, %INIFile%, Settings, DelFromString

  IniWrite, %ListOpenDir%, %INIFile%, Settings, ListOpen
  IniWrite, %ListSaveDir%, %INIFile%, Settings, ListSave
  IniWrite, %ListOriginalExt%, %INIFile%, Settings, ListOriginalExt
  IniWrite, %ListExt%, %INIFile%, Settings, ListExt
  
  IniWrite, %RegEx%, %INIFile%, Settings, RegEx
  IniWrite, %RegExNewName%, %INIFile%, Settings, RegExNewName

  IniWrite, %Template%, %INIFile%, Settings, Template

  GoSub, SaveCurrentBatch
  IniWrite, %DefaultBatch%, %INIFile%, Batch, DefaultBatch
  IniWrite, %StoredBatches%, %INIFile%, Batch, StoredBatches
  IniWrite, %ListOfBatchNames%, %INIFile%, Batch, ListOfBatchNames
  ExitApp
Return

;=================================================
;==================Action List====================
;=================================================

ActionList:
  Gui, Submit, NoHide
  IfEqual, ActionList, %PreviousAction%
      Return
  Gosub, HideControls
  If ActionList=Spacing
    {
      GuiControl, Show, SpaceGroup
      GuiControl, Show, DelExtraSpace
      GuiControl, Show, DotToSpace
      GuiControl, Show, UnderToSpace
      GuiControl, Show, CommaToSpace
      GuiControl, Show, SkipNumSeq
      GuiControl, Show, AddToBatch
    }
  Else If ActionList=Case Correction
    {
      GuiControl, Show, CapFirst
      GuiControl, Show, CapAll
      GuiControl, Show, Uppercase
      GuiControl, Show, Lowercase
      GuiControl, Show, InvertCase
      GuiControl, Show, AddToBatch
    }
  Else If ActionList=Bracket Deletion
    {
      GuiControl, Show, BracketText1
      GuiControl, Show, SquareBracket
      GuiControl, Show, CurlyBracket
      GuiControl, Show, RoundBracket
      GuiControl, Show, OpenBracket
      GuiControl, Show, BracketText2
      GuiControl, Show, StartLeft
      GuiControl, Show, StartRight
      GuiControl, Show, BracketText3
      GuiControl, Show, DelAllBracket
      GuiControl, Show, DelNumBracket
      GuiControl, Show, NumBracket
      GuiControl, Show, NumBracket2
      GuiControl, Show, BracketText4
      GuiControl, Show, AddToBatch
    }
  Else If ActionList=String Replacement
    {
      GuiControl, Show, StringReplaceText
      GuiControl, Show, SearchField
      GuiControl, Show, ReplaceField
      GuiControl, Show, AddStringReplace
      GuiControl, Show, StringReplaceList
      GuiControl, Show, ReplaceAll
      GuiControl, Show, ReplaceWithCase
      GuiControl, Show, RemoveSRL
      GuiControl, Show, ClearSRL
      GuiControl, Show, EditSRL
      GuiControl, Show, MoveUpSRL
      GuiControl, Show, MoveDownSRL
      GuiControl, Show, AddToBatch
    }
  Else If ActionList=Insertion
    {
      GuiControl, Show, InsertString
      GuiControl, Show, InsertCounterRadio
      GuiControl, Show, InsertStringText
      GuiControl, Show, InsertStringGroup
      GuiControl, Show, InsertCounterGroup
      GuiControl, Show, InsertStringRadio
      GuiControl, Show, InsertCounterText
      GuiControl, Show, CounterStart
      GuiControl, Show, CounterStart2
      GuiControl, Show, CounterDigits
      GuiControl, Show, CounterDigits2
      GuiControl, Show, CounterIncrement
      GuiControl, Show, CounterIncrement2
      GuiControl, Show, InsertAtPositionText
      GuiControl, Show, InsertAtPosition
      GuiControl, Show, InsertAtPosition2
      GuiControl, Show, InsertFromBeginning
      GuiControl, Show, InsertFromEnd
      GuiControl, Show, AddSpaceAfter
      GuiControl, Show, AddSpaceBefore
      GuiControl, Show, AddToBatch
    }
  Else If ActionList=Character Deletion
    {
      GuiControl, Show, CharDel
      GuiControl, Show, CharDelCount
      GuiControl, Show, CharDelCount2
      GuiControl, Show, DelAfter
      GuiControl, Show, DelBefore
      GuiControl, Show, DelFromPositionText
      GuiControl, Show, DelFromPosition
      GuiControl, Show, DelFromPosition2
      GuiControl, Show, DelFromBeginning
      GuiControl, Show, DelFromEnd
      GuiControl, Show, DelFromString
      GuiControl, Show, AddToBatch
    }
  Else If ActionList=Regular Expression
    {
      GuiControl, Show, RegExText1
      GuiControl, Show, RegExText2
      GuiControl, Show, RegEx
      GuiControl, Show, RegExNewName
      GuiControl, Show, RegExHelp1
      GuiControl, Show, RegExHelp2
      GuiControl, Hide, AddToBatch
    }
  Else If ActionList=Custom
    {
      GuiControl, Hide, AddToBatch
      GuiControl, Show, Template
      GuiControl, Show, TemplateText
      GuiControl, Show, TemplateNotes
      GuiControl, Text, TemplateNotes, %TemplateHelp% %CounterStart%, %CounterDigits% Digits Long, by %CounterIncrement% )`n    - `%folder`% = Folder Name
    }
  Else If ActionList=Amber's Counter
    {
      GuiControl, Show, InsertCounterText
      GuiControl, Show, CounterStart
      GuiControl, Show, CounterStart2
      GuiControl, Show, CounterDigits
      GuiControl, Show, CounterDigits2
      GuiControl, Show, CounterIncrement
      GuiControl, Show, CounterIncrement2
      GuiControl, Show, InsertAtPositionText
      GuiControl, Show, InsertAtPosition
      GuiControl, Show, InsertAtPosition2
      GuiControl, Show, InsertFromBeginning
      GuiControl, Show, InsertFromEnd
      GuiControl, Show, AddSpaceAfter
      GuiControl, Show, AddSpaceBefore
      GuiControl, Show, AmberCounterText
      GuiControl, Show, AmberButton
      GuiControl, Hide, AddToBatch
      GuiControl, Hide, RenameButton
    }
  Else If ActionList=Rename From List
    {
      GuiControl, Show, ListClear
      GuiControl, Show, ListOpen
      GuiControl, Show, ListSave
      GuiControl, Show, ListOfNames
      GuiControl, Show, ListOriginalExt
      GuiControl, Show, ListExt
      GuiControl, Show, ListText
      GuiControl, Hide, AddToBatch
    }
  PreviousAction := ActionList
  Gosub, Preview
Return

HideControls:
  Loop %cnt%
    {
      If A_Index>1
          PreviousAction:=arraylist%A_Index%
      If PreviousAction=Spacing
        {
          GuiControl, Hide, SpaceGroup
          GuiControl, Hide, DelExtraSpace
          GuiControl, Hide, DotToSpace
          GuiControl, Hide, UnderToSpace
          GuiControl, Hide, CommaToSpace
          GuiControl, Hide, SkipNumSeq
        }
      Else If PreviousAction=Case Correction
        {
          GuiControl, Hide, CapFirst
          GuiControl, Hide, CapAll
          GuiControl, Hide, Uppercase
          GuiControl, Hide, Lowercase
          GuiControl, Hide, InvertCase
        }
      Else If PreviousAction=Bracket Deletion
        {
          GuiControl, Hide, BracketText1
          GuiControl, Hide, SquareBracket
          GuiControl, Hide, CurlyBracket
          GuiControl, Hide, RoundBracket
          GuiControl, Hide, OpenBracket
          GuiControl, Hide, BracketText2
          GuiControl, Hide, StartLeft
          GuiControl, Hide, StartRight
          GuiControl, Hide, BracketText3
          GuiControl, Hide, DelAllBracket
          GuiControl, Hide, DelNumBracket
          GuiControl, Hide, NumBracket
          GuiControl, Hide, NumBracket2
          GuiControl, Hide, BracketText4
        }
      Else If PreviousAction=String Replacement
        {
          GuiControl, Hide, StringReplaceText
          GuiControl, Hide, SearchField
          GuiControl, Hide, ReplaceField
          GuiControl, Hide, AddStringReplace
          GuiControl, Hide, StringReplaceList
          GuiControl, Hide, ReplaceAll
          GuiControl, Hide, ReplaceWithCase
          GuiControl, Hide, RemoveSRL
          GuiControl, Hide, ClearSRL
          GuiControl, Hide, EditSRL
          GuiControl, Hide, MoveUpSRL
          GuiControl, Hide, MoveDownSRL
        }
      Else If PreviousAction=Insertion
        {
          GuiControl, Hide, InsertString
          GuiControl, Hide, InsertCounterRadio
          GuiControl, Hide, InsertStringText
          GuiControl, Hide, InsertStringRadio
          GuiControl, Hide, InsertStringGroup
          GuiControl, Hide, InsertCounterGroup
          GuiControl, Hide, InsertCounterText
          GuiControl, Hide, CounterStart
          GuiControl, Hide, CounterStart2
          GuiControl, Hide, CounterDigits
          GuiControl, Hide, CounterDigits2
          GuiControl, Hide, CounterIncrement
          GuiControl, Hide, CounterIncrement2
          GuiControl, Hide, InsertAtPositionText
          GuiControl, Hide, InsertAtPosition
          GuiControl, Hide, InsertAtPosition2
          GuiControl, Hide, InsertFromBeginning
          GuiControl, Hide, InsertFromEnd
          GuiControl, Hide, AddSpaceBefore
          GuiControl, Hide, AddSpaceAfter
        }
      Else If PreviousAction=Character Deletion
        {
          GuiControl, Hide, CharDel
          GuiControl, Hide, CharDelCount
          GuiControl, Hide, CharDelCount2
          GuiControl, Hide, DelAfter
          GuiControl, Hide, DelBefore
          GuiControl, Hide, DelFromPositionText
          GuiControl, Hide, DelFromPosition
          GuiControl, Hide, DelFromPosition2
          GuiControl, Hide, DelFromBeginning
          GuiControl, Hide, DelFromEnd
          GuiControl, Hide, DelFromString
        }
      Else If PreviousAction=Regular Expression
        {
          GuiControl, Hide, RegExText1
          GuiControl, Hide, RegExText2
          GuiControl, Hide, RegEx
          GuiControl, Hide, RegExNewName
          GuiControl, Hide, RegExHelp1
          GuiControl, Hide, RegExHelp2
        }
      Else If PreviousAction=Custom
        {
          GuiControl, Hide, Template
          GuiControl, Hide, TemplateText
          GuiControl, Hide, TemplateNotes
        }
      Else If PreviousAction=Amber's Counter
        {
          GuiControl, Hide, InsertCounterText
          GuiControl, Hide, CounterStart
          GuiControl, Hide, CounterStart2
          GuiControl, Hide, CounterDigits
          GuiControl, Hide, CounterDigits2
          GuiControl, Hide, CounterIncrement
          GuiControl, Hide, CounterIncrement2
          GuiControl, Hide, InsertAtPositionText
          GuiControl, Hide, InsertAtPosition
          GuiControl, Hide, InsertAtPosition2
          GuiControl, Hide, InsertFromBeginning
          GuiControl, Hide, InsertFromEnd
          GuiControl, Hide, AddSpaceBefore
          GuiControl, Hide, AddSpaceAfter
          GuiControl, Hide, AmberCounterText
          GuiControl, Hide, AmberButton
          GuiControl, Show, RenameButton
        }
      Else If PreviousAction=Rename From List
        {
          GuiControl, Hide, ListClear 
          GuiControl, Hide, ListOpen 
          GuiControl, Hide, ListSave
          GuiControl, Hide, ListOfNames 
          GuiControl, Hide, ListOriginalExt 
          GuiControl, Hide, ListExt 
          GuiControl, Hide, ListText
        }
    }
Return

;=================================================
;================File List========================
;=================================================

GUIFiles:
  Gui +OwnDialogs
  FileSelectFile, Files, M3, %LastFileDir%, Select a file or files to Rename
  If ErrorLevel
      Return
  GuiControl, -Redraw, FileList
  Loop, Parse, Files, `n
    {
      If (A_Index = 1)
          FilePath = %A_LoopField%.
      Else
        {
          SplitPath, A_LoopField, FileName,, FileExt
          LV_Add("", FileName, FilePath, FileExt)
        }
    }
  GuiControl, +Redraw, FileList
  LV_ModifyCol(1, "AutoHdr")
  LV_ModifyCol(2, "AutoHdr")
  LastFileDir:=FilePath
  GuiControl, Disable, UndoButton
  Gosub, PreviewAll
Return

GUIFolder:
  Gui +OwnDialogs
  Gui, Submit, NoHide
  FileSelectFolder, FileLocation, %LastFolderDir%, 3, Select the folder that Contains the files to be Renamed
  If ErrorLevel
      Return
  LastFolderDir:=A_Desktop " *" FileLocation
  GuiControl, -Redraw, FileList
  StringRight, LastChar, FileLocation, 1
  If LastChar = \
      StringTrimRight, FileLocation, FileLocation, 1
  Loop, %FileLocation%\*,0,%SubFolder%
      LV_Add("", A_LoopFileName, A_LoopFileDir, A_LoopFileExt)
  GuiControl, +Redraw, FileList
  LV_ModifyCol(1, "AutoHdr")
  LV_ModifyCol(2, "AutoHdr")
  GuiControl, Disable, UndoButton
  Gosub, PreviewAll
Return

ContextProperties:
  FocusedRowNumber := LV_GetNext(0, "F")
  If Not FocusedRowNumber
      Return
  LV_GetText(FileName, FocusedRowNumber, 1)
  LV_GetText(FilePath, FocusedRowNumber, 2)
  Run Properties "%FilePath%\%FileName%",, UseErrorLevel
  If ErrorLevel
      MsgBox, Could not perform requested action on "%FilePath%\%FileName%".
Return

ClearFileListRows:
  GuiControl, -Redraw, FileList
  RowNumber = 0
  Loop
    {
      RowNumber := LV_GetNext(RowNumber - 1)
      If not RowNumber
          Break
      LV_Delete(RowNumber)
    }
  GuiControl, +Redraw, FileList
  GuiControl, Disable, UndoButton
  Gosub, PreviewAll
Return

ClearAllFileListRows:
  GuiControl, -Redraw, FileList
  LV_Delete()
  LV_ModifyCol(1, "AutoHdr")
  LV_ModifyCol(2, "AutoHdr")
  GuiControl, +Redraw, FileList
  GuiControl, Disable, UndoButton
  Gosub, PreviewAll
Return

ClearDeadFileListRows:
  GuiControl, -Redraw, FileList
  RowNumber:=1
  Loop
    {
      Length:=LV_GetCount()
      If Length<=%RowNumber%
          Break
      LV_GetText(FileName, RowNumber, 1)
      LV_GetText(FilePath, RowNumber, 2)
      IfNotExist, %FilePath%\%FileName%
          LV_Delete(RowNumber)
      Else
          RowNumber++
    }
  LV_ModifyCol(1, "AutoHdr")
  LV_ModifyCol(2, "AutoHdr")
  GuiControl, +Redraw, FileList
  GuiControl, Disable, UndoButton
  Gosub, PreviewAll
Return

;=================================================
;=============String Replace List=================
;=================================================

AddStringReplace:
  Gui, ListView, StringReplaceList
  Gui, Submit, NoHide
  If StrLen(SearchField) = 0
      Return
  LV_Add("", SearchField, ReplaceField)
  If LV_GetCount()>11
    {
      LV_ModifyCol(1, 178)
      LV_ModifyCol(2, 178)
    }
  GuiControl,, SearchField,
  GuiControl,, ReplaceField,
  Gui, ListView, FileList
  Gosub, Preview
Return

EditSRL:
  Gui, ListView, StringReplaceList
  FocusedRowNumber := LV_GetNext(0, "F")
  If Not FocusedRowNumber
      Return
  LV_GetText(TempSearch, FocusedRowNumber, 1)
  LV_GetText(TempReplace, FocusedRowNumber, 2)
  LV_Delete(FocusedRowNumber)
  GuiControl,, SearchField, %TempSearch%
  GuiControl,, ReplaceField, %TempReplace%
  Gui, ListView, FileList
  Gosub, Preview
Return

RemoveSRL:
  Gui, ListView, StringReplaceList
  GuiControl, -Redraw, StringReplaceList
  RowNumber = 0
  Loop
    {
      RowNumber := LV_GetNext(RowNumber - 1)
      If not RowNumber
          Break
      LV_Delete(RowNumber)
    }
  If LV_GetCount()<12
    {
      LV_ModifyCol(1, 187)
      LV_ModifyCol(2, 187)
    }
  GuiControl, +Redraw, StringReplaceList
  Gui, ListView, FileList
  Gosub, Preview
Return

ClearSRL:
  Gui, ListView, StringReplaceList
  GuiControl, -Redraw, StringReplaceList
  LV_Delete()
  LV_ModifyCol(1, 187)
  LV_ModifyCol(2, 187)
  GuiControl, +Redraw, StringReplaceList
  Gui, ListView, FileList
  Gosub, Preview
Return

MoveUpSRL:
  Gui, ListView, StringReplaceList
  FocusedRowNumber := LV_GetNext(0, "F")
  MoveRowNumber:= FocusedRowNumber-1
  If FocusedRowNumber=1
    {
      Gui, ListView, FileList
      Return
    }
  GuiControl, -Redraw, BatchList
  LV_GetText(Temp1, FocusedRowNumber, 1)
  LV_GetText(Temp2, FocusedRowNumber, 2)
  LV_GetText(Temp3, MoveRowNumber, 1)
  LV_GetText(Temp4, MoveRowNumber, 2)
  LV_Modify(FocusedRowNumber, "", Temp3, Temp4)
  LV_Modify(MoveRowNumber, "Select Focus", Temp1, Temp2)
  GuiControl, +Redraw, StringReplaceList
  Gui, ListView, FileList
  Gosub, Preview
Return

MoveDownSRL:
  Gui, ListView, StringReplaceList
  FocusedRowNumber := LV_GetNext(0, "F")
  MoveRowNumber:= FocusedRowNumber+1
  Length:=LV_GetCount()
  If Length<=%FocusedRowNumber%
    {
      Gui, ListView, FileList
      Return
    }
  GuiControl, -Redraw, BatchList
  LV_GetText(Temp1, FocusedRowNumber, 1)
  LV_GetText(Temp2, FocusedRowNumber, 2)
  LV_GetText(Temp3, MoveRowNumber, 1)
  LV_GetText(Temp4, MoveRowNumber, 2)
  LV_Modify(FocusedRowNumber, "", Temp3, Temp4)
  LV_Modify(MoveRowNumber, "Select Focus", Temp1, Temp2)
  GuiControl, +Redraw, StringReplaceList
  Gui, ListView, FileList
  Gosub, Preview
Return

SaveSRL:
  Gui, ListView, StringReplaceList
  StoredSRL:=""
  ListLength:=LV_GetCount()
  Loop %ListLength%
    {
      LV_GetText(SearchString, A_Index, 1)
      LV_GetText(ReplaceString, A_Index, 2)
      StoredSRL:=StoredSRL SearchString "?" ReplaceString "?"
    }
  IniWrite, %StoredSRL%, %INIFile%, Settings, StoredSRL
  Gui, ListView, FileList
Return

LoadSRL:
  IniRead, StoredSRL, %INIFile%, Settings, StoredSRL, %A_Space%
  Gui, ListView, StringReplaceList
  GuiControl, -Redraw, StringReplaceList
  Loop, Parse, StoredSRL, ?
    {
      StringSplit, OutArray, A_LoopField, ?
      If OutArray0
          LV_Add("", OutArray1, OutArray2)
    }
  If LV_GetCount()>11
    {
      LV_ModifyCol(1, 178)
      LV_ModifyCol(2, 178)
    }
  GuiControl, +Redraw, StringReplaceList
  Gui, ListView, FileList
Return

;=================================================
;===============Rename From List==================
;=================================================

ListOptionButtons:
  Gui, Submit, NoHide
  If A_GuiControl=ListClear
    GuiControl,, ListOfNames, 
  Else If A_GuiControl=ListOpen
    OpenList()
  Else If A_GuiControl=ListSave
    SaveList(ListOfNames)
  Gosub Preview
Return

OpenList()
  {
    Global ListOpenDir
    FileSelectFile, OutFile, 3, %ListOpenDir%, Open, Text Documents (*.txt)
    If ErrorLevel
        Return
	ListOpenDir:=OutFile
    FileRead, FileContents, %OutFile%
    GuiControl,, ListOfNames, %FileContents%
  }

SaveList(CurrentList)
  {
    Global ListSaveDir
    FileSelectFile, OutFile, S, %ListSaveDir%, Save, Text Documents (*.txt)
    If ErrorLevel
        Return
	ListSaveDir:=OutFile
    FileDelete, %OutFile%
    FileAppend, %CurrentList%, %OutFile%
  }

;=================================================
;==============Renaming Algorithms================
;=================================================

StringReplacement:
  Gui, ListView, StringReplaceList
  If LV_GetCount()
    {
      If ReplaceWithCase
          StringCaseSense, ON
      Loop % LV_GetCount()
        {
          LV_GetText(SearchString, A_Index, 1)
          LV_GetText(ReplaceString, A_Index, 2)
          StringReplace, FileName, FileName, %SearchString%, %ReplaceString%, %ReplaceAll%
        }
      StringCaseSense, OFF
    }
  NewName:=DeleteIllegalChars(FileName)
  Gui, ListView, FileList
Return

SpaceCorrection(FileName, DelExtraSpace, DotToSpace, CommaToSpace, UnderToSpace, SkipNumSeq)
  {
    If DotToSpace
      {
        If SkipNumSeq
		  {
            FileName := RegExReplace( FileName, "(?<=\d)\.(?=\d)", "|")
            StringReplace, FileName, FileName, ., %A_Space%, ALL
            StringReplace, FileName, FileName, |, ., All
		  }
        Else
          StringReplace, FileName, FileName, ., %A_Space%, ALL
      }
    If CommaToSpace
      StringReplace, FileName, FileName, `,, %A_Space%, ALL
    If UnderToSpace
      StringReplace, FileName, FileName, _, %A_Space%, ALL
    If DelExtraSpace
      {
        FileName=%FileName%
        Loop
          {
            StringReplace, FileName, FileName, %A_Space%%A_Space%, %A_Space%
            If ErrorLevel
              Break
          }
      }
    Return FileName
  }

CaseCorrection(FileName, CapFirst, CapAll, UpperCase, LowerCase, InvertCase)
  {
    If CapFirst
      {
        StringLower, FileName, FileName
        FirstChar:=SubStr(FileName, 1, 1)
        StringUpper, FirstChar, FirstChar
        FileName:=SubStr(FileName, 2)
        FileName:=FirstChar FileName
      }
    Else If CapAll
        StringUpper, FileName, FileName, T
    Else If Uppercase
        StringUpper, FileName, FileName
    Else If Lowercase
        StringLower, FileName, FileName
    Else If InvertCase
      {
        NewFileName:=""
        Loop, Parse, FileName
          {
            Char:= A_LoopField
            If Char Is Upper
                StringLower, Char, Char
            Else If Char Is Lower
                StringUpper, Char, Char
            NewFileName:=NewFileName Char
          }
        FileName:=NewFileName
      }
    Return FileName
  }

InsertString(FileName, InsertString, InsertAtPosition, InsertFromBeginning=1)
  {
    If InsertFromBeginning
      {
        StringMid, BeforeString, FileName, InsertAtPosition,, L
        StringMid, AfterString, FileName, InsertAtPosition+1
      }
    Else
      {
        StringLen, Length, FileName
        InsertAtPosition:= Length - InsertAtPosition
        StringMid, BeforeString, FileName, InsertAtPosition,, L
        StringMid, AfterString, FileName, InsertAtPosition+1
      }
    FileName:= BeforeString InsertString AfterString
    Return DeleteIllegalChars(FileName)
  }

InsertCounter(FileName,ByRef Counter, CounterDigits, CounterIncrement, AddSpaceBefore, AddSpaceAfter, InsertAtPosition, InsertFromBeginning, InsertFromEnd=0)
  {
    IncrementCounter(Counter, CounterDigits, CounterIncrement, AddSpaceBefore, AddSpaceAfter)
    FileName:=InsertString(FileName, Counter, InsertAtPosition, InsertFromBeginning)
    Return FileName
  }

IncrementCounter(ByRef Counter, CounterDigits, CounterIncrement, AddSpaceBefore=0, AddSpaceAfter=0)
  {
    Counter=%Counter%
    Counter := Counter + CounterIncrement
    StringLen, CounterLength, Counter
    Loop % CounterDigits-CounterLength
        Counter := "0" Counter
    If AddSpaceBefore
        Counter := " " Counter
    If AddSpaceAfter
        Counter := Counter " "
  }

DeleteBrackets(FileName, SquareBracket, CurlyBracket, RoundBracket, OpenBracket, StartLeft, DelAllBracket, NumBracket)
  {
    If SquareBracket
      {
        Brack1:="["
        Brack2:="]"
      }
    Else If CurlyBracket
      {
        Brack1:="{"
        Brack2:="}"
      }
    Else If RoundBracket
      {
        Brack1:="("
        Brack2:=")"
      }
    If Not StartLeft
        Gosub, ReverseFileName
    NumBracket++
    Length=
    Gosub, ClearVars
    NewFileName:=FileName

    ; Couldn't get a working regex for open brackets
    Loop
      {
        If NOT DelAllBracket && A_Index>NumBracket
            Break
        NoChange:=True
        FileName:=NewFileName
        StringLen, Length, FileName

        Loop, Parse, FileName
          {
            If (A_LoopField=Brack1)
              {
                Temp1:=True
                StartBracket:=A_Index
              }
            If (A_LoopField=Brack2)
              {
                EndBracket:=A_Index
                If (Temp1)
                  {
                    Temp1=
                    If (EndBracket=Length)
                      {
                        NewFileName:=SubStr(FileName,1,--StartBracket)
                        Gosub, ClearVars
                        Break
                      }
                    If (StartBracket>1)
                      {
                        NewFileName:=SubStr(FileName,1,--StartBracket) SubStr(FileName,++EndBracket)
                        Gosub, ClearVars
                        Break
                      }
                  }
                If OpenBracket
                  {
                    NewFileName:=SubStr(FileName,++EndBracket)
                    Gosub, ClearVars
                    Break
                  }
              }
            If (Length=A_Index AND Temp1 AND OpenBracket)
              {
                NewFileName:=SubStr(FileName,1,--StartBracket)
                Gosub, ClearVars
                Break
              }
          }

        If NoChange
            Break
      }
    If NOT StartLeft
        Gosub, ReverseFileName
    Return FileName

ClearVars:
  NoChange=
  Temp1=
  StartBracket=
  EndBracket=
Return

ReverseFileName:
  TempBrack:=Brack1
  Brack1:=Brack2
  Brack2:=TempBrack
  StringLen, Length, FileName
  Length++
  NewName:=""
  Loop %Length%
    {
      Pos:=Length-A_Index
      StringMid, Char, FileName, %Pos%, 1, L
      NewName:=NewName Char
    }
  FileName:=NewName
Return
}

CustomTemplate(Name, Ext, FilePath, Template, Num, List)
  {
    Ext:="." Ext
    SplitPath, FilePath, Folder
    If Not Folder
        Folder:=FilePath
    StringReplace, Template, Template, `%Name`%, %name%, All
    StringReplace, Template, Template, `%Ext`%, %Ext%, All
    StringReplace, Template, Template, `%Num`%, %Num%, All
    StringReplace, Template, Template, `%List`%, %List%, All
    StringReplace, FileName, Template, `%Folder`%, %Folder%, All
    Return DeleteIllegalChars(FileName)
  }

DeleteCharacter(FileName, CharDelCount, DelFromPositionText, DelBefore, DelFromPosition, DelFromBeginning, DelFromString)
  {
    If DelFromPositionText
      {
        If DelFromBeginning
          {
            StringMid, Part1, FileName, DelFromPosition,, L
            StringMid, Part2, FileName, DelFromPosition+CharDelCount+1
          }
        Else
          {
            StringLen, Length, FileName
            DelFromPosition:=Length-DelFromPosition+1
            StringMid, Part1, FileName, DelFromPosition-CharDelCount-1,, L
            StringMid, Part2, FileName, DelFromPosition
          }
      }
    Else
      {
        StringGetPos, StringPos, FileName, %DelFromString%
        If ErrorLevel OR (StrLen(DelFromString) = 0)
            Return FileName
        If DelBefore
          {
            StringMid, Part1, FileName, StringPos-CharDelCount,, L
            StringMid, Part2, FileName, StringPos+1
          }
        Else
          {
            StringLen, Length, DelFromString
            StringPos:=StringPos+Length
            StringMid, Part1, FileName, StringPos,, L
            StringMid, Part2, FileName, StringPos+CharDelCount+1
          }
      }
    FileName:=Part1 Part2
    Return FileName
  }

ListRenaming(FileName, FileExt, ByRef List, ListOriginalExt, ListExt)
  {
    ListItem:=NextItemInList(List)
    If StrLen(ListItem) = 0
      Return FileName "." FileExt
    If ListExt
      FullFileName:=FileName "." ListItem
    Else If ListOriginalExt
      FullFileName:=ListItem "." FileExt
    Else
      FullFileName:=ListItem
    Return FullFileName
  }

NextItemInList(ByRef List)
  {
    Position:=InStr(List, "`n")
    If Position
      {
        ListItem := SubStr(List, 1, Position-1)
        List := SubStr(List, Position+1)
        Return ListItem
      }
    If StrLen(List) != 0
      {
        ListItem:=List
        List:=""
        Return ListItem
      }
  }

DeleteIllegalChars(FileName)
  {
    StringReplace, FileName, FileName, \,, All
    StringReplace, FileName, FileName, /,, All
    StringReplace, FileName, FileName, :,, All
    StringReplace, FileName, FileName, ?,, All
    StringReplace, FileName, FileName, <,, All
    StringReplace, FileName, FileName, >,, All
    StringReplace, FileName, FileName, *,, All
    StringReplace, FileName, FileName, |,, All
    StringReplace, FileName, FileName, ",, All ;"
    Return FileName
  }
  
;=================================================
;=====================Hotkeys=====================
;=================================================

#IfWinActive Lightning Renamer

~Enter::
  GuiControlGet, OutputVar, Focus
  IfInString, OutputVar, Edit15
    Return
  GuiControlGet, Tabs
  Tabs=%Tabs%
  If Tabs=Actions
    Gosub RenameButton
  Else
    Gosub RenameBatchButton
Return

#IfWinActive
