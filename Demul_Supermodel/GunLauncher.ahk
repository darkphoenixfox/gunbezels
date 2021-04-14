#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force

game = %1%
m3gungames = lalmachin,lostwsga,oceanhun,swtrilgy


hikaru=braveff
awave=claychal,xtrmhnt2,xtrmhunt,rangrmsn,sprtshot
naomi=confmiss,deathcox,hotd2,lupinsho,mok,ninjaslt
demulgungames= %awave%,%hikaru%,%naomi%

if (game != "")
{
	if (InStr(game,"\") > 0) || (InStr(game,".") > 0)
	{
		splitpath, game,,,, game
	}
}

	IniRead, resx, %A_ScriptDir%\gunlauncher.ini, Default, width, 1920
	IniRead, resy,  %A_ScriptDir%\gunlauncher.ini, Default, height, 1080
	IniRead, rompath,  %A_ScriptDir%\gunlauncher.ini, Roms, path, %A_ScriptDir%\roms
	IniRead, emulator, %A_ScriptDir%\gunlauncher.ini, Emulator, Emulator
	IniRead, emupath, %A_ScriptDir%\gunlauncher.ini, Emulator, path
	IniRead, mousypath, %A_ScriptDir%\gunlauncher.ini, Nomousy, path, path, c:\nomousy\nomousy.exe
	IniRead, mousyrun, %A_ScriptDir%\gunlauncher.ini, Nomousy, Run Nomousy
	IniRead, dspath, %A_ScriptDir%\gunlauncher.ini, Demulshooter, path


if !FileExist(A_ScriptDir "\gunlauncher.ini")
{
	while (emulator!="supermodel") && (emulator!="demul")
		InputBox, emulator, First run, Emulator`n`(supermodel or demul),,,,,,,,demul
	Inputbox, emupath, First run, Emulator path,,,,,,,,%A_ScriptDir%\%emulator%.exe
	InputBox, resx, First run, Horizontal screen resolution,,,,,,,,1920
	InputBox, resy, First run, Vertical screen resolution,,,,,,,,1080
	InputBox, rompath, First run, Roms folder,,,,,,,,%a_scriptdir%\roms
	while (mousyrun!="yes") && (mousyrun!="no")
		InputBox, mousyrun, First run, Run Nomousy?,,,,,,,,no
	if (mousyrun="yes")
		InputBox, mousypath, First run, Nomousy.exe path,,,,,,,,C:\nomousy\nomousy.exe
	else
		mousypath = "none"
	
	if (emulator = "demul")
		InputBox, dspath, First run, Demulshooter.exe path,,,,,,,,C:\demulshooter\demulshooter.exe
	
	
	IniWrite, %resx%, %A_ScriptDir%\gunlauncher.ini, default, width
	IniWrite, %resy%, %A_ScriptDir%\gunlauncher.ini, default, height
	IniWrite, %rompath%, %A_ScriptDir%\gunlauncher.ini, Roms, path
	IniWrite, %emulator%, %A_ScriptDir%\gunlauncher.ini, Emulator, Emulator
	IniWrite, %emupath%, %A_ScriptDir%\gunlauncher.ini, Emulator, path
	IniWrite, %mousypath%, %A_ScriptDir%\gunlauncher.ini, Nomousy, path
	IniWrite, %mousyrun%, %A_ScriptDir%\gunlauncher.ini, Nomousy, Run Nomousy
	IniWrite, %dspath%, %A_SCriptDir%\gunlauncher.ini, Demulshooter, path
	if (game = "")
		ExitApp
}
else if (game="")
{
	InputBox, emulator, Configuration, Emulator`n`(supermodel or demul),,,,,,,,%emulator%
	Inputbox, emupath, Configuration, Emulator path,,,,,,,,%emupath%
	InputBox, resx, Configuration, Horizontal screen resolution,,,,,,,,%resx%
	InputBox, resy, Configuration, Vertical screen resolution,,,,,,,,%resy%
	InputBox, rompath, Configuration, Roms folder,,,,,,,,%rompath%
	InputBox, mousyrun, Configuration, Run Nomousy?,,,,,,,,%mousyrun%
	if (mousyrun="yes")
		InputBox, mousypath, Configuration, Nomousy.exe path,,,,,,,,%mousypath%
	else
		mousypath = "none"
	if (emulator = "demul")
		InputBox, dspath, First run, Demulshooter.exe path,,,,,,,,%dspath%
	
	IniWrite, %resx%, %A_ScriptDir%\gunlauncher.ini, default, width
	IniWrite, %resy%, %A_ScriptDir%\gunlauncher.ini, default, height
	IniWrite, %rompath%, %A_ScriptDir%\gunlauncher.ini, Roms, path
	IniWrite, %emulator%, %A_ScriptDir%\gunlauncher.ini, Emulator, Emulator
	IniWrite, %emupath%, %A_ScriptDir%\gunlauncher.ini, Emulator, path
	IniWrite, %mousypath%, %A_ScriptDir%\gunlauncher.ini, Nomousy, path
	IniWrite, %mousyrun%, %A_ScriptDir%\gunlauncher.ini, Nomousy, Run Nomousy
	IniWrite, %dspath%, %A_SCriptDir%\gunlauncher.ini, Demulshooter, path
	ExitApp
} 

FileDelete, %A_ScriptDir%\reshade-shaders\Textures\Bezel.png
FileDelete, %A_ScriptDir%\reshade-shaders\Textures\Bezel_off.png

;---------------------model 3
if (emulator="supermodel")
{ 
	if (Instr(m3gungames, game))
	{
		FileCopy, %A_ScriptDir%\Artwork\%game%.png, %A_ScriptDir%\reshade-shaders\Textures\Bezel.png
		FileCopy, %A_ScriptDir%\Artwork\%game%.png, %A_ScriptDir%\reshade-shaders\Textures\Bezel_off.png
	}
	
	if (mousyrun="yes")
		run, %mousypath% /hide
	run, `"%emupath%`" `"%rompath%\%game%.zip`" -fullscreen -res=%resx%`,%resy%, %A_ScriptDir%, emuPID
	
return
}

;----------------------demul
if (emulator="demul")
{
	if (Instr(hikaru, game))
		system=hikaru
	else if (Instr(naomi, game))
		system=naomi
	else if (Instr(awave, game))
		system=awave
	else
		ExitApp

	
	splitpath, emupath,,emupath
	iniwrite, %rompath%, %A_ScriptDir%\demul.ini, files, roms0
	if (Instr(demulgungames, game))
	{ 
		FileCopy, %A_ScriptDir%\Artwork\%system%\%game%.png, %A_ScriptDir%\reshade-shaders\Textures\Bezel.png
		FileCopy, %A_ScriptDir%\Artwork\%system%\%game%.png, %A_ScriptDir%\reshade-shaders\Textures\Bezel_off.png
	}
	sleep 3000
	run, %dspath% -target=demul07a -rom=%game%,,dsPID
	if (mousyrun="yes")
		run, %mousypath% /hide	
	run, `"%emupath%\Demul07_CRTGeomMOD.exe`" -run=%system% -rom=%game%, %A_ScriptDir%
	sleep 200
	process, exist, demul.exe
	emuPID := errorlevel
return
}


$ESC::
Process, close, %emuPID%
if (emulator="demul")
	Process, close, %dsPID%
	Process, close, demulshooter.exe
if (mousyrun="yes")
	run, %mousypath%
sleep 100
ExitApp