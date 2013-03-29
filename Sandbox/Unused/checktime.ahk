FormatTime, TimeVar,, Hmm
FormatTime, DateVar,, WDay ; 1=Sunday, 2=Monday etc.

If DateVar between 1 and 7 
  If TimeVar between 745 and 1700
    MsgBox, %DateVar%`n%TimeVar%`n%RS_StatusVar%