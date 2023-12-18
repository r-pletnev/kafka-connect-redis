# Testing kafka-connect-redis plugin on unstable connection

## Goal

The main task is to verify how the combination of Redis and Kafka clusters will work under the conditions of an unstable internet connection, as well as when operating through a VPN (assuming the presence of a working VPN service).

The project consists of the following folders:

- `redis`: contains a Docker Compose file that describes the Redis server, as well as auxiliary scripts for working with it.

- `kafka`: contains a Docker Compose file that describes the Kafka cluster and all auxiliary services and scripts for working with it.
