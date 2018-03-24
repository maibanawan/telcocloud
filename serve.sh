#!/bin/bash

#geting names of instances to delete
openstack server list | awk '{print $4}' | grep -v ^N | grep -v ^$ | paste -sd ","> list.csv
x=$(cat list.csv | awk '{print $1}')
lenx=${#x}
y=$(calc $lenx+1)
num_vms=$(calc $y/5)
echo $num_vms

#select name of vm randomly
vm=$(( 1 + $RANDOM % $num_vms ))
start=$(calc $(calc $vm-1)*5)
vm_name=${x:start:4}
openstack server delete $vm_name

