#!/bin/bash
#some variables
time=0
wppath="$(pwd)/mojave"
declare -a timeseed
config=~/.config/tea-dynamic-wallpaper.cfg
mapfile -t images < <(ls ${wppath} -v | grep -e jpg -e jpeg -e png)
mapfile -t cfgxml < <(xfconf-query -c xfce4-desktop -l | grep "last-image$")

#get time from API
Kota=Jakarta #A city name. Example: London
Negara=Indonesia #A country name or 2 character alpha ISO 3166 code. Examples: GB or United Kindom
mapfile -t timeapi < <(curl -s "http://api.aladhan.com/v1/timingsByCity?city=${Kota}&country=${Negara}&method=8" | jq --raw-output '.data.timings.Fajr, .data.timings.Sunrise, .data.timings.Dhuhr, .data.timings.Asr, .data.timings.Maghrib, .data.timings.Isha, .data.timings.Imsak, .data.timings.Midnight')
#API FROM https://aladhan.com/prayer-times-api#GetTimingsByCity

#set initial config
echo 0 > ${config}
seed1=$(( $(( $(( $(($(echo "${timeapi[2]}" | cut -d':' -f 1)*60)) + $(echo "${timeapi[2]}" | cut -d':' -f 2) )) - $(( $(($(echo "${timeapi[1]}" | cut -d':' -f 1)*60)) + $(echo "${timeapi[1]}" | cut -d':' -f 2) )) )) / 5 ))
seed2=$(( $(( $(( $(($(echo "${timeapi[3]}" | cut -d':' -f 1)*60)) + $(echo "${timeapi[3]}" | cut -d':' -f 2) )) - $(( $(($(echo "${timeapi[2]}" | cut -d':' -f 1)*60)) + $(echo "${timeapi[2]}" | cut -d':' -f 2) )) )) / 5 ))
timeseed[0]=$(( $(($(echo "${timeapi[0]}" | cut -d':' -f 1)*60)) + $(echo "${timeapi[0]}" | cut -d':' -f 2) ))
timeseed[1]=$(( $(($(echo "${timeapi[1]}" | cut -d':' -f 1)*60)) + $(echo "${timeapi[1]}" | cut -d':' -f 2) ))
timeseed[2]=$(( ${timeseed[1]} + seed1 ))
timeseed[3]=$(( ${timeseed[2]} + seed1 ))
timeseed[4]=$(( ${timeseed[3]} + seed1 ))
timeseed[5]=$(( ${timeseed[4]} + seed1 ))
timeseed[6]=$(( $(($(echo "${timeapi[2]}" | cut -d':' -f 1)*60)) + $(echo "${timeapi[2]}" | cut -d':' -f 2) ))
timeseed[7]=$(( ${timeseed[6]} + seed2 ))
timeseed[8]=$(( ${timeseed[7]} + seed2 ))
timeseed[9]=$(( ${timeseed[8]} + seed2 ))
timeseed[10]=$(( ${timeseed[9]} + seed2 ))
timeseed[11]=$(( $(($(echo "${timeapi[3]}" | cut -d':' -f 1)*60)) + $(echo "${timeapi[3]}" | cut -d':' -f 2) ))
timeseed[12]=$(( $(($(echo "${timeapi[4]}" | cut -d':' -f 1)*60)) + $(echo "${timeapi[4]}" | cut -d':' -f 2) ))
timeseed[13]=$(( $(($(echo "${timeapi[5]}" | cut -d':' -f 1)*60)) + $(echo "${timeapi[5]}" | cut -d':' -f 2) ))
timeseed[14]=$(( $(($(echo "${timeapi[7]}" | cut -d':' -f 1)*60)) + $(echo "${timeapi[7]}" | cut -d':' -f 2) ))
timeseed[15]=$(( $(($(echo "${timeapi[6]}" | cut -d':' -f 1)*60)) + $(echo "${timeapi[6]}" | cut -d':' -f 2) ))

#main program
while true ; do
	#get current time
	time=$(( $(($(date +"%H")*60)) + $(date +"%M") ))

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

	#echo "${timeseed[0]} | ${time} | ${varcfg[0]} | ${timeseed[14]}" #debug_line_can_be_removed!
	sleep 10
done
