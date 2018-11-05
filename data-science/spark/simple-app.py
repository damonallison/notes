"""A test python application.

To run Spark applications in Python with

"""

from pyspark.sql import SparkSession


# When reading text files, all spark cluster nodes must have access to the file.
# Use a network or cloud share (HDFS or S3).
nameFile = "data/names.txt"

spark = SparkSession.builder.appName("SimpleApp").getOrCreate()
nameDataset = spark.read.text(nameFile)

numDamon = nameDataset.filter(nameDataset.value.contains("damon")).count()
numAllison = nameDataset.filter(nameDataset.value.contains("allison")).count()

print(f"Total lines:{nameDataset.count()} lines with damon: {numDamon}, lines with allison: {numAllison}")
