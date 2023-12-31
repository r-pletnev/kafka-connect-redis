#!/bin/bash

set -e
(
if lsof -Pi :6379 -sTCP:LISTEN -t >/dev/null ; then
    echo "Please terminate the local redis-server on 6379"
    exit 1
fi
)

if [ $# -lt 1 ]; then
    echo "Usage: $0 <redis server ip address>"
    exit 1
fi

redisHost="$1"

echo "Starting docker"
docker compose up -d

function clean_up {
    echo -e "\n\nSHUTTING DOWN\n\n"
    curl --output /dev/null -X DELETE http://localhost:8083/connectors/datagen-pageviews || true
    curl --output /dev/null -X DELETE http://localhost:8083/connectors/redis-sink || true
    curl --output /dev/null -X DELETE http://localhost:8083/connectors/redis-source || true
    docker compose down
    if [ -z "$1" ]
    then
      echo -e "Bye!\n"
    else
      echo -e "$1"
    fi
}

sleep 5
echo -ne "\n\nWaiting for the systems to be ready.."
function test_systems_available {
  COUNTER=0
  until $(curl --output /dev/null --silent --head --fail http://localhost:$1); do
      printf '.'
      sleep 10
      (( COUNTER+=1 ))
      if [[ $COUNTER -gt 50 ]]; then
        MSG="\nWARNING: Could not reach configured kafka system on http://localhost:$1 \nNote: This script requires curl.\n"

          if [[ "$OSTYPE" == "darwin"* ]]; then
            MSG+="\nIf using OSX please try reconfiguring Docker and increasing RAM and CPU. Then restart and try again.\n\n"
          fi

        echo -e "$MSG"
        clean_up "$MSG"
        exit 1
      fi
  done
}

test_systems_available 8082
test_systems_available 8083

trap clean_up EXIT

echo -e "\nKafka Topics:"
curl -X GET "http://localhost:8082/topics" -w "\n"

echo -e "\nKafka Connectors:"
curl -X GET "http://localhost:8083/connectors/" -w "\n"

sleep 7

sleep 2
echo -e "\nAdding Redis Kafka Source Connector for the 'mystream' stream:"

jsonString=$(cat <<EOF
{
  "name": "redis-source",
  "config": {
    "tasks.max": "1",
    "connector.class": "com.redis.kafka.connect.RedisStreamSourceConnector",
    "redis.uri": "redis://$redisHost:6379",
    "redis.insecure": true,
    "redis.stream.name": "mystream",
    "topic": "mystream"
  }
}
EOF
)



curl -X POST -H "Content-Type: application/json" --data "$jsonString" http://localhost:8083/connectors -w "\n"


sleep 2
echo -e "\nKafka Connectors: \n"
curl -X GET "http://localhost:8083/connectors/" -w "\n"

echo -e '''


==============================================================================================================
Examine the topics in the Kafka UI: http://localhost:9021 or http://localhost:8000/
  - The `pageviews` topic should have the generated page views.
  - The `mystream` topic should contain the Redis stream messages.
The `pageviews` stream in Redis should contain the sunk page views: redis-cli xlen pageviews

Examine the Redis database:
  - In your shell run: docker compose exec redis /opt/redis-stack/bin/redis-cli
  - List some RedisJSON keys: SCAN 0 TYPE ReJSON-RL
  - Show the JSON value of a given key: JSON.GET pageviews:971
==============================================================================================================

Use <ctrl>-c to quit'''

read -r -d '' _ </dev/tty
