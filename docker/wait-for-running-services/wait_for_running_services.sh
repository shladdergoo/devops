#!/bin/bash

set -e
set -x

sleep $2

runningcount=0
servicecount=$(docker stack ps -q -f "desired-state=running" $1 | wc -l)

while [ $runningcount -lt $servicecount ]
do
    runningcount=$(docker stack ps -q -f "desired-state=running" $1 | xargs docker inspect --format='{{.Status.State}}' | grep running | wc -l)
    echo $runningcount "/" $servicecount "running services. waiting..."
    sleep $2
    servicecount=$(docker stack ps -q -f "desired-state=running" $1 | wc -l)
done
