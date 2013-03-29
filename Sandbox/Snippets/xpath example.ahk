#NoEnv
#WinActivateForce
#SingleInstance force
SendMode Input
SetWorkingDir %A_ScriptDir%
SetTitleMatchMode, 2

#Include lib\xpath.ahk

FileRead, feed, C:\Users\elliotd\Dropbox\HomeShare\test.xml
msgbox % feed
rss := xpath_load(feed)
latest := XPath(rss, "/machines/machine[1]/run/text()")
msgbox % latest