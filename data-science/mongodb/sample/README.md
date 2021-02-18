# A sample MongoDB DB layer

A sample go DB layer which uses mongo as a data store.

## Setup

Create the cluster:

* Config server (3 member replica set) `config01`, `config02`, `config03`

* 3 shards (each a 2 member replica set)
  * `shard01a`, `shard01b`
  * `shard21a`, `shard02b`
  * `shard03a`, `shard03b`

* 1 router (`monogos`) running on `27017`

```shell
$ cd cluster
$ `docker-compose up -d`
$ sh init.sh
```

* Verify the cluster

Connect via `docker-compose` or `mongosh`:
* `docker-compose exec router mongo`
* `mongosh --host localhost -- port 27017`

```
mongos> sh.status()

--- Sharding Status ---
  sharding version: {
	"_id" : 1,
	"minCompatibleVersion" : 5,
	"currentVersion" : 6,
	"clusterId" : ObjectId("5981df064c97b126d0e5aa0e")
}
  shards:
	{  "_id" : "shard01",  "host" : "shard01/shard01a:27018,shard01b:27018",  "state" : 1 }
	{  "_id" : "shard02",  "host" : "shard02/shard02a:27019,shard02b:27019",  "state" : 1 }
	{  "_id" : "shard03",  "host" : "shard03/shard03a:27020,shard03b:27020",  "state" : 1 }
  active mongoses:
	"3.4.6" : 1
 autosplit:
	Currently enabled: yes
  balancer:
	Currently enabled:  yes
	Currently running:  no
		Balancer lock taken at Wed Aug 02 2017 14:17:42 GMT+0000 (UTC) by ConfigServer:Balancer
	Failed balancer rounds in last 5 attempts:  0
	Migration Results for the last 24 hours:
		No recent migrations
  databases:

```


## Creating a sharded collection

0. Create a database and collection

```shell
mongos> use shipt

# autoIndexID automatically creates an index on _id.
mongos> db.createCollection("drivers", {autoIndexId: true})
```

1. Enabling sharding on db.

**Important: You can only run enableSharding in the `admin` database from a `mongos` instance**

```javascript

// Enable sharding on the database
db.adminCommand( {
    enableSharding: "<dbname>"
})

// Shard a collection
sh.shardCollection("<dbname>.<collection>", { key: 1|"hashed"})

//
// Determine sharding status
//
db.printShardingStatus()

// For a really verbose sharding status:
sh.status({verbose: true}


//
// Describe collections
//
db.getCollectionInfos()

```

## Schema validation

```javascript

// validationLevel
//
// strict (default): Applies validation rules against all inserts and updates
// moderate: Apply validation rules to inserts and updates to existing documents that already fulfill the criteria.
//           Updates to existing documents that do not fulfill the validation criteria are not checked for validity.
//
db.runCommand( {
	collMod: "drivers",
	validationLevel: "strict",
	validator: {
		$jsonSchema: {
			bsonType: "object",
			required: ["first_name", "last_name", "created_at"],
			properties: {
				first_name: {
					bsonType: "string",
					description: "first_name - required"
				},
				last_name: {
					bsonType: "string",
					description: "last_name - required"
				},
				created_at: {
					bsonType: "date",
					description: "created_at - required"
				}
			}
		}
	}
} )

```