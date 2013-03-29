#Include lib\Winserv.ahk

WinServ("SQL Server Agent (MSSQLSERVER)", WinServ("SQL Server Agent (MSSQLSERVER)") ? False : True)


sleep 3000
If WinServ("SQL Server Agent (MSSQLSERVER)") 
{ 
	msgbox, true
;WinServ("SQL Server Agent (MSSQLSERVER)", False, True) 
} 
Else 
{
	msgbox, false
;WinServ("SQL Server Agent (MSSQLSERVER)", True, True) 
} 