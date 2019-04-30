#!/bin/bash
installpath=/usr/share/tealinux

if [ "$EUID" -ne 0 ]
  then echo "Cannot set some parameters"; echo "Are you root?"
  exit
fi

mkdir "${installpath}"
mkdir "${installpath}/dynamic-wallpaper"
echo "copying $(pwd)/dynamic-wallpaper.sh"
cp "$(pwd)/dynamic-wallpaper.sh" "${installpath}/dynamic-wallpaper"
echo "copying $(pwd)/realtimeapi.sh"
cp "$(pwd)/realtimeapi.sh" "${installpath}/dynamic-wallpaper"
echo "copying $(pwd)/LICENSE"
cp "$(pwd)/LICENSE" "${installpath}/dynamic-wallpaper"
echo "copying $(pwd)/mojave"
cp -r "$(pwd)/mojave" "${installpath}/dynamic-wallpaper"
echo "copying $(pwd)/dynamic-wallpaper.desktop"
cp "$(pwd)/dynamic-wallpaper.desktop" "/etc/xdg/autostart"

echo "done!"