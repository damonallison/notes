# Kafka Training

## Questions

* Should / can we use kafka as a source of truth (vs. mysql or SQL Server).

* How to add brokers after the fact?

* Can we shut off auto-creation?
    * Use the REST API to configure the cluster.
    * Force admins to create topics prior to message publish?

* Any way to force producers / consumers to follow a key / value contract?
    * Prevent bad messages from being pushed to a topic.


* Versioning. Any message versioning tricks with Avro / Json.
    * Put message version into the payload?
    * How to remove fields?

* Any tricks for key selection?
    * We want to avoid having `hot` customers hash to the same partition.

* Infrastructure topology
    * Advantages / disadvantages of single vs. multiple clusters?

* Do companies write middleware / interceptors (authentication, logging, security) or build pipelines around producers / consumers to handle general activities?

* What does LinkedIn use for compression / serialization formats?
    * Pros / cons of different serialization schemes?

* Are the producer / consumers persistent? i.e., persistent socket connections?
* Python examples are done in HTTP

* Damon: 54.205.44.107
    * http://54.205.44.107/training/#/
    * training / training

* Why do you need to `poll(0)` to get partition assignments? Could that be done as part of `.subscribe([topic_list])`
    * `poll()` is used in a loop so it can update configuration without having to break the poll loop or have to event from server -> client.
    * it's kafka's chance to pull the latest configuration for the client.

## Recommendations

* Distinghuish between a broker and a "server".
* Only keep 3-5 zookeeper nodes around. More than that makes things too chatty.
* Never start with less than 3 brokers in prod.
* Keep zookeeper nodes off of broker nodes.
* If you have multiple producers, ensure the producers are publishing messages for different keys.
    * Ordering problems will occur if multiple producers are producing messages with the same key.
* Use 3 or 4 digit broker numbers.
    * Makes it easier to read the logs, distinguish between partitions of `0` and `1`.

* Get off `librdkafka` (.NET, etc). It's always going to be second class.
* Hide the pub / sub / topic / messaging semantics from developers (aka, drone v2)


## Content

* Producers push -> <- Consumers pull

* Consumers pull
    * Puts responsibility on the client to maintain state, less burden on the server.
    * Consumers

* Topic
    * Each topic can have a different retention policy, configuration.

* Kafka uses page cache rather than heap. Disks are fast, read the docs.


### Zookeeper

* Zookeeper stores cluster config / ACLs.
* Zookeeper is responsible for keeping brokers alive, broker communication.

### Producer

* Math.abs(Utils.murmur2(keyBytes)) % (numPartitions - 1)) + 1;

### Consumer

* EOS : exactly once semantics : not in `librdkafka`
    * EOS only works with `acks=-1`
    * Transactional guarantees has been delivered exactly once.
    * Brokers dedupe based on `ProducerId` / `TransactionId`
    * `enable.idempotence=true`
    * `acks=-1`
    * Producer writes atomically across partitions using "transactional" messages.

### Schema Registry

* Producers serialize data and prepend the schema ID to the key and value.
* `_schemas` is the topic for holding schemas.
* Schema registry communication only happens when first seeing schema.

`props.put(KafkaAvroDeserializerConfig.SPECFIC_AVRO_READER_CONFIG, "true");`
`props.put(KafkaAvroDeserializerConfig.SCHEMA_REGISTRY_URL_CONFIG, "http://schemaregistry1:8081");`

### Chapter 9 : Basic Kafka Administration

> Kafka running on Windows may prove problematic.
> If you're installing Kafka on Windows, don't.

* Java 8 or 9
* You should never have to bring down your Kafka cluster. Do rolling upgrades.
* Do not alter partition count on topics that use
* Make sure all brokers use the same configuration file!

* Topic deletion
    * Stop all producers / consumers.
    * All brokers must be running for the delete to be successful.

* Log Management
    * You can combine `compact` and `delete` retention policies.
    * Tombstone : Key + null value. Will stay in topic for a day, then strip out key.
        * Use this to delete keys out of the system.

* How many partitions?
    * Producers usually produce @ 25MB/s.
    * Consumers are the bottleneck. More partitions == more parallelism.

* `server.properties`
```
auto.create.topics.enable=false
delete.topic.enable=true
```

### Chapter 10 : Kafka Streams

> Only works in Java.

* KSQL -> Graphana is awesome.


---

# Hands On

* Home directory : `/home/training/developer/exercise_code`
* Zookeeper : `zookeeper-shell`

#### JVM Processes

JVM Name == Service Name

* QuorumPeerMain == `zookeeper`
* SupportedKafka == `kafka-server`
* KafkaRestMain == `kafka-rest`
* SchemaRegistryMain == `schema-registry`

* Kafka is distributing messages round-robin to all partitions starting with partition `0` (or `1`).

