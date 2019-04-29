#!/bin/bash

apiconfig=~/.config/apitime-dynamic-wallpaper.cfg
Kota=Semarang #A city name. Example: London
Negara=Indonesia #A country name or 2 character alpha ISO 3166 code. Examples: GB or United Kindom

##API FROM https://aladhan.com/prayer-times-api#GetTimingsByCity
rm -f "${apiconfig}"
if [ "$(curl -s "http://api.aladhan.com/v1/timingsByCity?city=Semarang&country=ID&method=8" | jq --raw-output '.status')" == "OK" ]; then
	#get time from API	
	mapfile -t apiseed < <(curl -s "http://api.aladhan.com/v1/timingsByCity?city=${Kota}&country=${Negara}&method=8" | jq --raw-output '.data.timings.Fajr, .data.timings.Sunrise, .data.timings.Dhuhr, .data.timings.Asr, .data.timings.Maghrib, .data.timings.Isha, .data.timings.Imsak, .data.timings.Midnight')
	#API FROM https://aladhan.com/prayer-times-api#GetTimingsByCity

	#set time according to API
	seed1=$(( $(( $(( $(($(echo "${apiseed[2]}" | cut -d':' -f 1)*60)) + $(echo "${apiseed[2]}" | cut -d':' -f 2) )) - $(( $(($(echo "${apiseed[1]}" | cut -d':' -f 1)*60)) + $(echo "${apiseed[1]}" | cut -d':' -f 2) )) )) / 5 ))
	seed2=$(( $(( $(( $(($(echo "${apiseed[3]}" | cut -d':' -f 1)*60)) + $(echo "${apiseed[3]}" | cut -d':' -f 2) )) - $(( $(($(echo "${apiseed[2]}" | cut -d':' -f 1)*60)) + $(echo "${apiseed[2]}" | cut -d':' -f 2) )) )) / 5 ))
	apitime[0]=$(( $(($(echo "${apiseed[0]}" | cut -d':' -f 1)*60)) + $(echo "${apiseed[0]}" | cut -d':' -f 2) ))
	apitime[1]=$(( $(($(echo "${apiseed[1]}" | cut -d':' -f 1)*60)) + $(echo "${apiseed[1]}" | cut -d':' -f 2) ))
	apitime[2]=$(( ${apitime[1]} + seed1 ))
	apitime[3]=$(( ${apitime[2]} + seed1 ))
	apitime[4]=$(( ${apitime[3]} + seed1 ))
	apitime[5]=$(( ${apitime[4]} + seed1 ))
	apitime[6]=$(( $(($(echo "${apiseed[2]}" | cut -d':' -f 1)*60)) + $(echo "${apiseed[2]}" | cut -d':' -f 2) ))
	apitime[7]=$(( ${apitime[6]} + seed2 ))
	apitime[8]=$(( ${apitime[7]} + seed2 ))
	apitime[9]=$(( ${apitime[8]} + seed2 ))
	apitime[10]=$(( ${apitime[9]} + seed2 ))
	apitime[11]=$(( $(($(echo "${apiseed[3]}" | cut -d':' -f 1)*60)) + $(echo "${apiseed[3]}" | cut -d':' -f 2) ))
	apitime[12]=$(( $(($(echo "${apiseed[4]}" | cut -d':' -f 1)*60)) + $(echo "${apiseed[4]}" | cut -d':' -f 2) ))
	apitime[13]=$(( $(($(echo "${apiseed[5]}" | cut -d':' -f 1)*60)) + $(echo "${apiseed[5]}" | cut -d':' -f 2) ))
	apitime[14]=$(( $(($(echo "${apiseed[7]}" | cut -d':' -f 1)*60)) + $(echo "${apiseed[7]}" | cut -d':' -f 2) ))
	apitime[15]=$(( $(($(echo "${apiseed[6]}" | cut -d':' -f 1)*60)) + $(echo "${apiseed[6]}" | cut -d':' -f 2) ))

	for index in ${!apitime[@]}; do
		if [ "${index}" == "0" ]; then
			echo ${apitime[$index]} > "${apiconfig}"
		else
			echo ${apitime[$index]} >> "${apiconfig}"
		fi
	done
	echo "Get new data from API"
else
	echo "Cannot get data from API, are you online?"
fi