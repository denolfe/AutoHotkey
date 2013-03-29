;===Description=========================================================================
/*
BarChart
Author:		Learning one (Boris Mudrinić)
Contact:	boris.mudrinic@gmail.com
Version:	1.00

Requires Gdip.ahk by Tic; http://www.autohotkey.com/forum/topic32238.html


License.
You can non-commercialy use and redistribute BarChart if put 2 things in your product's documentation or "About MsgBox"; 1) credit to the author, 2) link to BarChart's AutoHotkey forum post. Author is not responsible for any damages arising from use or redistribution of his work. If redistributed in source form, you are not allowed to remove comments from this file. If you are interested in commercial usage, contact the author to get permission for it.


Documentation.
Return value, usage.
BarChart() returns a pointer to BarChart bitmap. Use this bitmap to set it to picture control in your GUI, create layered window from it, save it to file, set it to clipboard, etc.
To create and use bitmap, call Gdip_Startup() first, than BarChart(), than do what you want with bitmap, than Gdip_DisposeImage(), and finally Gdip_Shutdown().

Parameters. BarChart(ChartData, Width, Height, TitleText="", Skin="LightOrange", Options="")

=ChartData= A string that contains chart data. It can be a table with two columns like;
Mike	24
Jenny	22
Steve	27
Marry	23
or a table with just one column (a list) which contains only numbers, like;
34
-27
-19.02
39.08
Default row delimiter is a <new line> character, and default columns delimiter is a <tab> character. To create separator between bars, put a blank line between them like this;
Car1	200
Car2	230

Truck1	130
Truck2	90
Note: if BarChart's values contain both positive and negative numbers, "DataAlignment" and "TitleAlignment" attributes are automatically set to "Center".

=Width, Height= Width and Height of a bitmap in which BarChart will be drawn. BarChart is centered in its width and height. BarChart is cropped (not scaled) if it is bigger than specified bitmap's width and height.

=TitleText= Optional. BarChart's title. If blank, entire title bar in chart won't be drawn.

=Skin= Optional. It is a set of BarChart's pre-defined graphical attributes. You can create your own skins, and override pre-defined skin attributes. Here is a list of pre-defines skins;
SimpleGreen,SimpleBlue,SimpleOrange,
LightGreen,LightBlue,LightOrange,
ClassicGreen,ClassicBlue,ClassicOrange,
DiagonBlackGreen,DiagonBlackBlue,DiagonBlackOrange,
DiagonWhiteGreen,DiagonWhiteBlue,DiagonWhiteOrange,
OutlinesWhite,OutlinesGray,OutlinesDark,
DarkT,Bricks

=Options= Optional. Here you can set and override a bunch of BarChart's pre-defined graphical and other attributes like; BarSpacing, BarRoundness, BarHeightFactor, MaxValue, TextSize, TextFont, DataAlignment, TitleAlignment, ValuesSuffix and many more. For a full list you'll have to look in the code. Look at examples to learn how to use them.
Syntax is "AttributeA:valueA, AttributeB:valueB, AttributeZ:valueZ". Example: "BarHeightFactor:1.8, ValuesSuffix: °C, DataAlignment:Center"
*/




;===Function============================================================================
BarChart(ChartData, Width, Height, TitleText="", Skin="LightOrange", Options="") {	; by Learning one

	;=== Skin ===
	if Skin in SimpleGreen,SimpleBlue,SimpleOrange
	{
		if (Skin = "SimpleGreen")
			Color := "BEF4B2"
		else if (Skin = "SimpleBlue")
			Color := "D8DFFF"
		else if (Skin = "SimpleOrange")
			Color := "FFE67A"
		BarColorA := "ff" Color, BarColorB := "ff" Color, BarColorDirection := 1, BarBorderColor := 0, BarTextColor := "ff000000", BarColorWidthDiv := 1, BarColorHeightDiv := 1
		TitleBackColorA := 0, TitleBackColorB := 0, TitleBackColorDirection := 1, TitleBorderColor := 0, TitleTextColor := "ff000000", TitleHeightFactor := 1
		PlotBackColorA := "ffffffff", PlotBackColorB := "ffffffff", PlotBackColorDirection := 1, PlotRangeBorderColor := 0
		ChartBackColorA := "ffffffff", ChartBackColorB := "ffffffff", ChartBackColorDirection := 1
		ChartBackHatchColorA :=  0, ChartBackHatchColorB := 0, ChartBackHatchStyle :=  0, ChartBackRoundness := 4
	}
	else if Skin in LightGreen,LightBlue,LightOrange
	{
		if (Skin = "LightGreen")
			Color := "AEEA9A"
		else if (Skin = "LightBlue")
			Color := "B8BFDD"
		else if (Skin = "LightOrange")
			Color := "F7DC42"
		BarColorA := "33" Color, BarColorB := "ff" Color, BarColorDirection := 0, BarBorderColor := "ee" Color, BarTextColor := "ff555555", BarColorWidthDiv := 1, BarColorHeightDiv := 1
		TitleBackColorA := 0, TitleBackColorB := 0, TitleBackColorDirection := 1, TitleBorderColor := 0, TitleTextColor := "ff6B624C", TitleHeightFactor := 1
		PlotBackColorA := 0, PlotBackColorB := 0, PlotBackColorDirection := 1, PlotRangeBorderColor := 0
		ChartBackColorA := "ffffffff", ChartBackColorB := "ffffffff", ChartBackColorDirection := 1
		ChartBackHatchColorA :=  0, ChartBackHatchColorB := 0, ChartBackHatchStyle :=  18, ChartBackRoundness := 4
	}
	else if Skin in ClassicGreen,ClassicBlue,ClassicOrange
	{
		if (Skin = "ClassicGreen")
			Color := "AEEA9A"
		else if (Skin = "ClassicBlue")
			Color := "B8BFDD"
		else if (Skin = "ClassicOrange")
			Color := "F7DC42"
		BarColorA := 0, BarColorB := "ff" Color, BarColorDirection := 1, BarBorderColor := "88" Color, BarTextColor := "ff555555", BarColorWidthDiv := 1, BarColorHeightDiv := 1
		TitleBackColorA := 0, TitleBackColorB := 0, TitleBackColorDirection := 0, TitleBorderColor := 0, TitleTextColor := "ff6B624C", TitleHeightFactor := 1
		PlotBackColorA := 0, PlotBackColorB := 0, PlotBackColorDirection := 0, PlotRangeBorderColor := 0
		ChartBackColorA := "ffffffff", ChartBackColorB := "ffffffff", ChartBackColorDirection := 1
		ChartBackHatchColorA :=  0, ChartBackHatchColorB := 0, ChartBackHatchStyle :=  18, ChartBackRoundness := 4
	}
	else if Skin in DiagonBlackGreen,DiagonBlackBlue,DiagonBlackOrange
	{
		if (Skin = "DiagonBlackGreen")
			Color := "469336"
		else if (Skin = "DiagonBlackBlue")
			Color := "071D9E"
		else if (Skin = "DiagonBlackOrange")
			Color := "BF7C00"
		BarColorA := "33" Color, BarColorB := "ff" Color, BarColorDirection := 0, BarBorderColor := "ff" Color, BarTextColor := "ffdddddd", BarColorWidthDiv := 1, BarColorHeightDiv := 1
		TitleBackColorA := 0, TitleBackColorB := 0, TitleBackColorDirection := 1, TitleBorderColor := 0, TitleTextColor := "ffdddddd", TitleHeightFactor := 1
		PlotBackColorA := 0, PlotBackColorB := 0, PlotBackColorDirection := 1, PlotRangeBorderColor := 0
		ChartBackColorA := "ff000000", ChartBackColorB := "ff000000", ChartBackColorDirection := 1
		ChartBackHatchColorA :=  "20ffffff", ChartBackHatchColorB := 0, ChartBackHatchStyle :=  18, ChartBackRoundness := 4
	}
	else if Skin in DiagonWhiteGreen,DiagonWhiteBlue,DiagonWhiteOrange
	{
		if (Skin = "DiagonWhiteGreen")
			Color := "AEEA9A"
		else if (Skin = "DiagonWhiteBlue")
			Color := "B8BFDD"
		else if (Skin = "DiagonWhiteOrange")
			Color := "F4CE44"
		BarColorA := "ffffffff", BarColorB := "ff" Color, BarColorDirection := 1, BarBorderColor := "ff" Color, BarTextColor := "ff333333", BarColorWidthDiv := 1, BarColorHeightDiv := 1
		TitleBackColorA := "ffffffff", TitleBackColorB := "55ffffff", TitleBackColorDirection := 1, TitleBorderColor := "ffdddddd", TitleTextColor := "ff555555", TitleHeightFactor := 1.4
		PlotBackColorA := "55ffffff", PlotBackColorB := "ffffffff", PlotBackColorDirection := 1, PlotRangeBorderColor := "ffdddddd"
		ChartBackColorA := "ffffffff", ChartBackColorB := "fff7f7f7", ChartBackColorDirection := 1
		ChartBackHatchColorA :=  "18000000", ChartBackHatchColorB := 0, ChartBackHatchStyle :=  18, ChartBackRoundness := 4
	}
	else if skin in OutlinesWhite,OutlinesGray,OutlinesDark 
	{
		if (Skin = "OutlinesWhite")
			OutlineColor := "ff666666", BackgroundColor := "ffffffff"
		else if (Skin = "OutlinesGray")
			OutlineColor := "ffffffff", BackgroundColor := "ff888888"
		else
			OutlineColor := "ffcccccc", BackgroundColor := "ff181818"
		BarColorA := 0, BarColorB := 0, BarColorDirection := 1, BarBorderColor := OutlineColor, BarTextColor := OutlineColor, BarColorWidthDiv := 1, BarColorHeightDiv := 1
		TitleBackColorA := 0, TitleBackColorB := 0, TitleBackColorDirection := 1, TitleBorderColor := "", TitleTextColor := OutlineColor, TitleHeightFactor := 1
		PlotBackColorA := 0, PlotBackColorB := 0, PlotBackColorDirection := 1, PlotRangeBorderColor := ""
		ChartBackColorA := BackgroundColor, ChartBackColorB := BackgroundColor, ChartBackColorDirection := 1
		ChartBackHatchColorA :=  0, ChartBackHatchColorB := 0, ChartBackHatchStyle :=  38, ChartBackRoundness := 4
	}
	else if (Skin = "DarkT") {
		BarColorA := "ff858ADB", BarColorB := "ff383C77", BarColorDirection := 1, BarBorderColor := 0, BarTextColor := "ffffffff", BarColorWidthDiv := 1, BarColorHeightDiv := 1
		TitleBackColorA := "aa000000", TitleBackColorB := "66000022", TitleBackColorDirection := 1, TitleBorderColor := 0, TitleTextColor := "ffffffff", TitleHeightFactor := 1.4
		PlotBackColorA := "66000022", PlotBackColorB := "aa333344", PlotBackColorDirection := 1, PlotRangeBorderColor := 0
		ChartBackColorA := "ff333344", ChartBackColorB := "ff111122", ChartBackColorDirection := 1
		ChartBackHatchColorA :=  "44000000", ChartBackHatchColorB := 0, ChartBackHatchStyle :=  21, ChartBackRoundness := 4
	}
	else if (Skin = "Bricks") {
		BarColorA := "ffffffff", BarColorB := "99619B68", BarColorDirection := 1, BarBorderColor := "44619B68", BarTextColor := "ff555555", BarColorWidthDiv := 1, BarColorHeightDiv := 1
		TitleBackColorA := "ffffffff", TitleBackColorB := "ccffffff", TitleBackColorDirection := 1, TitleBorderColor := "ffbbbbbb", TitleTextColor := "ff6B624C", TitleHeightFactor := 1.4
		PlotBackColorA := "ccffffff", PlotBackColorB := "ffffffff", PlotBackColorDirection := 1, PlotRangeBorderColor := "ffbbbbbb"
		ChartBackColorA := "ffffffff", ChartBackColorB := "ffffffff", ChartBackColorDirection := 1
		ChartBackHatchColorA :=  "45000000", ChartBackHatchColorB := 0, ChartBackHatchStyle :=  38, ChartBackRoundness := 4
	}
	; etc.

	;=== User's options & overrides ===	
	Loop, parse, Options, `,, %A_Space%
	colonpos := InStr(A_LoopField, ":"), var := SubStr(A_LoopField, 1, colonpos-1), val := SubStr(A_LoopField, colonpos+1), %var% := val

	;=== Other options, defaults ===	
	BarSpacing := (BarSpacing = "") ? 4 : BarSpacing
	BarRoundness := (BarRoundness = "") ? 4 : BarRoundness
	BarHeightFactor := (BarHeightFactor = "") ? 1.4 : BarHeightFactor
	BarColorsFlip := (BarColorsFlip = "") ? 0 : BarColorsFlip
	
	TextIndentation := (TextIndentation = "") ? 4 : TextIndentation
	RowsDelimiter := (RowsDelimiter = "") ? "`n" : RowsDelimiter
	ColumnsDelimiter := (ColumnsDelimiter = "") ? "`t" : ColumnsDelimiter
	DisplayValues := (DisplayValues = "") ? 1 : DisplayValues
	DataValueSeparator := (DataValueSeparator = "") ? ": " : DataValueSeparator
	ValuesSuffix := (ValuesSuffix = "") ? "" : ValuesSuffix
	DataAlignment := (DataAlignment = "") ? "Left" : DataAlignment	; Left,Right,Center. Note: case sensitive!
	MaxValue := (MaxValue = "") ? 0 : MaxValue

	TextFont := (TextFont = "") ? "Arial" : TextFont
	TextSize := (TextSize = "") ? 12 : TextSize
	TextRendering := (TextRendering = "") ? 5 : TextRendering
	TitleTextSize := (TitleTextSize = "") ? 14 : TitleTextSize
	TitleTextFormat := (TitleTextFormat = "") ? "Bold" : TitleTextFormat	; Available formats: "Regular|Bold|Italic|BoldItalic|Underline|Strikeout". Note: case sensitive!
	TitleAlignment := (TitleAlignment = "") ? DataAlignment : TitleAlignment	; Left,Right,Center. Note: case sensitive!
	TitleIndentation := (TitleIndentation = "") ? 0 : TitleIndentation
	
	FrameWidth := (FrameWidth = "") ? 8 : FrameWidth
	SmoothingMode := (SmoothingMode = "") ? 4 : SmoothingMode
	
	;=== If user didn't use obligatory Title case for Gdip_TextToGraphics() options, fix it ===
	StringUpper, DataAlignment, DataAlignment, T
	StringUpper, TitleTextFormat, TitleTextFormat, T
	StringUpper, TitleAlignment, TitleAlignment, T
	if TitleTextFormat contains Bolditalic
		StringReplace, TitleTextFormat, TitleTextFormat, Bolditalic, BoldItalic, All

	;=== Bitmap, Graphics, SmoothingMode ===
	pBitmap := Gdip_CreateBitmap(Width, Height), G := Gdip_GraphicsFromImage(pBitmap), Gdip_SetSmoothingMode(G, SmoothingMode)
	
	;=== Get Bar height ===
	TextMeasure := Gdip_TextToGraphics(G, "T_", "x0 y0 Vcenter " DataAlignment " c" BarTextColor " r" TextRendering " s" TextSize, TextFont, Width, Height, 1)
	StringSplit, m, TextMeasure, |
	TextHeight := m4
	BarHeight := TextHeight*BarHeightFactor
	
	;=== Get Title height ===
	if (TitleText != "") {
		TextMeasure := Gdip_TextToGraphics(G, TitleText
			, "x" FrameWidth " y0 Vcenter " TitleAlignment " " TitleTextFormat " c" TitleTextColor " r" TextRendering " s" TitleTextSize, TextFont, Width - FrameWidth*2, "", 1)
		StringSplit, m, TextMeasure, |
		TitleHeight := (BarHeight > m4) ? BarHeight : m4
		TitleHeight *= TitleHeightFactor
	}
	else
		TitleHeight := 0
	
	;=== If only one column in ChartData ===
	if (InStr(ChartData, ColumnsDelimiter) = 0) {
		Loop, parse, ChartData, %RowsDelimiter%
			NewChartData .= ColumnsDelimiter A_LoopField RowsDelimiter
		ChartData := SubStr(NewChartData,1,StrLen(NewChartData)-StrLen(RowsDelimiter))
	}
	
	;=== Get dimensions, layout... ===
	TotalBars := 0, MaxPositiveValues := 0, MaxNegativeValues := 0
	Loop, parse, ChartData, %RowsDelimiter%
	{
		TotalBars++
		if A_LoopField is Space
			continue
		StringSplit, Field, A_LoopField, %ColumnsDelimiter%
		if Field2 is not number
			continue
		if (Field2 > MaxPositiveValues)
			MaxPositiveValues := Field2
		if (Field2 < MaxNegativeValues)
			MaxNegativeValues := Field2
		if Field2 is not number
		field1 := "", field2 := ""
	}
	MaxValue := abs(MaxValue)
	if (MaxPositiveValues > 0 and MaxNegativeValues = 0) { ; only positive
		ChartDataMaxRange := (MaxValue > MaxPositiveValues) ? MaxValue : MaxPositiveValues
	}
	else if (MaxPositiveValues = 0 and MaxNegativeValues < 0) { ; only negative
		ChartDataMaxRange := (MaxValue > abs(MaxNegativeValues)) ? - MaxValue : MaxNegativeValues
	}
	else if (MaxPositiveValues > 0 and MaxNegativeValues < 0) { ; positive & negative
		Candidates := MaxValue "`n" MaxPositiveValues "`n" Abs(MaxNegativeValues)
		ChartDataMaxRange := 0
		Loop, parse, Candidates, `n
		{
			if (A_LoopField > ChartDataMaxRange)
				ChartDataMaxRange := A_LoopField
		}
		ChartDataMaxRange *= 2
		DataAlignment := "Center", TitleAlignment := "Center"	; force to Center data and title alignment
	}
	else	; zeros
		ChartDataMaxRange := 1
	
	TotalBarSpacing := (TotalBars-1)*BarSpacing
	MaxBarWidth := Width - FrameWidth*2
	BarUnitWidth := abs(MaxBarWidth/ChartDataMaxRange)
	if (TitleText != "")
		y := (Height-(BarHeight*TotalBars+TotalBarSpacing+TitleHeight+BarSpacing))/2
	else
		y := (Height-(BarHeight*TotalBars+TotalBarSpacing))/2
	
	;=== Draw Chart back ===
	pBrush := Gdip_CreateLineBrushFromRect(0, 0, Width, Height, "0x" ChartBackColorA, "0x" ChartBackColorB, ChartBackColorDirection, 1)
	Gdip_FillRoundedRectangle(G, pBrush, 0, 0, Width, Height, ChartBackRoundness)
	Gdip_DeleteBrush(pBrush)
	
	pBrush := Gdip_BrushCreateHatch("0x" ChartBackHatchColorA, "0x" ChartBackHatchColorB, ChartBackHatchStyle)
	Gdip_FillRoundedRectangle(G, pBrush, 0, 0, Width, Height, ChartBackRoundness)
	Gdip_DeleteBrush(pBrush)
	
	;=== Draw Title area ===
	if (TitleText != "")
	{
		if (TitleBackColorA != 0 or TitleBackColorB != 0) {
			pBrush := Gdip_CreateLineBrushFromRect(FrameWidth, y, MaxBarWidth, TitleHeight, "0x" TitleBackColorA, "0x" TitleBackColorB, TitleBackColorDirection, 1)
			Gdip_FillRoundedRectangle(G, pBrush, FrameWidth, y, MaxBarWidth, TitleHeight, BarRoundness)
			Gdip_DeleteBrush(pBrush)
		}
		if  (TitleBorderColor != 0) {
			pPen := Gdip_CreatePen("0x" TitleBorderColor, 1)
			Gdip_DrawRoundedRectangle(G, pPen, FrameWidth, y, MaxBarWidth, TitleHeight, BarRoundness)
			Gdip_DeletePen(pPen)
		}
		Gdip_TextToGraphics(G, TitleText, "x" FrameWidth + TitleIndentation " y" y+1 " Vcenter " TitleAlignment " "  TitleTextFormat " c" TitleTextColor " r" TextRendering " s" TitleTextSize
			, TextFont, MaxBarWidth - TitleIndentation*2, TitleHeight)
		y := y+TitleHeight+BarSpacing
	}
	
	;=== Draw Plot area ===
	if (PlotBackColorA != 0 or PlotBackColorB != 0) {
			pBrush := Gdip_CreateLineBrushFromRect(FrameWidth, y, MaxBarWidth, BarHeight*TotalBars+TotalBarSpacing
				, "0x" PlotBackColorA, "0x" PlotBackColorB, PlotBackColorDirection, 1)
			Gdip_FillRoundedRectangle(G, pBrush, FrameWidth, y, MaxBarWidth, BarHeight*TotalBars+TotalBarSpacing, BarRoundness)
			Gdip_DeleteBrush(pBrush)
		}
	if (PlotRangeBorderColor != 0)	{
		pPen := Gdip_CreatePen("0x" PlotRangeBorderColor, 1)
		Gdip_DrawRoundedRectangle(G, pPen, FrameWidth, y, MaxBarWidth, BarHeight*TotalBars+TotalBarSpacing, BarRoundness)		
		Gdip_DeletePen(pPen)
	}
	
	;=== Draw Bars & Text ===
	y := y-BarHeight-BarSpacing	
	Loop, parse, ChartData, %RowsDelimiter%
	{
		y := y+BarHeight+BarSpacing
		if A_LoopField is Space		; bar separator
			continue
		StringSplit, Field, A_LoopField, %ColumnsDelimiter%
		if Field1 is Space
			Field1 := ""
		if Field2 is not number
			Field2 := ""
			
		if (MaxPositiveValues > 0 and MaxNegativeValues < 0) { ; positive & negative. (forced Center data and title alignment)
			if (Field2 >= 0)
				x := Width/2
			else
				x := Width/2 - BarUnitWidth*abs(Field2)
			DivW := 2
		}
		else {
			if (DataAlignment = "Left")
				x := FrameWidth
			else if (DataAlignment = "Right")
				x := Width-FrameWidth-BarUnitWidth*abs(Field2)
			else if (DataAlignment = "Center")
				x := FrameWidth+(MaxBarWidth-BarUnitWidth*abs(Field2))/2
			DivW := 1
		}
		
		if (Field2 != "" and Field2 != 0) {
			if (BarColorA != 0 or BarColorB != 0) {
				if !BarColorsFlip
					pBrush := Gdip_CreateLineBrushFromRect(x, y, MaxBarWidth/BarColorWidthDiv/DivW, BarHeight/BarColorHeightDiv, "0x" BarColorA, "0x" BarColorB, BarColorDirection, 1)
				else
					pBrush := Gdip_CreateLineBrushFromRect(x, y, MaxBarWidth/BarColorWidthDiv/DivW, BarHeight/BarColorHeightDiv, "0x" BarColorB, "0x" BarColorA, BarColorDirection, 1)
				Gdip_FillRoundedRectangle(G, pBrush, x, y, BarUnitWidth*abs(Field2), BarHeight, BarRoundness)
				Gdip_DeleteBrush(pBrush)
			}
			if  (BarBorderColor != 0) {
				pPen := Gdip_CreatePen("0x" BarBorderColor, 1)
				Gdip_DrawRoundedRectangle(G, pPen, x, y, BarUnitWidth*abs(Field2), BarHeight, BarRoundness)		
				Gdip_DeletePen(pPen)
			}
		}
		
		if (DisplayValues = 1) {
			if (Field1 = "" and Field2 = "")
				BarText := ""
			else if (Field1 != "" and Field2 = "")
				BarText := Field1
			else if (Field1 = "" and Field2 != "")
				BarText := Field2 ValuesSuffix
			else if (Field1 != "" and Field2 != "")
				BarText := Field1 DataValueSeparator Field2 ValuesSuffix
		}
		else
			BarText := Field1
				
		if (DataAlignment = "Left")
			Gdip_TextToGraphics(G, BarText, "x" FrameWidth+TextIndentation " y" y+1 " Left Vcenter c" BarTextColor " r" TextRendering " s" TextSize
				, TextFont, MaxBarWidth-TextIndentation, BarHeight)
		else if (DataAlignment = "Right")
			Gdip_TextToGraphics(G, BarText, "x" FrameWidth " y" y+1 " Right Vcenter c" BarTextColor " r" TextRendering " s" TextSize, TextFont, MaxBarWidth-TextIndentation, BarHeight)
		else if (DataAlignment = "Center")
			Gdip_TextToGraphics(G, BarText, "x" FrameWidth " y" y+1 " Center Vcenter c" BarTextColor " r" TextRendering " s" TextSize, TextFont, MaxBarWidth, BarHeight)
		field1 := "", field2 := ""
	}
	Gdip_DeleteGraphics(G)
	return pBitmap
}