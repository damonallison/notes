# Kafka

## Questions

* Prove that messages from a partition always be dispatched to the same consumer.
* Send strongly typed messages to a topic.
    * What happens on fail messages?
    * How to version messages to a topic?

## What is kafka?

* A distributed streaming platform.

## Why use kafka?

* To distribute data between systems.

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
        * Each partition can be processed by a different consuming instance.
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

* Cluster
    * The top level entity of a kafka installation.
    * Each topic has a "leader" broker within a cluster.
    * The cluster manager (zookeeper?) is responsible for managing the leader, selecting a new leader when the current leader dies.

* Broker
    * Unique "server" node within a cluster.

## Creating Topics

* Determine the number of partitions you want to have.
    * Partitions determine the scale out capability.
        * The maximum number of concurrent consumers cannot be greater than the partition size.
    * You can repartition after creation.
        * Warning : if a topic that has a key, ordering will be affected.

```

# Main configuration directory
/usr/local/etc/kafka

# Log directory (log.dir)
/usr/local/var/lib/kafka-logs


$ kafka-topics --zookeeper localhost:2181 --list
$ kafka-topics --zookeeper localhost:2181 --create --if-not-exists --replication-factor 1 --partitions 1 --topic com.damonallison.test

$ kafka-console-producer --broker-list localhost:9092 --topic com.damonallison.test
$ kafka-console-consumer --bootstrap-server localhost:9092 --topic com.damonallison.test

$ kafka-topics --zookeeper localhost:2181 --describe --topic com.damonallison.test

# An example Kafka Connect file connector.
# Reads from a source file (test.txt) writes to a sink (listener) file ()
$ connect-standalone connect-standalone.properties connect-file-source.properties connect-file-sink.properties

```