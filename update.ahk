

outputVersion(){
	global
	version:="0.0.1"
	if A_Args.Length() > 0
	{
		for n, param in A_Args
		{
			RegExMatch(param, "--out=(\w+)", outName)
			if(outName1=="version") {
				f := FileOpen("version.txt","w")
				f.Write(version)
				f.Close()
				ExitApp
			}
		}
	}
}


downloadUrlBase:="https://download.fastgit.org/Nigh/ahk-autoupdate-template/releases/latest/download/"
; github: https://github.com/Nigh/ahk-autoupdate-template/releases/latest/download/version.txt
; fast mirror: https://download.fastgit.org/Nigh/ahk-autoupdate-template/releases/latest/download/version.txt

versionFilename:="version.txt"
binaryFilename:="app.zip"

update_log:="
(
text your update log here
)"

IniRead, lastUpdate, setting.ini, update, last, 0
IniRead, autoUpdate, setting.ini, update, autoupdate, 1
today:=A_MM . A_DD
if(autoUpdate) {
	if(lastUpdate!=today) {
		MsgBox,,Update,Getting Update,2
		update()
	} else {
		IniRead, version_str, setting.ini, update, ver, "0"
		if(version_str!=version) {
			IniWrite, % version, setting.ini, update, ver
			MsgBox, % version "`nUpdate log`n`n" update_log
		}
	}
} else {
	MsgBox,,Update,Update Skiped`n`nCurrent version`nv%version%,2
}

update(){
	global
	req := ComObjCreate("MSXML2.ServerXMLHTTP")
	req.open("GET", downloadUrlBase versionFilename, true)
	req.onreadystatechange := Func("updateReady")
	req.send()
}

; with MSXML2.ServerXMLHTTP method, there would be multiple callback called
updateReqDone:=0
updateReady(){
	global req, version, updateReqDone, downloadUrlBase, binaryFilename
	; log("update req.readyState=" req.readyState, 1)
    if (req.readyState != 4){  ; Not done yet.
        return
	}
	if(updateReqDone){
		; log("state already changed", 1)
		Return
	}
	updateReqDone := 1
	; log("update req.status=" req.status, 1)
    if (req.status == 200){ ; OK.
        ; MsgBox % "Latest version: " req.responseText
		RegExMatch(version, "(\d+)\.(\d+)\.(\d+)", verNow)
		RegExMatch(req.responseText, "(\d+)\.(\d+)\.(\d+)", verNew)
		if(verNow1*10000+verNow2*100+verNow3<verNew1*10000+verNew2*100+verNew3) {
			MsgBox, 0x24, Download, % "Found new version " req.responseText ", download?"
			IfMsgBox Yes
			{
				UrlDownloadToFile, % downloadUrlBase binaryFilename, % binaryFilename
				if(ErrorLevel) {
					MsgBox, 16,, % "Download failed"
				} else {
					MsgBox, ,, % "File saved as " binaryFilename "`n`nProgram will exit now", 2
					IniWrite, % A_MM A_DD, setting.ini, update, last
					ExitApp
				}
			}
		} else {
			MsgBox, ,, % "Current version: v" version "`n`nIt is the latest version", 2
			IniWrite, % A_MM A_DD, setting.ini, update, last
		}
	} else {
        MsgBox, 16,, % "Update failed`n`nStatus=" req.status
	}
}
