WinWaitActive, TWI, 2
If ErrorLevel
	ExitApp
Items=128 SDRAM|100XLG|WIRE-MCD-0001|WIRE-SCD-0001|PHON-BUS-1250|ZZ-NI
Loop 2
{
	Loop,Parse,Items,|
	{
		Send !n
		Send % A_LoopField
		Send {Tab 2}
		Send 5
	}
}


ExitApp