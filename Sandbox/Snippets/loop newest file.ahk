Folder = C:\Folder ; change this to the actual folder

Loop, \\vm-vayne\SalesPad4\SalesPad_4_Release\4.1*, 2, 0
{
     FileGetTime, Time, %A_LoopFileFullPath%, C
     If (Time > Time_Orig)
     {
          Time_Orig := Time
          File := A_LoopFileName
     }
}
MsgBox, Newest file in %Folder% is %File%
Return
