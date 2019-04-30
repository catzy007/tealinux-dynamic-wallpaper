#!/bin/bash
#some variables
time=0
wppath=/usr/share/tealinux/dynamic-wallpaper/mojave #you might need to change this
apipath=/usr/share/tealinux/dynamic-wallpaper
apiconfig=~/.config/apitime-dynamic-wallpaper.cfg
config=~/.config/tea-dynamic-wallpaper.cfg
status=~/.config/status-dynamic-wallpaper.cfg
declare -a timeseed
mapfile -t images < <(ls ${wppath} -v | grep -e jpg -e jpeg -e png)
mapfile -t cfgxml < <(xfconf-query -c xfce4-desktop -l | grep "last-image$")

#get time from API
echo "$(${apipath}/realtimeapi.sh)"

#set initial config
echo 0 > ${config}

readarray -t timeseed < ${apiconfig}
for i in {14..1}; do
	temp1=${images[$i]}
	temp2=${images[$(($i-1))]}
	images[$i]=${temp2}
	images[$(($i-1))]=${temp1}
done
temp=${images[0]}
images[0]=${images[15]}
images[15]=${temp}

if [ ! -f "${status}" ]; then
	echo 1 > ${status}
fi

#main program
while true ; do
	readarray -t statuscfg < ${status}
	if [ "${statuscfg[0]}" == "1" ]; then
		#get current time
		hour=$(date +"%H")
		mint=$(date +"%M")
		time=$(( 10#${hour}*60 + 10#${mint} ))

		#set wallpaper according to time
		readarray -t varcfg < ${config}
		if (( "${time}" > "${timeseed[14]}" )); then
			if (( "${varcfg[0]}" != "${timeseed[15]}" )); then
				echo ${timeseed[15]} > ${config}
				echo "$(${apipath}/realtimeapi.sh)"
				readarray -t timeseed < ${apiconfig}
			fi
		else
			if (( "${time}" >= "${varcfg[0]}" )); then
				default="${wppath}/${images[15]}"
				for index1 in ${!images[@]}; do
					if (( "${timeseed[$index1]}" > "${time}")); then
						default="${wppath}/${images[$index1]}"
						echo "${timeseed[$index1]}" > ${config}
						break
					fi			
				done
				echo "${default}"
				for index2 in ${!cfgxml[@]}; do
					xfconf-query -c xfce4-desktop -p "${cfgxml[$index2]}" -s "${default}"
				done
			fi
		fi

		#echo "${timeseed[0]} | ${time} | ${varcfg[0]} | ${timeseed[14]} | ${default}" #debug_line_can_be_removed!
	fi
	sleep 10
done
