count := 0

Loop, \\draven\Testing\Logs\*, 2, 0
{
	branch := A_LoopFileFullPath

	days6 = ;blank
	days6 += -6, days
	Loop, %branch%\*.mht
	{
	  FileGetTime, time, %A_LoopFileLongPath%, M
	  ;msgbox % time . " " A_LoopFileFullPath
	  if time < %days6%
	  {
	    FileDelete, %A_LoopFileFullPath%
	    count++
	    ;FileAppend, %A_LoopFileName%`n, debug.log
	  }
	}

}
	Notify(count " Old Logs Deleted","",-6,"GC=555555 TC=White MC=White")
	Sleep 7000

	Exitapp