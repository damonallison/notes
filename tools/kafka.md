# Kafka

## Todo

* Cluster / partition strategy.
    * Any good strategies for key partitioning? By customer identifier?

* Topic naming strategy. Any tips?

* Delivery semantics. How to guarantee once and only once delivery?
    * Better to design systems to expect "at least once" delivery (allow for duplicates?)

*

* POC
    * Write a producer and consumer.
    * Write AVRO messages.
    * How to version messages?
    * What are the failure points?


## What is kafka?

* A distributed streaming platform.

* Design motivations for Kafka.
    * High throughput to support web scale log streams.
    * Support backlogs to support ETL, bursting data in / out.
    * Low latency message delivery to replace RabbitMQ / messaging systems.
    * Streaming.
    * Fault tolerant.

## Why use kafka?

* To distribute data between systems.
* Simplify system-system communication. Avoid API callback hell.

* As a messaging system.
    * Consumers can be scaled as a group.
        * Each message is delivered once per group, not per listener.
    * Maintains an ordered historical record.
        * Ordering is lost in traditional queuing systems, as messages are delivered async to consumers.
        * Consumers can reply past messages.

* As a storage system.
    * Kafka stores records with a fast, constant performance regardless of partition size.
    * Guaranteed delivery.

* As a stream processor.
    * You can build a stream of streams to control data flow.
    * Example : use the Streams API to compute aggregations from stream activity, publishing the results to a new stream.


## Design

* Topic
    * A stream of records.

* Partition
    * Each topic is broken into 1-n partitions.
    * Each partition is ordered only within its partition.
    * Partitions provide scale out.
        * Each partition must fit on the servers that host it.
    * Partitions provide parallelism.
        * Each partition is processed by one consumer per consumer group.
    * Partitions are replicated across N servers for fault tolerance.
    * If you need total message ordering, you must only have 1 partition.
        * This will also mean only 1 consumer process per consumer group.

* Producer
    * Publish data to topics.
    * Producers determine which partition to send each record.
        * i.e., Publish to topic based on round robin, or data element within the record.
        * If data must be ordered, it must be on the same partition.

* Consumer (Groups)
    * Consumers have a `consumer group` name.
    * Multiple consumers can run within a group for scaling consumption.
    * Each record is delivered to one instance within each consumer group.
    * Each consumer is the exclusive consumer for a partition.
        * `All messages within a partition will be handled by the same consumer instance within each consumer group`.
        * Parallelism is limited to the number of partitions.
            * If you have 4 partitions, you can have 4 consumers per consumer group.
            * If you want to scale consumption, increase the number of partitions.

* Cluster
    * The top level entity of a kafka installation.
    * Each topic has a "leader" broker within a cluster.
    * The cluster manager (zookeeper?) is responsible for managing the leader, selecting a new leader when the current leader dies.

* Broker
    * Unique "server" node within a cluster.

* Message Delivery Semantics
    * Message commitment.
        * Kafka supports an idempotent message delivery option.
            * The producer attaches an identifier to each message.
            * Kafka guarantees the message is only committed to the log once.
        * Producers can publish messages with two delivery semantics
            * Wait for delivery commit confirmation (10 ms)
            * Send completely async, only wait until the leader has the message.
    * Kafka guarantees a committed message will not be lost as long as there is one in-sync replica at all times.
        * Committed message == all ISRs have applied the message to the log.


* Replication
    * The partition is the unit of replication.
    * Each partition has a leader. All read / writes go to the leader.
    * When partitions > brokers (typical case), leaders are distributed among brokers.

* Log compaction
    * Simple log compaction happens by date. All data occurring before a fixed date (say 20 days) is deleted.
    * Key based. The last log message for each key is retained.

* Quotas
    * Prevent DDoS.

## Operations

* Determine replication factor.
    * Definitely more than 1. You want to roll servers.
    * With replication `n`, `n - 1` servers can fail.

* Determine partition count.
    * Each partition must fit completely on a single machine.
    * Partitions determine the degree of parallelism.
        * The maximum number of concurrent consumers cannot be greater than the partition size.
    * You can repartition after creation.
        * Existing data does not move. Therefore partitions relying on hashes may not work.
        * Warning : if a topic that has a key, ordering will be affected.
        * You cannot reduce the number of partitions for a tpoic. (future plans perhaps)

* Mirroring
    * 

```

# Main configuration directory
/usr/local/etc/kafka

# Log directory (log.dir) : this is where all kafka data resides
/usr/local/var/lib/kafka-logs

# Start zookeeper
$ zookeeper-server-start /Users/allidam/programs/kafka_2.11-1.0.0/config/zookeeper.properties

# Start zookeeper (brew installed)
$ zookeeper-server-start /Users/allidam/programs/kafka_2.11-1.0.0/config/zookeeper.properties

# Start kafka
$ ~/programs/kafka_2.11-1.0.0/bin/kafka-server-start.sh ~/programs/kafka_2.11-1.0.0/config/server-0.properties


# List topics
$ kafka-topics --zookeeper localhost:2181 --list

# Create a new topic
$ kafka-topics --zookeeper localhost:2181 --create --if-not-exists --replication-factor 1 --partitions 1 --topic com.damonallison.test

# Describe a topic (replication factor)
$ kafka-topics --zookeeper localhost:2181 --describe --topic com.damonallison.test

# Delete
$ kafka-topics
$ ./kafka-console-producer.sh --broker-list localhost:9092 --topic com.damonallison.test
$ ./kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic com.damonallison.test --from-beginning


# An example Kafka Connect file connector.
# Reads from a source file (test.txt) writes to a sink (listener) file ()
$ connect-standalone connect-standalone.properties connect-file-source.properties connect-file-sink.properties

```