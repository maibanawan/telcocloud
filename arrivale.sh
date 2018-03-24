#!/bin/env bash

end=$((SECONDS+5m))

while [ $SECONDS -lt $end ]; do
   interval=$(( 1 + $RANDOM % 5 ))
   interval_sec=$(calc $interval*60)
   source createe.sh
   sleep $interval_sec
done
