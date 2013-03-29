;===Auto-execute========================================================================
ChartData =
(
Mike	24
Jenny	22
Steve	27
Marry	23
)

Gui, 1:Add, Picture, x5 y5 w250 h120 BackgroundTrans 0xE vBarChartPic	; create picture control which must have 0xE option
pToken := Gdip_Startup()												; start up GDI+
pBitmap := BarChart(ChartData, 250, 120)								; create bitmap
SetBitmap2Pic(pBitmap,"BarChartPic")									; set bitmap to picture control
Gdip_DisposeImage(pBitmap)												; dispose of bitmap
Gdip_Shutdown(pToken)													; shut down GDI+
Gui 1:Show, w260 h130													; show Gui
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