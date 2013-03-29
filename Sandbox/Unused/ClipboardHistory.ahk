;v 2.01


#Persistent
#SingleInstance force
#NoTrayIcon

ClipBoardHistory()
return


initializeClipBoardHistory:
SendMode Input


;set constants
clph_trimText:=true ;trim leading and tailing spaces of text put into history, only history entries will be trimmed, not the text in clipboard
clph_maxHistoryEntryLength:=1000 ; do not put strings longer than this number into history
clph_listAppearOnPress := 2 ; Listview should appear if paste button is pressed for the 2nd time

clph_Concatenators := new ArrayList
;generate list of joining strings
clph_Concatenators.Insert(" - ")
clph_Concatenators.Insert(" ")
clph_Concatenators.Insert("-")
clph_Concatenators.Insert("`n")



clph_selectedConcatenator := 1


;initialize variables
monitorClipboardEnabled:=true
;initialize the 1st list
clph_History := new ArrayList
clph_SelectedEntries := new ArrayList

;add an entry to the tray icon menu
Menu, TRAY, Add, Clear History, clph_clearHistory
return


;can be called by scripts that #include this one
ClipBoardHistory()
  {
    global clph_maxHistoryEntries
    clph_maxHistoryEntries:=30 ;how many history entries to keep
    rowCount := clph_maxHistoryEntries + 1
    ;create the gui
    Gui, 2: +AlwaysOnTop
    Gui, 2: Margin, 0,0 ;must be called before the Listview control is added
    Gui, 2: Add, ListView,-Hdr w500  R%rowCount% AltSubmit gClph_ListView, index|content
    Gui, 2: -caption
    gui, 2:+ToolWindow ;don't make taskbar button
    ; make the window title distinguishable so it won't detect the browser title for example 
    Gui, 2: Show, Hide, Clipboard History897516 ;used to set the title without actually showing the window
    gosub, initializeClipBoardHistory
  }




OnClipboardChange: ; runs once at startup btw
  ;don't do anything if disabled. Can be used by other included scripts when using the clipboard temporarily
  if(!monitorClipboardEnabled)
    return
  
  clph_addToHistory()
    if (A_EventInfo=1) ;1 if it contains something that can be expressed as text (this includes files copied from an Explorer window)
      {
        
      if(StrLen(Clipboard) <=clph_maxHistoryEntryLength)
        {
          clph_History.RemoveValue(Clipboard)
          if(clph_trimText)
            ;trim the text
            clph_tempClipBoardText=%Clipboard%
            else
              ;don't trim the text
              clph_tempClipBoardText:=Clipboard
    
        }
      }

return

#IfWinExist, Clipboard History897516 ahk_class AutoHotkeyGUI
^c::

  clph_concatenatorButtonPressed()
return
#IfWinExist

$^v::
  clph_pasteButtonPressed()
return

clph_concatenatorButtonPressed()
  {
    global clph_Concatenators, clph_selectedConcatenator
    concatenatorCount := clph_Concatenators.Size()
    if(clph_selectedConcatenator == concatenatorCount)
      {
        clph_selectedConcatenator := 1
      }
      else
        {
          clph_selectedConcatenator++
        }
    clph_updateTooltip()
    
  }


clph_pasteButtonPressed()
  {
    global ArrayList, clph_History, clph_SelectedEntries, clph_pastePressCount, clph_ListViewLeftClickCount, clph_pasteMode, clph_listAppearOnPress
    
    clph_pastePressCount++
    if(!clph_pasteMode)
      {
        clph_pasteMode:=true
        
      }
    
    if(clph_SelectedEntries.Size()>0)
      {
        ;get first selected entry
        firstSelectedEntry := clph_SelectedEntries[1]
        
        if(firstSelectedEntry==clph_History.Size())
          {
            entryToSelect := clph_rowToHistoryEntry(1) 
            
          }
          else
            {
              entryToSelect := firstSelectedEntry + 1
            }
        
      }
      else
        {
          entryToSelect := clph_rowToHistoryEntry(1)
        }
    ;remove the current selection
    clph_SelectedEntries := new ArrayList
    clph_SelectedEntries.Insert(entryToSelect)
    
    if(clph_pastePressCount == clph_listAppearOnPress) ; appear only on 2nd press
      clph_showGui()
    
    ; must be called after the LV has been created
    clph_updateGui(entryToSelect)
    
  
    
    
    clph_updateTooltip()
    
    
    
    clph_ListViewLeftClickCount := 0
  
  }


$^q:: ;$ is against self triggering by send command
if(clph_pasteMode)
  {
    clph_selectPrevious()


  }
  else
    {
      send, ^q
    }
return

clph_selectPrevious()
  {
    global
    local firstSelectedEntry, entryToSelect
    if(clph_SelectedEntries.Size()>0)
      {
        ;get first currently selected entry
        firstSelectedEntry := clph_SelectedEntries[1]
        
        if(firstSelectedEntry==1)
          {
            if(clipboard=="")
              {
                entryToSelect := clph_History.Size()
              }
              else
                {
                  entryToSelect := 0
                }
            
            
          }
          else if(firstSelectedEntry==0)
            {
              entryToSelect := clph_History.Size()
            }
          else 
            {
              entryToSelect := firstSelectedEntry - 1
            }
        
      }

    ;remove the current selection
    clph_SelectedEntries := new ArrayList
    clph_SelectedEntries.Insert(entryToSelect)



    clph_updateGui(entryToSelect)
    clph_updateTooltip()
    clph_ListViewLeftClickCount := 0
    
  }



$^l::
  if(clph_pasteMode)
    {
      clph_endPaste()
      clph_SelectedEntries := new ArrayList
    }
    else
      {
        send, ^l
      }
return



~Control UP::
  if(clph_pasteMode)
    {
      clph_paste()
     
      
    }
return

clph_paste()
  {
    global ArrayList, clph_History, clph_SelectedEntries
    clph_endPaste()
    if(clph_SelectedEntries.Size()>0)
      {
        ;if only 0 is selected i.e. current clipboard don't generate it because it could be something else than text e.g. pasting files in explorer
        if(clph_SelectedEntries[1]!=0 || clph_SelectedEntries.Size()>1)
          {
            pasteText := clph_generatePasteText()
            ;check ;if only 1 entry was selected
            if(clph_SelectedEntries.Size()==1)
              {
                ;delete it from history because it will become current clipboard and later be added again
                clph_History.Remove(clph_SelectedEntries[1])
                
              }
            ;insert it into clipboard so it can be pasted
            clipboard := pasteText
          
          }
              
        Send, ^v      
        clph_SelectedEntries := new ArrayList
      
      
      }
  
  }



clph_endPaste()
{
  global
    Gui, 2: hide
    ToolTip
    clph_pasteMode:=false
    Gui 2:Default
    LV_Delete()
    Gui 1:Default
    clph_pastePressCount := 0
    clph_ListViewLeftClickCount := 0
    clph_Concatenators.Move(clph_selectedConcatenator, 1)
    clph_selectedConcatenator := 1
    
    
}

clph_addToHistory()
  {
    global clph_History, clph_tempClipBoardText, clph_maxHistoryEntryLength, clph_maxHistoryEntries
    ;check if already in list
    foundAtPosition := clph_History.IndexOf(clph_tempClipBoardText)
    if (foundAtPosition!=0){
      ;if already in list move to top of list
      
      clph_History.Move(foundAtPosition, 1)
      
      }
      ;else add at top of the list
      else
        {
        
          ;first check if clipboard has really changed because may apps copy the same text to clipboard twice
          ;only add to history if text is shorter than the specified clph_maxHistoryEntryLength
          if ( clipboard != clph_tempClipBoardText && 0 < StrLen(clph_tempClipBoardText))
            {  
              clph_History.Insert(1,clph_tempClipBoardText)      

      
              ;trim the number of entries
              clph_History.Trim(clph_maxHistoryEntries)
      
            }
        }
        
  }




clph_clearHistory:
  clph_History := new ArrayList

return


clph_updateTooltip()
  {
    global clph_SelectedEntries
    if(clph_SelectedEntries.Size()==1)
      {
        ;if only one entry is selected
        ;insert the position in front of the text
        selectedEntryNum := clph_SelectedEntries[1]
        ToolTip, % selectedEntryNum . ": "clph_generatePasteText()
      }
      else
        ;otherwise just show the text
        {
          ToolTip, % clph_generatePasteText()
        }
        
    
    
    
    
  }

clph_generatePasteText()
{
  global clph_SelectedEntries, clph_History, clph_Concatenators, clph_selectedConcatenator
  concatenatedString := ""
  entriesCount := clph_SelectedEntries.Size()
  Loop , % entriesCount
    {
      ;assuming clph_selectedEntries is the position in the history not the ListView
      selectedEntryNum := clph_SelectedEntries[A_Index]
      if(selectedEntryNum == 0)
        {
          concatenatedString .= Clipboard
        }
        else
          {
            concatenatedString .= clph_History[selectedEntryNum]
          }
      if(!(entriesCount==A_Index))
        {
          concatenatedString .= clph_Concatenators[clph_selectedConcatenator]
        }
    
     
    }
  return concatenatedString
}
    

Clph_ListView:
if(A_GuiEvent=="Normal")
  {
 
    clph_ListViewLeftClicked(A_EventInfo)
    

  }
  else if(A_GuiEvent=="RightClick")
    {
      
      clph_ListViewRightClicked(A_EventInfo)

    }
return



clph_ListViewLeftClicked(rowNumber)
  {
    
    global clph_SelectedEntries
  

  
    positionInSelectedEntries := clph_SelectedEntries.IndexOf(clph_rowToHistoryEntry(rowNumber))
    ;if clicked entry was selected i.e. was in selectedEntries list
    if(positionInSelectedEntries > 0)
      {
        clph_SelectedEntries.Remove(positionInSelectedEntries)
        
      }
        else
          {
            
            clph_SelectedEntries.Insert(clph_rowToHistoryEntry(rowNumber))

          }
  
    clph_updateTooltip()
  }


;rowNumber is the focused row not the one that was clicked
clph_ListViewRightClicked(rowNumber)
  { ;geht nicht da rechtsklick keine rows selektiert, daher linksklick simulieren
    global ArrayList, clph_SelectedEntries
    clph_SelectedEntries := new ArrayList

    LV_Modify(0, "-Select")
    
    ;select the row by left clicking
    Click ; in AHK_L this will not trigger the A_GuiEvent=="Normal" event
    selectedRow:= LV_GetNext() ; get the row that is now selected because it was right-clicked
    clph_ListViewLeftClicked(selectedRow)
    
  }


clph_showGui()
  {
    global clph_History
        Gui 2:Default
        if(clipboard!="")
          {
            LV_Add("","0 ",clipboard)
            rowCount++
          }
          
        For key, value in clph_History
          {
            LV_Add("",key, value)
          }
  
        Gui, 2: show, NA ;NA makes the gui window not get activated
        Gui 1:Default
  }



clph_updateGui(entryToSelect)
  { 
    ;global ListView1
    
    
    if(clipboard=="")
      {
        
        listPosAdd := 0
      }
      else
        {
          listPosAdd := 1
        }
      
    Gui 2:Default
    ;0 will apply command to all rows
    LV_Modify(0,"-Select")
    LV_Modify(0,"-Focus")
  
    LV_Modify(entryToSelect + listPosAdd,"Select Focus")
    Gui 1:Default
  
      
  }

;convert a row number to the Entry number in the history
;the top row in Listview is 1
clph_rowToHistoryEntry(row)
  {
    if(clipboard=="")
      return  row
    else
      return row - 1
      
  
  }

class ArrayList
{


  
  ;renturns 0 if not found
  IndexOf(value)
    {
      For k, v in this
        if(v==value)
          return k
      return 0
    }
  
  
    Move(oldPosition, newPosition)
      {
        this.Insert(newPosition, this.Remove(oldPosition))
      }
    
    Trim(size)
      {
        this.Remove(size+1, this.MaxIndex())
      }
      
    RemoveValue(value)
      {
        this.Remove(this.IndexOf(value))
      }
      
    Size()
      {
        if(this.IsEmpty())
          return 0
        else 
          return this.MaxIndex()
      }
      
    IsEmpty()
      {
        return this.MaxIndex()==""
      }
       
    
}