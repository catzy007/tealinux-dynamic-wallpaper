#!/bin/bash
#some variables
time=0
wppath=$(pwd)/mojave
apipath=$(pwd)
apiconfig=~/.config/apitime-dynamic-wallpaper.cfg
config=~/.config/tea-dynamic-wallpaper.cfg
declare -a timeseed

mapfile -t images < <(ls ${wppath} -v | grep -e jpg -e jpeg -e png)
mapfile -t cfgxml < <(xfconf-query -c xfce4-desktop -l | grep "last-image$")

#get time from API
echo "$(${apipath}/realtimeapi.sh)"

if [ ! -f "${apiconfig}" ]; then
	echo "API not working, please try again"
else
	#set initial config
	echo 0 > ${config}
	readarray -t timeseed < ${apiconfig}

	#main program
	while true ; do
		#get current time
		hour=$(date +"%H")
		mint=$(date +"%M")
		time=$(( ${hour}*60 + ${mint} ))

		#set wallpaper according to time
		readarray -t varcfg < ${config}
		if (( "${time}" > "${timeseed[14]}" )); then
			if (( "${varcfg[0]}" != "${timeseed[15]}" )); then
				echo ${timeseed[15]} > ${config}
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
				#echo "${default}" #debug_line_can_be_removed!
				for index2 in ${!cfgxml[@]}; do
					xfconf-query -c xfce4-desktop -p "${cfgxml[$index2]}" -s "${default}"
				done
			fi
		fi

		#echo "${timeseed[0]} | ${time} | ${varcfg[0]} | ${timeseed[14]} | ${default}" #debug_line_can_be_removed!
		sleep 10
	done
fi
