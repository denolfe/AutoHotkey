scriptdir = C:\Users\elliotd\Dropbox\Scripts\SQL
outputFile = %scriptdir%\sqlmerge.sql

IfExist, %outputFile%
	FileDelete, %scriptdir%\sqlmerge.sql

Loop, %scriptdir%\*.sql
{
	FileRead, aFileContents, %A_LoopFileFullPath% 
	FileAppend, `n`n----------%A_LoopFileName%----------`n`n, %outputFile% 
	FileAppend, %aFileContents%, %outputFile% 
}
;msgbox % outputfile
Run, %outputFile%
