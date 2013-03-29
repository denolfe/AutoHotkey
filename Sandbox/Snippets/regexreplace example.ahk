path := "This\is\a\path\"
msgbox % path
url := RegExReplace(path, "(\\)", "/")
url := RegExReplace(url, "(path)", "url")
msgbox % url