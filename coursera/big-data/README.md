# Big Data

Big Data is a 6 course Coursera specialization in Big Data targeted at introductory students. The curriculum was built and presented by University of California, San Diego.

Here is an overview of all 6 courses. Each course is expected to take about about 6 weeks, but you can get each course done in 1-2 weeks if you really want to.

## 01 - Introduction to Big Data

* The goal of "Data Science" is to discover insight, value, and opportunity from data.
* `Data Science` is the intersection between business, math, and hacking.
* "Big Data" is a generic term meant to describe scalable data needs that span multiple machines.

* Data is being created at record speed.
    * Volume
    * Velocity
    * Veracity (Quality)
    * Variety
    * Valence (connectedness)

* Data is unstructured and semi-structured (HTML, JSON). Strict relational DBMSs break down.
* Big Data systems must be horizaontally scalable, fault tolerant (redundant),
* Hadoop is a distributed file system (HDFS - Hadoop File System) along with a resource scheduler (YARN) and a programming model (MapReduce).

## 02 - Big Data Modeling & Management

* Modeling is describing the data. (think SQL schema).
    * Relational model
    * Graph model
    * Vactor space model (term frequency / weight)
* Managing data is about how you work with data:
    * Injest (streaming / batch / error handling)
    * Store
    * Operate

* Data lakes are where streams of data flow, untouched.
    * Data lakes allow people to sample, test, use the data in it's raw form.

* Data Management
    * BDMS's are built for "big data" : scalable, fault tolerant, distributed.
    * Redis, Hadoop, MongoDB are examples of BDMSs.

## 03 - Big Data Integration & Processing

* The `big data` workflow is the process of:
  * Acquiring -> Preparing (i.e., ETL) -> Integration -> Analysis -> Visualization -> Dissemination

* Integration
    * Streaming
    * Batch processing
    * Determining how to integrate data sources.
        * What fields do the data sets have in common?
        * How to map between data sources?
        * How to handle missing values?

* Processing
    * The processing layer is where data is analyzed (processed).
    * Querying - SQL or a programming model (hadoop) using joins, selection, projection.
    * Processing - processing data in DBMS systems is handled in pipelines.
        * Common processing steps (modeled into a pipeline) include:
        * Map
        * Reduce
        * Filter
        * Join
        * Aggregations
    * Machine Learning algorithms are frequently used to prcess data.
        * Regression: the predicted future value.
        * Classification: classifying a sample into one of many options (i.e., rainy, sunny, cloudy, snowy).
    * Tools used
        * Hadoop : Map Reduce over HDFS. Slow but cheap.
        * Spark : In-memory analysis. Fast but expensive.
        * GraphX (graph modeling / processing)

## 04 - Machine Learning with Big Data

* KNIME is a graphical pipeline builder to analyze data.
* Spark is a programming environment to analyze data.

* An ML `model` is result of running an algorithm on test data, producing the rules and logic that allow you to get predictions on new data.

* Categories of ML
  * Classification : predict a category of data.
  * Regression : predict numeric value.
  * Cluster Analysis : organize similar things into groups.
  * Association Analysis : understand how items are associated (beer / diapers, product recommendations).

* Supervised vs. unsupervised
    * Supervised - training data is labeled, each sample has a known target.
        * Classification and Regression are supervised.
    * Unsupervised - target is unknown. Samples are *not* labeled into a category.
        * Cluster analysis, association analysis are unsupervised.

* Classification Algorithms
    * kNN (k-nearest neighbors) : classify based on neighbors. Given a sample, find nearest `k` neighbors.
    * Naive Bayes. Given a number of values, how do you classify a sample?
        * i.e. given income, marital status, age, home value - what socioeconomic class is the sample in?

* Regression
    * Same as classification, but produces a value, not a class, for each sample.
    * Linear regression finds the `best fit` line between two variables.

* Clustering
    * Put samples into clusters based on input values.

* Association analysis
    * Determine the liklihood items occur together.

## 05 - Graph Analytics for Big Data

* Graphs could be put into a relational DB, representing edges in joining tables.
    * The queries to determine path length, for example, would be a difficult, or iterative query.
    * Graph DB's specialize in storing and querying into graph data structures.

* Charts (like pie charts) are not graphs in the graph theory sense.
* Graph data structures have nodes and edges. Each node / edge can have properties.
* Graphs have properties
    * Size / diameter
    * Each node has a degree - the number of incoming and outgoing edges.
    * Connectedness: the level of degrees
    * Communities : Dense sub-section of a graph.
* Centrality analysis finds the "central" nodes.
    * Central nodes are attack points - taking out a central node disrupts the entire network.
    * Central nodes are influencers in social circles, hubs in transportation networks.

* Neo4j is a graph DB. It's query language is called `Cypher`.
    * Neo4j and cypher allow us to query the graph - nodes, relationships, shortest paths,

* Giraph / GraphX : graph processing on spark. RDD's for edges / vertices.
