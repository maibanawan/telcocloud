#!/bin/env bash
up_threshold=80
down_threshold=40

fmax=1996000
export available_f=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies)
while true
do
 for i in $(seq 0 11);
 do
 #export available_f=$(cat /sys/devices/system/cpu/cpu$i/cpufreq/scaling_available_frequencies)
 export current_f=$(cat /sys/devices/system/cpu/cpu$i/cpufreq/cpuinfo_cur_freq)
 export x=$(mpstat -P $i | awk '{print $13}')
 export idle=${x:8:2}
 export utilization=$(calc 100 - $idle)
 echo $utilization
 if (( $utilization > $up_threshold ))
 then
  if (( $current_f == 1596000 ))
  then
   next_freq=1729000
  elif (( $current_f == 1729000 )) 
  then
   next_freq=1862000
  elif (( $current_f == 1862000 )) 
  then
   next_freq=1995000 
  elif (( $current_f == 1995000 )) 
  then
   next_freq=1996000 
  fi
  sudo sh -c "echo -n "userspace" > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_governor"
  sudo sh -c "echo -n  $next_freq > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_setspeed"
  echo $current_f $next_freq
 elif (( $utilization < $down_threshold ))
 then   
  if (( $current_f == 1996000 ))
  then
   next_freq=1995000
  elif (( $current_f == 1995000 )) 
  then
   next_freq=1862000
  elif (( $current_f == 1862000 )) 
  then
   next_freq=1729000 
  elif (( $current_f == 1729000 )) 
  then
   next_freq=1596000 
  fi
  sudo sh -c "echo -n "userspace" > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_governor"
  sudo sh -c "echo -n  $next_freq > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_setspeed"
  echo $current_f $next_freq
 fi
 done
done
