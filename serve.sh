#!/bin/bash

#geting names of instances to delete
openstack server list | awk '{print $4}' | grep -v ^N | grep -v ^$ | paste -sd ","> list.csv
x=$(cat list.csv | awk '{print $1}')
lenx=${#x}
y=$(calc $lenx+1)
num_vms=$(calc $y/5)
echo $num_vms
Num=$num_vms
for i in in $(seq 1 $Num);
do 
#select name of vm randomly
vm=$(( 1 + $RANDOM % $num_vms ))
echo $vm
start=$(calc $(calc $vm-1)*5)
echo $start
vm_name=${x:start:4}
openstack server delete $vm_name

openstack server list | awk '{print $4}' | grep -v ^N | grep -v ^$ | paste -sd ","> list.csv
x=$(cat list.csv | awk '{print $1}')
lenx=${#x}
y=$(calc $lenx+1)
num_vms=$(calc $y/5)
echo $num_vms
done
