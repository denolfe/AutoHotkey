a::
ControlGetFocus, OutputVar, A
if ErrorLevel
    MsgBox, The target window doesn't exist or none of its controls has input focus.
else
    MsgBox, Control with focus = %OutputVar%

