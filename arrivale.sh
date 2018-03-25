#!/bin/env bash

end=$((SECONDS+300))
count=1
total_time=0
total_vms=0
while [ $SECONDS -lt $end ]; do
   interval=$(( 3 + $RANDOM % 3 ))
   echo $interval
   interval_sec=$(calc $interval*60)
   source createe.sh
   #sleep $interval_sec
   c=$(( $count + 1 ))
   count=$c 
   total_time=$(( $total_time + $interval ))
   total_vms=$(( $total_vms + $N ))
done
echo total_time $total_time
echo total_vms $total_vms
