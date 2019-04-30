# Dynamic-Wallpaper for tealinuxOS
bash approach to dynamic wallpaper for tealinuxos and other XFCE4 based os like xubuntu.
dynamic wallpaper can get data from [api](https://aladhan.com/prayer-times-api#GetTimingsByCity)
that used to sync corresponding sun and moon time to image.

# dependency
* curl `sudo apt install curl`
* jq `sudo apt install jq`
* libgtk3 `sudo apt install libgtk-3-dev`

# installation
* clone this repo or download
* using installer `sudo ./install.sh`

# configuration
* you can change wallpaper by editing `dynamic-wallpaper.sh` wallpaper path at `wppath=`. 
wallpaper is consist of 16 images that correspond to `dawn, sunrise, noon, sunset, dusk, nightfall, and midnight`.
dynamic wallpaper supports `jpg, jpeg, png`
* by default, dynamic wallpaper set location city to `Semarang` and county `ID` you can change it in `realtimeapi.sh` at `Kota=` and `Negara=`.
set city by `A city name. Example: London` and country `A country name or 2 character alpha ISO 3166 code. Examples: GB or United Kindom` check [ISO 3166](https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes)

# using macOS dynamic wallpaper
* download dynamic-wallpaper `example.heic` file 
* install [libheif](https://github.com/strukturag/libheif) `sudo apt install libheif-examples`
* check if valid `heif-info example.heic`
* convert to jpg `heif-convert example.heic example.jpg`
* set `dynamic-wallpaper.sh` wppath

# working principle
* dynamic-wallpaper get time data from api, then time converted to minutes. this become (seed)
* dynamic-wallpaper adjust image based on time data.
* example :

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


## some image copyright goes to the respective owner
