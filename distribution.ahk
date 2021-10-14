; # requirements:
; # autohotkey in PATH
; # ahk2exe in PATH
; # 7z in PATH
; # mpress in ahk2exe path

#SingleInstance, Force
SetWorkingDir, %A_ScriptDir%

appName:="app"

if FileExist(appName ".exe")
{
	FileDelete, % appName ".exe"
}

if FileExist("version.txt")
{
	FileDelete, version.txt
}

if InStr(FileExist("dist"), "D")
{
	FileRemoveDir, dist, 1
}

FileCreateDir, dist

RunWait, ahk2exe.exe /in %appName%.ahk /out %appName%.exe /icon icon.ico /compress 1
If (ErrorLevel)
{
	MsgBox, % "ERROR CODE=" ErrorLevel
	ExitApp
}
RunWait, autohotkey.exe .\%appName%.ahk --out=version
If (ErrorLevel)
{
	MsgBox, % "ERROR CODE=" ErrorLevel
	ExitApp
}
RunWait, 7z a -r %appName%.zip .\%appName%.exe
If (ErrorLevel)
{
	MsgBox, % "ERROR CODE=" ErrorLevel
	ExitApp
}
FileDelete, %appName%.exe
FileMove, %appName%.zip, dist\%appName%.zip, 1
FileMove, version.txt, dist\version.txt, 1
MsgBox, Build Finished
