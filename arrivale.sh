#!/bin/env bash

end=$((SECONDS+3))

while [ $SECONDS -lt $end ]; do
   echo $SECONDS
done
