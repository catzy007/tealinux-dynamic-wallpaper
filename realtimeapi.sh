#!/bin/bash

apiconfig=~/.config/apitime-dynamic-wallpaper.cfg
locationconfig=~/.config/location-dynamic-wallpaper.cfg
activelocation=~/.config/active-dynamic-wallpaper.cfg
Kota=Semarang
Negara=ID

#set initial value for first time user
if [ ! -f "${apiconfig}" ]; then
	echo 276 > "${apiconfig}"
	echo 353 >> "${apiconfig}"
	echo 424 >> "${apiconfig}"
	echo 495 >> "${apiconfig}"
	echo 566 >> "${apiconfig}"
	echo 637 >> "${apiconfig}"
	echo 710 >> "${apiconfig}"
	echo 750 >> "${apiconfig}"
	echo 790 >> "${apiconfig}"
	echo 830 >> "${apiconfig}"
	echo 870 >> "${apiconfig}"
	echo 912 >> "${apiconfig}"
	echo 1067 >> "${apiconfig}"
	echo 1157 >> "${apiconfig}"
	echo 1430 >> "${apiconfig}"
	echo 266 >> "${apiconfig}"
fi
if [ ! -f "${activelocation}" ]; then
	echo ${Kota} > "${locationconfig}"
	echo ${Negara} >> "${locationconfig}"
fi

#get location config from file
if [ ! -f "${locationconfig}" ]; then
	echo "Configured location data not found! Continue using default config City=${Kota} Country=${Negara}"
else
	readarray -t location < ${locationconfig}
	if [ "$(curl -s "http://api.aladhan.com/v1/timingsByCity?city=${location[0]}&country=${location[1]}&method=8" | jq --raw-output '.status')" == "OK" ]; then
		Kota=${location[0]}
		Negara=${location[1]}
		echo ${Kota} > "${activelocation}"
		echo ${Negara} >> "${activelocation}"
		echo "Location data valid! Using current location data City=${Kota} Country=${Negara}"
	else
		readarray -t location < ${activelocation}
		Kota=${location[0]}
		Negara=${location[1]}
		echo "Configured location data invalid! Continue using previous configuration City=${Kota} Country=${Negara}"
	fi
fi

#API FROM https://aladhan.com/prayer-times-api#GetTimingsByCity
if [ "$(curl -s "http://api.aladhan.com/v1/timingsByCity?city=${Kota}&country=${Negara}&method=8" | jq --raw-output '.status')" == "OK" ]; then
	#get time from API	
	mapfile -t apiseed < <(curl -s "http://api.aladhan.com/v1/timingsByCity?city=${Kota}&country=${Negara}&method=8" | jq --raw-output '.data.timings.Fajr, .data.timings.Sunrise, .data.timings.Dhuhr, .data.timings.Asr, .data.timings.Maghrib, .data.timings.Isha, .data.timings.Midnight, .data.timings.Imsak')
	#API FROM https://aladhan.com/prayer-times-api#GetTimingsByCity

	#set time according to API
	seed1=$(( $(( $(( $((10#$(echo "${apiseed[2]}" | cut -d':' -f 1)*60)) + 10#$(echo "${apiseed[2]}" | cut -d':' -f 2) )) - $(( $((10#$(echo "${apiseed[1]}" | cut -d':' -f 1)*60)) + 10#$(echo "${apiseed[1]}" | cut -d':' -f 2) )) )) / 5 ))
	seed2=$(( $(( $(( $((10#$(echo "${apiseed[3]}" | cut -d':' -f 1)*60)) + 10#$(echo "${apiseed[3]}" | cut -d':' -f 2) )) - $(( $((10#$(echo "${apiseed[2]}" | cut -d':' -f 1)*60)) + 10#$(echo "${apiseed[2]}" | cut -d':' -f 2) )) )) / 5 ))
	apitime[0]=$(( $((10#$(echo "${apiseed[0]}" | cut -d':' -f 1)*60)) + 10#$(echo "${apiseed[0]}" | cut -d':' -f 2) ))
	apitime[1]=$(( $((10#$(echo "${apiseed[1]}" | cut -d':' -f 1)*60)) + 10#$(echo "${apiseed[1]}" | cut -d':' -f 2) ))
	apitime[2]=$(( ${apitime[1]} + seed1 ))
	apitime[3]=$(( ${apitime[2]} + seed1 ))
	apitime[4]=$(( ${apitime[3]} + seed1 ))
	apitime[5]=$(( ${apitime[4]} + seed1 ))
	apitime[6]=$(( $((10#$(echo "${apiseed[2]}" | cut -d':' -f 1)*60)) + 10#$(echo "${apiseed[2]}" | cut -d':' -f 2) ))
	apitime[7]=$(( ${apitime[6]} + seed2 ))
	apitime[8]=$(( ${apitime[7]} + seed2 ))
	apitime[9]=$(( ${apitime[8]} + seed2 ))
	apitime[10]=$(( ${apitime[9]} + seed2 ))
	apitime[11]=$(( $((10#$(echo "${apiseed[3]}" | cut -d':' -f 1)*60)) + 10#$(echo "${apiseed[3]}" | cut -d':' -f 2) ))
	apitime[12]=$(( $((10#$(echo "${apiseed[4]}" | cut -d':' -f 1)*60)) + 10#$(echo "${apiseed[4]}" | cut -d':' -f 2) ))
	apitime[13]=$(( $((10#$(echo "${apiseed[5]}" | cut -d':' -f 1)*60)) + 10#$(echo "${apiseed[5]}" | cut -d':' -f 2) ))
	apitime[14]=$(( $((10#$(echo "${apiseed[6]}" | cut -d':' -f 1)*60)) + 10#$(echo "${apiseed[6]}" | cut -d':' -f 2) ))
	apitime[15]=$(( $((10#$(echo "${apiseed[7]}" | cut -d':' -f 1)*60)) + 10#$(echo "${apiseed[7]}" | cut -d':' -f 2) ))

	for index in ${!apitime[@]}; do
		if [ "${index}" == "0" ]; then
			echo ${apitime[$index]} > "${apiconfig}"
		else
			echo ${apitime[$index]} >> "${apiconfig}"
		fi
	done
	echo "Get new data from API"
	#for index in ${!apiseed[@]}; do echo ${apiseed[$index]}; done #debug_line_can_be_removed!
	#for index in ${!apitime[@]}; do echo ${apitime[$index]}; done #debug_line_can_be_removed!
else
	echo "Cannot get data from API, are you online?"
fi
