#!/bin/env bash

end=$((SECONDS+300))
count=1
while [ $SECONDS -lt $end ]; do
   interval=$(( 3 + $RANDOM % 3 ))
   echo $interval
   interval_sec=$(calc $interval*60)
   source createe.sh
   #sleep $interval_sec
   c=$(( $count + 1 ))
   count=$c 
done
