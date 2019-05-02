#!/bin/bash

#kill all remaining process
pkill -u $(whoami) -f /usr/share/tealinux/dynamic-wallpaper/dynamic-wallpaper.sh

#run new process
/bin/bash /usr/share/tealinux/dynamic-wallpaper/dynamic-wallpaper.sh &
