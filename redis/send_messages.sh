#! /bin/bash

let i=0;
while true
do
    let i++;
    now="$(date +%T)"
    docker exec redis-source redis-cli "xadd" "mystream" "*" "message #$i" "time $now"
    sleep 2
done

