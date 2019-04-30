# dynamic-wallpaper for tealinuxOS
bash approach to dynamic wallpaper for tealinuxos and other XFCE4 based os like xubuntu.
dynamic wallpaper can get data from [api](https://aladhan.com/prayer-times-api#GetTimingsByCity)
that used to sync corresponding sun and moon time to image.

# dependency
* curl `sudo apt install curl`
* jq `sudo apt install jq`

# installation

# configuration
* you can change wallpaper by editing `dynamic-wallpaper.sh` at `wppath=`. 
wallpaper is consist of 16 images that consist of `dawn, sunrise, noon, sunset, dusk, nightfall, and midnight`.
dynamic wallpaper supports `jpg, jpeg, png`
* by default, dynamic wallpaper set location city to `Semarang` and county `ID` you can change it in `realtimeapi.sh` at `Kota=` and `Negara=`.
set city by `A city name. Example: London` and country `A country name or 2 character alpha ISO 3166 code. Examples: GB or United Kindom`
