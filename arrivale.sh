#!/bin/env bash

end=$((SECONDS+300))
count=1
while [ $SECONDS -lt $end ]; do
   interval=$(( 1 + $RANDOM % 5 ))
   echo $interval
   interval_sec=$(calc $interval*60)
   source createe.sh
   sleep $interval_sec
   count=$(calc $count+1)
done
