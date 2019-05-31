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
chmod +x "${installpath}/dynamic-wallpaper/dynamic-wallpaper.sh"

echo "copying $(pwd)/dynamic-wallpaper-startup.sh"
cp "$(pwd)/dynamic-wallpaper-startup.sh" "${installpath}/dynamic-wallpaper"
chmod +x "${installpath}/dynamic-wallpaper/dynamic-wallpaper-startup.sh"

echo "copying $(pwd)/realtimeapi.sh"
cp "$(pwd)/realtimeapi.sh" "${installpath}/dynamic-wallpaper"
chmod +x "${installpath}/dynamic-wallpaper/realtimeapi.sh"

echo "copying $(pwd)/LICENSE"
cp "$(pwd)/LICENSE" "${installpath}/dynamic-wallpaper"

echo "copying $(pwd)/robotic"
cp -r "$(pwd)/robotic" "${installpath}/dynamic-wallpaper"

echo "copying $(pwd)/tealinux-dynamic-wallpaper.png"
cp "$(pwd)/ico/tealinux-dynamic-wallpaper.png" "/usr/share/pixmaps/"

echo "copying $(pwd)/dynamic-wallpaper.desktop"
cp "$(pwd)/dynamic-wallpaper.desktop" "/usr/share/applications"
chmod +x "/usr/share/applications/dynamic-wallpaper.desktop"

echo "copying $(pwd)/dynamic-wallpaper-startup.desktop"
cp "$(pwd)/dynamic-wallpaper-startup.desktop" "/etc/xdg/autostart"
chmod +x "/etc/xdg/autostart/dynamic-wallpaper-startup.desktop"

echo "Installing GUI"
cp -r "$(pwd)/GUI" "${installpath}/dynamic-wallpaper"
cd "${installpath}/dynamic-wallpaper/GUI"
cmake .
make

echo "done!"
echo "reboot to apply effect!"
