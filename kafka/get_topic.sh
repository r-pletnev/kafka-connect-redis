#!/bin/bash 
#
#

docker compose exec broker /bin/kafka-console-consumer --bootstrap-server localhost:9092 --topic mystream --from-beginning --max-messages 10 --timeout-ms 10000
