;; Define from and to locations
from := "\\nasus\user documents\elliotd\Documents\TestComplete 8 Projects\SalesPadTest\SalesPad_Final\"
to := "\\nasus\Shared Folders\Testing\"


Loop, %from%*.mht, 0, 0
{
     FileGetTime, Time, %A_LoopFileFullPath%, C
     If (Time > Time_Orig)
     {
          Time_Orig := Time
          File := A_LoopFileFullPath
		  Name := A_LoopFileName
     }
}

;; Copy and rename installer
FileCopy, %File%, %to%%Name%
