#!/bin/bash

#geting names of instances to delete
openstack server list | awk '{print $4}' | grep -v ^N | grep -v ^$ | paste -sd ","> list.csv
x=$(cat list.csv | awk '{print $1}')
lenx=${#x}
y=$(calc $lenx+1)
num_vms=$(calc $y/7)
echo $num_vms
Num=$num_vms
total_running_time=0
for i in in $(seq 1 $Num);
do 
#select name of vm randomly
vm=$(( 1 + $RANDOM % $num_vms ))
echo $vm
start=$(calc $(calc $vm-1)*7)
echo $start
vm_name=${x:start:6}
running_time=$(( 1 + $RANDOM % 3 ))
echo $running_time
running_time_sec=$(( $running_time * 60 )) 
sleep $running_time_sec
openstack server delete $vm_name
openstack server list | awk '{print $4}' | grep -v ^N | grep -v ^$ | paste -sd ","> list.csv
x=$(cat list.csv | awk '{print $1}')
lenx=${#x}
y=$(calc $lenx+1)
num_vms=$(calc $y/7)
echo $num_vms
total_running_time=$(( $total_running_time + $running_time ))
done
echo total_running_time $total_running_time
