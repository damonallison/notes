# Kafka

```bash
##
# List all topics
#
$ kafka-topics --zookeeper kafkadvzk1:2181/kafkadev/01 --list

#
# Describe a topic (Configuration, Leader, ISRs)
#
$ kafka-topics --zookeeper kafkaprzk1:2181/kafkaprod/01 --topic vision_shipments_api_v1 --describe

#
# Delete a topic
#
$ kafka-topics --zookeeper kafkadvzk1:2181/kafkadev/01 --topic vision_shipments_api_v2 --delete

#
# Create topic / post message
#
# Post a message (auto topic create is turned on in DEV)
$ kafka-console-producer --broker-list kafkadvcl01b1:9092,kafkadvcl01b2:9092,kafkadvcl01b3:9092 --topic allidam-test

#
# Read a topic
#
kafka-console-consumer --bootstrap-server kafkadvcl01b1:9092 --topic vision_shipments_api_v1 --from-beginning

#
# View a consumer group
#
kafka-consumer-groups --bootstrap-server kafkadvcl01b1.chrobinson.com:9092 --group vision-shipments-consumer-cloud --describe

#
# Reset offsets for a consumer group
#
kafka-consumer-groups --bootstrap-server kafkadvcl01b1.chrobinson.com:9092 --group vision-shipments-consumer-cloud --reset-offsets --to-earliest --execute --all-topics

#
# List active members in a consumer group.
#
kafka-consumer-groups --bootstrap-server kafkadvcl01b1.chrobinson.com:9092 --group vision-shipments-consumer-cloud --describe --members

#
# Kafka UI
#
$ docker pull landoop/kafka-topics-ui
$ docker run --rm -it -p 8000:8000 -e "KAFKA_REST_PROXY_URL=kafkadvrestcl01:8082" -e "PROXY=true" landoop/kafka-topics-ui

```


### Luminosity.TREXListenerPlugin

#### NavisphereVision DB

```shell
NavVisionDevDB
NavVisionIntDB
NavVisionTrnDB
NavVisionDB
```


### Committing Offsets

```js

const consumerConf = {
  "enable.auto.commit": true,      // default
  "auto.commit.interval.ms": 5000, // default
  "enable.auto.offset.store": true // default
}

// If enable.auto.offset.store == false && enable.auto.commit == true
// The application will have to call rd_kafka_offset_store() to store
// the offset to autocommit.
```
