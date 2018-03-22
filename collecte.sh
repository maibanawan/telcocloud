#!/bin/bash -ex
echo timesatmp,temperature,power1,power2,total_power >> collected000.csv
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
echo $time,$temp,$power1,$power2,$total_power >> collected000.csv
awk -F"," '{printf "%-35s %-20s %-20s %-20s %-20s\n",$1,$2,$3,$4,$5}' collected000.csv >> collected1000.csv
