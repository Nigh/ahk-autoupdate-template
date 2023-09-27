FileEncoding("UTF-8")
appName := "auto upgrader"
version := "0.4.0"
versionFilename := "version.txt"
ahkFilename := "app.ahk"
binaryFilename := "app.exe"
downloadFilename := "app.zip"
GitHubID := "Nigh"
repoName := "ahk-autoupdate-template"
downloadUrl := "/" GitHubID "/" repoName "/releases/latest/download/"
update_log := "
(
Rewrite updater.ahk with C, that will reduce the compiled binary by half.
)"
