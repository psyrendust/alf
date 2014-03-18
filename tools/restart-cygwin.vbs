'#
'# Restarts the current Cygwin shell.
'#
'# Author:
'#   Larry Gordon
'#
'# Usage:
'#   $ sbl .
'#   $ sbl filename.txt
'#   $ sbl file1.txt file2.txt
'#
'# License:
'#   The MIT License (MIT) <http://psyrendust.mit-license.org/2014/license.html>
'# ------------------------------------------------------------------------------

Set WshShell = CreateObject("WScript.Shell")
WshShell.AppActivate("CONEMU64")
' Send {Ctrl + Shift + R} which is keymapped to "Recreate active console"
WshShell.SendKeys "^+w"
' Wait for the "Restart current console dialog"
WScript.Sleep 2000
' Send {Alt + s} to select the "Restart" button
WshShell.SendKeys "%s"
' ' Send {Ctrl + Shift + R} which is keymapped to "Recreate active console"
' WshShell.SendKeys "^+r"
' ' Wait for the "Restart current console dialog"
' WScript.Sleep 200
' ' Send {Alt + s} to select the "Restart" button
' WshShell.SendKeys "%s"
Set WshShell = Nothing
