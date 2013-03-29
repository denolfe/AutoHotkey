#WinActivateForce
#SingleInstance force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

site = http://djvyrus.com/ASOT/2011

Loop, B:\Music\ASOT*.mp3
	latestfile = %A_LoopFileName%

StringReplace, latestfile, latestfile,  ASOT, , All
StringReplace, latestfile, latestfile,  .mp3, , All
ep = %latestfile%

Loop
{
	file = B:\Music\ASOT %ep%.mp3
	IfNotExist, %file%
	{
		UrlDownloadToFile, %site%/ASOT %ep%.mp3, B:\Music\ASOT %ep%.mp3
		break
	}
	ep++
}

epold := ep-1
FileDelete,  B:\Music\ASOT %epold%.mp3

;; Delete old episode, move new to Dropbox ;;
Loop, B:\Dropbox\HomeShare\ASOT*.mp3
	FileDelete, %A_LoopFileFullPath%
FileCopy, B:\Music\ASOT %ep%.mp3, B:\Dropbox\HomeShare\ASOT %ep%.mp3