#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force ; Determines whether a script is allowed to run again when it is already running.

; Tool to save per-game configurations for PCSX2
; Written for the Sinden Lightgun community

;initialization
;grab the script parameter if any was provided
game = %1% 

;check if the parameter was an iso name (launchbox) and convert this to the right game name
if (game != "")
{	
	iniread, isoname, %A_Scriptdir%\pcsx2launcher.ini, isonames, %game%
	if (isoname != "") && (isoname != "ERROR")
	{ 
		game := isoname
	} 
	
	gamecheck := game
	splitpath, gamecheck, gamecheck
	gamecheck := SubStr(gamecheck,  1, InStr(gamecheck, ".") -1)
	
	iniread, isoname, %A_Scriptdir%\pcsx2launcher.ini, isonames, %gamecheck%
	if (isoname != "") && (isoname != "ERROR")
	{ 
		game := isoname
	} 
	

}
;read the ini or create it
if !FileExist(A_ScriptDir "\pcsx2launcher.ini")
{
	IniWrite, pcsx2.exe, pcsx2launcher.ini, default, emuexe
	IniWrite, --fullscreen --nogui, pcsx2launcher.ini, default, pcsx2flags
}

IniRead, emuexe, pcsx2launcher.ini, default, emuexe, pcsx2.exe
IniRead, flags, pcsx2launcher.ini, default, pcsx2flags, --fullscreen --nogui

if !FileExist(A_ScriptDir "\gameconfigs"), "D"
	FileCreateDir, %A_ScriptDir%\gameconfigs

if !FileExist(A_ScriptDir "\" emuexe) ; Check if we are in the PCSX2 folder
{
	Msgbox,, Error, %emuexe% not found. Please run this tool from the PCSX2 folder or update your pcsx2launcher.ini file.
	ExitApp
} 

;Check if we are trying to run a game (config folder exist) or set up a new game (no config folder or script run without paramenters)
if (game < 1) || !FileExist(A_ScriptDir "\gameconfigs\" game "\game.ini") ; if there are not parameters or the ini doesnt exist
	goto SetUP ;we want to set up a new game
else
	goto RunGame ;we want to run a game
ExitApp

SetUP:
FileRead, iso, %A_ScriptDir%\inis\PCSX2_ui.ini  ; read the PCSX2 ini to find the last used iso
loop, parse, iso, `n, `r
{
	StringSplit, m, A_LoopField, =
	if (m1="CurrentIso")
		iso := m2
}

if (iso != "") && (game < 1) ; either grab the game name from the parameter passed to AHK or the iso name
{ 
	iso := StrReplace( SubStr(iso,  InStr(iso, "=") + 1), "\\", "\")

	splitpath, iso,isoname
	isoname := SubStr(isoname,  1, InStr(isoname, ".") -1)
	game := isoname
	game := StrReplace( SubStr(game,  1, InStr(game, ".") -1), " ", "_")
	game := StrReplace( game, "(", "")
	game := StrReplace( game, ")", "")
}
if (iso = "" )
	iso := "Your game iso with full path"
if (game = "")
	game := "Game name (no spaces)"
	
Gui, Add, Text, x42 y120 w430 h20 , Game name (name of the config folder, no spaces):
Gui, Add, Edit, x42 y140 w430 h20 vgame, %game%

Gui, Add, Text, x42 y190 w430 h20 , Game iso location and filename:
Gui, Add, Edit, x42 y210 w430 h20 viso, %isoname%

Gui, Add, Text, x42 y260 w430 h20 , Program to run before PCSX2 (Pedals`, drivers`, etc):
Gui, Add, Edit, x42 y280 w430 h20 vappatlaunch, none
Gui, Add, Text, x42 y310 w430 h20 , Parameters for this program (leave empty for none):
Gui, Add, Edit, x42 y330 w430 h20 vappatlaunchparams,
Gui, Add, Text, x42 y360 w140 h20 , Close it after closing PCSX2:
Gui, Add, CheckBox, x182 y358 w20 h20 vcloseappatlaunch,

Gui, Add, Text, x42 y410 w430 h20 , Program to run after closing PCSX2 (Pedals`, drivers`, etc):
Gui, Add, Edit, x42 y430 w430 h20 vappatquit, none
Gui, Add, Text, x42 y460 w430 h20 , Parameters for this program (leave empty for none):
Gui, Add, Edit, x42 y480 w430 h20 vappatquitparams,

Gui, Add, Button, x132 y520 w100 h30 default, &OK
Gui, Add, Button, x292 y520 w100 h30 , Cancel
Gui, Font, S12 CDefault, Verdana
Gui, Add, Text, x32 y19 w450 h80 , If you haven't done it yet`, run PCSX2`, configure all your settings including nuvee options. Then run the game`, complete calibration and save the state (F1).  Close PCSX2 and re-run this script.
; Generated using SmartGUI Creator for SciTE
Gui, Show, w518 h580, PCSX2 per game config creator GUI
return

ButtonOK:
Gui, Submit
game := StrReplace( game, " ", "_")
if (closeappatlaunch = 1)
	closeappatlaunch := "yes"
else
	closeappatlaunch := "no"

;MSgbox, setting the ini as follows:`r`nGAME: %game%`r`nISO: %iso%`r`nprogram at launch: %appatlaunch%`r`nclose it: %closeappatlaunch%`r`nprogram at quit: %appatquit%

if !FileExist(A_ScriptDir "\gameconfigs\" game), D
	FileCreateDir, %A_ScriptDir%\gameconfigs\%game%

;write the values from the GUI to the game.ini
IniWrite, %iso%, %A_ScriptDir%\gameconfigs\%game%\game.ini, default, iso
IniWrite, %appatlaunch%, %A_ScriptDir%\gameconfigs\%game%\game.ini, default, appatlaunch
IniWrite, %appatlaunchparams%, %A_ScriptDir%\gameconfigs\%game%\game.ini, default, appatlaunchparams
IniWrite, %closeappatlaunch%, %A_ScriptDir%\gameconfigs\%game%\game.ini, default, closeappatlaunch
IniWrite, %appatquit%, %A_ScriptDir%\gameconfigs\%game%\game.ini, default, appatquit
IniWrite, %appatquitparams%, %A_ScriptDir%\gameconfigs\%game%\game.ini, default, appatquitparams
Iniwrite, %game%, %A_ScriptDir%\pcsx2launcher.ini, isonames, %isoname%


FileDelete,  %A_Scriptdir%/inis/game.ini
FileCopy, %A_Scriptdir%/inis/ , %A_Scriptdir%/gameconfigs/%game%/*.* , 1

Gui, 2:Font, S10 CDefault Bold, Verdana
Gui, 2:Add, Text, x25 y19 w540 h130 , The configuration has been saved.`n Run this command: `n`n  %A_Scriptname% %game% `n`n to run your game with the saved settings.
Gui, 2:Add, Button, x102 y179 w140 h30 default, &Close
Gui, 2:Add, Button, x322 y179 w160 h30 , Run the game now
; Generated using SmartGUI Creator for SciTE
Gui, 2:Show, w594 h239, Configuration Saved GUI
return

2ButtonClose:
ExitApp

2ButtonRunthegamenow:
gui, 2:hide
gosub RunGame

ButtonCancel:
ExitApp

GuiClose:
ExitApp

RunGame:
; Read the ini file for our game
IniRead, iso, %A_Scriptdir%/Gameconfigs/%game%/game.ini, default, iso ; read the iso name from the ini
IniRead, appatlaunch, %A_Scriptdir%/Gameconfigs/%game%/game.ini, default, appatlaunch, none ; read the program to run before the game
if (appatlaunch = "")
	appatlaunch := "none" ; make sure that an empty value is treated the same as none

if (appatlaunch = "none") ; if no program to launch we dont need to close it, set it to no
	closeappatlaunch = "no"
else
{ 
	IniRead, closeappatlaunch, %A_Scriptdir%/Gameconfigs/%game%/game.ini, default, closeappatlaunch, no ; does it need to be closed after the game
	IniRead, appatlaunchparams, %A_Scriptdir%/Gameconfigs/%game%/game.ini, default, appatlaunchparams, 
}
IniRead, appatquit, %A_Scriptdir%/Gameconfigs/%game%/game.ini, default, appatquit, none ; read the program to run after finishing the game
IniRead, appatquitparams, %A_Scriptdir%/Gameconfigs/%game%/game.ini, default, appatquitparams,

if (appatquit = "")
	appatquit := "none"

;copy the ini files to the main folder
FileCopy, %A_Scriptdir%/gameconfigs/%game%/*.*, %A_Scriptdir%/inis/ , 1

; run all the things
if (appatlaunch != "none")
{ 
	SplitPath, appatlaunch, , launchpath
	run, `"%appatlaunch%`" %appatlaunchparams% ,%launchpath%,, atlaunchPID ;run the at launch app from its own dir
}
run, `"%A_Scriptdir%/%emuexe%`" `"%iso%`" %flags%,,, pcsx2PID ; Run PCSX2 with the flags from the ini file
sleep 300
WinActivate, ahk_exe %pcsx2PID%
sleep 10000
Send {F3 Down} ; Load the Savestate
Sleep, 100
Send {F3 up}


; close PCSX by pressing ESC
$ESC::
if (appatlaunch != "none") && ((closeappatlaunch = "yes") || (closeappatlaunch = "1"))
		process, close, %atlaunchPID%

Process, Close, %pcsx2PID% ; quit PCSX2 by PID
sleep 200

if (appatquit != "none")
{
	SplitPath, appatquit, , quitpath
	run, `"%appatquit%`" %appatquitparams% ,%quitpath% ;run the at quit app from its own dir
}
ExitApp