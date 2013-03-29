#SingleInstance force

UrlDownloadToFile,http://www.netikus.net/show_ip.html/,%TEMP%\ip
FileReadLine,IP,%TEMP%\ip,1
FileDelete,%TEMP%\ip
MsgBox,4160,Public IP,%ip%



 ~esc::ExitApp