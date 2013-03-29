#Include mymethods.ahk
;#Include lib\adosql.ahk
#Singleinstance force
SetTitleMatchMode, 2

;;; CapsLock toggles state ;;;
CapsLock:: (nav:=!nav)

;;; only when capslock down ;;;  
;*CapsLock::    nav := 1
;*CapsLock up:: nav := 0

#if nav
	h::Key("left", "")
	j::Key("down", "")
	k::Key("up", "")
	l::Key("right", "")
	n::Key("left", "^")
	p::Key( "right", "^")
#if

Key(key, pfx = "")
{
	SendInput {blind}%pfx%{%key%}
}