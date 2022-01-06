# AHK auto update template

![](logo.png)

`logo.png`(modified) from https://www.pngrepo.com/ 

`icon.ico` is converted from the `logo.png`  at https://cloudconvert.com/png-to-ico with `48x48` dimension

> tested on Autohotkey 1.1.33.07

## !!!NOTICE!!!

Please note that `v1` is no longer in development, please move to [v2](https://github.com/Nigh/ahk-autoupdate-template)


## how it works

When publish release on Github, upload a additional `version.txt` file.

Then the script would download the file and check if there is newer version. If there is, then download it.

## Setup

### `update.ahk`
- the `update_log` would be shown once through the `msgbox` after success update

### `meta.ahk`
- set `version`
- set `ahkFilename` to your script name, it would compile `%ahkFilename%.ahk` to `%binaryFilename%.exe`
- set `downloadUrl` to your github release URL

### `distribution.ahk`
> The **requirements** of using the `distribution.ahk` is:  
  ; `autohotkey` in PATH  
  ; `ahk2exe` in PATH  
  ; `mpress` in `ahk2exe` path

### `icon.ico`
- put your icon in the same directory.

### notice
version is compared by `(\d+)\.(\d+)\.(\d+)`

## Usage
1. Run `distribution.ahk`, is will compile your script into binary, and then compress it into zip. At the same time, it will genarate the `version.txt`. And then, this two file would be moved into `dist` directory.
2. Upload the two files in the `dist` directory to your release.
3. Everything would work.

## Template Usage

1. Fork this repo.
2. New Repository.
3. You can choose `Repository template` now.

