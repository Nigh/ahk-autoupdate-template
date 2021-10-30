
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
#include meta.ahk

outputVersion()

if A_IsCompiled
debug:=0
Else
debug:=1

; if you need admin privilege, enable it.
if(0)
{
	UAC()
}
#include update.ahk
menu()
OnExit, trueExit

; ===============================================================
; ===============================================================
; your code below

Gui, -DPIScale -AlwaysOnTop -Owner +OwnDialogs
Gui, Font, s32 Q5, Verdana
Gui, Add, Text, w640 Center, AHK-AutoUpdate-Template
Gui, Font, s12 Q5, Verdana
Gui, Add, Text, w640 Center, v%version%
Gui, Show
Return

GuiClose:
ExitApp
trueExit:
ExitApp

#If debug
F5::ExitApp
F6::Reload
#If
; ===============================================================
; ===============================================================

UAC()
{
	full_command_line := DllCall("GetCommandLine", "str")
	if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
	{
		try
		{
			if A_IsCompiled
				Run *RunAs "%A_ScriptFullPath%" /restart
			else
				Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
		}
		ExitApp
	}
}
#include menu.ahk
