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
 if (( $utilization > $up_threshold ))
 then
  for j in $(seq 1 4)
  do
   index=$(( 5 - $j ))
   if (( $current_f == ${available_f[$index]} ))
   then
    next_index=$(( index - 1 ))
    next_freq=${available_f[$next_index]}
   fi
  done
  sudo sh -c "echo -n "userspace" > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_governor"
  sudo sh -c "echo -n  $next_freq > /sys/devices/system/cpu/cpuX/cpufreq/scaling_setspeed"
  echo $current_f $next_freq
 elif (( $utilization < $down_threshold ))
 then   
  for j in $(seq 1 3)
  do
   index=$j
   if (( $current_f == ${available_f[$index]} ))
   then
    next_index=$(( index + 1 ))
    next_freq=${available_f[$next_index]}
   elif (( $current_f == $fmax ))
   then
    next_freq=${available_f[1]}
   fi
  done
  sudo sh -c "echo -n "userspace" > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_governor"
  sudo sh -c "echo -n  $next_freq > /sys/devices/system/cpu/cpuX/cpufreq/scaling_setspeed"
  echo $current_f $next_freq
 fi
 done
#done
