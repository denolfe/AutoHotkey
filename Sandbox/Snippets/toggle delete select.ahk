#Include mymethods.ahk
;#Include lib\adosql.ahk
#Singleinstance force
SetTitleMatchMode, 2

FileSelectFile, StrTemp, 1, C:\Users\elliotd\Dropbox\Scripts, Select File, *.sql
FileRead, StrTemp, C:\Users\elliotd\Dropbox\Scripts\SQL\delete future documents.sql
;StrTemp := "delete from sop10100"
url := RegExReplace(StrTemp, "delete from", "select * from")
msgbox % url
clipboard := url