#IfWinActive, ahk_class Chrome_WidgetWin
	
	; Mouse shortcuts for changing tabs
	^XButton1::Send, ^+{Tab}
	^XButton2::Send, ^{Tab}
	
	; KB shortcuts for specific tabs
	!1::Send, ^1
	!2::Send, ^2
	!3::Send, ^3
	!4::Send, ^4
	!5::Send, ^5
	!6::Send, ^6

	F1::
		IfWinActive, New Tab
			Send ^l
		else
			Send ^t
		SendInput chrome`:`/`/chrome`/extensions`/{Enter}
		Return

	::jq::var jq=document.createElement('script');jq.src = "https://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js";document.getElementsByTagName('head')[0].appendChild(jq);// ... give time for script to load, then type.jQuery.noConflict();
	::l9::localhost:9000

#IfWinActive