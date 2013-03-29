#NoEnv
DynaRun(Script)
{
ptr := A_PtrSize ? "Ptr" : "UInt"
char_size := A_IsUnicode ? 2 : 1
; To prevent "collision", pipe_name could be something mostly "unique", like:
;   pipe_name := A_TickCount
pipe_name := "testpipe"

; Before reading the file, AutoHotkey calls GetFileAttributes(). This causes
; the pipe to close, so we must create a second pipe for the actual file contents.
; Open them both before starting AutoHotkey, or the second attempt to open the
; "file" will be very likely to fail. The first created instance of the pipe
; seems to reliably be "opened" first. Otherwise, WriteFile would fail.
pipe_ga := CreateNamedPipe(pipe_name, 2)
pipe    := CreateNamedPipe(pipe_name, 2)
if (pipe=-1 or pipe_ga=-1) {
    MsgBox CreateNamedPipe failed.
    ExitApp
}

Run, %A_AhkPath% "\\.\pipe\%pipe_name%"

; Wait for AutoHotkey to connect to pipe_ga via GetFileAttributes().
DllCall("ConnectNamedPipe", ptr, pipe_ga, ptr, 0)
; This pipe is not needed, so close it now. (The pipe instance will not be fully
; destroyed until AutoHotkey also closes its handle.)
DllCall("CloseHandle", ptr, pipe_ga)
; Wait for AutoHotkey to connect to open the "file".
DllCall("ConnectNamedPipe", ptr, pipe, ptr, 0)

; Standard AHK needs a UTF-8 BOM to work via pipe.  If we're running on
; Unicode AHK_L, 'Script' contains a UTF-16 string so add that BOM instead:
Script := (A_IsUnicode ? chr(0xfeff) : chr(239) chr(187) chr(191)) . Script

char_size := (A_IsUnicode ? 2:1)
if !DllCall("WriteFile", ptr, pipe, "str", Script, "uint", (StrLen(Script)+1)*char_size, "uint*", 0, ptr, 0)
    MsgBox WriteFile failed: %ErrorLevel%/%A_LastError%

DllCall("CloseHandle", ptr, pipe)
}


CreateNamedPipe(Name, OpenMode=3, PipeMode=0, MaxInstances=255) {
    global ptr
    return DllCall("CreateNamedPipe","str","\\.\pipe\" Name,"uint",OpenMode
        ,"uint",PipeMode,"uint",MaxInstances,"uint",0,"uint",0,"uint",0,ptr,0,ptr)
}