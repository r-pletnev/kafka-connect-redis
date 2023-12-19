# Testing kafka-connect-redis plugin on unstable connection

## Goal

The main task is to verify how the combination of Redis and Kafka clusters will work under the conditions of an unstable internet connection, as well as when operating through a VPN (assuming the presence of a working VPN service).

The project consists of the following folders:

- `redis`: contains a Docker Compose file that describes the Redis server, as well as auxiliary scripts for working with it.

- `kafka`: contains a Docker Compose file that describes the Kafka cluster and all auxiliary services and scripts for working with it.

## Kafka

To start the kafka cluster, follow these steps:

- Navigate to the `kafka` directory.
- Edit the Makefile and add the address of the Redis server.
- Run the command make start.

After starting the cluster, in a new terminal, execute the command `make get-topic` to check for the presence of new messages.

## Redis

To start the redis server, follow these steps:

- Navigate to the `redis` directory.
- Run the command `make start`. This command will start the Redis server on `0.0.0.0:6379`.
- Run the command `make send-messages`. This command initiates the sending of messages to the `mystream` stream.

After running this command, checking for the presence of new messages in the Kafka topic can be done using the command `make get-topic` or by opening a browser at http://localhost:9092.
