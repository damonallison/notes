"""A Spark Streaming (DStream) example"""
#
# Spark Streaming Programming Guide
# https://spark.apache.org/docs/latest/streaming-programming-guide.html
#
# Spark Streaming provides a high level distretized stream abstraction (DStream)
# which represents a continuous stream of data. 
# 
# Streams are created from input data sources such as Kafka, Flume, or Kinesis.
# Internally, a DStream is represented as a sequence of RDDs.
#
# * Streams can perform calculations and transformations using windowing.
# * Streams can be joined to produce a combined output stream.
# * You can use Spark SQL or MLLib to process streamed data.
#
from pyspark import SparkContext
from pyspark.streaming import StreamingContext

# local[*] will run the context in local mode. This is typically set to a Spark,
# Mesos, or YARN cluster URL.
#
# When running locally, always use "local[n]" where n > number of receivers.
# (A receiver is an incoming data source. In this example, we have a single
# socket receiver).
sc = SparkContext("local[2]", "NetworkWordCount")

# The streaming context is the main entry point of all Spark Streaming
# functionality. Here, we create a streaming context with a 1 second batch
# interval. 
#
# Note that windows in Spark Streaming are different than batch intervals.
# Windows can span multiple batches.
ssc = StreamingContext(sc, 1)

# Create a DStream that will connect to hostname:port
#
# 
lines = ssc.socketTextStream("localhost", 9999)

# Split each line into a new DStream of words
words = lines.flatMap(lambda line: line.split(" "))

# Count each word in each batch
pairs = words.map(lambda word: (word, 1))
wordCounts = pairs.reduceByKey(lambda x, y: x + y)

# Print the first 10 elements of each RDD generated in this DStream to the
# console.
wordCounts.pprint()


# Start the computation (stream)
# 
# Once a context has been started, no new streaming computations can be setup or
# added to it.
#
# Only 1 StreamingContext can be active in a JVM at the same time.
ssc.start()

# Wait for the computation to terminate (SIGnal)
#
# Processing can be manually stopped using ssc.stop()
ssc.awaitTermination()