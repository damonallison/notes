# Big Data : Course 2 : Big Data Modeling and Management Systems

# Week 1

## What is in this course?

### What is Big Data Modeling?

* Creating data models (i.e., structured or unstructured) which describes your data.

Understanding your data model forces you to answer questions like:

* What type of storage do you need?
  * Storing images? Perhaps a file system or blob storage like S3.
* What type of processing will you need to run?
  * Real time? Multiple pass algorithms (bad with Hadoop).

### What is big data management?

The goal of data management is to determine what type of infrastructure you'll need need to support the data you're capturing and analysis you're doing.

* Do you need to store multiple replicas?
* Do you need to run statistics / processing on the data? What type?
* Will you need to support real time analytical capabilities?
* What is the difference between data at rest / data in motion?
* Big data is transitioning infrastructure from DBMS (SQL Server, Oracle) to Big Data Management Systems (BDMSs).

They added this course of modeling and management to prepare students for retrieving and processing big data and performing big data analytics, which are coming up in the next courses.

## Why Big Data Modeling and Management?

### Summary of Introduction to Big Data

* Big Data is generated from 3 main sources : devices, people, and organizations.
* Value comes from integrating different data sources.
* Big data -> Insight -> Action

There are two broad sections of big data:

* Big Data Engineering
  * Acquiring
  * Preparing
    * Explore : understanding the data.
    * Pre-process data for easier analysis.
* Computational Big Data Science (Analytics)
  * Analyze
  * Report
    * Summarize
    * Visualize
  * Act

* Hadoop
  * Allows scaling out on commodity boxes, fault tolerant, and custom data types.
  * YARN allows multiple jobs to run simultaneously.
  * Storm / Spark / Flink : real time and in-memory processing. 100x better performance of some tasks.
  * Some data models do not fit well into Map Reduce. Mongo, Cassandra are "hadoop" tools which do not rely on MapReduce.

### Big Data Management "Must-Ask Questions"

* How do we ingest the data?
* Where and how do we store it?
* How can we ensure data quality?
* What operations do we perform on the data?
* How can these operations be efficient?
* How do we scale up data volume, variety, velocity, and access?
* How do we keep the data secure?

### Data Ingestion

* How many data sources?
* How large are the data items?
* Will the number of data sources grow?
* Rate of data ingestion?
* What to do with bad data?
  * Error, flag, report, warn, discard, etc.
* What to do with data is too little or too much?

* "Ingestion policies"
  * Rules, like an exception handler, that indicate what happens when errors happen during ingestion.
  * Examples : auditing, error handling, what do to with data overflow, data loss.
  * Rules around what to do if you can't keep up with real time data processing.

### Data Storage

* How much data to store?
  * Memory, disk units, CPU, etc.
  * How will it scale?
  * Network access storage? Or local storage?

* How fast do we need to read/write?
  * Cache memory (fastest)
  * DRAM
  * Flash (USB / SSD) at least 10x faster than HDD.
  * HDD
  * Network, tape, other external systems.

### Data Quality

* Better quality means better analysis and decision making. (actionable insight)
* Quality assurance means needed for regulatory compliance.
* Quality leads to better engagement and interactions with external entities.

### Data Operations

You must document, define implement, and test the set of operations required for a specific application.

There are broad categories of data operations:

* Operations that work on a single item.
  * An operation that acts on a single record (image, text)

* Operations that works on a collection.
  * Filter a collection (selecting a subset of data)
  * Combining collections.
  * Compute a function on a collection (map reduce).

* Efficiency of data operations
  * Use parallelism where possible.

### Data Scalability and Security

* Scaling up vs. out.
  * Up is typically faster.
  * Out is larger (the trend in big data management).

* Security
  * Data at rest and in transit must be secure.
  * Encryption / decryption increases security but slows down performance.


## Real Big Data Management Applications

### Big Data Applications : Example from an Energy Company

* Smart energy meters. 1.5 billion data points per day (15 min intervals).
* What happens with each interval?
  * Billing
  * Analytics
    * Histograms of hourly usage (daily / monthly).
    * Effect of outdoor temperature.
    * Find trends. Make good predictions for future energy requirements.
    * Group users into categories (for marketing).

### Gaming Industry : Apmetrix CTP Mark Caldwell

* Advice
  * Understand your goals first.
  * Put a taxonomy (data model) together. What are the nouns, verbs, data points that you collect?

* Management challenges : communication and determining what data you want to collect.

### Flight Data Management at FlightStats : A lecture by CTP Chad Berkley

* Real time flight status data.
* Daily ingress
  * ~15M flight events / day (arrival / departure)
  * 260M aircraft positions per day (real time flight tracking - every 10 seconds).

* "The hub" : Stored in S3.
* Their hub is OSS.

* Generated data
  * Trying to get into predictions.
  * Over oceans - they attempt to generate approximate location when planes are over oceans and are not transmitting updates.


--------------------------------------------------------------------------------

# Week 2

## What is a Data Model?

### Big Data Modeling

* Modeling is about describing your data structure, the operations you can perform on your data, and the constraints you place on the models.

* What is the **structure** of your data?

* What **operations** will you perform on your data?
  * i.e., You can perform math on date of birth fields, not name fields.

* What **constraints** are placed on your data?
  * Example constraints:
    * Created By must be greater than '2000-01-01' (value)
    * Each customer must have one or more addresses (cardinality).

### Data Model Structures

* Structured data defines a pattern for data. File formats and data types are examples of structure.
* Unstructured data does not define a structure.

### Data Model Operations

Methods to manipulate data.

* Subsetting (selection or filtering).
  * Find all records with an item price > 100.
* Substructure extraction (projection)
  * Selecting only a few fields from a record.
* Union / Join (combining)
  * Set union will give you the unique set of records, without duplicates.
  * Join : (think T-SQL join) : Data from multiple result sets are joined based on a data field common to both sets (like an ID field).

### Data Model Constraints

* Logical statement about the data.
* Constraints provide semantics (meaning) of the data.
  * Example constraint : a week has 7 days.
  * A movie has only one title.

* Types of Constraints
  * Value constraints. Constraints on a single field.
    * Ex: Age is never negative.
  * Uniqueness constraint
    * Ex: A movie can have only one title.
  * Cardinality constraint
    * A person can take between 0 and 3 blood pressure medications at a time.
  * Type constraint
    * Last name is alphabetical.
    * Domain constraint
      * Ex: The day in a month must be less than 32. Or a more complex data constraint could limit the day in the month based on each month.
  * Structural constraints
    * The number of rows / columns in a matrix must be equal.


## Different Kinds of Data Models (Part 1)

### What is a relational data model?

* Easiest, most frequently used data model.
* Based on tables and schema.
  * Tuples (rows) are atomic. Each field contains exactly one value (or null).
  * Schema specifies constraints.
    * Null / not null.
    * Value constraints (> 25000)
    * Primary keys provide uniqueness constraints.
  * Foreign keys reference fields from a parent table. Foreign keys exist in the child table.
  * JOIN is expensive (a reason big data systems denormalize data).

* People typical start in Excel, with .csv.
* Spreadsheets do not enforce data structure principles (and thus bad or poorly structured data).
* Non-atomic : columns which have two values.

### What is a semistructured data model?

* WWW is semistructured.
* Most semistructured data is tree structured.
* XML is semistructured.
  * Some elements have multiple children.
* JSON is semistructured.

* The model for most semistructured data is a tree.
  * Trees allow navigational access. (get-parent, get-children, get-siblings).
  * Find all nodes with a certain value.

### Week 2 Quiz

* What is the approximate population of La Paz county in the state of Arizona for the CENSUS2010POP (column H)?
  * ~ 20,000 (20,489)
* What county in the state of Wyoming has the smallest estimated population?
  * Niobrara
* At 2:45 of the video, the Instructor creates a filter for all of the counties in California with a population greater than 1,000,000. However, included in the results is the entire state of California. This anomalous value might skew our analysis if, for example, we wanted to compute the average population of these results. What additional filter might work to resolve this problem?
  * Add a filter to detect and remove results which do not include the word “County” in column G.

* How often (in seconds) do the R5 measurements occur?
  * 60
* What is the field for rain accumulation?
  * Rc
* What is the (Red, Green, Blue) pixel value for location 500, 2000?
  * (163, 118, 79)

* Is the value likely to be land or ocean?
  * Land (Ocean is at 0, 0 with (11, 10, 50))

* Given a tweet, what path would you most likely enter to obtain a count of the number of followers for a user?
  * user/followers_count

* Which of the following fields are nested within the ‘entities’ field (select all that apply)?
  * user_mentions
  * symbols
  * urls

## Different Kinds of Data Models (Part 2)

* Logarithm : the power to which a fixed number (the base) must be raised to produce a given number.

### Vector Space Model

* Text is unstructured data. How can we analyze text data?

* Document Vector Model (Vector Model)

  * Overview
    * A document vector model gives a score to each word in a document.
    * Each document is given an overall query length.
    * A search query is "matched" to each document.
    * The document with the highest similarity to the query ranks the highest.

* Creating a vector model for text data

```
Documents:

  d1 : "new york times"
  d2 : "new york post"
  d3 : "los angeles times"
```

  * 1. Create a Term frequency matrix (TF)
    * TF is a matrix of frequency of each word occurring in a document.

  ```

    Document Frequency
      Document | angeles | los | new | post | times | york |
      d1       | 0       | 0   | 1   | 0    | 1     | 1    |
      d2       | 0       | 0   | 1   | 1    | 0     | 1    |
      d3       | 1       | 1   | 0   | 0    | 1     | 0    |
      Doc Freq | 1       | 1   | 2   | 1    | 2     | 2    |
  ```

  * Inverse document frequency (IDF)
    * The inverse of the frequency the word occurs. The more frequent a word is in all documents, the less it's inverse document frequency.
    * This normalizes results. Less weight is given to terms which appear frequently in all documents.
    * More weight is given to terms which appear less frequently.

    * For each term, it's IDF is log(2) of (total documents / doc frequency)

```
Inverse Document Frequency

Term   | Doc-Frequency | IDF
angeles| 1             | log(2)(3/1) = 1.584
los    | 1             | log(2)(3/1) = 1.584
new    | 2             | log(2)(3/2) = 0.584
post   | 1             | log(2)(3/1) = 1.584
times  | 2             | log(2)(3/2) = 0.584
york   | 2             | log(2)(3/2) = 0.584

```

  * Why log(2)?
    * There is no mathematical reason for it. It's a convention in comp sci to use log(2) to compute many important factors.
    * The relative score of the IDF doesn't change regardless of the log base we use.

  * Why IDF?
    * IDF acts as a penalty factor for terms which are too widely used to be considered informative. (i.e., "the", "this", "is")

  * The TF-IDF matrix.
    * For each term, the TF * IDF are multiplied together to produce a

  * Length
    * Each document is given a total score, or "length".
    * Length == sqrt of the sum of squares for each term.
      * Length of d1 = sqrt(0.584 ^ 2 + 0.584 ^ 2 + 0.584 ^ 2)

```
Document Vector Model

Document | angeles | los   | new   | post  | times | york  | length
d1       | 0       | 0     | 0.584 | 0     | 0.584 | 0.584 | 1.011
d2       | 0       | 0     | 0.584 | 1.584 | 0     | 0.584 | 1.786
d3       | 1.584   | 1.584 | 0.584 | 1.584 | 0     | 0.584 | 2.316

```

* Searching in vector space

  * To search in the vector space, the query is given a score for each document.
  * The document with the highest score matches the search term the best.

* Creating the query vector.

  * Assume search string of "new new york"

  * Find the max frequency of a term used in the search.
    * new == 2

  * Using the IDF vector, for each term multiply:
    * Term frequency * (query frequency / max term frequency)

  * Find length of Q in the same fashion that we found the length of the IDF vector (sqrt of sum of squares)

```

Query Vector

Query | angeles | los   | new           | post  | times | york
Q     | 0       | 0     | (2/2) * 0.584 | 0     | 0     | (1/2) * 0.584
Total | 0       | 0     | 0.584         | 0     | 0     | 0.292

Length Q = sqrt ( 0.584^2 + 0.292^2) == 0.652

```

* You now have a vector for each document and a vector for the query. We now need to determine which document is most similar to the search query.

* Similarity function

  * Measures the cos() of the angle between these two vectors.
  * If the vectors are identical, the angles between them are 0, therefore the cos == 1.
  * As the size of the angle increases, the cos decreases, making them more dissimilar.

  * The mathematical formula is:
    * For each term, multiply it's IDF and Q values.
    * Add all term results together.
    * Divide by (IDF length / Q length).

```
Similarity Function
                new (d * Q)    + york (d * Q)   / (length(d) * length(Q)
cosSim(d1, q) = 0.584 * 0.584  + 0.584 * 0.292  / (1.011 * 0.652)
cosSim(d1, q) = (0.341056 + 0.170528) / 0.659
cosSim(d1, q) = 0.511584 / 0.659172
cosSim(d1, q) = 0.776

cosSim(d2, q) = (0.584 * 0.584) / (1.786 * 0.652) = 0.292
cosSim(d3, q) = (0.584 * 0.292) / (2.316 * 0.652) = 0.112

```

* Query term ranking
  * While similarity functions give you a brute force value assuming all search terms have equal weight, in the real world certain terms weigh more than others.
  * By weighing each query term, you give terms more or less relevance.

* Image Search
  * Computing features (color histogram) for the RGB color scheme.
  * The vector space model can be used for image search as it was for text search.

### Graph Data Model

Social networks are examples of graph data models.

* Graphs are different from other models in that they contain both properties and relationships to other entities in the graph.
* The "property graph model" contains vertexes (nodes) and edges (connections).
* Traversal : following edges based on a certain set of conditions.

* "Optimal Path" Operations
  * Shortest path (e.g., networks)
  * Optimal path (e.g., trip planner)
  * Best compromise. A path including constraints.

* Neighborhoods
  * A neighborhood of a node N in a graph is a set of edges directly connected to it.
  * A K neighborhood of N is a collection of edges between nodes that are, at most, K steps away from N.

* Communities
  * A subgraph (cluster) that has many more edges within the subgraph compared to edges outside the subgraph.

* Anomalous Neighborhoods : Different neighborhood shapes

* Connectedness
  * Connectedness is the degree to which nodes are connected.
  * In a fully connected graph, all nodes can be connected to each other.
  * In a fully disconnected graph, no nodes are connected.
  * Finding optimal paths should be performed only within connected components.

* Finding paths within large graphs can be performed via map reduce. This will be explained in the graph course.

### Other Data Models

* Arrays of vectors
  * Images are arrays of vectors. Each pixel is an RGB vector.

* Example operations on array of vectors
  * `dim(A)` - number of dimensions of A
  * `size(A, dim)` - size of a specific dimension
  * `A(i, j)` - value at (i, j)
  * `A(i, j)[k]` - value of the kth element in the vector at (i. j)
  * `length(A(i,j))` - vector length at (i, j)
  * `distance(A(i, j), A(k, l), f)` - vector distance between the values of two cells given the distance function `f`.


## Quiz : Data Models Quiz

* What is a possible pitfall of utilizing Excel as a way to manipulate small databases?
  * Excel does not enforce many principles of relational data models.

* What does the term “atomic” mean in the context of relational databases?
  * A tuple that cannot be reduced.

* What is the Pareto-Optimality problem?
  * Find the best possible path given two or more optimization criteria where neither constraint can be fully optimized simultaneously.

* What constitutes a community within a graph?
  * A dense amount of edge connections between nodes in a community and a few connections across communities.

* Why are trees useful for semi-structured data such as XML and JSON?
  * Trees take advantage of the parent-child relationship of the data for easy navigation.

* What is the general purpose of modeling data as vectors?
  * The ability to normalize vectors allowing probability distributions.

* Suppose we collect data month by month. Each month, we would have a batch of data containing the fields listed above. At the end of the year, we want to summarize our registrant activities for the entire year, so we would remove redundancies in our data by removing any records with duplicate account numbers from month to month. What type of operation do we use in this scenario?
  * Union

* From the information given in question 7, what are the constraints, if any, which we have placed on the Account Number field for the end of year collection?
  * Account Number should be unique.

* Suppose 100 people signup for our system and of the 100 people, 60 of them did not input an address. The system lists the values as NULL for these empty entries in the address field. Would this situation still have structure for our data?
  * Yes the data has structure because we have placed a structural constraint on the data, thus the data will always have the originally defined structure.

--------------------------------------------------------------------------------

## Week 4 : Streaming Data

### Data Model vs. Data Format

What is the difference between a data format and a data model?

#### Data Format

* The serialized representation of the data. Text file, binary file, csv file, etc.

#### Data Model

* A data model is the description of your data structure. The content, operations you can perform on the data, and the constraints you place on the data.


### Working With Streaming Data

#### What is a Data Stream?

* Streaming : processing data as it's generated.
  * Allows for real time analysis, intelligence.

* Stream
  * Unbounded sequence of data records.
  * Data is typically timestamped and geocoded.

* Challenges of streaming
  * Streams must be processed in real time.
  * The sheer size, velocity puts pressure on the infrastructure to keep up.

* Streaming System Characteristics
  * Manage one record or small time window.
  * Near real-time.
  * Independent computations. Systems subscribe to events.
  * Non-interactive with the source of data.

* Dynamic Steering (self-driving car)
  * Dynamically changing system behavior based on current streaming data.

* Amazon Kinesis, Apache Kafka, Apache Storm, are software which processes streaming data.


#### Why is Streaming Data Different?

* Data at rest
  * Static data stored in data source. Analysis happens after data is collected.
  * Batch processing.
* Data in motion
  * Data is analyzed and processed in real time.
  * Stream processing.

* Data Processing Algorithms
  * Static / Batch
    * Known size, time, and space.
  * Streaming
    * Unbounded size, but finite time and space.
    * Algorithms which require multiple iterations of processing are not possible.

* Streaming Data Management and Processing
  * Compute one data element or small window of data elements at a time.
  * Relatively fast and simple.
  * No interactions with the data source. The streaming system simply listens to the data source (subscribe to events).

* Lambda architecture
  * All data is processed in real time, handed off to a batch system for longer term storage and batch processing.

* Challenges with streaming data systems.
  * Streaming data changes over time (size / frequency of streamed data).
  * Social networking data cluster on weekends / news events.

* Streaming Data Summary
  * Size is unbounded.
  * Size and frequency are unpredictable (i.e., Twitter spikes)
  * Processing must be kept fast and simple (before being handed off to a batch system)

#### Understanding Data Lakes

* Strict data schemas don't fit big data.
  * Why?
    * Each consuming application may want to read data into a different format.
    * One data model will not serve all applications.

* What is a data lake?
  * A place where all incoming streams can be stored in their native form. (Get it -- streams, lake?)
  * Applications can view / examine the data, take samples.

* Schema on read (data lake approach)
  * Load data from source.
  * Store raw data.
  * Each application adds a data model (schema) on read.

* Schema on write (traditional DB approach)
  * Transform and structure before loaded into warehouse.

* Data Lake vs. Data Warehouse
  * Data Warehouse : Hierarchical, structured data model.
  * Data Lake : object storage (blob) with a unique ID.

* Data Lake Object Storage
  * Each object (blob) is stored with an object_id and other metadata.
  * Metadata is stored apart from the binary blob.

* Data Lake Summary
  * A big data storage architecture.
  * Collects all raw data for current and future analysis.
  * Transforms and adds formatting only when needed (schema on read).
  * All users can consume the data in their own fashion.



#### Quiz : Data Formats and Streaming Data Quiz

* What is true between data modeling and the formatting of the data?
  * The data does not necessarily need to be formatted in a way that represents the data model. Just so long as it can be extrapolated.

* What is streaming?
  * Utilizing real time data to compute and change the state of an application continuously.

* Of the following, what best describes the properties of working with streaming data?
  * Small time windows for working with data.
  * Independent computations that do not rely on previous or future data.
  * Does not ping the source interactively for a response upon receiving the data.
  * Data manipulation is near real time.

* What is a characteristic of streaming data?
  * Data is unbounded in size but requires only finite time and space to process it.

* What type of algorithm is required for analyzing streaming data?
  * Fast and simple

* What is lambda architecture?
  * A method to process streaming data by utilizing batch processing and real time processing.

* Of the following, which best represents the challenge regarding the size and frequency of data?
  * The size and frequency of the streaming data may be sporadic.

* What is the difference between data lakes and data warehouses?
  * Data lakes house raw data while data warehouses contain pre-formatted data.

* What is schema-on-read?
  * Data is stored as raw data until it is read by an application where the application assigns structure.

--------------------------------------------------------------------------------

## Week 5 : Big Data Management : The "M" in DBMS

### Why Data Management?

#### DBMS-based and non-DBMS-based Approaches to Big Data

* When should we use Hadoop / Yarn vs. a DB system?

* Storing Data : Files vs DBMS
  * Early DBMS's were applications based on files (Excel, Access).
    * Problems
      * Data redundancy, inconsistency, isolation between multiple files.
      * Each query needed to be written as a separate program.
      * Integrity (constraints) could not be applied (constraints were hardcoded)
      * No atomicity in updates (transactions).

* Advantages of DBMSs
  * Declarative query languages
  * Data independence - isolates the users from physical storage.
  * Efficient data access.

    * ACID / failure recovery.
      * Atomic. All or nothing.
      * Consistent. All data written to the DBMS must be valid according to the defined constraints (data types, PKs, FKs).
      * Isolation. Each transaction is isolated from others, even when multiple transactions are running concurrently.
      * Durable. A completed Tx will exist regardless of power loss or system failure.

* Parallel and distributed DBMS
  * Parallel DBMSs spread data across multiple machines for redundancy. Queries use parallelism for efficiency.
  * Multiple replicas can handle queries.
* Distributed DBMSs is a network of DBMSs in which the schema is distributed.
  * One DBMS knows about the others, can query into others.

* Do DBMSs solve big data challenges?
  * No. Why?
    * The general trend in big data is distributed. Distributed processing in commodity clusters. Of which traditional DBMSs were not designed for (but are getting there).

* DBMS and MapReduce style systems
  * If DBMSs are so great, why are we seeing map reduce style systems being used?
    * DBMS started with a different focus - efficient storage, transaction, retrieval.
    * Classic DBMSs did not take into account machine failure or commodity machines.
    * DBMSs do not support complex data processing over a cluster of machines.
      * MR algorithms are typically complex / multi-stage, requires more than data storage / retrieval.

* Shifting requirements
  * Data loading - a new bottleneck.
    * With streaming data, applications need real time data loading / indexing.
  * Too much functionality.
    * Some applications are read only, simple tables. A full blown DBMS is overkill.
  * Support for real-time processing.
    * Data must be loaded and analyzed in real time to enable immediate decision making.

* No single solution.
  * DMBS on HDFS is being developed.
  * Spark provides stream, real time calculations in addition to MR.
  * DBMSs are starting to develop analytical computations within the DBMSs.



### From DBMS to BDMS

#### From DBMS to BDMS

* Desired Characteristics of BDMS
  * What is an ideal BDMS?
    * Semi-structured, flexible data model.
      * Supports "Schema first" to "schema never"
    * Support for common data types.
      * Text, documents, temporal (time, before, after, during, etc), spacial data (map)
    * Full query language.
      * At least as powerful as SQL.
    * Efficient, parallel runtime (cross-machine query).
    * Wide range of query sizes.
      * Can return large objects / data sets.
    * Continuous data ingestion
      * Streaming data + historical data.
    * Scale gracefully in large, commodity clusters.
    * Easy operational management. Simple to administer.

* ACID and BASE
  * ACID is hard to maintain in a BDMS (slow w/ large data sets).

* BASE relaxes ACID
  * BA : Basic availability.
    * The query processor will respond to a query, however the response might be that the system is in an inconsistent state to process it.
    * S : Soft state. The state is likely to change over time due to eventual consistency.
    * E : Eventual consistency. The system will eventually become consistent when it stops receiving input.

* BASE essentially says:
  * We are going to relax ACID to accommodate larger throughput and better performance.
  * The system will eventually be consistent, however in the immediate term it may be available right away.

* CAP Theorem
  * A distributed computer system cannot simultaneously achieve:
    * Consistency. All nodes see the same data at any time.
    * Availability. Every request receives a success / failure response.
    * Partition tolerance. The system continues to operate across machine failures.

* The marketplace
  * There are so many different BDMS systems which focus on different aspects.
  * This course will look into the main systems across different big data use cases.


#### Redis : An Enhanced Key-Value Store

* In-memory data structure store
  * strings, hashes, lists, sets, sorted sets.

* Keys can be up to 512MB. Images can be used as a binary string key.
* Keys may have internal structure and expiry.
  * "user"
  * "user.commercial"
  * "user.commercial.entertainment"

* Redis and Data Look-up
  * Ziplists compacts the list in memory. Insertion and deletion is a bit slower.
  * Twitter added lists of ziplists. Constant time insertion / deletion as well as compressed storage.

* 2012 - Twitter timeline servivce
  * 40TB memory
  * 30M queries / sec.
  * 6000 machines

* Case 3 : (key:string, value: attribute-value pairs)
  * Values can be hashes (attribute / value pairs).
  * Redis optimizes storage of hash values.

* Redis and Scalability
  * Partitioning and replication
    * Range partitioning
      * Each section in a range (1-1000000 to machine 1, 100001-200000 to machine 2)
    * Hash partitioning
      * Keys are hashed, hash ranges are distributed between nodes.
  * Partitioning and replication
    * Master -> slave.
    * Clients read from slaves.
    * Slaves are "mostly consistent".

#### Aerospike : A New Generation Key/Value Store

* Designed for "web scale".
* Mostly in-memory K/V store, with disk persistence.
* Stores a secondary index on keys.
* Data types
  * Scalars, lists, maps, geospatial, large objects.
* AQL
  * Similar to SQL to access key/value storage.
* Transactions in Aerospike
  * ACID compliance.
    * Synchronous writes to replicas.
  * Durability. Data stored in SSD in every node.
  * Network partitioning reduced.
    * Tries to completely eliminate CAP theorem. Tries to aggressively distribute data as new nodes are leaving / joining the network.

#### Semi-Structured AsterixDB (Apache)

* MongoDB is the default semi-structured (JSON) based data.
* AsterixDB was developed by UC Irvine. It supports ACID guarantees.

```
Example Semi-structured schema

create dataverse LittleTwitterDemo
create dataset TweetMessages(TweetMessageType) primary key tweet_id

// Open means the actual data may have more attributes that what is defined
// in this type.
create type TwitterUserType as open {
  id: int32,
  screen_name: string,
  lang: string,
  friends_count: int32,
  statuses_count: int32,
  followers_count: int32
}

// Closed means the actual data must have the same schema as defined
// in this type.
create type TwitterMessageType as closed {
  tweet_id: string,
  user: TwitterUserType,
  geo: point? // ? == optional
  created_at: datetime
  referred_topics: {{ string }},
  text: string
}
```

* AsterixDB runs on HDFS

* Options for querying in AsterixDB
  * Asterix can use multiple query engines. They have built a low level query implementation and know how to translate multiple syntaxes into a common query operation.
  * AQL : Asterix Query Language. Similar to XPath.
    * `for $user in dataset TwitterUsers order by $user.followers_count desc, $user.lang asc return $user`
  * Hive queries (HiveQL)
    * `SELECT a.val, b.val FROM a LEFT OUTER JOIN b on (a.key = b.key)`
  * Xquery
  * Hadoop MR jobs
  * SQL++ (coming up) - extends SQL for JSON.

* Operating over a cluster
  * Hyracks
    * Query execution engine for partitioned parallel execution of queries.
    * Runs on multiple machines.

* Accessing external data : **this is awesome!**
  * You setup feeds to injest data into Asterix.
    * Real-time data from files in a directory path.
    * API feeds to stream data from an external API into Asterix.


#### SOLR : Managing Text

* Basic challenges with text data
  * Hard to determine what a good match is.
    * Lexical & capitalization differences:  `Analyze == Analyse == analyze?`?
    * Punctuations : `abc-123 == abc123`? What if the searcher doesn't get the punctuation correct or remember the punctuation?
    * Proper nouns : `barack obama == B. Obama == barack hussein obama`
    * Synonyms: `Mom == mother`
    * Abbreviations: `dr. == doctor`
    * Initialism: `USA == United Status of America` (not an acronym)

* Inverted Index
  * Vocabulary : all terms in a collection of documents
    * Multi-word terms, synonym sets.
  * Occurrence
    * For each term in the collection:
      * List of docID, position of occurrence, tf, idf...

* SOLR Functionality
  * The core SOLR use case is full text search.
  * SOLR can also search any field in a structured text document (CSV, etc)
    * Indexes text, numbers, geographic data, ...
  * Faceted Search
    * Think Amazon search, where each facet can be searched on (all computers from apple)
  * Term highlighting
  * Index-time analyzers. You can specify how you want your text analyzed and broken down.
    * Tokenizers
    * Filters
    * Example : Break on all white space. Convert all to lower case. Recognize synonyms from a given input file.
    * Remove noise words like "a, the, is.
    * Queries are also ran thru an analyzer.

* Solr queries
  * fl : items you want back
  * Return all
    * http://localhost:8983/solr/query?q=*.*
  * All books with "black" in the title field, return author, title
    * http://localhost:8983/solr/query?q=title:black&fl=author,title
  * All books sorted by pubyear_i in descending order
    * http://localhost:8983/solr/query?q=*.*&sort=pubyear_i desc
  * Above query but facet by all values in the cat field
    * http://localhost:8983/solr/query?q=*.*&sort=pubyear_i desc&facet=true&facet.field=cat

#### Relational Data : Vertica

* Vertica : A columnar store

  * DBMS built to reside on HDFS
  * Belongs to a family of DBMS architectures called "column stores".
  * In a DBMS, data is stored together in rows.
  * In a column store, each column of data is stored separately.
    * Queries only uses the columns needed, not the entire rows like DBMS.
    * Usually much faster for queries, even for large data.

* Advantages of column stores
  * Space Efficiency
    * Column stores keep columns in sorted order (speed, save space with duplicates).
    * Compression
    * RLE (run length encoding) (1/7/2007, 16 == the next 16 rows use this same value).
    * Frame-of-reference encoding - fix a number and only record differences.

* Working with Vertica
  * Column groups
    * Frequently co-accessed columns behave as mini row-stores within the column store.
  * Writes are slower. Vertica has to convert row representation into column representation, then compress.
  * Enhanced suite of analytical operations.
    * Window statistics : operations over a range of rows (e.g., by time)
    * "Compute a moving average of a bid every 40 seconds"
      * `SELECT ts.bid, AVG(bid)
         OVER (ORDER BY ts RANGE BETWEEN INTERVAL '40 seconds' PRECEDING AND CURRENT ROW)
         FROM ticks
         WHERE stock = 'abc'
         GROUP BY bid, ts
         ORDER BY ts;`

* Vertica and Distributed R
  * Distributed R
    * Master -> Slave topology.
    * Work is partitioned across machines.

* Moving analytics processes into the DBMS will improve performance.
* Most BDMS who want to play in the analytics space will implement analytics in their systems like Vertica.

### Quiz

* The desired characteristics of a BDMS include (select all that apply)
  * Continuous data ingestion
  * A full query language
  * A flexible semi-structured data model
  * Support for common “Big Data” data types

* Fill in the blank with the best answer: CAP theorem states that _________ all at once within a distributed computer system?
  * it is impossible to have consistency, availability, and partition tolerance

* What is the purpose of the acronym BASE?
  * To impose properties on a BDMS in order to guarantee certain results.

* What are ziplists in Redis?
  * A compressed list that is stored within the value of the database.

* What is one of the main features of Aerospike?
  * Support for geospatial data storage and geospatial queries.

* What database would be best suited for the following scenario: An app development company is trying to implement a cloud based storage system for their new map-based app. The cloud will manage the longitude and latitude of the data in order to track user location.
  * Aerospike (for the geospacial abilities)

* What database would be best suited for the following scenario: A big wholesale company is trying to implement a search engine for their products.
  * Solr

* Which of the following data types are supported by Redis? (select all that apply)
  * Lists
  * Strings
  * Sorted Sets
  * Hashes

--------------------------------------------------------------------------------

## Week 6 Designing a Big Data Management System for an Online Game

* Objective : catch as many flamingos you can by following the mission instructions.
* You must have at least one point in every map grid cell to advance a level.

* What to consider when designing an information system for the game.
  * Ranking of users.
    * Each user is ranked by speed and accuracy.
    * Rankings are tracked in real time. Can be viewed on the web or mobile app.
    * Other players can see each user's
      * Score, speed, accuracy.
      * What parts of the map the user has the most points for.
      * Player categorization ("rising star", "veteran", "coach", "social butterfly", "hot flamingo")
  * Ranking of teams
    * Each new team member requires 80% approval for new team members.
    * New players can be recruited.
    * Existing players can be "outvoted" if they are not contributing.
  * In-game Purchases
    * Binoculars to spot mission specific flamingos.
    * Special flamingos which count for more than 1 grid point.
    * Blocks to freeze a mission for :20.
    * Trading cards to transfer points to cells which need points.
  * Game completion
    * The game never ends.
    * The challenge for Elgence is to keep the game interesting for veteran players (using big data).

* What analytical tasks can be performed to improve Catch the Pink Flamingo game.
  * Social network analysis to determine sentiment, morale around different levels.
  * Analyze purchases and behaviors for different players.
    * What makes the most successful players successful?
  * Analyze behavior pattern, understanding what levels are hard, what player mistakes are made.

### Homework

* Designing the data required to run the game.
* Keeping track of what is going on when people are actually playing the game.
* Analyzing how people played past games to improve the way the game is played.

```
Users

userId : long (PK)
username: string
joiningDate: date
dateOfBirth: date
currentLevel: int
authenticationKey: string

Teams:

teamId: long
userId: long
joiningDate: date
```

* Users can only be a part of one team.
* A level 1 user will *not* have a team.

Need a table to track `user clicks`.

userID: long	sessionID: long	timestamp: dateTime	clickedPoint: coordinate	missionID: long	isHit: bit	userClickID:
long (PK)
100	4356	10/12/2015::14:15:09	(4,8)	13	yes	1
101	3241	10/23/2015::14:15:19	(20,5)	18	no	2
102	4537	11/4/2015::14:15:20	(17,43)	21	no	3

A user could click on multiple points within a second, or click multiple times at the same point, therefore there is no way to uniquely identify a row. Adding `userClickID` as a primary key would allow us to uniquely identify a row. Having a primary key would allow us to link other tables to this table.


**List all node and edge properties for a graph.**

* User (Node)
  * userId: long
  * username: string
  * joiningDate: date
  * dateOfBirth: date
  * currentLevel: int
  * authenticationKey: string

* Teams (Node)
  * teamId: long
  * userId: long
  * joiningDate: date

* Start (Edge)
  * userId: long
  * chatSessionId: long
  * timestamp: datetime

* Join (Edge)
  * userId: long
  * chatSessionId: long
  * timestamp: datetime

* Leave (Edge)
  * userId: long
  * chatSessionId: long
  * timestamp: datetime

* Chat Session (Node)
  * chatSessionId: long
  * teamId: long
  * title: string

* Writes (Edge)
  * userId: long
  * chatId: long
  * timestamp: datetime

* Chat (Node)
  * chatId: long
  * chatSessionId: long
  * message: string

* Mentions (Edge)
  * userId: long
  * chatTextId: long
  * timestamp: datetime


**Briefly explain how you would use the graph to answer the following five questions?**

* Which teams are having more conversations?

Each chat session has a 'teamId' associated with it. The chat session teamId is set to the creating user's teamId when the chat session is created.

To determine which teams are having more chats, we count the number of chat sessions by teamId.

* Do users chat more (or less) before they leave a team?

The teams entity tells us when users join and leave a team. Using this data, we can analyze the frequency of the number of Writes to chat sessions belonging to each team over time to determine when users chat relative to joining or leaving a team.

* What are the dominant terms (words) used in a chat session within a specific time period?

First, we would filter chat messages by sessionId and the time they were written. Next, we would find the document frequency of each term, sorted descending by frequency.

* Which users are most active in a specific chat session?

First, we would filter the Chat vertex for all Chat instances for a given chat session (by chatSessionId), joined to the writes edge using chatId. This would give us a complete list of all chat messages for a session with the user who wrote them. We would then group the results by user and sort by write count descending.

* How many chat sessions is a user participating in at the same time?

We would examine the Join and Leave edges to determine what chat sessions a user has joined and left. The difference between the number joined and the number left is the number of chat sessions the user is participating in.


{
  "flamingos" : [
    {
      "id" : 1
      "name" : "angry green overweight",
      "speed" : 10,
      "aggression" : 5,
      "pause_frequency" : 20,
      "subtypes" [
        3,
        4
      ]
    },
    {
      "id" : 2,
      "name" : "sleepy",
      "speed" : 0,
      "aggression" : 0,
      "pause_frequency" : 0
    },
    {
      "id" : 3,
      "name" : "green_beak"
      "beak_color" : "green",
    },
    {
      "id" : 4,
      "name" : "overweight"
      "weight" : 100,
    }
  ],
  "game" {
    "game-levels": [
      {
        // Level 2 : catch 10 angry green overweight flamingos and 1 sleeping flamnigo
        "level" : 2,
        "gridSize" : "4x8"
        "missions" : [
          {
              "flamingo_id" : 1,
              "num_flamingos": 10
          },
          {
            "flamingo_id" : 2,
            "num_flamingos" : 1
          }
        ]
      }
    ]
  }
}


**Explain how you might extend the tree with at least five specific flamingo properties. For example, beak-color whose values might be “bright-red” or “pink”.

You could extend the tree by creating flamingo properties which themselves have a structure. For example, you could add a "dimensions" property to a flamingo that tells you the flamingo's height, weight, head size, etc.

Specific flamingo properties could include:

* Speed
* Aggression
* Dimensions (height, weight)
* Color (beak)
* Back / front logo (star, flag, emoji)
* Feet shape
* Accessories (clothes, hat, jerelery)


Your objective is to make sure the tree has enough properties to launch the game and connect with the three data structures we have used so far.

When the game launches, we read the user's "current level" to determine which level to use. We then query into the game structure for the level and layout the game according to the level properties.

Level properties include missions. We create all missions for the level and the flamingos for each mission and add them to the level the user is playing.
