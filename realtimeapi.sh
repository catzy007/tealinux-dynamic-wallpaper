#!/bin/bash
##API FROM https://aladhan.com/prayer-times-api#GetTimingsByCity
Kota=Jakarta #A city name. Example: London
Negara=Indonesia #A country name or 2 character alpha ISO 3166 code. Examples: GB or United Kindom
declare -a timeseed

mapfile -t timeapi < <(curl -s "http://api.aladhan.com/v1/timingsByCity?city=${Kota}&country=${Negara}&method=8" | jq --raw-output '.data.timings.Fajr, .data.timings.Sunrise, .data.timings.Dhuhr, .data.timings.Asr, .data.timings.Maghrib, .data.timings.Isha, .data.timings.Imsak, .data.timings.Midnight')
for index in ${!timeapi[@]}; do
	echo ${index} ${timeapi[$index]}
done

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

echo $seed1
echo $seed2
for index in ${!timeseed[@]}; do
	echo ${index} ${timeseed[$index]}
done
