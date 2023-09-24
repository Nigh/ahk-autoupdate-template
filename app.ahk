#Requires AutoHotkey v2.0
SetWorkingDir(A_ScriptDir)
#SingleInstance force
#include meta.ahk
#include *i compile_prop.ahk

#include prod.ahk

; if you need admin privilege, enable it.
if (0)
{
	UAC()
}
#include update.ahk
setTray()
OnExit(trueExit)

; ===============================================================
; ===============================================================
; your code below

mygui := Gui("-DPIScale -AlwaysOnTop -Owner +OwnDialogs")
myGui.OnEvent("Close", myGui_Close)
mygui.SetFont("s32 Q5", "Verdana")
mygui.Add("Text", "w640 Center", "AHKv2-AutoUpdate-Template")
mygui.SetFont("s12 Q5", "Verdana")
mygui.Add("Text", "w640 Center", "v" . version)
mygui.Show()
Return

mygui_Close(thisGui) {
	trueExit(0, 0)
}
trueExit(ExitReason, ExitCode) {
	ExitApp
}

; ===============================================================
; ===============================================================

UAC()
{
	full_command_line := DllCall("GetCommandLine", "str")

	if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)")) {
		try
		{
			if A_IsCompiled
				Run '*RunAs "' A_ScriptFullPath '" /restart'
			else
				Run '*RunAs "' A_AhkPath '" /restart "' A_ScriptFullPath '"'
		}
		ExitApp
	}
}
#include tray.ahk
