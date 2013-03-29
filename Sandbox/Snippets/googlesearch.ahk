SendMode Input 
RegRead, OutputVar, HKEY_CLASSES_ROOT, http\shell\open\command 
StringReplace, OutputVar, OutputVar," 
SplitPath, OutputVar,,OutDir,,OutNameNoExt, OutDrive 
browser=%OutDir%\%OutNameNoExt%.exe 

^g:: 
{ 
   BlockInput, on 
   prevClipboard = %clipboard% 
   clipboard = 
   Send, ^c 
   BlockInput, off 
   ClipWait, 2 
   if ErrorLevel = 0 
   { 
          searchQuery=%clipboard% 
          GoSub, GoogleSearch 
   }
   clipboard = %prevClipboardAll%
   return 
} 

GoogleSearch: 
   StringReplace, searchQuery, searchQuery, `r`n, %A_Space%, All 
   Loop 
   { 
          noExtraSpaces=1 
          StringLeft, leftMost, searchQuery, 1 
          IfInString, leftMost, %A_Space% 
          { 
                 StringTrimLeft, searchQuery, searchQuery, 1 
                 noExtraSpaces=0 
          } 
          StringRight, rightMost, searchQuery, 1 
          IfInString, rightMost, %A_Space% 
          { 
                 StringTrimRight, searchQuery, searchQuery, 1 
                 noExtraSpaces=0 
          } 
          If (noExtraSpaces=1) 
                 break 
   } 
   StringReplace, searchQuery, searchQuery, \, `%5C, All 
   StringReplace, searchQuery, searchQuery, %A_Space%, +, All 
   StringReplace, searchQuery, searchQuery, `%, `%25, All 
   IfInString, searchQuery, . 
   { 
          IfInString, searchQuery, + 
                 Run, %browser% http://www.google.com/search?hl=en&q=%searchQuery% 
          else 
                 Run, %browser% %searchQuery% 
   } 
   else 
          Run, %browser% http://www.google.com/search?hl=en&q=%searchQuery% 
return