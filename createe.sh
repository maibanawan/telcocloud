#!/bin/env bash
N=$(( 1 + $RANDOM % 4 ))
echo $N
for i in $(seq 1 $N);
do 
echo vm-$count-$i
openstack server create --nic net-id=a9d9c7ec-b335-485c-8b3a-a68ee9079537 --flavor tempest2 --image 75d4f34f-ee34-4cd2-815b-c835b0132ae3 vm-$count-$i
done
