RegRead, GPVersion1, HKLM, SOFTWARE\Classes\Installer\Products\6A0A09CD09D2E394D8315DA41D329BDF, ProductName
RegRead, GPVersion2, HKLM, SOFTWARE\Classes\Installer\Products\15C013CBD27B75C4EAE95A280A09C32F, ProductName
RegRead, GPVersion3, HKLM, SOFTWARE\Classes\Installer\Products\7CCCD69894796DD4ABFE949F9AEC2E59, ProductName
GPVersion := GPVersion1 . GPVersion2 . GPVersion3

If RegExMatch(GPVersion, "P)\d+", matchlength)
	GPVersion := "GP" . SubStr(GPVersion, RegExMatch(GPVersion, "P)\d+", matchlength), matchlength)
msgbox % GPVersion
