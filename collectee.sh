#!/bin/bash -ex
echo timestamp,temperature,power1,power2,total_power,cpu0_u,cpu0_f,cpu1_u,cpu1_f,cpu2_u,cpu2_f,cpu3_u,cpu3_f,cpu4_u,cpu4_f,cpu5_u,cpu5_f,cpu6_u,cpu6_f,cpu7_u,cpu7_f,cpu8_u,cpu8_f,cpu9_u,cpu9_f,cpu10_u,cpu10_f,cpu11_u,cpu11_f >> collected000.csv
while true
do 
   export x=$(sudo eri-ipmitool rns 0)
   time=${x:54:24}
   temp=${x:170:8}
   export x=$(sudo eri-ipmitool rns 4)
   volt1=${x:170:8}
   export x=$(sudo eri-ipmitool rns 5)
   volt2=${x:170:8}
   export x=$(sudo eri-ipmitool rns 68)
   crt1=${x:170:8}
   export x=$(sudo eri-ipmitool rns 69)
   crt2=${x:170:8}
   power1=$(calc $volt1*$crt1)
   power2=$(calc $volt2*$crt2)
   total_power=$(calc $power1+$power2)
   export f0=$(cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq)
   export f1=$(cat /sys/devices/system/cpu/cpu1/cpufreq/cpuinfo_cur_freq)
   export f2=$(cat /sys/devices/system/cpu/cpu2/cpufreq/cpuinfo_cur_freq)
   export f3=$(cat /sys/devices/system/cpu/cpu3/cpufreq/cpuinfo_cur_freq)
   export f4=$(cat /sys/devices/system/cpu/cpu4/cpufreq/cpuinfo_cur_freq)
   export f5=$(cat /sys/devices/system/cpu/cpu5/cpufreq/cpuinfo_cur_freq)
   export f6=$(cat /sys/devices/system/cpu/cpu6/cpufreq/cpuinfo_cur_freq)
   export f7=$(cat /sys/devices/system/cpu/cpu7/cpufreq/cpuinfo_cur_freq)
   export f8=$(cat /sys/devices/system/cpu/cpu8/cpufreq/cpuinfo_cur_freq)
   export f9=$(cat /sys/devices/system/cpu/cpu9/cpufreq/cpuinfo_cur_freq)
   export f10=$(cat /sys/devices/system/cpu/cpu10/cpufreq/cpuinfo_cur_freq)
   export f11=$(cat /sys/devices/system/cpu/cpu11/cpufreq/cpuinfo_cur_freq)
   export x=$(mpstat -P 0)
   export i0=${x:251:5}
   export x=$(mpstat -P 1)
   export i1=${x:251:5}
   export x=$(mpstat -P 2)
   export i2=${x:251:5}
   export x=$(mpstat -P 3)
   export i3=${x:251:5}
   export x=$(mpstat -P 4)
   export i4=${x:251:5}
   export x=$(mpstat -P 5)
   export i5=${x:251:5}
   export x=$(mpstat -P 6)
   export i6=${x:251:5}
   export x=$(mpstat -P 7)
   export i7=${x:251:5}
   export x=$(mpstat -P 8)
   export i8=${x:251:5}
   export x=$(mpstat -P 9)
   export i9=${x:251:5}
   export x=$(mpstat -P 10)
   export i10=${x:251:5}
   export x=$(mpstat -P 11)
   export i11=${x:251:5} 
   u0=$(calc 100 - $i0)
   u1=$(calc 100 - $i1)
   u2=$(calc 100 - $i2)
   u3=$(calc 100 - $i3)
   u4=$(calc 100 - $i4)
   u5=$(calc 100 - $i5)
   u6=$(calc 100 - $i6)
   u7=$(calc 100 - $i7)
   u8=$(calc 100 - $i8)
   u9=$(calc 100 - $i9)
   u10=$(calc 100 - $i10)
   u11=$(calc 100 - $i11)
   echo $time,$temp,$power1,$power2,$total_power,$u0,$f0,$u1,$f1,$u2,$f2,$u3,$f3,$u4,$f4,$u5,$f5,$u6,$f6,$u7,$f7,$u8,$f8,$u9,$f9,$u10,$f10,$u11,$f11 >> collected000.csv
   awk -F"," '{printf "%-30s %-20s %-20s %-20s %-20s %-20s %-20s %-20s %-20s %-20s %-20s %-20s %-20s %-20s %-20s %-20s %-20s %-20s %-20s %-20s %-20s %-20s %-20s %-20s %-20s %-20s %-20s %-20s %-20s \n",$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29}' collected000.csv > collected1000.csv     
   sleep 1
   
done
