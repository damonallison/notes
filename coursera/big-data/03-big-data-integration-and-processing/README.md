# Big Data : Course 3 : Big Data Integration and Processing

Big data integration and processing is about acquiring data (i.e., batch, streaming) and processing data (i.e., transforming, querying).

## Week 1 : Welcome to Big Data Integration and Processing

### Why Big Data Integration and Processing?

* Introduction to query languages for MongoDB / Aerospike.
* Data pipelines (batch / stream processing concepts).
* Spark batch & stream processing examples.
* Splunk for processing big data.

#### Summary Of Big Data Modeling and Management

* Big Data Modeling and Management
  * Data modeling tells you
    * The structure of the data (schema)
    * What operations can be performed on the data.
    * What constraints apply
      * Relationships, rules. (i.e., a movie can only have one title)
      * All values must be > 0
  * Database Management System
    * Handle low level storage / retrieval of data storage, manipulation, retrieval, transactions, failure, security.
    * Allows the user to focus on higher level operations like querying and analysis.
    * SQL Server, Mongo, Redis are examples of database management systems.

* Different Data Models
  * Relational Data
    * Tables / relations.
  * Semi-structured
    * Document stores (MongoDB)
    * Modeled like a tree.
  * Graph data
    * Nodes / edges.
    * Social network.
    * Operations include traversing the network to find patterns
  * Text data
    * Articles, reports

* Streaming Data
  * Infinite low of data coming from a data source.
  * Data rates vary. Can be too fast / too large to store.
  * Often processed in memory.
  * Common use case: alerts / notifications are noticed from streaming data, raise alerts.

* DBMS and BDMS
  * BDMS
    * Designed for parallel and distributed processing.
      * Data is partitioned across machines to allow parallel computation.
    * May not guarantee ACID consistency across machines.
      * Eventual consistency.
    * Often built on Hadoop.
      * Automatic replication.
      * Map reduce ability.

#### Why is Big Data Processing Different?

* Requirements for Big Data Systems
  * DBMS systems do not scale out.
  * When you hit capacity, you start queuing up events.
  * You'll need to administer additional databases (more complex with DBMS).
  * DBMSs not designed for distributed processing will not scale out.

* BDMS
  * BDMS increase scalability (commodity clusters) and reduce operational complexity.
  * Spark : data processing scalability across commodity clusters.

* Requirements for Big Data systems (the 5 V's)
  * 1. (Volume) Handle large volumes of data.
    * Partitioning of data across a commodity cluster.
    * Fast data access across cluster.
    * Distributed computations across nodes.
  * 2. Handle Fault Tolerance
    * Replicate data across nodes.
  * 3. Enable scaling out
  * 4. (Variety) Optimized and extensible for many data types.
    * Document, table, key-value, graph, multimedia, streaming.
  * 5. (Velocity) Enable both streaming and batch processing.
    * Low latency processing of streaming data
      * Hadoop is *not* good for stream processing and low latency.
    * Accurate processing of all available data.

### Querying Data Part 1

#### What is Data Retrieval? Part 1

* What is data retrieval?
  * The way in which desired data is retrieved from the data store.
  * How to specify the request (the query language)
  * The internal processing within the DBMS to handle the query (parallelism, security, etc)
  * Consider how streaming changes querying.

* What is a Query Language?
  * Declarative. You specify what to retrieve, not how to retrieve it.
  * SQL
  * PGSQL / T-SQL : Higher level programming languages which embed query languages.

* SQL
  * Standard for structured data.
  * Started out relational, being extended to support other types of data.
  * A SQL query is a filter, projection.

### What is Data Retrieval? Part 2

* Select-Project queries in the large

  * **NOTE : Querying across machines in a cluster is a map reduce problem.**
```
Reduce:
for each machine in parallel {
  execute SELECT query
}

Map:
  Gather results
  Union

Done

```

  * Large tables can be partitioned.
    * Ex: Range partitioning on primary key.
  * Newer systems like Spark-SQL are automatically partitioned across a cluster.
  * Watch for table scans w/ big data! These queries will be broadcasted across all nodes in a cluster.


* Local and Global Indexes
  * An index is a reverse table. It records associated table rows for each index value.
  * A local index indexes the local machine data only.
  * A global index indexes the machines a key is associated with. (ex. "damon" is on machines 1, 2, 10)

### Querying Two Relations

* Querying two relations
  * A JOIN clause relates columns in two tables.
  * `SELECT DISTINCT beer from Likes L, Frequents F WHERE bar='the great american bar' AND F.drinker = L.drinker`

* SPJ Queries (SPJ = Select-Project-Join)
  * Select : The `WHERE` clause is executed first to filter the result set.
  * Join : The relations are joined.
  * Project : Only the desired columns are kept from the result set.
  * Deduplicate : Remove redundancy.

* Join in a distributed setting
  * Semijoin
    * The problem with joins across machines is data from multiple tables need to be joined together.
    * Step 1. Retrieve required results from Table A.
    * Step 2. Copy results to a designated machine for joining against the results from Table B.
    * Step 3. Copy results to a third machine for final processing.

  * **A distributed DB will handle this processing for you. Hadoop by itself will not.**

#### Subqueries

* Uncorrelated Subqueries
  * The results from the first (inner) query is sent to the second (outer) query.
  * The queries are completely independent. (Uncorrelated)

* Correlated Subqueries
  * The subquery needs to run for each record in the parent query. This is expensive.
  * Correlated subqueries occur when values from the parent query are used in the subquery.
    * `SELECT product, price from Sells S1 WHERE price > (SELECT AVG(price) FORM Sells S2 WHERE S1.bar = S2.bar)`

* Aggregate queries
  * AVG, MIN, MAX, COUNT

* GROUP BY : allows you to produce statistics aggregated by groups.
  * `SELECT ProductName, AVG(Rate) FROM Table WHERE Column = 'test' GROUP BY ProductName`
  * The grouping variable in the above query is `ProductName`.

* Grouping Aggregates over Partitioned Data
  * If results are on multiple machines, results are calculated locally on each machine (map reduce).
  * Results are mapped together to produce the final output.

#### Week One Hands On

```
$ psql

\d (list tables)
\d [tablename] (describe table "tablename")
```

--------------------------------------------------------------------------------

## Week 2

### Connecting to MongoDB

```

// Start mongo
$ cd big-data-3/mongodb
$ ./mongodb/bin/mongod --dbpath db

// Open a query terminal
$ ./mongodb/bin/mongo

> show dbs
> use <dbname>
> show collections
> db.users.findOne() // your query here.

```

### Querying JSON Data with MongoDB

* MongoDB stores JSON data (semistructured).
* We move from relational `SQL` queries to tree traversal.
* JSON has arrays and dictionaries, which are nested.

* SQL SELECT and MongoDB find()
  * MongoDB is a collection of documents.
  * db.collection.find(<query filter>, <projection>).<cursor modifier>
  * `collection` is similar to `FROM`. Specifies the source.
  * `query filter` is like `WHERE`.
  * `projection` is like `SELECT`.
  * `cursor modifier` filters results or define which portion.

* Some simple queries
  * SQL: `SELECT * FROM Beers`
  * MongoDB : db.Beers.find()

  * SQL: `SELECT beer, price FROM Sales`
  * MongoDB: `db.Sells.find( {}, {beer: 1, price:1 } )`
    * 1 == project this column. By default, all elements have an `_id` field.
    * Setting `{ _id:0 }` will suppress that column.

* Adding Query Conditions (`WHERE`)
  * SQL: `SELECT manufacturer FROM Beers WHERE name = 'Heineken'`
  * MongoDB: `db.Beers.find( {name: "Heineken"}, {manufacturer:1, _id:0})`

  * SQL: `SELECT DISTINCT beer, price FROM Sales WHERE price > 15`
  * MongoDB: `db.Sells.distinct( {price: { {$gt: 15 } }, { beer:1, price:1, _id:0})`

* Regular Expressions (SQL `LIKE`)
  * Count the number of manufacturers whose names have the partial string `am` in it - must be case insensitive.
  * `db.Beers.find(name: {$regex:/am/i}).count()`
  * `db.Beers.find(name: {$regex:/^Am/}).count()` (case sensitive for all starting with `Am`)
  * `db.Beers.find(name: {$regex:/^Am.*corp$/}).count()` (case sensitive for all starting with `Am` ending with `corp`)

```
{
  _id: 1,
  item: "bud",
  tags: ["popular", "summer", "Japanese"],
  rating: "good"
}
```
* Array operations
  * Find items which are tagged as `popular` **or** `organic`
    * `db.inventory.find({tags: {$in: ["popular", "organic"]}})`
  * Find items which are **not** tagged as `popular` **nor** `organic`
    * `db.inventory.find({tags: {$nin: ["popular", "organic"]}})`
  * Extract a portion of an array. Find the 2nd and 3rd elements of tags.
    * `$slice[1, 2]` == start at element 1, take length of 2
    * `db.inventory.find( {}, {tags: {$slice: [1, 2]}})`
      * Returns `["summer", "Japanese"]`
  * Find a document whose 2nd element in tags is "summer" (`tags.1`) or more generally (`key.position`)
    * `db.inventory.find( {}, {tags.1: "summer"})`

* Compound statements

```

Finds the cheapest or most expensive beers which are "good" or have a low quantity whose name
does not contain "coors". (This is a contrived query to demonstrate logical operations)

SQL:

SELECT * FROM inventory WHERE
  ((price > 100) OR (price < 1)) AND
  ((rating = 'good') OR (qty < 20)) AND
  (item NOT LIKE '%coors%')

db.inventory.find({
  $and: [
    {$or: [{price: {$gt: 100}}, {price: {$lt: 1}}]},
    {$or: [{rating: "good"}, {qty: {$lt: 20}}]},
    {item: {$regex: /coors/i"}}
  ]
})

```

* Queries over Nested Elements

```

Assume a collection with the following documents.

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
  * Find users whose first point total is < 80. Returns `_id: 2`
    * `db.users.find({'points.0.points': {$lte: 80}})`
  * Find users who have one or more point total below 80. Returns `_id: [1, 2]`
    * `db.users.find({'points.points': {$lte: 80}})`
  * Find users who have a points tuple with points <= 81 AND bonus == 20. Returns `_id: 2`
    * Note the `,` is treated as an implicit `$and` when querying each node.
    * `db.users.find({'points.points': { $lte: 81}, 'points.bonus': 20})`
  * **MongoDB does not have adequate support to perform recursive queries over nested substructures**.
    * i.e., you can't return all child nodes for a given node.
    * **Mongo DB does not support recursive search.**

### Aggregation Functions

* On Counting and Distinct
  * SQL: `SELECT COUNT(*) FROM Drinkers`
  * MongoDB: `db.Drinkers.count()`

  * Count the number of unique addresses
    * SQL: `SELECT COUNT(DISTINCT addr) FROM Drinkers`
    * MongoDB: `db.Drinkers.count(addr: {$exists: true})`

  * Get the distinct values of an array.
    * Data: `{_id: 1, places: ["USA", "France", "Spain", "UK", "Spain"]}`
      * `db.countryDB.distinct(places)`
        * `["USA", "France", "Spain", "UK"]`
      * `db.countryDB.distinct(places).length`
        * `4`

* Aggregation Framework
  * Modeled on the concept of a data processing pipeline.
  * Grouping, aggregate, function, sorting, ...
  * The `$match` below matches first, followed by grouping. Matching first filters out unwanted rows, speeds processing.
  * The interesting thing about the query below is the column names are passed
    as strings into the `$group` operator. The `$` within the string is telling
    mongo that it's a variable, not a constant.

  * Records are grouped by `$cust_id` and `$amount` is aggregated.
  * Note that `$sum` in the following query is the reduce function (the field being aggregated).

  * Mongo data is sharded. Aggregations happen on a sharded collection.

```

The $match function executes first to filter results.
The $group attribute has two arguments
  1. The elements to group by ($cust_id).
  2. The elements to map ($amount).

db.orders.aggregate( [
  { $match: { status: "A" }},
  { $group: { _id: "$cust_id", total: { $sum: "$amount" } } }
  ])


Returns:

{
  _id: "A123"  // the "$cust_id" field
  total: 2345  // the $sum of "$amount"
}
```

* Multi-attribute Grouping

```

The following groups by multiple attributes, using the $sum function
as the mapping function.

db.computers.aggregate(
  [
    {
      $group: {
        _id: { brand: "$brand", title: $"title", category: "$category", code: "$code" },
        count: { $sum: 1}
      }
    }
    {
      "$sort: { count: 1, category: -1 }"  // count asc, category desc
    }
  ]
)
```

* Text Search with Aggregation
  * Mongo has a text search engine that is invoked via the same aggregation engine.
  * Having either `Hillary` or `Democrat` will match the document.
  * `$meta` is a computed element which is a result of the text search.

```
db.articles.aggregate(
  [
    { $match: { $text: { $search: "Hillary Democrat" } } },
    { $sort: { score: { $meta: "textScore" } } },
    { $project: { title: 1, _id: 0 } }
  ]
)
```

* JOIN in MongoDB (lookup)
  * Join was introduced in Mongo 3.2.
  * Join is part of the aggregation pipeline as a `$lookup` operation.
  * Note that null matches null objects or implicitly if the field does not exist.
    * In the following case, order 3 has an implicitly `null` `"item"` attribute.
      * Inventory document 5 matches null explicitly, 6 implicitly since the sku field is missing.

```
orders:

{ "_id" : 1, "item" : "abc", "price" : 12, "quantity" : 2 }
{ "_id" : 2, "item" : "jkl", "price" : 12, "quantity" : 2 }
{ "_id" : 3 }

inventory:

{ "_id" : 1, "sku": "abc", description: "product 1", "instock": 120 }
{ "_id" : 2, "sku": "def", description: "product 1", "instock": 80 }
{ "_id" : 3, "sku": "ijk", description: "product 3", "instock": 70 }
{ "_id" : 4, "sku": "jkl", description: "product 4", "instock": 70 }
{ "_id" : 5, "sku": null }
{ "_id" : 6 }


db.orders.aggregate([
  {
    $lookup: {
      from: "inventory",
      localField: "item",
      foreignField: "sku",
      as "inventory_docs"
    }
  }
])


{
  "_id" : 1,
  "item" : "abc",
  "price": 12,
  "quantity" : 2,
  "inventory_docs" : [{
    "_id" : 1,
    "sku" : "abc",
    "description" : "product 1",
    "instock" : 70
  }]
},
{
  "_id" : 2,
  "item" : "jkl",
  "price": 12,
  "quantity" : 2,
  "inventory_docs" : [{
    "_id" : 4,
    "sku" : "jkl",
    "description" : "product 4",
    "instock" : 70
  }]
},
{
  "_id" : 3,
  "inventory_docs" : [{
      "_id" : 5,
      "inventory_docs" : [
        {
          "_id" : 5,
          "sku" null
        },
        {
          "_id" : 6
        }
      ]
    }]
}
```

### Querying Aerospike

* Aerospike's query language, `AQL`, is geared around geospacial queries.

* Why would you store each field in a separate bin individually?

* Aerospike is a key/value store.
* Data is organized in namespace. A namespace is a top level data container.
* Each namespace contains indexes and policies.
  * Policies tell Aerospike how to store the data (ram or SSD), how many replicas are required, TTL.

* Areospike hierarchy.
  * Namespace ("database")
    * Sets ("tables")
      * Each set has a "key" ("primary key")
      * Bins ("fields" - name / value pairs)

* AQL : Much like SQL.

* Querying fast data
  * Streaming is infinite and fast.
  * Data is gathered in windows for a unit of processing.
  * Query engines must account for window overlap.
  * Bottom line : Streaming data changes the way a query processor works.


### Quiz

* What does it mean for a query language to be declarative?
  * The language specifies what data to obtain.

* How would you go about querying the entire username column (however many)?
  * SELECT username FROM user_table

* How would you go about querying the entire database table (please refer to question 2's table)?
  * SELECT * FROM user_table

* What is the global indexing table?
  * An index table in order to keep track of a given data type that might exist within multiple machines.

* What are the three computing steps of a semi-join?
  * Project, Ship, Reduce

* What is the purpose of a semi-join?
  * Increase the efficiency of sending data across multiple machines.

* What is a subquery
  * A query statement within another query.

* What is a correlated subquery?
  * A type of query that contains a subquery that requires information from a query one level up.

* What is the purpose of GROUP BY queries?
  * Enables calculations based on specific columns of the table.

* Which part of the statement would reflect that of the FROM statement in SQL as illustrated in the lecture?
  * <collection>

* Which part of the statement would reflect that of the SELECT statement in SQL as illustrated in the lecture?
  * <projection>

* Which part of the statement would reflect that of the WHERE statement in SQL as illustrated in the lecture?
  * <query filter>

* What would be the most likely statement that we would need to grab email info for user indexes greater than 24?
  * `db.email.find({userIndex:{$gt:24}}, {email:1, _id:0})`

*  What does it mean to have a `_id:0` within our query statement?
  * Tell MongoDB not to return a document id.

### Hands-on Quiz (Postgres, MongoDB, Pandas)

* What is the highest level that the team has reached in gameclicks? (Hint: use the MAX operation in postgres).
  * `psql`
  * `SELECT MAX(teamlevel) FROM gameclicks;`
  * `8`

* How many user id's (repeats allowed) have reached the highest level as found in the previous question? (Hint: For postgres: you may either use two queries or use a sub-query).
  * `SELECT COUNT(*) FROM gameclicks WHERE teamlevel = (SELECT MAX(teamlevel) FROM gameclicks);`
  * `51294`

* How many user id’s (repeats allowed) reached the highest level in game-clicks and also clicked the highest costing price in buy-clicks? Hint: Refer to question 4 for ideas.
  * `32747`

```
SELECT COUNT(*) FROM gameclicks GC JOIN buyclicks BC ON GC.userId = BC.userId
  WHERE
    GC.teamlevel = (SELECT MAX(teamlevel) FROM gameclicks) -- highest level in game
  AND
    BC.price = (SELECT MAX(price) FROM buyclicks) -- highest costing price
```

* What does the following line of code do in postgres?

`SELECT count(userid) FROM (SELECT buyclicks.userId, teamLevel, price FROM buyclicks JOIN gameclicks on buyclicks.userId = gameclicks.userId) temp WHERE price=3 and teamLevel=5;`

  * Finds the total number of user ids (repeats allowed) in buy-clicks that have bought items with prices worth $3 and was in a team with level 5 at some point in time.

* In the MongoDB data set, what is the username of the twitter account who has a tweet_followers_count of exactly 8973882?
  * `db.users.findOne( { tweet_followers_count: 8973882 , { user_name: 1}})`
  * `FIFAcom`

--------------------------------------------------------------------------------

## Week 3 : Information Integration

### Overview of Information Integration

Information integration is combining (integrating) data from multiple data sources.

* A business case (from IBM)
  * Mergers / Acquisitions require integration, potentially with completely different data structures (insurance company and bank).
  * Consolidating data from different regions / different systems provides global visibility.

* An "integrated view" is a view (or table) which combines data from multiple data sources.

* Schema Mapping
  * Mapping source schema -> target schema.

* Querying Integrated Data
  * Querying data in an integrated system is more complicated than querying a traditional store.
    * Where to retrieve data? Depending on where the data is stored, you may have to compute on the fly.
      * "Materialized" : Data is pre-computed and stored.
      * "Virtual" : Data is computed on the fly.

* Record Linkage
  * Linking the same entity across different data stores.
  * User record clustering or pattern matching to group like records.
    * "Lisa Jackson, 1234 first street"
    * "Elizabeth Jackson, 1234 first St."

* The "Big Data" Problem
  * Many sources
    * Hundreds of tables.
    * Schema mapping problem is combinatorial model.
  * How to solve "big data" integration problems?
    * "Pay as you go model"
      * Don't integrate data from different systems until you need it. Keep data in their original stores and query using best effort logic. Results may not be perfect, but that may be OK.
      * As you determine frequently accessed data stores, formally integrate the sources.
    * Probabilistic schema mapping
      * Determine via statistics and algorithms which target schema is ideal.

* Designing Mediated (Integrated) Schema
  * Need to determine how to map data.
  * How are identities mapped?
  * Which elements should be grouped together?

* Attribute Grouping : how do you group attributes together in the target (mediated) schema?
  * How similar (related) are the attributes?
  * If you assign similarity values to each attribute, you *could* algorithmically generate the target schema.


### A Data Integration Scenario

* How is a query answered in the virtual data integration setting?
  * Virtual data integration occurs when data is stored in their original systems.

* Example Schema Mapping
  * How do you map source to target schema?
  * "Local as view (LAV)" mapping
    * You define a local "view" and map that view to the source schemas.

* Query Answering
  * The query engine must translate the query meant for the target schema into queries against the source schemas.

* Example : Integration of Public Health Infrastructure
  * In health care, the standard is "HL7 (Health Level 7)".
  * The problem is there are multiple, differing implementations of the standard.

  * Data Exchange
    * Given source and target schemas, how to map data from source to target?

  * Using Codebooks
    * Data standards

  * Compression
    * Dictionary encoding.
    * Data in column DBs, columns can be compressed.

  * Ontological Data
    * The domain is represented in an ontology.
    * Ontology queries are graph queries.

  * Takeaway points (summary)
    * Data variety complicates integration.
    * Standards can often act as "Global Schemas"
    * Data Exchange Challenges
      * Format conversions.
      * Constraints.
      * Data Compression.
      * Model Transformation. Taking data in one system, convert to a model in the target system.
      * Query Transformation. Taking a query against a target schema must be tranlated to the source system.

### Integration for Multichannel Customer Analytics

* How to integrate data across multiple business channels?
  * How successful are marketing campaigns?
  * Where is the company deficient across product lines?
  * Where is the market opportunity?

* Data Fusion
  * The goal of data fusion is to find a true value for an attribute (customer satisfaction) across different data sources.
  * Each data source may measure the value differently.
  * Example: how satisfied are you with this keyboard?
    * Source 1 : rates from 1-10.
    * Source 2 : rates "not happy, happy, very happy"

* Too many sources!
  * There are potentially too many data sources, especially on the internet.
  * You need to find the best sources.
    * Accurate? Trustworthy?
    * Was the data copied from another source?
    * Each source receives a "score" or "bias" and estimate value to each data source.

* Source selection
  * Give each source an overall score.
  * Choose only the best sources **before** integration.
  * Adding sources improves quality around 6-8 sources. At some point, adding more sources does not improve accuracy.

### Quiz

* What is the main problem with big data information integration?
  * Many sources

* What would be the two possible solutions associated with "big data" information integration as mentioned in lecture? (Choose 2)
  * Probabilistic Schema Mapping
  * Pay-as-you-go Model

* What are mediated schemas?
  * Schema created from integrating two or more schemas.

* In attribute grouping, how would one evaluate if two attributes should go together? (Choose 2)
  * Similarity of Attributes
  * Probability of Two Attributes Co-occurring

* What is a data item?
  * Data that represents an aspect of a real-world entity.

* What is data fusion?
  * Extracting the true value of a data item.

* What is a potential problem of having too many data sources as mentioned in lecture?
  *  Too many data values.

* What do we mean when we say "the true value of a data item"?
  * Extrapolated data from a data item that represents the worth of that item.

* What is a potential method to deal with too many data sources as mentioned in lecture?
  * Compare and weigh each source by their trustworthiness.


### Industry Examples for Big Data Processing and Integration

#### Big Data Management and Processing using Splunk and Datameer

* Why Splunk?
  * Analytics / real time data reporting.
  * Machine data (servers -> IoT).
  * Doesn't rely on schemas.

* Ford / Splunk
  * ODB port data to determine driver behavior across gas and electric cars.
  * Do drivers driver differently when using a gas / electric car?
  * How efficient are the drivers?

#### Big Data Management and Processing using Datameer

* Music reservation for pono music.
  * Neil Young. High resolution audio. It's dead.
  * Needs a recommendation engine tailored to each user.

* Datameer is an analytics platform.
  * Full stack analytics platform. Ingestion -> Reporting.
  * Based on hadoop / spark / D3 front end for visualizations.

* Data is ingested via import jobs.
  * Salesforce (buying data), other APIs.

* Processing data
  * Import jobs create "sheets" (think Excel). You then join data sheets together.
  * You query data in the "sheets" via a visual web editor. It's a WYSIWYG editor. It's crap.
  * You create "output" sheets, which can be exported.

* Operationalizing
  * Once you have the processing setup, you can export the data into JSON.
  * You create "export jobs" to export data.

#### Quiz : Hands-On: Big Data Management and Processing Using Splunk

* Which of the queries below will return the average population of the counties in Georgia (be careful not to include the population of the state of Georgia itself)?
  * `source="census.csv" CTYNAME != "Georgia" STNAME="Georgia" | stats mean(CENSUS2010POP)`

* What is the average population of the counties in the state of Georgia (be careful not to include the population of the state of Georgia itself)?
  * `source="census.csv" CTYNAME != "Georgia" STNAME="Georgia" | stats mean(CENSUS2010POP)`
  * 60928.635220

* Of the options below, which query allows you to find the state with the most counties?
  * `stats count by STNAME | sort -count`

* What state contains the most counties?
  * Texas

* Of the options below, which query allows you to find the most populated counties in the state of Texas?
  * Both

* What is the most populated county in the state of Texas?
  * Harris


--------------------------------------------------------------------------------

## Week 4

### Big Data Pipelines and High-level Operations for Big Data Processing

#### Big Data Processing pipelines

* Big data is processed in pipelines.

* Map reduce processing pipeline
  * Split -> Map -> Shuffle / Sort -> Reduce
  * Split -> Do -> Merge

* Big Data Pipelines
  * Data parallelism : running the same function across chunks of data in parallel (map / reduce).
  * Big data pipelines are modeled after unix process pipes.

* Kafka -> Storm (chunk into small batches) -> Real time view (or batch view storage)

#### Some High-Level Processing Operations in Big Data Pipelines

There are common big data transformations.

* Transformations are higher order functions to shape data.

* Map
  * Apply same operation to each member of a collection.

* Reduce
  * Collecting things that have the same `key`.

* Cross / cartesian
  * Operating on each pair from two sets.

* Match / Join
  * Operating on each pair from two sets which have the same `key`.

* Co-Group
  * Group common items.
  * Apply a process to each collection.

* Filter
  * Select elements that match a criteria.


#### Aggregation Operations in Big Data Pipelines

* Aggregation : a transformation which takes all elements as input (sum).
  * Group by
  * Statistics : mean, median, mode, sum, min, max, standard deviation.

* Aggregation typically results in smaller, more organized data sets.

#### Typical Analytical Operations in Big Data Pipelines

* The (obvious) goal of analytical operations (analysis) is to discover trends which ultimately drive product decisions.
* Patterns -> Insights -> Decisions

* Classification
  * The goal is to classify data into categories.
  * Examples
    * Classifying a stock into a risk profile (high, medium, low risk).
    * Pattern recognition

* Classification : Decision Tree
  * Decisions are modeled as a tree structure.
  * Each data element traverses a tree. The leaves of the tree specify the classification of the data element.

* Cluster Analysis (clustering)
  * Goal is to organize groups into similar associations.
  * Example
    * Social media - clustering people into preference groups. (Apple fans, Google fans).
    * Grouping customers into clusters for targeted marketing.
    * Grouping articles with similar topics.
  * k-means clustering
    * Samples are grouped into `k` clusters.

* Path Analysis
  * Analyzes sequences of nodes in a graph.
  * Example : find shortest path from home to work. May be different based on traffic, weather, etc.

* Connectivity Analysis
  * Analyzing graphs to determine how connected nodes are.
  * Highly interacting groups are more connected. They are called `communities`.
  * Example
    * Social network graphs - find people
    * Find influencers.

* Machine Learning Algorithms
  * Classification
  * Regression
  * Cluster Analysis
  * Associative Analysis

* Graph Analytics Techniques
  * Path Analysis
  * Connectivity Analytics
  * Community Analytics
  * Centrality Analytics

* Main take away
  * The goal of analytics is to provide actionable insights.


### Big Data Processing Tools and Systems

* Hadoop Ecosystem
  * Data Management and Storage
    * HDFS : distributed FS.
    * Redis / Areospike : key value stores
    * Lucene : text (vector) search
    * Gephi : graph
    * Cassandra / HBase
    * MongoDB : document store
  * Data integration and processing
    * Most are implemented on top of YARN.
    * Storm, spark, flink, pig (scripting), hive.
  * Coordination and workflow management
    * Scheduling, coordinating of jobs.
    * Apache Zookeeper

#### Big Data Workflow Management

* A big data workflow is the process of
  * Acquiring -> Preparing (i.e., ETL) -> Integration -> Analysis -> Visualization -> Dissemination

#### The Integration and Processing Layer

* Categorization of big data processing systems (how do we pick a set of tools?)
  * Execution model : batch or streaming.
  * Latency : do you need low (online gaming) or OK with high latency (batch)
  * Scalability
  * Programming Language
  * Fault tolerance

* Big Data Processing Systems

  * MapReduce
    * Execution model : batch
    * Latency : high
    * Scalability
    * Programming Language : java
    * Fault tolerance : replication

  * Spark
    * Batch and stream using disk or memory.
    * In memory structure (Resilient Distributed Dataset (RDD)).
    * Scala, Python, R
    * Because data sets are in memory, performance is high for in memory processing.
    * Processing is done in "micro" batches, making it not ideally suited for real time critical stream processing.

  * Flink
    * Batch and stream processing using.
    * Optimizer

  * Beam (Google)
    * Streaming and windowing framework.
    * Highly scalable.

  * Storm
    * Real time stream processing with low latency.
    * Many programming languages.

* Lambda architecture
  * Splitting incoming data into both batch and stream layers.


#### Introduction to Apache Spark

* Why Spark?
  * Hadoop is solely based on Map Reduce. Not all problems fit into this model.
  * i.e. Join between data sets, grouping data, performing multiple stages of map reduce.
  * Relies on reading data from HDFS. Will not work for iterative algorithms.
  * Native support for Java only.
  * No interactive shell support. Scientists prefer REPL support.
  * No support for streaming.

* Basics of Data Analysis with Spark.
  * Multiple distributed data transformations available.
  * In memory processing (fast) for iterative applications.
  * Support for batch and streaming workflows.
  * Interactive Shell (python, scala, java)

* The Spark Stack
  * SparkSQL | Spark Streaming | MLLib | GraphX
  * Spark Core
    * Distributed scheduling.
    * Memory Management
    * YARN interaction
    * RDD API (carry data between nodes).
  * SparkSQL
    * Querying structured / unstructured data.
    * Converts results to RDDs.
  * Spark Streaming
    * Creates small aggregate data sets (micro-batches) from streaming data.
    * Each micro batch can be made into an RDD.
  * MLLib
    * Spark native library for ML algorithms.
  * GraphX
    * Graph analytics / processing.

#### Getting Started With Spark : Concepts and Architecture

* What does in memory processing mean?
  * Memory operations are up to 100k times faster than disk I/O.
  * Resilient Distributed Datasets are how spark distributes data across machines.

* RDDs : Resilient Distributed Datasets
  * Datasets
    * Come from external sources (JSON, HDFS, Kafka, S3, SQL, anywhere).
    * RDDs are immutable.
  * Distributed
    * Across clustered machines (i.e., AWS).
    * Divided in partitions.
  * Resilient
    * Tracks history of each RDD over time.
    * If one node (partition) of data is disrupted, spark can replay the single failed node.

* Spark Architecture
  * Driver Program | Worker Node
  * Cluster Manager (YARN)
    * Manages worker nodes. Creates, restarts workers.
  * Worker Node
    * Executor (JVM)
    * PySpark will use multiple python processes running against a single executor JVM.

#### Quiz : Pipeline and Tools

* What is data-parallelism as defined in lecture?
  * Running the same function simultaneously for the partitions of a data set on multiple cores.

* Of the following, which procedure best generalizes big data procedures such as (but not limited to) the map reduce process?
  * split->do->merge

* What are the three layers for the Hadoop Ecosystem? (Choose 3)
  * Data Management and storage
  * Data Integration and Processing
  * Coordination and Workflow Management

* What are the 5 key points in order to categorize big data systems?
  * Execution model, Latency, Scalability, Programming Language, Fault Tolerance

* What is the lambda architecture as shown in lecture?
  * A type of hybrid data processing architecture.

* Which of the following scenarios is NOT an aggregation operation?
  * Removing undefined values.

* What usually happens to data when aggregated as mentioned in lecture?
  * Data becomes smaller.

* What is K-means clustering?
  * Group samples into k clusters.

* Why is Hadoop not a good platform for machine learning as mentioned in lecture? (Choose 4)
  * Map and Reduce Based Computation.
  * Java support only.
  * No interactive shell and streaming.
  * Bottleneck using HDFS.

* What are the layers (parts) of Spark? (Choose 5)
  * SparkSQL
  * Spark Streaming
  * MLLib
  * GraphX
  * Spark Core

* What is in-memory processing?
  * Having the input completely in memory.

#### Quiz : Wordcount in Spark

* What does the following line of code do?
  `words = lines.flatMap(lambda line: line.split(“ “))`
  * Each line in the document is split up into words.

* What does the following line of code imply about the state of partitions before the action is performed?
  `words = lines.flatMap(lambda line: line.split(“ “))`
  * Each Spark partition corresponds to a line in the document.

* When the following command is executed, where is the file written and how can it be accessed?
  `counts.coalesce(1).saveAsTextFile(‘hdfs:/user/cloudera/wordcount/outputDir’)`
  * HDFS and through the “hadoop fs” command.

* What does the number one (1) allow us to do in the following line of code?
  `tuples = words.map(lambda word: (word,1))`
  * Treat each word with a weight of one during the counting process.


--------------------------------------------------------------------------------

## Week 5 : Big Data Analytics using Spark

### Programming in Spark

#### Spark Core : Programming in Spark using RDDs in pipelines

* The "driver" is the main entry point for a spark application. It contains a spark context.
* Spark is split into a driver / worker node architecture.
* Spark deals entirely in RDDs (immutable). RDDs are distributed across nodes. (Resilient Distributed Dataset).

* Creating RDDs
  * `lines = sc.parallelize(["big", "data"])`
  * `numbers = sc.parallelize(range(100), 3) // split across three partitions`
  * `numbers.collect() // gather all nodes from partitions.`

* Processing RDDs
  * Transformations (map, filter) - lazy evaluated when an action is executed (like Haskell or Erlang).
  * Actions (collect) = performs validation, converts into results.
  * RDDs can be cached (watch memory usage).

* Programming in spark
  * Create RDDs -> apply transformations -> perform actions

#### Spark Core : Transformations

* Transformations
  * All RDDs are immutable. Applying a transformation on an RDD creates a new RDD.
  * Transformations are lazily applied. Typically when an action is performed.

* map : apply a function to each element of an RDD (1 -> 1 transformation)
  * RDDs are partitioned. Each worker nodes contains N number of partitions.

* flatMap : map, then flatten the output.

* Narrow transformations (map / flatMap)
  * Processing logic only uses data within the partition. We don't need to shuffle data to perform the transformation.

* filter (narrow transformation)

* coalesce (reduce the number of partitions)
  * Use when you have reduced the RDD size.

* Wide Transformations
  * Requires data from other partitions to be shuffled in order to perform transformations.
  * `groupByKey` / `reduceByKey` : require data to be shuffled across partitions.

#### Spark Core : Actions

* Actions terminate a spark pipeline.

* Example actions
  * `.collect()` : all resulting RDDs from workers are copied to the JVM on the driver node.
  * `take(n)`
  * `reduce(func)`
  * `saveAsTextFile(filename)` : saves to local disk / HDFS (use when results are large)

* If results are too large for the driver, results can be written directly to storage (HDFS).

* The spark ecosystem provides APIs in `java`, `scala`, and `python`.


### Main Modules in the Spark Ecosystem

#### Spark SQL

* Query structured and unstructured data.
* Provides a common query language on top of multiple existing data structures.
* APIs for Scala, Java, and Python (like all of spark core).

* Relational Operations
  * Embed SQL queries in Spark programs.
  * Allow programs to access data using JDBC and ODBC.
    * BI tools, SQL databases, any other application which contains a JDBC / ODBC implementation.

* DataFrames
  * Distributed data organized as named columns.
  * Spark SQL can also return data frames.
    * Data frames are like relational tables.

* How to use SparkSQL?
  * Create a `SQLContext`
  * Create a `DataFrame` from
    * An existing RDD.
    * A Hive table.
    * Data sources (JDCB / ODBC).


```
from pyspark.sql import SQLContext
sqlContext = SQLContext(sc)

# create a data frame from a JSON file.
df = sqlContext.read.json("/filename.json")

# display data frame in spark shell.
df.show()

# DataFrames are just like tables.
df.printSchema()

# Select only the "X" column
df.select("X").show()

# Select everybody, but increment the discount by 5%.
df.select(df["name"], df["discount"] + 5).show()

# Select people height greater than 4.0 ft
df.filter(df["height"] > 4.0).show()

# Count people by zip
df.groupBy("zip").count().show()

```

* A `DataFrame` can be created from an RDD of Row objects.


#### Spark Streaming

* Data streams are converted into discrete RDDs.

* Spark streaming sources.
  * Kafka. Pub / sum messaging system.
  * Flume. Collect / aggregate log data.
  * HDFS
  * S3
  * Twitter
  * Socket
  * API
  * Etc....

* Streaming -> Discretize (micro batches) -> DStream -> Transformations -> DStream -> Action -> Results
* DStreams are grouped into windows.

* Main take aways
  * The goal of spark streaming is to convert streaming data into batch RDDs, which allow streaming sources to be treated like any other RDDs.
  * DStreams can create a sliding window to perform calculations on a window of time.

#### Spark MLLib

* What is Spark MLLib?
  * MLLib is an ML library running on top of spark core.
  * MLLib provides distributed implementations of common ML algorithms and utilities.
  * APIs for Scala, Java, Python, and R (just like the rest of Spark).

* MLLib Algorithms and Techniques
  * Machine Learning
    * Classification, regression, clustering, etc.
  * Statistics
    * Summary statistics (mean, stddev, etc).
    * Methods to sample a dataset.
  * Utilities
    * Dimensionality reduction, transformation, etc.

* MLLib Example - Summary Statistics

```
from pyspark.mllib.stat import Statistics

# data as RDD
dataMatrix = sc.parallelize([[1,2,3], [4,5,6], [7,8,9], [10,11,12]])

# Compute column summary statistics
summary = Statistics.colStats(dataMatrix)
print(summary.mean())
print(summary.variance())
print(summary.numNonzeros())
```

* MLLib Example - Classification

```
from pyspark.mllib.tree import DecisionTree, DecisionTreeModel
from pyspark.mllib.util import MLUtils

# read and parse data
data = sc.textFile("data.txt")

# Decision tree Classification
model = DecisionTree.trainClassifier(parsedData, numClasses=2)
print(model.toDebugString())
model.save(sc, "decisionTreeModel")
```

* Main take aways
  * MLLib is Spark's machine learning library.
    * Distributed implementation.
  * Main categories of algorithms and techniques
    * Machine Learning
    * Statistics
    * Utility for ML pipelines


#### Spark GraphX

* What is GraphX?
  * Spark's API for graphs and graph computation (in parallel).

* GraphX uses a property graph model.
  * Both Nodes and Edges can have attributes and values.

* Properties -> Tables
  * Vertex Table
    * Contains nodes properties.
  * Edge Table
    * Contains edge properties.

* GraphX uses special RDDs
  * VertexRDDs and EdgeRDDs

* Triplets
  * A view which logically joins vertex and edge properties.
    * "A E[A-B] B" : Nodes A and B are joined by Edge [A-B]. This is a triplet.

* Pregel API
  * Bulk-synchronous parallel messaging mechanism. (?)
  * Constrained to the topology of the graph.

* Summary
  * GraphX is used for parallel graph computations.
  * Special RDDs for storing Vertex and Edge information.
  * Pregel operator "works in a series of super steps" (?)

#### Quiz

* Which part of SPARK is in charge of creating RDDs?
  * Driver Program

* How does lazy evaluation work in Spark?
  * Transformations are not executed until the action stage.

* What are the consequences of lazy evaluation as mentioned in lecture?
  * Errors sometimes do not show up until the action stage.

* What is a wide transformation?
  * A transformation that requires data shuffling across node partitions.

* Where does the data for each worker node get sent to after a collect function is called?
  * Spark Context

* What are DataFrames?
  * A column like data format that can be read by Spark SQL.

* Can RDD's be converted into DataFrames directly without manipulation?
  * No: lines have to be converted into row.

* What is the function of Spark SQL as mentioned in lecture? (Choose 3)
  * Deploy business intelligence tools over Spark.
  * Enables relational queries on Spark.
  * Connect to variety of databases.

* What is a triplet in GraphX?
  * A type of data to contain the information on connections between vertices and edges.

#### Quiz (Hands on With SparkSQL / Spark Streaming)

* What does the following filter line of code do?
  * `df.filter(df[“teamlevel”] > 1)`
  * Filter each row to show only team levels larger than 1.

* What does the following do?
  * `df.select(“userid”, “teamlevel”).show(5)`
  * Select the columns named “userid” and “teamlevel” and display first 5 rows.

* What does the 1 represent in the following line of code?
  * `ssc = StreamingContext(sc,1)`
  * A batch interval of 1 second.

* What does the following code do?
  * `window = vals.window(10, 5)`
  * Creates a window that combines 10 seconds worth of data and moves by 5 seconds.

#### Quiz : Expressing Analytical Questions as MongoDB Queries

* Query 1: How many tweets have location not null?
  * `db.users.find( { "user.Location" : { $ne: null } }).count()`
  * `6937`

* Query 2 : How many people have more followers than friends?
  * Note that the `where` clause takes a random JS function. This is a bloody hack - Mongo has to
    scan every document and execute the JS string against it! Mongo recommends you save
    this calculation directly into the document to avoid having to calculate it.
    * Find all tweets where the user has more followers than friends.
      * `db.users.find( { $where: "this.user.FollowersCount > this.user.FriendsCount" }).count()`
      * `5809`
      * **NOTE** : This is the answer they are looking for!

    * Find all distinct **users** (by UserId) with more followers than friends.
      * `db.users.distinct( "user.UserId", { $where: "this.user.FollowersCount > this.user.FriendsCount" }).length`
    * `4971`

* Query 3: Return text of tweets which have the string "http://" ?
  * `db.users.find( { 'tweet_text': { $regex: /http:\/\// } }).count()`
  * `10`


* Query 4: Return all the tweets which contain text "England" but not "UEFA"?
  * `db.users.find({
      $and: [
          { tweet_text: {$regex : /England/ } },
          { tweet_text: { $not: /UEFA/ } }
        ]
    }, { tweet_text: 1})`
  * `35`

* Query 5: Get all the tweets from the location "Ireland" and contains the string "UEFA"?
  * `db.users.find({
      $and: [
        { 'user.Location': "Ireland" },
        { tweet_text: /UEFA/ }
      ]
    })`

#### Quiz (Mongo)

* How many tweets have location not null?
  * `6937`

* How many people have more followers than friends? (Hint : use this.user instead of user).
  * `5809`

* Perform a query that returns the text of tweets which have the string "http://". Which of the following substrings do NOT occur in the results? (Choose all that apply)
  * `@infomessi_`
  * `@DundalkFC`

* Query: Return all the tweets which contain text "England" but not "UEFA". In these results the string “Euro 2016” appears in...
  * `0 tweets`

* Query: Get all the tweets from the location "Ireland" which also contain the string "UEFA". In this result the user with the highest friends count is...
  * `ProfitwatchInfo`
