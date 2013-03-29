;#Include lib\mymethods.ahk
;#Include lib\adosql.ahk
#NoEnv
#Singleinstance force
SetTitleMatchMode, 2


#Include lib\Notify-new.ahk

;; Begin Testing Suite

Active_Test_ID := Notify("Testing Active","yes, it is.",0,"Style=Mine BW=2")
RunWait, notepad.exe
Notify("","",-0,"Wait=" Active_Test_ID)

Notify("Testing YYESSSS","",-5,"Style=Mine")



/*
	VolumeNotifyID := Notify("Volume","",VA_GetMasterVolume(),"PG=100 PW=250 GC=555555 SI=0 SC=0 ST=0 TC=White MC=White BW=0 Image=169")
	Notify("Volume","",VA_GetMasterVolume(),"Update=" VolumeNotifyID)
	Notify("","",-1,"Wait=" VolumeNotifyID)