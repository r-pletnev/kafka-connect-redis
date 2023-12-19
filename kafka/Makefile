.PHONY: zookeeper
zookeeper:
	docker exec -it zookeeper /bin/bash

.PHONY: kafka
kafka:
	docker exec -it kafka /bin/bash

.PHONY: list-connectors
list-connectors:
	curl -X GET http://localhost:8083/connectors


# TODO: Don't forget to add Redis Server ip address as argument of ./run.sh
.PHONY: start
start:
	bash ./run.sh 

.PHONY: get-topic
get-topic:
	bash ./get_topic.sh
