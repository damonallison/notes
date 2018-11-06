# Spark

Spark is a general purpose cluster computing framework. Data is read from any
source (HDFS, file system, SQL, etc) into in-memory Dataset (RDD) and processed
across the cluster.

## Spark Core

The primary architectural component is the `Dataset`, which is based on the
original `RDD` (Resilient, Distributed Dataset). `Dataset`s are lazy. Functions
are not performed until an action (like `count`) is executed.

Spark was born out of the limitations of single pass MapReduce popularized by
Hadoop. Applications like ML require multipass iterative algorithms which
MapReduce / Hadoop was not good for.

Spark programs are executed from a "driver" application, which invokes functions
on RDDs like map, filter, reduce across a cluster. Two types of operations can
be performed on Datasets:

Oudside of `RDD`s, spark offers two forms of shared variables:

* `Broadcast Variables` : Read only data that needs to be accessed across all nodes.
* `Accumulators`

## Spark vs. Hadoop

### Similarities

Spark is *similar* to Hadoop in some respects:

* Computation is distributed to handle large data sets.
* Both systems are resilient - they can handle node failures.

### Differences

* Spark is in-memory and fast.
* Hadoop is somewhat limited to MapReduce jobs in batch environments.
* Spark is a more general purpose programming environment.
  * Support for Python, SQL (SparkSQL), and countless statistics libraries.
* Hadoop is not ideal for iterative algorithms (multiple stages of ML).
* Spark supports streaming.
  * Streams are converted into Dataset windows.
  * Stream sources could be HDFS, Twitter, API, Socket, Kafka.
* REPL / Jupyter support.

## Dataset (RDD)

Spark's main abstration is the Dataset. The Dataset is a collection of elements
partitioned across nodes in a cluster that can be operated on in parallel.

* Datasets can be cached (using `.cache`) in memory for faster processing.
  Consider this for "hot" data sources.

* Spark’s original (pre-2.0) main programming interface was called the
  "Resilient Distributed Dataset" (RDD). RDD was replaced in 2.0 with `Dataset`.
  Dataset is strongly typed like RDD, but faster.

## Shared Variables

By default, when spark runs a task on different nodes, it ships a copy of each
variable used in the function to each executor. Therefore, each node has a copy
within it's JVM. `By default, state is not shared across nodes.`

* Spark supports two types of shared variables: broadcast variables and accumulators.
  * Broadcast: used to cache a value in memory on all nodes.
  * Accumulators: variables which are only added to - such as counters and sums.

Programming in spark is a pipeline.

```plain

Create Dataset ->
  Apply transformations (map / filter) ->
    Perform action (collect, reduce, take)

```

## Shuffle Operations / Memory Usage

Some transformations in spark require data to be shuffled in memory. For
example, `reduceByKey` must read *all* data in the RDD, group values by key, and
then run the reduce operation. Reading all data and building new RDDs for `map`
and `reduce` operations to run by key requires data to be shuffled in memory.

Shuffling can be very memory / resource heavy. Spark uses temporary files to
during shuffling.

---

## Spark SQL

Spark SQL introduced the `DataFrame` abstraction. A `DataFrame` is conceptually
similar to TABLEs in SQL (rows / columns).

`DataFrame`s can be created from multiple input sources:

* Files (text, csv, json)
* Hive
* JDBC

`Dataset` can be converted to a `DataFrame`.

---

## Spark Structured Streaming

Spark Streaming is a stream processing engine based on Spark SQL. It allows you
to write SQL queries against a series of data with results updating in real
time.

* Supports windowing.
* Supports joining stream with non-stream (fixed) data.
* Support deduplication based on watermark (unique id).

Similar to `ksql` in the Kafka ecosystem.

Input sources include:

* Files
* Kafka
* Socket (for testing only)
* "Rate source" : manual data creation (for testing only)

Output sources (sinks) include:

* File
* Kafka
* Console
* Memory

## Spark Streaming

* Spark streaming receives live data streamed in from Kafka, TCP, HDFS, or another data source.
* Data is processed into batches (RDDs).
* Batches are processed in Spark, gathered on the driver, and written to an
  output data source.

---

## Spark MLLib

MLLib provides ML functionality on top of Spark. It's goal is to make practical
machine learning scalable and easy. It takes advantage of Spark's parallel,
distributed nature to run ML algorithms on massive data sets

Features:

* ML Algorithms: classification, regression, clustering, collaborative
  filtering.
* Featurization: feature extraction, transformation, dimensionality, selection.
* Pipelines: tools for constructing, evaluating, and tuning ML pipelines.
* Persistence: save / load algorithms, models, and Pipelines.
* Utilities: linear algebra, statistics, data handling, etc.

Pipelines are inspired by `scikit-learn`.

The core data structure used by `MLLib` is the `DataFrame`. Pipelines are built
by combining `Transformer` and `Estimator` algorithms together in a sequence.

* Transformer: A Transformer is an algorithm which can transform one DF to
  another DF.

* Estimator: An `Estimator` accepts a `DataFrame` and creates a `Model`, which
  is a `Transformer`. For example, `LinearRegression` is an `Estimator`, and
  calling `fit()` on it trains a `LogisticRegressionModel`, which is a
  `Transformer`.


---

## Installing / Configuring Spark

* Using `brew`, spark is installed to `/usr/local/Cellar/apache-spark/2.3.2`
* `SPARK_HOME=/usr/local/Cellar/apache-spark/2.3.2/libexec`

### Spark configuration

* `$SPARK_HOME/conf/spark-env.sh` allows you to setup environment variables.

```bash

# Add the following line to have spark bind on a local IP.
# This works around issues with IP binding on some networks.

SPARK_LOCAL_IP=127.0.0.1

```

### Running Spark

You can launch spark in `scala` or `python` shells.

```python

# launch a scala spark REPL
$ spark-shell

# Launch the python spark REPL
$ pyspark
```

### Installing / Running juptyer notebook

```bash
# install
$ pip install jupyter

# run
$ jupyter notebook
```

### Configuring the PySpark driver to automatically open a Jupyter Notebook

Pyspark can be configured to launch in a jupyter notebook at launch.

```bash

# In ~/.config/fish/config.fish

set --export PYSPARK_DRIVER_PYTHON jupyter
set --export PYSPARK_DRIVER_PYTHON_OPS 'notebook'

```

### Set the default Derby DB directory to /tmp/derby

When using certain features in spark (explode, for example), a Derby DB is created. To avoid creating this DB in your local directory, create it in `/tmp`.

```bash

# Edit $SPARK_HOME/spark-defaults.conf

spark.driver.extraJavaOptions -Dderby.system.home=/tmp/derby

```

---

## Using Spark

### Create a Dataframe

```bash
>>> textFile = spark.read.text("/tmp/damon.txt")

>>> textFile.count() # Number of rows in the Dataframe

# Maps a line to an integer value and aliases it "numWords",
# creating a new DataFrame. `agg` is called to find the largest
# word count.

>>> from pyspark.sql.functions import *
>>> textFile.select(size(split(textFile.value, "\s+")).name("numWords")).agg(max(col("numWords"))).collect()

# Spark supports caching. This is useful when data is
# accessed repeatedly, such as when querying a small Dataset
# or running an iterative algorithm like PageRank.

>>> textFile.cache()
```

* Since `python` is not strongly typed, spark Datasets are not strongly typed in
  python. All Datasets in python are Dataset[Row], and called `DataFrame` to be
  consistent with the data frame concept in `R` and `Pandas`.

## Do not use global variables

Lambdas should *not* reference non-local (global) variables. When lambdas
execute across nodes in a cluster, each cluster node will have it's own copy of
the global variable. Thus, the variable on the driver program will not be
updated.

**Closures should not be used to mutate non-local state.**

To reference variables across all nodes in a cluster, use an `Accumulator`.

## Printing elements of an RDD

To print an RDD across all nodes within a cluster, they must be `collect()`ed first on the driver:

```python

> rdd.collect().foreach(println)
```

If you only need to print out a few elements:

```python

> rdd.take(100).foreach(println)

```

## Examples

* Copy a file into HDFS
  * `$ hadoop fs -ls`
  * `$ hadoop fs -put words.txt`

* Start pyspark
  * `$ pyspark`

* Creating a spark context given a text file into a `lines` RDD and `words` RDD.
  * `lines = sc.textFile("hdfs:/user/cloudera/words.txt")`
  * `words = lines.flatMap(lambda line: line.split(" "))`

* Create a tuple for each word with an initial count of 1.
  * `tuples = words.map(lambda word: (word, 1))`

* Sum all word count values. reduceByKey calls the lambda for all the tuples with the same word.
  * `counts = tuples.reduceByKey(lambda a, b: (a + b))`

* Write word counts to text files in HDFS
  * `coalesce` combines all RDD partitions into a single partition since we want a single output file.
  * `counts.coalesce(1).saveAsTextFile('hdfs:/user/cloudera/wordcount/outputDir')`

* Copy output file out of HDFS
  * `hadoop fs -copyToLocal wordcount/outputDir/part-00000 count.txt`

---

### Course 3 - Week 5 : Hands-on: Data Processing in Spark

This example loads data from the "gameclicks" table in postgres into spark.

```python

from pyspark.sql import SQLContext
sqlsc = SQLContext(sc)
df = sqlsc.read.format("jdbc")
  .option("url", "jdbc:postgresql://localhost/cloudera?user=cloudera")
  .option("dbtable", "gameclicks")
  .load()

# The DataFrame is conceptually similar to a relational table.
# Print it's schema.
df.printSchema()

df.count()

# Order by the "timestamp" column, show only the top 5 rows.
df.orderBy("timestamp").show(5)

# Projection using "select"
df.select("userid", "teamlevel").show(5)

# Filtering (i.e., "WHERE")
df.filter(df["teamlevel"] > 1).select("userid", "teamlevel").show(5)

# Grouping (i.e., "GROUP BY")
df.groupBy("ishit").count().show()


# Performing aggregate operations
from pyspark.sql.functions import *

# Calculate the average hit rate, and total the ishit column.
df.select(mean("ishit"), sum("ishit")).show()


# Joining data frames

df = sqlsc.read.format("jdbc")
  .option("url", "jdbc:postgresql://localhost/cloudera?user=cloudera")
  .option("dbtable", "adclicks")
  .load()

df2.printSchema()

# Combine the two data frames, creating a new data frame.
merge = df.join(df2, "userid")

merge.printSchema()
```


#### Spark Streaming

```python

# Parse a line of weather station data, returning the average wind direction measurement

import re

def parse(line):
    match = re.search("Dm=(\d+)", line)
    if match:
        val = match.group(1)
        return [int(val)]
    return []

from pyspark.streaming import StreamingContext

# Create a StreamingContext with a 1 second window.
ssc = StreamingContext(sc, 1)

# Create a DStream of weather data.
lines = ssc.socketTextStream("rtd.hpwren.ucsd.edu", 12028)

# Reads average wind speed from each line and store it in a new DStream called vals.
vals = lines.flatMap(parse)

# Create a new DStream called window that combines 10 seconds worth of data
# and moves by 5 seconds.
window = vals.window(10, 5)

# Define a function to find the minimum and maximum values in our window.
def stats(rdd):
  # Demonstrate the sliding window. For testing only.
  print(rdd.collect())
  if rdd.count() > 0
    print("max = {}, min = {}".format(rdd.max(), rdd.min()))


# Calls `stats` for each RDD in the DStream `window`
window.foreachRDD(lambda rdd: stats(rdd))

# Start streaming
ssc.start()

ssc.stop()

```
