string := "[2013/02/22/ 22:20] Player bookmark (""20130222_2106_pl_badwater_RED_BLU"" at 295438)"
;msgbox % string
searchfile := RegExReplace(string, ".*\(""|""\s.*", "") . ".dem"

If FileExist("C:\" . searchFile)
	msgbox, yes