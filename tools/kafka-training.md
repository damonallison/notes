# Kafka Training

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

* Kafka is Jay's favorite author. Kafka who?

* Get off `librdkafka` (.NET, etc). It's always going to be second class.
* Hide the pub / sub / topic / messaging semantics from developers (aka, done v2)

* Never start with less than 3 brokers in prod.

* The python example shows messages being sent over HTTP.

## Recommendations

* Distinghuish between a broker and a "server".
* Only keep 3-5 zookeeper nodes around. More than that makes things too chatty.
* Keep zookeeper nodes off of broker nodes.
* If you have multiple producers, ensure the producers are publishing messages for different keys.
    * Ordering problems will occur if multiple producers are producing messages with the same key.
* Use 3 or 4 digit broker numbers.
    * Makes it easier to read the logs, distinguish between partitions of `0` and `1`.


## Questions

* Should / can we use kafka as a source of truth (vs. mysql or SQL Server).

* How to add brokers after the fact?

* Can we shut off auto-creation?
    * Use the REST API to configure the cluster.
    * Force admins to create topics prior to message publish?

* Any way to force producers / consumers to follow a key / value contract?
    * Prevent bad messages from being pushed to a topic.


* Producers push -> <- Consumers pull



* Consumers pull
    * Puts responsibility on the client to maintain state, less burden on the server.
    * Consumers

* Topic
    * Each topic can have a different retention policy, configuration.

* Kafka uses page cache rather than heap. Disks are fast, read the docs.

* Clients.

### Zookeeper

* Zookeeper stores cluster config / ACLs.
* Zookeeper is responsible for keeping brokers alive, broker communication.


### Hands On

* Home directory : `/home/training/developer/exercise_code`
* Zookeeper : `zookeeper-shell`

#### JVM Processes

JVM Name == Service Name

* QuorumPeerMain == `zookeeper`
* SupportedKafka == `kafka-server`
* KafkaRestMain == `kafka-rest`
* SchemaRegistryMain == `schema-registry`

* Kafka is distributing messages round-robin to all partitions starting with partition `0` (or `1`).

