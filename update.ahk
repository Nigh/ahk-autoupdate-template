
#include meta.ahk

IfExist, updater.exe
{
	FileDelete, updater.exe
}

outputVersion(){
	global
	if A_Args.Length() > 0
	{
		for n, param in A_Args
		{
			RegExMatch(param, "--out=(\w+)", outName)
			if(outName1=="version") {
				f := FileOpen(versionFilename,"w","UTF-8-RAW")
				f.Write(version)
				f.Close()
				ExitApp
			}
		}
	}
}

update_log:="
(
text your update log here
)"

IniRead, lastUpdate, setting.ini, update, last, 0
IniRead, autoUpdate, setting.ini, update, autoupdate, 1
IniRead, updateMirror, setting.ini, update, mirror, fastgit
IniWrite, % updateMirror, setting.ini, update, mirror
today:=A_MM . A_DD
if(autoUpdate) {
	if(lastUpdate!=today) {
		; MsgBox,,Update,Getting Update,2
		get_latest_version()
	} else {
		IniRead, version_str, setting.ini, update, ver, "0"
		if(version_str!=version) {
			IniWrite, % version, setting.ini, update, ver
			MsgBox, % version "`nUpdate log`n`n" update_log
		}
	}
} else {
	; MsgBox,,Update,Update Skiped`n`nCurrent version`nv%version%,2
}

; updateSite:=""
get_latest_version(){
	global
	req := ComObjCreate("MSXML2.ServerXMLHTTP")
	if(updateMirror=="fastgit") {
		updateSite:="https://download.fastgit.org"
	} else if(updateMirror=="cnpmjs") {
		updateSite:="https://github.com.cnpmjs.org"
	} else {
		updateSite:="https://github.com"
	}
	req.open("GET", updateSite downloadUrl versionFilename, true)
	req.onreadystatechange := Func("updateReady")
	req.send()
}

; with MSXML2.ServerXMLHTTP method, there would be multiple callback called
updateReqDone:=0
updateReady(){
	global req, version, updateReqDone, updateSite, downloadUrl, downloadFilename
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
		if((verNew1>verNow1)
		|| (verNew1==verNow1 && ((verNew2>verNow2)
			|| (verNew2==verNow2 && verNew3>verNow3)))){
			MsgBox, 0x24, Download, % "Found new version " req.responseText ", download?"
			IfMsgBox Yes
			{
				try {
					UrlDownloadToFile, % updateSite downloadUrl downloadFilename, % "./" downloadFilename
					MsgBox, ,, % "Download finished`nProgram will restart now", 3
					IniWrite, % A_MM A_DD, setting.ini, update, last
					FileInstall, updater.exe, updater.exe, 1
					Run, updater.exe
					ExitApp
				} catch e {
					MsgBox, 16,, % "Upgrade failed`nAn exception was thrown!`nSpecifically: " e
				}
			}
		} else {
			; MsgBox, ,, % "Current version: v" version "`n`nIt is the latest version", 2
			IniWrite, % A_MM A_DD, setting.ini, update, last
		}
	} else {
        MsgBox, 16,, % "Update failed`n`nStatus=" req.status
	}
}
