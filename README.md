# AHK auto update template

![](logo.png)

`logo.png`(modified) from https://www.pngrepo.com/ 

`icon.ico` is converted from the `logo.png`  at https://cloudconvert.com/png-to-ico with `48x48` dimension

## how it works

When publish release on Github, upload a additional `version.txt` file.

Then the script would download the file and check if there is newer version. If there is, then download it.

## Setup

### `update.ahk`
- set `version` in `outputVersion()`
- set `downloadUrlBase` to your release URL
- `binaryFilename` should be same as the name in `distribution.ahk`
- the `update_log` would be shown once through the `msgbox` after success update

### `distribution.ahk`
- set `appName` to your script name, it would compile `%appName%.ahk` to `%appName%.exe`

### `icon.ico`
- put your icon in the same directory.

## Usage
1. Run `distribution.ahk`, is will compile your script into binary, and then compress it into zip. At the same time, it will genarate the `version.txt`. And then, this two file would be moved into `dist` directory.
2. Upload the two files in the `dist` directory to your release.
3. Everything would work.
