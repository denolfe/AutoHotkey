arr := []
arr[1] := "www.google.com"
arr[2] := "yahoo.com"
arr[3] := "www.amazon.com" 

Loop % arr.MaxIndex()
{
    site := arr[A_Index]
    Run, Chrome.exe %site%
    ;;; Other code here ;;;
}