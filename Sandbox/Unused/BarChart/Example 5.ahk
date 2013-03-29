;===Auto-execute========================================================================
ChartData =
(
Athens	11
London	6
Moscow	-9
Berlin	9
Oslo	-6
Paris	8
Madrid	12
)

ValuesSuffix := (A_IsUnicode) ? " °C" : " C"

OnMessage(0x201, "WM_LBUTTONDOWN")
pToken := Gdip_Startup()
pBitmap := BarChart(ChartData, 600, 400, "Temperatures today", "DiagonWhiteOrange", "BarHeightFactor:1.8, ValuesSuffix:" ValuesSuffix " , ChartBackRoundness:14, FrameWidth:50")

G := Gdip_GraphicsFromImage(pBitmap)
Gdip_TextToGraphics(G, "Have a nice day!", "x400 y320 Right Italic Vcenter cff555555 r5 s10", "Arial", 150, 30)
Gdip_DeleteGraphics(G)

CreateLayeredWin(1, pBitmap)
Gdip_DisposeImage(pBitmap)
Gdip_Shutdown(pToken)
Gui 1:Show, NA
return


;===Hotkeys=============================================================================
Escape::ExitApp


;===Functions===========================================================================
#Include %A_ScriptDir%\Gdip.ahk			; by Tic
#Include %A_ScriptDir%\BarChart.ahk		; by Learning one

CreateLayeredWin(GuiNum, pBitmap) {	; Creates layered window from pBitmap and returns its HWND (WinID). By Learning one.
	Gui %GuiNum%: Destroy
	Gui %GuiNum%: -Caption +E0x80000 +LastFound +ToolWindow +AlwaysOnTop +OwnDialogs
	Gui %GuiNum%: Show, hide
	hwnd := WinExist()

	Width := Gdip_GetImageWidth(pBitmap), Height := Gdip_GetImageHeight(pBitmap)
	hbm := CreateDIBSection(Width, Height), hdc := CreateCompatibleDC(), obm := SelectObject(hdc, hbm)
	G := Gdip_GraphicsFromHDC(hdc), Gdip_SetSmoothingMode(G, 4), Gdip_SetInterpolationMode(G, 7)
	Gdip_DrawImage(G, pBitmap, 0, 0, Width, Height)
	Gdip_DeleteGraphics(G)
	
	UpdateLayeredWindow(hwnd, hdc, (A_ScreenWidth-Width)/2, (A_ScreenHeight-Height)/2, Width, Height)
	SelectObject(hdc, obm), DeleteObject(hbm), DeleteDC(hdc)
	Return hwnd
}

WM_LBUTTONDOWN() {
	PostMessage, 0xA1, 2
}