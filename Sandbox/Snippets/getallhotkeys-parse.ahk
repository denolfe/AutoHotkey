Loop
{
    FileReadLine, line, C:\test.txt, %A_Index%
    if ErrorLevel
        break

    If Instr(line, "::")
    {
        StringSplit, linearray, line, ::,

        key := linearray1
        StringSplit, commandarray, linearray3, `;

        action := commandarray2

        hotkeyline := "key:  " . key . "`tAction:  " . action
        final .= hotkeyline . "`r"

    }
}
msgbox % final

return