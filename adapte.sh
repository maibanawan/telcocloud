#!/bin/env bash
up_threshold=80
down_threshold=20
fmax=1996000
export available_f=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies)
#while true
#do
 for i in $(seq 1 11);
 do
 #export available_f=$(cat /sys/devices/system/cpu/cpu$i/cpufreq/scaling_available_frequencies)
 export current_f=$(cat /sys/devices/system/cpu/cpu$i/cpufreq/cpuinfo_cur_freq)
 export x=$(mpstat -P $i | awk '{print $13}')
 export idle=${x:8:5}
 export utilization=$(calc 100 - $idle)
 echo $utilization
 done
#done
