CapsLock:: 
If (State:=!state) ; use () to indicate an expression in which a variable is assigned the value of its boolean negation
   msgbox % state ; '1000' is Number in this case, but it could just as easily be a %variable%
else
	msgbox % state