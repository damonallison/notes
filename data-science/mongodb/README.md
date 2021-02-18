# MongoDB

MongoDB is a distributed document store (NoSQL). Documents are stored in
`collections`, queried using a JSON-like based query language, and have dynamic
schemas (by default).

To achieve horizontal scalability, MongoDB has the concept of "replica sets"
(multiple copies) and collection sharding - distributing a collection over
multiple "shards" based on a shard key.

By default, collections are schemaless. Documents in the same collection can
have different representations. JSON schemas can be added to collections.

## Key Features

* Flexability
  * The key advantage of document stores over relational stores is the
    flexability and dynamic nature of documents. Documents do not require you to
    create complex, potentially slow `JOIN` statements or create a dedicated
    stored procedure query layer.

* Performance
  * Document based queries avoid expensive JOIN operations found in
    SQL based DMBSs.

* High Availability
  * Mongo supports multiple replica sets, providing automatic
    fail over and data redundancy.

* Scalability
  * Mongo shards data horizontally across a cluster of machines.

* Views
  * Read only
  * Not persisted to disk. Queries are evaluated against the base tables on
    demand.

## Conceptual

* Database

  * A set of document collections.

* Collections

  * A set of documents.

  * Collections can be capped. Once the cap is reached, the earliest documents
    are evicted (FIFO). Documents cannot be deleted from capped collections nor
    can you shard a capped collection.
  * Collections can have a TTL.

* Documents

  * Records in a collection. Must have an `_id` field (primary key).

  * Documents are stored in `BSON`. `BSON` is a binary representation of `JSON`
    but contains more types.


* Replica Set

  * Automatic failover and redundancy


* Transactions

  * All write operations are atomic at a single document level.

  * Atomicity of reads / writes across multiple documents in a single or
    multiple collections.

  * Read / write acknowledgement. Allows you to specify the level of read /
    write acknowledgement before considering a read / write successful.

  * NOTE: `mongo` internally uses the `majority` read / write concern to
    communicate cluster and shard metadata. If it's good enough for them,
    default to using it in your application unless you need the performance of
    `available` or a lesser TX level.


* Sharding
  * Partitions a collection across machines using a `shard key`.


-------------------------------------------------------------------------------

## Shards

* Shards partition data across a cluster of machines by a `shard key`.
* Once a collection is sharded, it cannot be unsharded. The `shard key` can be changed.
* If a query does not contian the shard key, `mongos` will scatter / gather results.
* You must connect to a `mongos` router to interact with a sharded collection.

### Sharding strategies

* Hashed Sharding
  * The shard key is hashed. Range based queries, even on the shard key, are
    unlikely to land on the same shard. Use hashed sharding if you are truly
    just using mongo as a document store and performing operations on single
    documents.

* Ranged sharding
  * Sharded by ranges of `shard key`.
  * Use this if you need to do range based queries on the `shared key`.
  * Example: `shard key` - `created_at`. Find all where `created_at > '2020-02-16`


### Setting up a sharded cluster

A sharded cluster requires:

* Shards: one shard per replica set
* `mongos` query router. It's possible to use primary shards to host `mongos`
  routers.
* Config servers (replica set)

For development purposes, you can setup the following:

* A replica set config server w/ 1 member.
* A single shard as a 1 member replica set.
* One mongos instance (on the shard)

#### Shards

* Shard partitioning is *only* based on `shard key`. Queries that must scatter
  across shards can (and should) still use indexes.

* Choose a shard key that gives you good distribution (typically not range) and
  use indices to speed up queries that must cross shards.

* Do not create shard keys that increase or decrease monotonically. All reads /
  writes for the latest documents will happen on a single shard.

* Hashed Sharding
  * Provides an even distribution.
  * Reduces targeted queries / increases broadcast
  * Use with monotonically increasing values, like `_id` which uses `ObjectID`
    values.

* Sharding recommendations
  * The shard key should have good cardinality.
  *



* Shard a collection
  * `sh.sharedCollection("db.collection", 1|"hashed")`

* Shard cluster overview
  * `sh.status()`



#### Config Server

* `mongos` uses config servers to retrieve sharded cluster topology.
* Each sharded cluster must have its own config servers.
* The `admin` (security) and `config` (cluster topology) DBs should never be
  directly manipulated.

#### mongos

* You typically run a mongos instance directly on your application servers.
* `mongos` can also be run directly on shards.
* To determine if you are connected to a `mongos` instance, use the `isMaster`
  command. `msg` should be `isdbgrid`.

```json
{
   "ismaster" : true,
   "msg" : "isdbgrid",
   "maxBsonObjectSize" : 16777216,
   "ok" : 1,
   ...
}
```

## Connecting to MongoDB

```bash

# Download `mongosh` - a more advanced shell than the traditional `mongo` shell

# Start mongo
$ cd big-data-3/mongodb

# Note: Mongo will create the database structure it needs.
$ ./mongodb/bin/mongod --dbpath db

# Open a query terminal
$ ./mongodb/bin/mongo

> show dbs
> use <dbname>
> show collections
> db.users.findOne() // your query here.

```

## Working with Mongo

> db.runCommand( {
>   create: "users",         -- The new collection name. Required.
>   capped: false,           -- Create a capped collection. When the collection reaches the cap,
                             -- the oldest documents are removed to make room for new. Optional.
>   size: 64000000           -- The maximum size of a capped collection. Used when capped : true. Optional.
}

## Importing / Exporting Data

> mongoexport --db test --collection users --out out.json
> mongoimport --db test --collection users --file in.json



## Queries

###### Generalized query pattern
> db.collection.find(<query filter>, <projection>).<cursor modifier>

###### Return all documents
> db.users.find()

###### Add a filter (string) (WHERE)
> db.users.find( { user_name : "damonallison" } )

###### Find all users who have 20 or more friends.
> db.users.find( { 'user.FriendsCount': { $gte: 20 } })

###### Filter using regex (case insensitive == /i)
> `db.users.find( { "user_name" : {$regex:/^a.*game$/i} })`

### Projection

###### Return only the user_name field.

> Note that `_id` will always be returned unless specifically set to 0.
> `db.users.find( {}, { "user_name" : 1, "_id" : 0} )`

# Distinct (with projection. Returns `user_name` and `_id`
> db.users.distinct( {}, { "user_name": 1 } )

---

### Array operations

###### Find items which are tagged as `popular` **or** `organic`
> db.inventory.find({tags: {$in: ["popular", "organic"]}})

# Find items which are **not** tagged as `popular` **nor** `organic`
db.inventory.find({tags: {$nin: ["popular", "organic"]}})

###### Extract a portion of an array. Find the 2nd and 3rd elements of tags.

> $slice[1, 2] == start at element 1, take length of 2
> db.inventory.find( {}, {tags: {$slice: [1, 2]}})

###### Find a document whose 2nd element in tags is "summer" (`tags.1`) or more generally (`key.position`)
> db.inventory.find( {}, {tags.1: "summer"})

### Compound statements

> SELECT * FROM inventory WHERE
>   ((price > 100) OR (price < 1)) AND
>   ((rating = 'good') OR (qty < 20)) AND
>   (item NOT LIKE '%coors%')

> db.inventory.find({
>  $and: [
>    {$or: [{price: {$gt: 100}}, {price: {$lt: 1}}]},
>    {$or: [{rating: "good"}, {qty: {$lt: 20}}]},
>    {item: {$regex: /coors/i"}}
>  ]
> })

###  Nested Elements.

Assume a collection with the following documents.

```
_id: 1,
points: [
  { points: 96, bonus: 20 },
  { points: 96, bonus: 10 }
]

_id: 2,
points: [
  { points: 53, bonus: 20 },
  { points: 64, bonus: 12 }
]

_id: 3,
points: [
  { points: 81, bonus: 8 },
  { points: 95, bonus: 20 }
]
```

###### Find users whose first point total is < 80. Returns `_id: 2`
> db.users.find({'points.0.points': {$lte: 80}})

###### Find users who have one or more point total below 80. Returns `_id: [1, 2]`
> db.users.find({'points.points': {$lte: 80}})

###### Find users who have a points tuple with points <= 81 AND bonus == 20. Returns `_id: 2`
> Note the `,` is treated as an implicit `$and` when querying each node.
> db.users.find({'points.points': { $lte: 81}, 'points.bonus': 20})`


### Aggregation Functions

###### Count
> db.users.count()
> db.users.find( { "user_name" : { $regex: /.*cole.*/i } }, { "user_name" : 1 }).count()

###### Distinct
> db.users.distinct(user_name).length

###### Groups by username. Sorts by count descending.
```
db.users.aggregate([
  { "$group" : { _id : "$user_name", count: {$sum:1} } },
  { "$sort" : { count: -1 } }
])
```

###### Groups by user_name, sums the "user.FriendsCount" field.

```
db.users.aggregate( [
  { $match: { "user.FriendsCount" : { $gte : 500 } } },
  { $group: { _id: "$user_name", total_friends: {$sum : "$user.FriendsCount" } } }
  ])
```

###### Text search with aggregation (using $text)

$meta is a computed element which is the result of the text search.

###### Having either "beat" or "win" anywhere in the tweet_text field will match.
```
db.users.aggregate([
  { $match: { $tweet_text: { $search: "beat win" } } },
  { $sort : { tweet_mention_count: -1}}
])
```
