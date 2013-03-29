;#Include mymethods.ahk
;#Include lib\adosql.ahk
#Singleinstance force
SetTitleMatchMode, 2

;; http://www.autohotkey.com/board/topic/83542-func-adosql-uses-ado-to-manage-sql-transactions-v503l/
branch := "Release"
version := "4.1"
result := "Fail"
FormatTime, TimeString,, M/d/yyyy h:mm:ss tt

connection_string := "Driver={SQL Server Native Client 10.0};Server=ELLIOT-PC;Database=SMARTBEAR;Uid=sa;Pwd=sa"
query := "INSERT INTO [dbo].[_Results] VALUES ('" . branch . "', '" . version . "', '" . result . "', '" . TimeString . "', '" . A_ComputerName . "')"
FileAppend, %query%`t%connection_string%`n, debug.log

ADOSQL(connection_string, query)
msgbox % ErrorLevel