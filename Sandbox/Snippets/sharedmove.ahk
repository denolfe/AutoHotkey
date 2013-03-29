;Origin: http://www.autohotkey.com/forum/topic3943.html

Loop, C:\Users\elliotd\Dropbox\Reports\*.*, 1, 1
{
    FileCopy, %A_LoopFileLongPath%, \\elliot-pc\shared\Reports, 1 
}

Loop, C:\Users\elliotd\Dropbox\Scripts\*.*, 1, 1
{
    FileCopy, %A_LoopFileLongPath%, \\elliot-pc\shared\Scripts, 1 
}

Notify("Reports/Scripts Moved","Reports/Scripts to Shared",-6,"GC=555555 TC=White MC=White")
Sleep 8000
ExitApp