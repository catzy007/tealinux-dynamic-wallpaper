# Dynamic-Wallpaper for TealinuxOS
Bash approach to dynamic wallpaper for tealinuxos and other XFCE4 based os like xubuntu.
dynamic wallpaper can get data from [api](https://aladhan.com/prayer-times-api#GetTimingsByCity)
that used to sync corresponding sun and moon time to image.

## Dependency
* curl `sudo apt install curl`
* jq `sudo apt install jq`
* libgtk3 `sudo apt install libgtk-3-dev`
* cmake `sudo apt install cmake`

summary `sudo apt update && sudo apt install curl jq libgtk-3-dev cmake`

## Installation
* Clone this repo or download zip
* Use default installer `sudo ./install.sh`

## Configuration
* You can change wallpaper by editing `dynamic-wallpaper.sh` wallpaper path at `wppath=`
* Wallpaper must consist of 16 images that correspond to `dawn, sunrise, noon, sunset, dusk, nightfall, and midnight`.
dynamic-wallpaper supports `jpg, jpeg, png`
* By default, dynamic-wallpaper set location city to `Semarang` and country `ID` you can change it in `realtimeapi.sh` at `Kota=` and `Negara=`
* Set city by `A city name. Example: London` and country `A country name or 2 character alpha ISO 3166 code. Examples: GB or United Kindom` check [ISO 3166](https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes)

## Using dynamic-wallpaper
* After successful installation and reboot, dynamic-wallpaper will automatically enabled.
* To disable or enable dynamic-wallpaper, go to menu, look for `Dynamic Wallpaper` and click the enable/disable button. the effect might take few seconds.
* After disabling dynamic-wallpaper, nothing will happend. Change your wallpaper manually!

## Using MacOS dynamic wallpaper
* Download MacOS dynamic wallpaper `example.heic` file 
* Install [libheif](https://github.com/strukturag/libheif) `sudo apt install libheif-examples`
* Check if valid `heif-info example.heic` and make sure it contain 16 images!
* Convert to jpg `heif-convert example.heic example.jpg`
* Set `wppath=` at `dynamic-wallpaper.sh`

## Working principle
* Dynamic-wallpaper get time data from api, then time converted to minutes. this become **seed**
* Dynamic-wallpaper adjust image based on **seed**.
* Example :

| SEED | START | STOP  | FILE | DESCR     |
| ---: | :---: | :---: | ---- | --------- |
| 262  | 04:12 | 04:22 | wp01 | Dawn      |
| 339  | 04:22 | 05:39 | wp02 | Sunrise   |
| 410  | 05:39 | 06:50 | wp03 |           |
| 481  | 06:50 | 08:01 | wp04 |           |
| 552  | 08:01 | 09:12 | wp05 |           |
| 623  | 09:12 | 10:23 | wp06 |           |
| 696  | 10:23 | 11:36 | wp07 | Noon      |
| 736  | 11:36 | 12:16 | wp08 |           |
| 776  | 12:16 | 12:56 | wp09 |           |
| 816  | 12:56 | 13:36 | wp10 |           |
| 856  | 13:36 | 14:16 | wp11 |           |
| 897  | 14:16 | 14:57 | wp12 | Sunset    |
| 1052 | 14:57 | 17:32 | wp13 | Dusk      |
| 1142 | 17:32 | 19:02 | wp14 | Nightfall |
| 1416 | 19:02 | 23:36 | wp15 | Midnight  |
| 252  | 23:36 | 04:12 | wp16 |           |


## Some image copyright goes to the respective owner
