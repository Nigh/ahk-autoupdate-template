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
title := mygui.Add("Text", "x20 w840 Center", "AHKv2-AutoUpdate-Template")
mygui.SetFont("s12 Q5", "Verdana")
mygui.Add("Text", "xp y+0 wp center", "v" . version)
mygui.SetFont("s20 Q5", "Verdana")
num := mygui.Add("Text", "xp y+15 wp center", 0)
mygui.SetFont("s16 Q5", "Verdana")
title.GetPos(, , &titleW)
test_btns := ["-1", "+1"]
btns_width := test_btns.Length * (64 + 2) - 2
btns_start := (titleW + 20*2 - btns_width) / 2
mygui.Add("Text", "y+0 w0 Hidden Section")
for i, btn in test_btns
{
	_btn := mygui.Add("Button", "yp w64 x" btns_start+(i-1)*(64+2), btn)
	_btn.OnEvent("Click", btn_fn(btn+0))
}
mygui.Show("w" titleW+40)
Return
btn_fn(dv) {
	global num
	fn(*) {
		num.Value := num.Value + dv
	}
	return fn
}

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
