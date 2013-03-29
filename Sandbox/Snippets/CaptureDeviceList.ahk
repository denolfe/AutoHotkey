if IsFunc("COM_Init")
     f := "COM_Init", %f%(), Release := "COM_Release"   ; v2.0
else Release := "ObjRelease"                            ; v2.1
IID_IAudioVolumeLevel := "{7FB7B48F-531D-44A2-BCB3-5AD5A134B3DC}"
IID_IAudioMute        := "{DF45AEEA-B74A-4B6B-AFAD-2366B6AA012E}"
while dev := VA_GetDevice("capture:" A_Index)
{
    t .= "** " A_Index ": " VA_GetDeviceName(dev) "`n"
    t .= "volume:`n"
    VA_EnumSubunits(dev, "DumpSubunitNames", "", IID_IAudioVolumeLevel)
    t .= "mute:`n"
    VA_EnumSubunits(dev, "DumpSubunitNames", "", IID_IAudioMute)
    t .= "`n"
    %Release%(dev)
}
MsgBox % t

DumpSubunitNames(part)
{
    VA_IPart_GetName(part, name)
    global t .= "   " name "`n"
}