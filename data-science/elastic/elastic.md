# Elastic Stack

Elastic was started by Shay Banon with the goal of simplifying the interface to Lucene. Elastic provides full text search powered by Lucene and analytics capabilities (aggregations, etc). It is scalable and performant for large data sets (shards, replicas, clusters).

Elastic is a distributed JSON document store. Every field is indexed by default. Built for performance.

## Important

* **Mapping types are being removed in ES7.**


## Elastic Concepts

* Elastic is a JSON / HTTP wrapper around lucene, breaking the dependence on java.
* Elastic, along with Logstash and Kibana is referred to as an "ELK stack" or "elastic stack".
* Reverse-search (Percolator) to raise events matching a pre-defined query when data changes.
    * Queries can be registered, notified on change.
* ES supports real-time `GET` requests, making it a suitable NoSQL datastore (no distributed Tx)
* Elastic is NRT (Near Realtime). There is about a 1 second lag between when a document is indexed and it is searchable.


### Elastic Terminology

* Cluster. 1-n nodes. Each cluster must have a unique name.
* Index. Document collection. Each document is added to an index.
* Type. A subset of fields in an index. A "view" of your index.
* Document. A unit of information that can be indexed. Documents are stored in JSON.
* Shard. An index can be spread across multiple shards.
    * Shards allow you to horizontally scale out your index.
    * Allows you to distribute and parallelize queries across shards.
    * Each shared can have one or more replica shards. Replica shards are *never* hosted on the same node where the primary shard resides.
    * Replicas act as redundancy, also speed up searching. Replica shards can fulfill queries.
* The number of shards and replicas are defined per index when the index is created. After creation, you can change the number of replications, but not shards.

## Likes

* Aggregation framework (multiple, nested).

## Dislikes

* HTTP API (underscores everywhere to avoid naming collisions `_cat`)
* JSON query syntax.


## Questions

* Do people use scripts (Groovy or Elastic's homegrown language) to modify documents?
* How much faster is elastic than SQL?
* How to create a lucene index populated by SQL triggers?
  * Can you automatically update an index based on SQL changes?
* Why can't you change the number of shards after index creation?

* Building up JSON queries feels like a hack. Is there a strongly typed object model (LINQ like) which can build up JSON for us using a strongly typed OM?
* What is `keyword` in searches?

## TODO

* Logstash
* Kibana
* Setup a cluster of two nodes.
* Create an index with two shards / two replicas.
* Understand the elastic API.
* Setup and run elastic locally.
* Batch update.
* Advanced query operators.
* Advanced aggregations.

* .NET API - Nest?
* Aliases?
* Keyword value?
  * What is the difference between `string`, `keyword`, and `text`?
* Read vs. write perf.
* What elastic plugins are available?
* Can we turn off dynamically generated indexes?
* `bool` queries - differences between `must` and `should`. Why use `should`?

## Elastic Environment

* Elastic (installed via homebrew) into `/usr/local`
  * App : `/usr/local/bin/elasticsearch`
  * Config : `/usr/local/etc/elasticsearch/elasticsearch.yml`
  * Log : `/usr/local/var/log/elasticsearch`
  * Data : `/usr/local/var/elasticsearch`

```

Launching elasticsearch. Important environment variables:
---
Java Configuration:
Important : JAVA_OPTS is ignored. Pass JVM parameters via ES_JAVA_OPTS
---
JAVA= + /Library/Java/JavaVirtualMachines/jdk1.8.0_73.jdk/Contents/Home/bin/java
ES_JVM_OPTIONS= + /usr/local/etc/elasticsearch/jvm.options
ES_JAVA_OPTS= + -Xms2g -Xmx2g -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=75 -XX:+UseCMSInitiatingOccupancyOnly -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -server -Xss1m -Djava.awt.headless=true -Dfile.encoding=UTF-8 -Djna.nosys=true -Djdk.io.permissionsUseCanonicalPath=true -Dio.netty.noUnsafe=true -Dio.netty.noKeySetOptimization=true -Dio.netty.recycler.maxCapacityPerThread=0 -Dlog4j.shutdownHookEnabled=false -Dlog4j2.disable.jmx=true -Dlog4j.skipJansi=true -XX:+HeapDumpOnOutOfMemoryError

---
Elastic Configuration:
---
ES_HOME= + /usr/local/Cellar/elasticsearch/6.1.3/libexec
ES_CLASSPATH= + /usr/local/Cellar/elasticsearch/6.1.3/libexec
ES_PATH_CONF= + /usr/local/etc/elasticsearch

```


## Mapping

### Types

* `text` : full text search
* `keyword` : exact value search
* `byte` `short` `integer` `long`
* `float` `double`
* `boolean`
* `date`
* `object`
* `nested`

* Mappings, once created, cannot be updated. Create a new index.
*


## API

### Optimistic Concurrency

* Append `version=x` to ensure you are updating the correct version of the document.
  * POST /customer/doc/1?version=1

* Prevents overwriting newer versions by accident.


### Searching

* Strings (exact values) and text (full text).
* Date range searches can be done using `date math`.
  * NOTE: this syntax may not be right. Research `date math` for correct syntax, rounding, etc.
```
"query" : {
  "range" : {
    "date_field_name" : {
      "gte" : "now-1d/d",
      "lt" : "now/d"
    }
  }
}
```


#### Analyzers

Analyzers perform three functions:

* Character filters. Eliminiating whitespace, irrelevant characters.
* Tokenizer.
* Token filters. Filters out unwanted tokens (a, an, the).



#### Query DSL

##### Boolean

###### must | must_not

The clause *must* or *must_not* appear in matching documents. `must` matches will contribute to the score.

###### filter

The clause *must* appear in the matching documents and will *not* contribute to the score.

###### should

* If alongside a `must` or `filter`, the query will match even if none of the `should` clauses match. These are only used to influence the score.
* If there are no `must` or `filter`, at least one of the `should` queries must match. (think of this as `OR`).


## Bulk load

```
curl -H "Content-Type: application/json" -XPOST 'localhost:9200/bank/account/_bulk?pretty&refresh' --data-binary "@accounts.json"
curl 'localhost:9200/_cat/indices?v'
```

* Searching
  * Searches are stateless. After the search is complete, there is no open connection to elastic (as there is with SQL).

  * Aggregation. Elastic queries can return aggregations *in tandem with* results.




```
$ docker pull docker.elastic.co/elasticsearch/elasticsearch:5.3.0
$ docker run -p 9200:9200 -e "http.host=0.0.0.0" -e "transport.host=127.0.0.1" docker.elastic.co/elasticsearch/elasticsearch:5.3.0
```


