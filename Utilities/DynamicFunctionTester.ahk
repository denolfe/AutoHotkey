;========================================================================
;
;                 DYNAMIC FUNCTION TESTER
;
; Author:        Pulover [Rodolfo U. Batista]
;                rodolfoub@gmail.com
;
;========================================================================

; Number of Rows for each parameter and for result:
N := 6

; Optional Function Name to Evaluate Exp<b></b>ressions (#Include File Name at the bottom)
ExpFunc := "Eval"

; List of Functions and Parameters to be displayed in the list: 
Functions =
(
Abs (Number)
ACos (Number)
Asc (String)
ASin (Number)
ATan (Number)
Ceil (Number)
Chr (Number)
Cos (Number)
DllCall ("[DllFile\]Function" [, Type1, Arg1, Type2, Arg2, "Cdecl ReturnType"])
Exp (N)
FileExist (FilePattern)
FileOpen ()
Floor (Number)
Func (FunctionName)
GetKeyName (Key)
GetKeySC (Key)
GetKeyState (KeyName [, "P" or "T"])
GetKeyVK (Key)
InStr (Haystack, Needle [, CaseSensitive = false, StartingPos = 1, Occurrence = 1])
IsByRef (Var)
IsFunc (FunctionName)
IsLabel (LabelName)
IsObject ()
Ln (Number)
Log (Number)
LTrim (String, OmitChars = " `t")
Mod (Dividend, Divisor)
NumGet (VarOrAddress [, Offset = 0][, Type = "UPtr"])
NumPut (Number, VarOrAddress [, Offset = 0][, Type = "UPtr"])
OnMessage (MsgNumber [, "FunctionName"])
RegExMatch (Haystack, NeedleRegEx [, UnquotedOutputVar = "", StartingPos = 1])
RegExReplace (Haystack, NeedleRegEx [, Replacement = "", OutputVarCount = "", Limit = -1, StartingPos = 1])
RegisterCallback ("FunctionName" [, Options = "", ParamCount = FormalCount, EventInfo = Address])
Round (Number [, N])
RTrim (String, OmitChars = " `t")
Sin (Number)
Sqrt (Number)
StrGet (Address [, Length] [, Encoding = None ] )
StrLen (String)
StrPut (String, Address [, Length] [, Encoding = None ] )
SubStr (String, StartingPos [, Length])
Tan (Number)
Trim (String, OmitChars = " `t")
VarSetCapacity (UnquotedVarName [, RequestedCapacity, FillByte])
WinActive ([WinTitle, WinText, ExcludeTitle, ExcludeText])
WinExist ([WinTitle, WinText, ExcludeTitle, ExcludeText])
)

Loop, Parse, Functions, `n
{
    Funct%A_Index% := RegExReplace(A_LoopField, "\s.*")
    Funct := Funct%A_Index%
    F_%Funct% := RegExReplace(A_LoopField, "^.*\s\(", "(")
    BIFunc .= Funct%A_Index% "|"
}

#NoEnv
SetBatchLines, -1

Gui, +Resize
Gui, Add, Text,, Function:
Gui, Add, ComboBox, W100 vFunc gShowSyntax, %BIFunc%
Gui, Add, Text, ys+20 W500 vSyntax
Gui, Add, CheckBox, Section xm W300 vUseEval gUpdateResult Disabled, Evaluate Parameters As Exp[b][/b]ressions
Gui, Add, Text, Section xm W300 vText1, Parameter 1:
Gui, Add, Edit, y+10 W300 r%N% vVar1 gUpdateResult Disabled
Gui, Add, Text, W300 vText2, Parameter 2:
Gui, Add, Edit, y+10 W300 r%N% vVar2 gUpdateResult Disabled
Gui, Add, Text, W300 vText3, Parameter 3:
Gui, Add, Edit, y+10 W300 r%N% vVar3 gUpdateResult Disabled
Gui, Add, Text, ys W300 vText4, Parameter 4:
Gui, Add, Edit, y+10 W300 r%N% vVar4 gUpdateResult Disabled
Gui, Add, Text, W300 vText5, Parameter 5:
Gui, Add, Edit, y+10 W300 r%N% vVar5 gUpdateResult Disabled
Gui, Add, Text, W300 vText6, Parameter 6:
Gui, Add, Edit, y+10 W300 r%N% vVar6 gUpdateResult Disabled
Gui, Add, Text, Section xm, Result:
Gui, Add, Edit, y+10 W610 r%N% vExResult ReadOnly
Gui, Add, Edit, Section xm y+10 W550 r2 vExString ReadOnly
Gui, Add, Button, xp+550 yp+2 W60 H30 gCopyEx, Copy
If IsFunc(ExpFunc)
{
    GuiControl, Enable, UseEval
    GuiControl,, UseEval, 1
}
Gui, Show, W640, Dynamic Function Tester
return

CopyEx:
Gui, Submit, NoHide
Clipboard := ExString
return

ShowSyntax:
Gui, Submit, NoHide
Loop, 6
{
    GuiControl, -Redraw, Text%A_index%
    GuiControl,, Text%A_index%
    GuiControl, -Redraw, Var%A_index%
    GuiControl,, Var%A_index%
    GuiControl, Disable, Var%A_index%
}
GuiControl,, Syntax, % F_%Func%
ThisFunc := RegExReplace(F_%Func%, "\(|\)|\[|\]")
Loop, Parse, ThisFunc, `,
{
    Param := A_LoopField
    GuiControl,, Text%A_Index%, %Param%
    GuiControl, Enable, Var%A_index%
}
Loop, 6
{
    GuiControl, +Redraw, Text%A_index%
    GuiControl, +Redraw, Var%A_index%
}
GuiControl, Enable, Var1
return

UpdateResult:
Gui, Submit, NoHide
If !IsFunc(Func)
{
    GuiControl,, ExResult, Nonexistent Function
    return
}
Loop, 6
If (Var%A_Index%  "")
    LastParam := A_Index
Params := Object()
Loop, %LastParam%
    Params.Insert(Var%A_Index%)
String := ""
For Index, Value in Params
{
    String .= Value "¢"
    If ((IsFunc(ExpFunc)) && (UseEval = 1))
        Params[Index] := %ExpFunc%(Params[Index])
}
GuiControl,, ExResult, % %Func%(Params*)
String := RTrim(String, ", ")
If (UseEval = 0)
    String := CheckExp(String)
Else
{
    StringReplace, String, String, ¢, `,%A_Space%, A
    StringTrimRight, String, String, 2
}
StringReplace, String, String, `n, ``n, All
GuiControl,, ExString, %Func%(%String%)
return

CheckExp(String)
{
    Loop, Parse, String, ¢
        NewStr .=  (A_LoopField  "") ? """" A_LoopField """, " : """"", "
    StringTrimRight, NewStr, NewStr, 6
    NewStr := RegExReplace(NewStr, "U)""(-?\d+)""", "$1")
    return NewStr
}

GuiClose:
ExitApp

#Include *i Eval.ahk

#SingleInstance force