# Elastic

## Questions

* How much faster is elastic than SQL?
* How to create a lucene index backed by SQL?
  * Can you automatically update an index based on SQL changes?
* Why can't you change the number of shards after index creation?

* Building up JSON queries feels like a hack. Is there a strongly typed object model (LINQ like) which can build up JSON for us using a strongly typed OM?


## Elastic Concepts


* It appears elastic is a JSON / HTTP wrapper around lucene, breaking the dependence on java.
* Elastic, along with Logstash and Kibana is referred to as an "ELK stack".
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


### Creating Indexes / Types


```
<REST VERB> /{index}/{type}/{id}

// Examples

// Create a new index "customer" (if necessary), type "external" (if necessary)
// and add or update the document with ID == 1.

// Adds (or updates) a document with ID == 1
PUT /customer/external/1
{
  "first_name" : "damon",
  "last_name" : "allison"
}


// Adds a document with a randomly generated ID
POST /customer/external
{
  "first_name" : "damon",
  "last_name" : "allison"
}

// Delete the customer index
DELETE /customer?pretty

```

* Updates can only be made to a single document at a time. Future plans would be to support SQL's `UPDATE WHERE` functionality.


* Elastic supports a `bulk` operation. Example:

```
POST /customer/external/_bulk?pretty
{"index":{"_id":"1"}}
{"name": "John Doe" }
{"index":{"_id":"2"}}
{"name": "Jane Doe" }
```

* Bulk load

```
curl -H "Content-Type: application/json" -XPOST 'localhost:9200/bank/account/_bulk?pretty&refresh' --data-binary "@accounts.json"
curl 'localhost:9200/_cat/indices?v'
```

* Searching
  * Searches are stateless. After the search is complete, there is no open connection to elastic (as there is with SQL).

  * Aggregation. Elastic queries can return aggregations *in tandem with* results.
## Logstash


* Collect, aggregate, parse data. Feed it to elastic.


## Kibana


* Visualization



```
$ docker pull docker.elastic.co/elasticsearch/elasticsearch:5.3.0
$ docker run -p 9200:9200 -e "http.host=0.0.0.0" -e "transport.host=127.0.0.1" docker.elastic.co/elasticsearch/elasticsearch:5.3.0
```
