# Kafka

## Todo

* Cluster / partition strategy.
    * Any good strategies for key partitioning? By customer identifier?
    * You can't update the partition strategy with hashed keys after topic creation (without strange things happening).

* Topic naming strategy. Any tips? How did LinkedIn do it?

* Delivery semantics. How to guarantee once and only once delivery?
    * Better to design systems to expect "at least once" delivery (allow for duplicates?)

* How does user / security work?
    * `Client Groups` in the documentation state the user / client id

* How can clients track their offset?
    * The client must send / read it's offset to the offset manager.
    * The client should use a `GroupCoordinatorRequest`.
    * "High level" consumers should handle this automatically.

* POC
    * Write a producer and consumer.
    * Write JSON and AVRO messages (to different topics).
    * How to version messages?
    * What are the failure points?

* Message format pros / cons
    * JSON vs. Avro

* Message versioning

* Log compaction strategies. Any tips?
    * Size
    * Date
    * Key

## What is kafka?

* A distributed streaming platform.

* Design motivations for Kafka.
    * High throughput to support web scale log streams.
    * Support backlogs to support ETL, bursting data in / out.
    * Low latency message delivery to replace RabbitMQ / messaging systems.
    * Streaming.
    * Fault tolerant.

## Why use kafka?

* To effeciently and quickly distribute data between systems.
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
    * Each topic partition has a "leader" broker within a cluster. All partition I/O occurs with the leader.
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
    * A better compaction is key based. The last log message for each key is retained.

* Quotas
    * Prevent DDoS.
    * Network based quotas - byte rate thresholds.
    * Request reate quotas - CPU utilization of network and I/O threads.
    * Quotas are enabled per client group, per server (broker).
    * The server (broker) sliently slows down the client by delaying responses.
        * By slowing down the response, the client does not need to implement backoff strategies.

## Implementation

* Log
    * For a topic `my_log`
        * Each partition has a unique directory. i.e., `my_log_0` for partition `0`, etc.
        * Each message's `id` is the byte offset of all messages ever sent to the topic.
        * Each file is named with the starting message `id` (byte offset).
    * A message's unique identifier is:
        * Node id + partition id + message id.
    * Note that the `message id` (byte offset) is hidden from the consumer.

* Consumer Offset Tracking
    * Consumer groups use a designated server called the `offset manager` to store offsets.
    * High level consumers should handle this automatically.
    * Previous versions of kafka used zookeeper to store offsets. That has been deprecated.
    * To find your consumer group offset manager, `GroupCoordinatorRequest` to look up it's offset manager.
    * Offsets are kept by partition.

## Operations

* Determine replication factor.
    * Replications are evenly distributed across servers.
    * Definitely more than 1. That will allow you to roll servers.
    * Each partition is stored with the format `topic_name-[partition]` i.e., `damon-0` for partition 0 of `damon` topic.

* Determine partition count.
    * Each partition must fit completely on a single machine.
    * Partitions determine the degree of parallelism.
        * The maximum number of concurrent consumers cannot be greater than the partition size.
    * You can repartition after creation.
        * Existing data does not move. Therefore partitions relying on hashes may not work.
        * Warning : if a topic that has a key, ordering will be affected.
        * You cannot reduce the number of partitions for a tpoic. (future plans perhaps)



## API

### Producer API

### Consumer API

* Update `AdvancedConsumer` to manually commit offsets on each message read (override automated defaults).
* Log each time offsets are committed.

Important configuration

```
//
// The only true required setting.
// The bootstrap server is used *only* for bootstrapping
// they will self identify all brokers in the cluster during bootstrapping.
//
// You typically want > 1 in case you want to bounce a server.
//
bootstrap.servers = localhost:9092,localhost:9093

//
// Client id helps in diagnostics, support.
//
client.id = "my-client-id"

//
// Used to store offsets
//
group.id = "my-group-id"

//
// Controls how often a consumer sends heartbeats to the server.
// Allows server to better determine when a client is disconnected,
// when a consumer rebalance is needed.
// Default 3s
//
heartbeat.interval.ms = 2000

//
// Offset management. Default true
//
enable.auto.commit = true

//
// The auto commit interval. Default 5000
//
auto.commit.interval.ms=5000

//
// The behavior to use when no commit history is found. Default = latest
//
// earliest = the first offset
// none = throw exception on the consumer if no offset is found for the consumer group.
// latest = the latest offset (stream new events going forward)
//
auto.offset.reset=earliest

```

[Confluent - Kafka Consumers](https://docs.confluent.io/current/clients/consumer.html)

* For each consumer group, each partition has a read offset. Each consumer must periodically persist their offsets.
* New consumers, when assigned partitions to read, will start from the persisted offset.


* By default, consumers have a
* How to reset client offsets?



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
$ kafka-topics --zookeeper localhost:2818 --delete --topic com.damonallison.test

# Start a console producer / consumer for testing
$ ./kafka-console-producer.sh --broker-list localhost:9092 --topic com.damonallison.test
$ ./kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic com.damonallison.test --from-beginning


# An example Kafka Connect file connector.
# Reads from a source file (test.txt) writes to a sink (listener) file ()
$ connect-standalone connect-standalone.properties connect-file-source.properties connect-file-sink.properties


# List Consumer Groups
$ ./kafka-consumer-groups.sh --bootstrap-server localhost:9092 --list


```

## Avro

* Schema based. Schemas, defined in JSON, are passed with a message.
* Dynamic. Code generation to read messages is not required.
* Avro includes an RPC mechanism.