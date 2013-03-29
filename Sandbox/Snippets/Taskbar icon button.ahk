; Give each instance of AutoHotkey.exe its own button:
RegWrite, REG_SZ, HKEY_CLASSES_ROOT, Applications\AutoHotkey.exe, IsHostApp

; To undo it:
RegDelete, HKEY_CLASSES_ROOT, Applications\AutoHotkey.exe, IsHostApp

; If you're confident that the Applications\AutoHotkey.exe key didn't exist, this will do:
RegDelete, HKEY_CLASSES_ROOT, Applications\AutoHotkey.exe