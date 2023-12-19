
.PHONY: redis-cli
redis-cli:
	docker exec -it redis-source redis-cli

.PHONY: monitor
monitor:
	docker exec -it redis-source redis-cli MONITOR

.PHONY: send-messages
send-messages:
	bash ./send_messages.sh

.PHONY: start
start:
	docker compose up -d
