QR = \\draven\Shared Folders\Safehouse\Scripts and Reports
outputFile = %QR%\QRmergeNetwork.txt

IfExist, %outputFile%
	FileDelete, %QR%\QRmergeNetwork.txt

Loop, %QR%\*.sprept, 0, 1
{
	FileRead, aFileContents, %A_LoopFileFullPath% 
	FileAppend, %A_LoopFileName%`n`n, %outputFile% 
	FileAppend, %aFileContents%, %outputFile% 
}
Run, %outputFile%
