Drive = T:\
DriveGet, status, Status, T:\
if ! (status = "Ready")	
	RunWait, %comspec% /c "net use T: \\draven\Testing\TestComplete",, Hide
else
	RunWait, %comspec% /c "net use T: /delete /y",, Hide

ExitApp