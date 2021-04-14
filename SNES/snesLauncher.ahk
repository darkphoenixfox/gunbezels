#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;; #Warn  ; Enable warnings to assist with detecting common errors.
;SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
;SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#NoEnv
#SingleInstance force
SetBatchLines -1
ListLines Off
SetTitleMatchMode,2

;*****************************Change Bezel path HERE********************
BezelPath := ".\SindenBezels\" ; folder with all the bezels
;***********************************************************************************

game = %1% ; take the 1st parameter into a variable

if (game = "")
	iniread, game, sneslauncher.ini, default, lastgame

splitpath, game,,,,gamename ; extract only the filename without extension
 
Run, snes9x.exe -port2 Superscope "%game%" -fullscreen ; run the 1st parameter game
sleep,200

;TURBO FUNCTION ON KEYBOARD IS BUGGED IN SNES9X, THIS CODE TO DETERMINE WHERE TO SEND THE MOUSE POINTER WHEN CLICKING MIDDLE MOUSE BUTTON
;DETERMINE THE PIXEL TO SHOOT FOR RELOAD
SysGet, m1, Monitor, 1
LeftPixel := Floor((m1right - ((m1bottom/7)*8))/2)
RightPixel := Floor(m1right - LeftPixel)

;STARTS NOMOUSY TO HIDE CURSOR WHEN ON TOP OF BEZEL
Run,%A_ScriptDir%\SindenBezels\nomousy.exe /hide
sleep,200

IfWinNotExist, frame
{
	CustomColor = 000000f  ; Can be any RGB color (it will be made transparent below).
	Gui, 88:+Toolwindow
	Gui, 88:+0x94C80000
	Gui, 88:+E0x20 ; this makes this GUI clickthrough
	Gui, 88:-Toolwindow
	Gui, 88: +LastFound +AlwaysOnTop -Caption +ToolWindow  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
	Gui, 88: Color, %CustomColor%
	Gui, 88: Add, Picture, x0 y0 w%m1right% h%m1Bottom% BackGroundTrans, %BezelPath%%gamename%.png ; load the png with the same name as the game rom with png extension
	WinSet, TransColor, %CustomColor% ;150	; Make all pixels of this color transparent and make the text itself translucent (150)
	Gui, 88: Show, x0 y0 w%m1right% h%m1Bottom% NoActivate, frame ; NoActivate avoids deactivating the currently active window.
}

; 
; Close Overlay
; 
SubOverlayClose:
  Gui, GUI_Overlay:Destroy
  Return


;TRIGGER BUTTON BOUND TO LEFT MOUSE BUTTON
$LButton::h

;CURSOR BUTTON BOUND TO RIGHT MOUSE BUTTON
$RButton::g

;START BUTTON / BOUND TO KEYBOARD 1, LIKE MAME DEFAULT START. CHANGE 1 TO WHATEVER YOU WANT START TO BE
$1::/

$Esc::
    Process,Close,snes9x.exe
    Run,taskkill /im "snes9x.exe" /F
	sleep,200
	Run,%A_ScriptDir%\SindenBezels\nomousy.exe /hide
	iniwrite, %game%, sneslauncher.ini, default, lastgame
    ExitApp
	Return
	