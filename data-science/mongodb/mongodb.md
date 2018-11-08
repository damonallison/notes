# MongoDB

MongoDB is a distributed document store. Documents are stored in `collections`,
queried using a JSON-like based query language, and have dynamic schemas.
Documents in the same collection can have different schemas.

The key advantage of document stores over relational stores is the flexability
and dynamic nature of documents. Documents do not require you to create complex,
potentially slow `JOIN` statements or create a dedicated stored procedure query
layer.

Schema is not enforced or does not have to be consistent between documents. This
allows you to version on demand.

## Key Features

* Performance.
  * Document based queries avoid expensive JOIN operations found in
    SQL based DMBSs.

* High Availability.
  * Mongo supports multiple replica sets, providing automatic
    fail over and data redundancy.

* Scalable.
  * Mongo shards data horizontally across a cluster of machines.

## Conceptual

* Database
  * A set of document collections.
* Collections
  * A set of documents.
* Documents
  * Records in a collection. Must have an `_id` field (primary key).
  * Documents are stored in `BSON`. `BSON` is a binary representation of `JSON`
    but contains more types.

## Launching Mongo

* To start mongod at runtime : `brew services start mongodb`

* Manually starting mongo
  * `mongod --config /usr/local/etc/mongod.conf`

* Mongo runs on port `27017`.

```bash
# Bulk importing of mongo data
# --drop == drop collection before inserting documents.

$ mongoimport --db test --collection restaurants --drop --file ~/projects/mongo/primer-dataset.json
```

-------------------------------------------------------------------------------

## Connecting to MongoDB

* `mongodb` launches a server instance.
* `mongo`

Mongo will create it's database structure. All it needs is a path to use when launching the daemon, specified with the `--dbpath <path>` option.

```bash

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
