# Data Science

## Kafka

* A distributed streaming platform used for building real time pipelines.
* Based around topics, partitions, producers, and consumers.

## Hadoop

* A distributed, fault tolerant, scalable, redundant file system (HDFS).
* A distributed MapReduce programming framework.

## Spark

* An distribued, in-memory, parallel data processing engine.
* Based on RDDs - Resilient Distributed Datasets.
* Spark SQL - Provides distributed SQL like operations (query, filter, sort) on large datasets.

## Hive

* Provides a SQL-like interface (HiveQL) which operates on databases and file systems which integrate with Hadoop.
* Abstracts away the underlying Hadoop / Java MapReduce API into a user friendly SQL interface.
* Hive compiles `HiveQL` statements into MapReduce or Spark jobs, which are submitted for execution.

## Anaconda

* A distribution of the Python and R which simplifies package management and deployment.
* Package versions are managed by the package manager `conda`.

## Flume

* Flume is a kafka-like streaming engine with tight integration with Hadoop.
* Kafka is a much better general purpose streaming engine than Flume. tl;dr - Use Kafka.
* Flume is tightly integrated with Hadoop / HDFS and is generally used to ingest data into HDFS.

## Cassandra

* Cassandra is a distributed NoSQL DBMS which runs on commodity hardware clusters.
* All nodes are equal. Cassandra is *not* a master/slave topology.
* Cassandra is meant for multi-datacenter deployments and scales well when new
  machines are added / removed.
* Cassandra stores rows of data into tables (like DBMS), and partitioned using a
  partition key. Within a partition, rows are clustered by a primary key.
* Cassandra cannot do joins or subqueries. Cassandra favors denormalization.
* Different rows with the same primary key can have different elements (schema
  is not fixed).
* Cassandra has a query language `CQL - Cassandra Query Language` which allows
  you to query tables.

## Redis

* Redis "REmote DIctionary Server" is an in-memory key/value data store.
* Redis values can be simple, primitive types (i.e., `string`) or more complex
  types like `lists`, `sets`, `hashes`.
* As of Redis 5, redis supports streaming, similar to kafka, but feels far less
  robust.

## MongoDB

* MongoDB is a scalable, fault tolerant, distributed document database.
* Documents are queried with a `JSON` query syntax.
* Queries are executed in a pipeline with multiple steps like selection,
  filtering, and aggregation.

---

## Pandas

* Provides high level data structures (Series, Dataframe) and tools for data analysis and manipulation.
* Pandas is built on top of NumPy.

## SciPy / NumPy

* A scientific computing library for Python.
* NumPy provides data structures for large, multi-dimensional arrays and matrices.
* SciPy builds on the NumPy array object.
* SciPy provides high level mathematical functions to operate on NumPy data structures.
* SciPy includes algorithms for clustering, image processing, linear algebra, spacial (kNN, distance), others.

## Matplotlib

* 2D plotting library.


---

## Splunk

* Splunk is a web based, data analysis and visualization tool.
* The main goal is to
