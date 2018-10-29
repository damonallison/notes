"""A test python application"""

from pyspark.sql import SparkSession

nameFile = "data/names.txt"

spark = SparkSession.builder.appName("SimpleApp").getOrCreate()

nameDataset = spark.read.text(nameFile).cache()

numDamon = nameDataset.filter(nameDataset.value.contains("damon")).count()
numAllison = nameDataset.filter(nameDataset.value.contains("allison")).count()

print(f"Lines with damon: {numDamon}, lines with allison: {numAllison}")
