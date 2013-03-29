;===Auto-execute========================================================================
BarbarianChart =
(
Vitality	80
Strenght	95
Dexterety	60
Magic	25
)

WizardChart =
(
Vitality	70
Strenght	40
Dexterety	50
Magic	95
)

Skin := "SimpleBlue"

OnExit, ExitSub
Gui, 1: Font, s30 q5 c666666
Gui, 1: Color, White

Gui, 1:Add, Picture, x5 y5 w250 h190 BackgroundTrans 0xE vBarPic
Gui, 1:Add, Picture, x260 y5 w250 h190 BackgroundTrans 0xE vWizPic
Gui, 1:Add, Text, x5 y200 w505 h60 Center , Press 1,2,3,4

pToken := Gdip_Startup()

pBar1 := BarChart(BarbarianChart, 250, 190, "Barbarian", Skin, "DataAlignment:Center, MaxValue:100")
pWiz1 := BarChart(WizardChart, 250, 190, "Wizard", Skin, "DataAlignment:Center, MaxValue:100")

pBar2 := BarChart(BarbarianChart, 250, 190, "Barbarian", Skin, "DataAlignment:Left, MaxValue:100")
pWiz2 := BarChart(WizardChart, 250, 190, "Wizard", Skin, "DataAlignment:Right, MaxValue:100")

pBar3 := BarChart(BarbarianChart, 250, 190, "Barbarian", Skin, "DataAlignment:Right, MaxValue:100")
pWiz3 := BarChart(WizardChart, 250, 190, "Wizard", Skin, "DataAlignment:Left, MaxValue:100")

MoreOptions := "ChartBackColorB:fff5f5ff, ChartBackHatchColorA:10000000, ChartBackHatchStyle:3, PlotBackColorA:0, PlotBackColorB:0, BarBorderColor:88aaaaff, BarColorB:333333aa, BarColorHeightDiv:3"
pBar4 := BarChart(BarbarianChart, 250, 190, "Barbarian", Skin, "DataAlignment:Right, MaxValue:100, " MoreOptions)
pWiz4 := BarChart(WizardChart, 250, 190, "Wizard", Skin, "DataAlignment:Left, MaxValue:100, " MoreOptions)

SetBitmap2Pic(pBar3, "BarPic")
SetBitmap2Pic(pWiz3, "WizPic")

Gui 1:Show, w515 h265, Characters
return


;===Hotkeys=============================================================================
#IfWinActive, Characters ahk_class AutoHotkeyGUI
1::
2::
3::
4::
SetBitmap2Pic(pBar%A_ThisHotkey%, "BarPic")
SetBitmap2Pic(pWiz%A_ThisHotkey%, "WizPic")
return
#IfWinActive


;===Subroutines=========================================================================
ExitSub:
Gdip_DisposeImage(pBar1), Gdip_DisposeImage(pWiz1)
Gdip_DisposeImage(pBar2), Gdip_DisposeImage(pWiz2)
Gdip_DisposeImage(pBar3), Gdip_DisposeImage(pWiz3)
Gdip_DisposeImage(pBar4), Gdip_DisposeImage(pWiz4)
Gdip_Shutdown(pToken)
ExitApp

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