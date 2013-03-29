;http://www.autohotkey.com/forum/topic23792-45.html

COM_Init()
prefix_list = playback:,capture:
Loop, Parse, prefix_list, `,
{
    Loop {
        if !(device := VA_GetDevice(A_LoopField A_Index))
            break
        device_list .= A_LoopField A_Index "=" VA_GetDeviceName(device) "`n"
        COM_Release(device)
    }
}
COM_Term()
MsgBox % device_list