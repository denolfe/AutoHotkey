GetPID(exeName)
{
   Process, Exist, %exeName%
   return ERRORLEVEL
}

ProcessExist(exeName)
{
   Process, Exist, %exeName%
   return !!ERRORLEVEL
}

ProcessClose(exeName)
{
   Process, Close, %exeName%
}

ProcessCloseAll(exeName)
{
   while ProcessExist(exeName)
   {
      ProcessClose(exeName)
      Sleep, 100
   }
}

GetProcessMouseIsOver()
{
   WinGet, exeName, ProcessName, A
   return exeName
}