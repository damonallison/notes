# Spark

The **big idea** with spark is providing in-memory data processing. Data is read from any source (HDFS, file system, SQL, etc) into in-memory RDD (resilient distributed datasets) and processed in memory.

RDDs are fault tolerant, distributed, and immutable.

Two types of operations can be performed on RDDs.

* Transformations. Create a new RDD.
* Actions. Return a value to the driver program after running a computation on the RDD.

## Do not use global variables!
Lambdas should *not* reference non-local (global) variables. When lambdas execute across nodes in a cluster, each cluster node will have it's own copy of the global variable. Thus, the variable on the driver program will not be updated.

**Closures should not be used to mutate non-local state.**

To reference variables across all nodes in a cluster, use an `Accumulator`.

## Printing elements of an RDD

To print an RDD across all nodes within a cluster, they must be `collect()`ed first on the driver:

> rdd.collect().foreach(println)

If you only need to print out a few elements:

> rdd.take(100).foreach(println)


## Examples

* Start jupyter (pile of shit editor)
  * `$ pyspark`

* Copy a file into HDFS
  * `$ hadoop fs -ls`
  * `$ hadoop fs -put words.txt`

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


### Course 3 - Week 5 : Hands-on: Data Processing in Spark

This example loads data from the "gameclicks" table in postgres into spark.

```
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
```
# Parse a line of weather station data, returning the average wind direction measurement
#
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


### Course 3, Week 6 : Assignment : Analysis using Spark

Launch pyspark with the following command

> pyspark --packages com.databricks:spark-csv_2.10:1.5.0

#### Question 1:

How many different countries are mentioned in the tweets? Each country can only count 1 time.
