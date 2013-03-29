;; Define installer and install dir
setupfile := "C:\SalesPad.Setup.exe"
installpath := "C:\Program Files (x86)\SalesPad.GP\"


get37()
get40()
get41()

;; Remove old install file
if FileExist(setupfile)
    FileDelete,  %setupfile%

;; Copy and rename installer
FileCopy, %FullFile%, %setupfile%

;; Run installer
Run, %setupfile%
ExitApp

return






get37()
{
    ;; Find newest installer
    Loop, \\katrina\public\LatestRelease\3.7\*.exe, 0, 0
    {
         FileGetTime, Time, %A_LoopFileFullPath%, C
         If (Time > Time_Orig)
         {
              Time_Orig := Time
              File := A_LoopFileName
              FullFile := A_LoopFileFullPath
         }
    }
    msgbox % File . "`n" . FullFile
}

get40()
{
    ;; Find newest installer
    Loop, \\katrina\public\LatestRelease\4.0\*.exe, 0, 0
    {
         FileGetTime, Time, %A_LoopFileFullPath%, C
         If (Time > Time_Orig)
         {
              Time_Orig := Time
              File := A_LoopFileName
              FullFile := A_LoopFileFullPath
         }
    }
    msgbox % File . "`n" . FullFile
}

get41()
{
    ;; Find newest installer
    Loop, \\katrina\public\LatestRelease\4.1\WithCC\*.exe, 0, 0
    {
         FileGetTime, Time, %A_LoopFileFullPath%, C
         If (Time > Time_Orig)
         {
              Time_Orig := Time
              File := A_LoopFileName
              FullFile := A_LoopFileFullPath
         }
    }
    msgbox % File . "`n" . FullFile    
}
