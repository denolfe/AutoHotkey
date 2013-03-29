#Include lib\yaml.ahk

yamlText=
(
- TestDetail: 
  TESTING-PC: 
    Name: TESTING-PC
    Run: 1
    Multibin: 0

  SMARTBEAR: 
    Name: SMARTBEAR
    Run: 1
    Multibin: 0

- Tests:
  Release: 1
  ServPack: 1
)


y:=Yaml("Snippets\test.yaml",1)							   	; create yaml object from file
;y:=Yaml(yamlText, 0)



msgbox % y.Object.Key
msgbox % y.Object.sequence.Dump()
msgbox % y.Object.sequence.(1)


;Msgbox % y.TestDetail.TESTING-PC.Name
;Msgbox % y.TestDetail.SMARTBEAR.Name
;Msgbox % y.TestDetail.SMARTBEAR.Run
;Msgbox % y.TestDetail.SMARTBEAR.Tests.(1)
;Msgbox % y.TestDetail.SMARTBEAR.Tests.(2)
;Msgbox % y.TestDetail.Tests

;Msgbox % y.(1)

;Loop 
;	MsgBox % Yaml_Get(y,"yaml" A_Index ".Settings.ButtonText.Button1")
;

;MsgBox % y.MainKey.SubKey.SubSubKey1
;MsgBox % y.MainKey.SubKey.SubSubKeyList.(2)
;y.MainKey.SubKey.SubSubKeyList.(2) := "modifieditem"
;msgbox % y.Dump()

;y.Save("test.yaml",1)	; save yaml to file.|


/*
test.yaml

TestDetail: 
  GP2010: 
    Name: TESTING-PC
    Run: 1
    SQL: 2008 R2
    Tests:
    	- test1
    	- test2


*/

/*

yamlObj:=Yaml("Key: abc`n1: cde`n- Item1`n- Item2",0)
MsgBox % yamlObj.Key
MsgBox % yamlObj.1 ;key named 1
MsgBox % yamlObj.(1) ;sequence item (same as yamlObj[""].1)
MsgBox % yamlObj.() ;count items saved in yamlObj[""] (same as yamlObj[""].MaxIndex())


*/