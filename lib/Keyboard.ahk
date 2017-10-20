Keyboard_SetDelayAndRepeat(delayMs, repeatMs, waitMs = 0, bounceMs = 0)
{
  VarSetCapacity(FILTERKEYS, 24)
  NumPut(24, FILTERKEYS, 0, "UInt") ;cbSize
  NumPut(1, FILTERKEYS, 4, "UInt") ;dwFlag
  NumPut(waitMs,FILTERKEYSStruct,8) ;iWaitMSec
  NumPut(delayMs, FILTERKEYS, 12, "UInt") ;iDelayMSec
  NumPut(repeatMs, FILTERKEYS, 16, "UInt") ;iRepeatMSec
  NumPut(bounceMs,FILTERKEYSStruct,20) ;iBounceMSec
  DllCall("SystemParametersInfo", "UInt", 0x0033, "UInt", 0, "Ptr", &FILTERKEYS, "Uint", 0)
}

Keyboard_SetDefaultDelayAndRepeat()
{
  VarSetCapacity(FILTERKEYS, 24)
  NumPut(24, FILTERKEYS, 0, "UInt") ;cbSize
  NumPut(1, FILTERKEYS, 4, "UInt") ;dwFlag
  NumPut(100,FILTERKEYSStruct,8) ;iWaitMSec
  NumPut(250, FILTERKEYS, 12, "UInt") ;iDelayMSec
  NumPut(50, FILTERKEYS, 16, "UInt") ;iRepeatMSec
  NumPut(1000,FILTERKEYSStruct,20) ;iBounceMSec
  DllCall("SystemParametersInfo", "UInt", 0x0033, "UInt", 0, "Ptr", &FILTERKEYS, "Uint", 0)
}