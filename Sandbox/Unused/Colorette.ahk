; ******* General ******* 
; COLORETTE
ScriptVersion := 1.0
; Script created using Autohotkey (http://www.autohotkey.com)
; AHK version: AHK_L (www.autohotkey.net/~Lexikos/AutoHotkey_L)
; Library dependancies:
; - DLG.ahk for color Dialogue
;
; AUTHOR: sumon @ the Autohotkey forums, (simon.stralberg (@) gmail.com)
; License: sumon's Std License (see my forum signature)
; 
; Thanks to: The Naked General _ jamixzol@gmail.com for his "Flashy and impractical color picker" which inspired me to this. Some of his comments may remain.
; || To-do ||
; Settings?
; Smoother solution for the hotkeys

TrayTip, Colorette:, Hover and RIGHTCLICK to copy RGB value`nPress SPACE for a color dialogue, 4, 1
OnExit, Exit
SetSystemCursor("IDC_Cross")
FileCreateDir, data
FileInstall, data\pick_click.wav, data\pick_click.wav
If (FileExist("colorette.exe"))
   Menu, Tray, Icon, Colorette.exe
; MAIN LOOOP: Pick Color

Loop ;Note: Some code from below is not needed
{
CoordMode, Mouse, Screen
MouseGetPos X, Y
PixelGetColor Color, X, Y, RGB
ColorD := Color ;build an int based variable
StringRight, color, color, 6 ;removes 0x prefix
SetFormat, IntegerFast, d
ColorD += 0  ; Sets Var (which previously contained 11) to be 0xb.
ColorD .= ""  ; Necessary due to the "fast" mode.

Gui, 2:Color, %color%
CoordMode, Pixel 
mX := X - 25
mY := Y - 80
Gui, 2:-Caption +ToolWindow +LastFound +AlwaysOnTop +Border

Gui, 2:Show, NoActivate x%mX% y%mY% w50 h50
}

RButton:: ; Catch Hover'd color
If (FileExist("data\pick_click.wav"))
   SoundPlay, data\pick_click.wav
ColorPicked:
StringRight, color, color, 6 ; Color HEX to RGB (or RGB to RGB)
   Clipboard := "null" ; So a void Clipboard doesn't seem as a capture
   Send ^c
   ClipboardCurrent := Clipboard ; To check StrLen
Clipboard := color
If (RegExMatch(ClipboardCurrent, "[0-9A-Fa-f]{6}")) ; WHY ALL THIS? Because, if someone selects a colorcode, Colorette will replace it with the chosen color. Otherwise it'll just go to the clipboard.
{ 
   Send ^v
   Traytip, Colorette:, %color% inserted, 2, 1
}
else
   Traytip, Colorette:, %color% picked, 2, 1
; 
RestoreCursors()
Gui, 2:Destroy
Sleep 2000
Gosub, Exit
Return

esc::
Exit:
RestoreCursors()
ExitApp
return

Space::  
Gui, 2:Hide
RestoreCursors()
Dlg_Color(color)  
Gosub, ColorPicked
return

; FUNCTIONS
; : SetSystemCursor() and RestoreCursors()
RestoreCursors()
{
   SPI_SETCURSORS := 0x57
   DllCall( "SystemParametersInfo", UInt,SPI_SETCURSORS, UInt,0, UInt,0, UInt,0 )
}

SetSystemCursor( Cursor = "", cx = 0, cy = 0 )
{
   BlankCursor := 0, SystemCursor := 0, FileCursor := 0 ; init
   
   SystemCursors = 32512IDC_ARROW,32513IDC_IBEAM,32514IDC_WAIT,32515IDC_CROSS
   ,32516IDC_UPARROW,32640IDC_SIZE,32641IDC_ICON,32642IDC_SIZENWSE
   ,32643IDC_SIZENESW,32644IDC_SIZEWE,32645IDC_SIZENS,32646IDC_SIZEALL
   ,32648IDC_NO,32649IDC_HAND,32650IDC_APPSTARTING,32651IDC_HELP
   
   If Cursor = ; empty, so create blank cursor 
   {
      VarSetCapacity( AndMask, 32*4, 0xFF ), VarSetCapacity( XorMask, 32*4, 0 )
      BlankCursor = 1 ; flag for later
   }
   Else If SubStr( Cursor,1,4 ) = "IDC_" ; load system cursor
   {
      Loop, Parse, SystemCursors, `,
      {
         CursorName := SubStr( A_Loopfield, 6, 15 ) ; get the cursor name, no trailing space with substr
         CursorID := SubStr( A_Loopfield, 1, 5 ) ; get the cursor id
         SystemCursor = 1
         If ( CursorName = Cursor )
         {
            CursorHandle := DllCall( "LoadCursor", Uint,0, Int,CursorID )   
            Break               
         }
      }   
      If CursorHandle = ; invalid cursor name given
      {
         Msgbox,, SetCursor, Error: Invalid cursor name
         CursorHandle = Error
      }
   }   
   Else If FileExist( Cursor )
   {
      SplitPath, Cursor,,, Ext ; auto-detect type
      If Ext = ico 
         uType := 0x1   
      Else If Ext in cur,ani
         uType := 0x2      
      Else ; invalid file ext
      {
         Msgbox,, SetCursor, Error: Invalid file type
         CursorHandle = Error
      }      
      FileCursor = 1
   }
   Else
   {   
      Msgbox,, SetCursor, Error: Invalid file path or cursor name
      CursorHandle = Error ; raise for later
   }
   If CursorHandle != Error 
   {
      Loop, Parse, SystemCursors, `,
      {
         If BlankCursor = 1 
         {
            Type = BlankCursor
            %Type%%A_Index% := DllCall( "CreateCursor"
            , Uint,0, Int,0, Int,0, Int,32, Int,32, Uint,&AndMask, Uint,&XorMask )
            CursorHandle := DllCall( "CopyImage", Uint,%Type%%A_Index%, Uint,0x2, Int,0, Int,0, Int,0 )
            DllCall( "SetSystemCursor", Uint,CursorHandle, Int,SubStr( A_Loopfield, 1, 5 ) )
         }         
         Else If SystemCursor = 1
         {
            Type = SystemCursor
            CursorHandle := DllCall( "LoadCursor", Uint,0, Int,CursorID )   
            %Type%%A_Index% := DllCall( "CopyImage"
            , Uint,CursorHandle, Uint,0x2, Int,cx, Int,cy, Uint,0 )      
            CursorHandle := DllCall( "CopyImage", Uint,%Type%%A_Index%, Uint,0x2, Int,0, Int,0, Int,0 )
            DllCall( "SetSystemCursor", Uint,CursorHandle, Int,SubStr( A_Loopfield, 1, 5 ) )
         }
         Else If FileCursor = 1
         {
            Type = FileCursor
            %Type%%A_Index% := DllCall( "LoadImageA"
            , UInt,0, Str,Cursor, UInt,uType, Int,cx, Int,cy, UInt,0x10 ) 
            DllCall( "SetSystemCursor", Uint,%Type%%A_Index%, Int,SubStr( A_Loopfield, 1, 5 ) )         
         }          
      }
   }   
}
