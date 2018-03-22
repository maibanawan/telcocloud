#!/bin/bash -ex
printf timesatmp,temperature,power1,power2,total_power >> collected.csv
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
total_power==$(calc $power1+$power2)
printf $time,$temp,$power1,$power2,$total_power >> collected.csv
