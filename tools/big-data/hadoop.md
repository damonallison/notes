# Hadoop

Much of hadoop is geared around redundancy and fault tolerance at the machine and rack (switch) level. HW concerns have to be solved by cloud providers, allowing us to focus on the algorithms and data on top of the virtualized HW.

"Google is a few years ahead of us who use Hadoop."

```
Google                       Open source project
2004 - GFS & MapReduce       2006 - Hadoop           batch programs
2005 - Sawzall               2008 - Pig & Hive       batch queries
2006 - Big Table             2008 - HBase            online key/value
2010 - Dremel/F1             2012 - Impala           online queries
2012 - Spanner               ?                       global transactions
```

## Hadoop

Hadoop is a batch based on a map reduce engine.

### Characteristics

* Commodity hardware (is anything non-commodity today?).
* Open source software (is anything not open source?).
* Fault tolerant. Survives single machine failures with any component.
* Schema-on-read. You can save data in the raw form, project it on the fly to the desired format (schema).
* More data with a simplier algorithm is better than lots of data with a high complex algorithm

## HBase

* Key/value store. (no-sql db)
* You can use hbase as an input or output to map reduce.


## Hadoop Modules ##

* Hadoop Common - base libraries used by other Hadoop modules.
* Hadoop Distributed File System (HDFS) - block based DFS.
* Hadoop YARN - resource management, scheduling.
* Hadoop MapReduce - programming model for processing large scale data.

## Hadoop Common ##

Common building blocks common to other Hadoop modules.

## Hadoop Cluster ##

* Master (1)
	* Job Tracker
	* Task Tracker
	* NameNode - tracks data nodes. Can be setup for automatic fail-over.
	* DataNode - block based storage node.
* Slave (worker node) (n)
	* DataNode
	* TaskTracker

## HDFS : Hadoop Distributed File System ##

Blocks are distributed among multiple machines.

NameNode(s) are the main server used to locate data. NameNodes are used to locate files, thus are the bottleneck. NameNodes can be federated using HDFS federation, allowing data to be partitioned into namespaces. A single NameNode is responsible for one or more namespaces.

HDFS was designed for mostly immutable files.

HDFS can be mounted directly with FUSE on linux.

Hadoop can work with other file systems - including S3. There is no need for rack awareness since all data is remote.


## Job Tracker / TrackTracker (The MapReduce engine)

JobTracker - job scheduler - pushes work to available TaskTracker nodes. The JobTracker knows where the data is stored and intelligently distributes jobs.


## Getting a file into hadoop

```
// import a file into hadoop
$ hadoop fs -copyFromLocal words.txt
$ hadoop fs -ls
$ hadoop fs -cp words.txt words2.txt
$ hadoop fs -copyToLocal words2.txt
```
