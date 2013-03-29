;===Auto-execute========================================================================
AgeChart =
(
Mike	24
Steve	27
Chris	25

Jenny	22
Marry	23
)

SalaryChart =
(
Mike	900
Steve	700
Chris	1000

Jenny	1300
Marry	800
)

Skin := "ClassicBlue"

Gui, 1:Add, Picture, x5 y5 w250 h190 BackgroundTrans 0xE vAgePic
Gui, 1:Add, Picture, x260 y5 w250 h190 BackgroundTrans 0xE vSalaryPic

Gui, 1: Font, q5 c666666
Loop, 50
	Text .= "some text "
Gui, 1:Add, Text, x5 y200 w505 h70 Center, %Text%

pToken := Gdip_Startup()

pAgeBitmap := BarChart(AgeChart, 250, 190, "Age", Skin)
pSalaryBitmap := BarChart(SalaryChart, 250, 190, "Salary", Skin, "ValuesSuffix: $")

SetBitmap2Pic(pAgeBitmap,"AgePic")
SetBitmap2Pic(pSalaryBitmap,"SalaryPic")

Gdip_DisposeImage(pAgeBitmap), Gdip_DisposeImage(pSalaryBitmap), Gdip_Shutdown(pToken)

Gui 1:Show, w515 h275, Employees
return


;===Subroutines=========================================================================
GuiClose:
ExitApp


;===Functions===========================================================================
#Include %A_ScriptDir%\Gdip.ahk			; by Tic
#Include %A_ScriptDir%\BarChart.ahk		; by Learning one

SetBitmap2Pic(pBitmap,ControlID,GuiNum=1) {	; sets pBitmap to picture control (which must have 0xE option and should have BackgroundTrans option). By Learning one.
	GuiControlGet, hControl, %GuiNum%:hwnd, %ControlID%
	hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap), SetImage(hControl, hBitmap), DeleteObject(hBitmap)	
	GuiControl, %GuiNum%:MoveDraw, %ControlID%	; repaints the region of the GUI window occupied by the control
}