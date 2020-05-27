# Stopford's blog posts

Notes taken from the blog post series: `The Data Dichotomy: Rethinking the Way We Treat Data and Services`
https://www.confluent.io/blog/data-dichotomy-rethinking-the-way-we-treat-data-and-services/

## Messaging as a single source of truth
* Microservices distribute the DB later across services. Joins are difficult or impossible.
* Traditional messaging systems discard events.
* Using a DB as the source of truth will not allow you to rebuild. You need a durable log store.
* Use events as the source of truth - even within your service! Dogfood your event stream.
* Kafka is meant to store large topics. 100s of TBs is common.
* Event streams allow sytems to evolve.

### Getting events into the log
* Event sourcing. Whole structure or delta. Both are options.
* CDC (Change Data Capture). Hook up a listener via Kafka Connect to listen for DB changes.

### Creating materialized views
* Memory images - load all into memory.
* Connect API
* State stores - Kafka backed K/V pairs usable from Kafka's streams API. Backed by Rocks DB.

## Leveraging the power of a database unbundled
* As systems grow, the DB is the central bottleneck.
* APIs aren't good at transferring data or joining data.
* Goal: to bring data together, but keep it isolated within your service.

Kreps:

> If you squint, you can view your system as one large distributed DB. Redis, Elastic, and query oriented systems are indexes. Streaming systems like Storm are distributed triggers.

* A database "unbundled" means separating storage out from query logic. Storage is inkafka, query logic into a materialized view.
* Materialized views can be ephemeral. In traditional messaging systems, they must be durable - you can't rebuild.

## Building a Microservices Ecosystem with Kafka Streams and KSQL
* Stateless systems are good. However, systems have state. Which typically falls to the data layer.
* Stream processors are proudly stateful. They store state where it is needed.
* Streams API is used for all JVM based languages.
* KSQL is a SQL like wrapper on top of the KStream API.
* KTables allow us to store state. Backed by Kafka topics, used to join streams together.
	* Global KTables are copied across all nodes. Keep them small (up to a few GB).
	* Local KTables are shared.

> Adopting event streaming requires a mindset shift. It requires an asynchronous, functional mindset rather than procedural / REST mindset.