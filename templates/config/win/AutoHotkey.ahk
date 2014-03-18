;#
;# AutoHotkey configuration to make the environment a bit more keyboard friendly.
;#
;# Author:
;#   Larry Gordon
;#
;# License:
;#   The MIT License (MIT) <http://psyrendust.mit-license.org/2014/license.html>
;# ------------------------------------------------------------------------------


; Redefine only when the active window is a console window
#If WinActive("ahk_class ConsoleWindowClass") or WinActive("ahk_class cygwin/x") or WinActive("ahk_class mintty")

; Close Command Window with Ctrl+w
$^w::
WinGetTitle sTitle
If (InStr(sTitle, "-")=0) {
  Send EXIT{Enter}
} else {
  if WinActive("ahk_class cygwin/x") or WinActive("ahk_class mintty") {
    Send exit{Enter}
  } else {
    Send ^w
  }
}

return


; Ctrl+up / Down to scroll command window back and forward
^Up::
Send {WheelUp}
return

^Down::d
Send {WheelDown}
return


; Use backslash instead of backtick (yes, I am a C++ programmer).
#EscapeChar \

; Paste in command window.
^V::
StringReplace clipboard2, clipboard, \r\n, \n, All
SendInput {Raw}%clipboard2%
return

#IfWinActive

; Parallels overrides to make it more like a mac
; #=Win ^=Ctrl +=Shift !=Alt

; Comment line with Cmd+/
#/::
Send ^{/}
return

; Move to top of page with Cmd+up
#Up::
Send {PgUp}
return

; Move to bottom of page with Cmd+down
#Down::
Send {PgDn}
return

; Move to end of line with Cmd+right
#right::
Send {End}
return

; Move to beginning of line with Cmd+left
#left::
Send {Home}
return

; Select to end of the line with Cmd+shift+right
#+right::
Send +{End}
return

; Select to the beginning of the line with Cmd+shift+left
#+left::
Send +{Home}
return

; Sublime duplicate line with Cmd+shift+d
#+d::
Send ^+{d}
return

; Sublime Delete to begining of line
#Backspace::
Send ^+{Backspace}
return

; Move to next tab
#!right::
Send ^{PgDn}
return

; Move to previous tab
#!left::
Send ^{PgUp}
return

; Sublime Quick Add Next
#d::
Send ^{d}
return

; Sublime Move Line Up
#+Up::
Send ^+{Up}
return

; Sublime Move Line Down
#+Down::
Send ^+{Down}
return

; Sublime Add Previous Line
^+Up::
Send ^!{Up}
return

; Sublime Add Next Line
^+Down::
Send ^!{Down}
return

; Sublime Command Palette
#+p::
Send ^+{p}
return
