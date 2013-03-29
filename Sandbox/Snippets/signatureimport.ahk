;
; Author:         Arber/Beni Dhomi, www.dhomi.com, <opera@dhomi.com>
;
; Script Function:
;   Copy a formated content to the Clipboard, then Save it to a file
;       Then Load this file anytime to the Clipboard and paste it to Gmail or any other application you wish
;

; SAVE file2clipboard

^#s::

 FileAppend, %ClipboardAll%, signature.rtf ;put here any filename you wish
Return


