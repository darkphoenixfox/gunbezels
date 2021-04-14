#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force


;*******THIS IS PROVIDED AS IS TO THE SINDEN LIGHTGUN COMMUNITY********************
;************************BY Pete AND Prof_gLX**************************************
;*******NO SUPPORT WILL BE GIVEN IF YOU WISH TO MODIFY THIS FILE*******************

;*****************************Change Rompath and Bezel path HERE********************
BezelPath := ".\SindenBezels\"
;***********************************************************************************

game = %1%

if (game = "")
	iniread, game, psxlauncher.ini, default, lastgame

if (game = "ERROR")
	ExitApp



splitpath, game,,,,gamename ; extract only the filename without extension
 
Run, %a_scriptdir%\SindenBezels\nomousy.exe /hide
Sleep 100
run, %a_scriptdir%\duckstation-qt-x64-ReleaseLTCG.exe `"%game%`" , %a_scriptdir%
;move emu inside the bezel

Sleep 2000
WinMove,ahk_exe duckstation-qt-x64-ReleaseLTCG.exe, , 239, 15, 1440, 1050
IfWinNotExist, frame
{
	SysGet, m1, Monitor, 1
	CustomColor = 000000f  ; Can be any RGB color (it will be made transparent below).
	Gui, 88:+Toolwindow
	Gui, 88:+0x94C80000
	Gui, 88:+E0x20 ; this makes this GUI clickthrough
	Gui, 88:-Toolwindow
	Gui, 88: +LastFound +AlwaysOnTop -Caption +ToolWindow  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
	Gui, 88: Color, %CustomColor%
	Gui, 88: Add, Picture, x0 y0 w%m1right% h%m1Bottom% BackGroundTrans, %BezelPath%\%gamename%.png
	WinSet, Style, -0xC40000, A
	WinSet, TransColor, %CustomColor% ;150	; Make all pixels of this color transparent and make the text itself translucent (150)
	Gui, 88: Show, x0 y0 w%m1right% h%m1Bottom%, NoActivate, frame ; NoActivate avoids deactivating the currently active window.
	WinHide, ahk_class Shell_TrayWnd
	WinHide, ahk_class Shell_SecondaryTrayWnd
}
; 
; Close Overlay
; 
;SubOverlayClose:
;  Gui, GUI_Overlay:Destroy
;  Return
$Esc::
    Run, .\SindenBezels\nomousy.exe
	Process,Close,Duckstation PS1 Emulator
    Run,taskkill /im "duckstation-qt-x64-ReleaseLTCG.exe" /F
	iniwrite, %game%, sneslauncher.ini, default, lastgame
	WinShow, ahk_class Shell_TrayWnd
	WinShow, ahk_class Shell_SecondaryTrayWnd
    ExitApp
return