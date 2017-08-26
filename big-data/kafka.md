# TODO

* Example C# client which reads / writes from / to a kafka server.

* Why not abstract away Kafka?

  * Each publish to a topic invokes 0-n HTTP services with a `POST` json payload.

  * Advantages
    * No TCP connections or persistent processes running to listen to each topic.
    * Language agnostic. No java needed or knowledge of kafka streams at all.
    * No "plug in" needed. Only an API. Many plugins end up invoking APIs. Having a plugin for each topic listener is a lot of copy / paste code.

* Kafka streams

# Zookeeper

ZooKeeper provides coordination services for distributed applications.

ZooKeeper was written by Yahoo! Research.


## Design goals

* Simple. All services are stored in a hierarchical DB, in memory (for speed).
* Replicated.
  * ZooKeeper is is replicated over a set of hosts called an ensemble.
  * Clients connect to a ZooKeeper server instance. If the TCP connection drops, is connects to a different instance.

## Data Model / Hierarchical Namespaces

Each node in the ZooKeeper namespace can have data associated with it as well as children. Each node is called a znode to make it clear the node is a "ZooKeeper Node".

Each node has an ACL associated with it to provide security / access permissions.

Clients can "watch" a znode and be notified when data changes.

All write requests from clients are forwarded to a single server called the `leader`. The leader updates `follower` servers. If `leader` dies, a `follower` is promoted to the `leader`. The messaging layer takes care of replacing leaders on sync failures.


```
/
  /app1
    /app1/p_1
    /app1/p_2
  /app2
    /app2/p_1
    /app2/p_2
```

# Kafka

## Introduction

Kafka is a distributed streaming platform. Kafka stores streams of records, called topics, in a fault tolerant, scalable way (using partitions). Clients can read historical records as well as stream events in real time.

Kafka is superior to traditional messaging systems in that:

* Like with queues, messages can be stored and delivered to 1 of N clients.
* Like with pub/sub systems, messages can be broadcasted to multiple subscribers.

Kafka improves on the queuing and pub/sub systems by allowing messages to be delivered to 1 of N clients, but also broadcasted to many clients.

* Topic. A stream of records.
* Record. A key, a value, and a timestamp.

## Core APIs

* Producer API. Write records to topics.
* Consumer API. Read records from topics.
* Streams API. Consumes input from one or more topics. Optionally transforms data, and writes to one or more output topics.
* Connector API. Infrastructure for building / running reusable producers or consumers that connect topics to existing systems. For example, a Postgres connector which captures every change to a DB.


## Topics and Logs

Each topic is partitioned. Each partition is an immutable series of records which is appended to (a structured commit log). Each partition is replicated across a configurable number of servers for fault tolerance. Partitions can be

Each topic has a retention period.

Each consumer can reset to an older offset, or the beginning of a topic, and start processing from there. This allows services to be offline and "catch up" after they resume. Or replay payloads.

Producers determine which partition to write to.

Consumers are put into "groups". A record is sent to only one consumer in a group, typically in a round-robin fashion. This allows you to scale out consumers.


### Kafka strengths as a messaging system.

* With message queuing, each message is given to a single subscriber.
* With pub/sub, each message goes to *all* subscribers.

Kafka's consumer groups allows you to divide up processing over a collection of processes (members of the consumer group). As with pub/sub, Kafka broadcasts messages to multiple consumers.

### Kafka as a storage system

Because kafka stores data on disk efficiently, it can be viewed as log storage system.

### Kafka as a streaming system

Stream processing applications can read from a kafka topic, transform each message, and write to an output stream topic. This is done using the `Streams API`.


### Kafka summary

By providing historical data storage and real time stream processing, Kafka clients can treat both data types the same way. Clients can read historical data, then switch over to streaming when it has processed all historical data.

-----

# Kafka Commands

```

# Start zookeeper
$ zkServer start

# Start kafka
$ kafka-server-start /usr/local/etc/kafka/server.properties

# List topics
$ kafka-topics --list --zookeeper localhost:2181

# Create a topic
$ kafka-topics --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test

# Start a console producer
$ kafka-console-producer --broker-list localhost:9092 --topic test

# Start a console consumer
$ kafka-console-consumer --broker-list localhost:9092 --topic test


```
