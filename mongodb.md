# mongodb

## Likes

* Documents can have varying schema. This is similar to "NULL" in T-SQL. Simplifies adding elements to a schema.
* Geo filter queries (within center, within box).
* Ability to scale out? How to handle consistency?
  * Could express run within Mongo

## Questions

* How does schema versioning in Mongo differ from T-SQL? In good or bad ways?
* How is concurrency handled?

* `mongoimport` (and mongo in general) looks to be based on `go`. What is mongo's relationship to `go`?

### Mongo Proper

* Security?

## Commands

### Launching Mongo

* To start mongod at runtime : `brew services start mongodb`

* Manually starting mongo
  * `mongod --config /usr/local/etc/mongod.conf`

* Mongo runs on port `27017`.

```

# Bulk importing of mongo data
# --drop == drop collection before inserting documents.

$ mongoimport --db test --collection restaurants --drop --file ~/projects/mongo/primer-dataset.json
```

## Conceptual

* Collections - similar to tables in a relational DB.
* Documents in a collection must have an `_id` field (primary key).
