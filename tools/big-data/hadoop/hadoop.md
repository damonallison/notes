# Hadoop

Hadoop is a batch based on a map reduce engine.

Much of hadoop is geared around redundancy and fault tolerance at the machine
and rack (switch) level. HW concerns have to be solved by cloud providers,
allowing us to focus on the algorithms and data on top of the virtualized HW.

"Google is a few years ahead of us who use Hadoop."

```plaintext
Google                       Open source project
2004 - GFS & MapReduce       2006 - Hadoop           batch programs
2005 - Sawzall               2008 - Pig & Hive       batch queries
2006 - Big Table             2008 - HBase            online key/value
2010 - Dremel/F1             2012 - Impala           online queries
2012 - Spanner               ?                       global transactions
```


## Characteristics

* Commodity hardware (is anything non-commodity today?).
* Open source software (is anything not open source?).
* Fault tolerant. Survives single machine failures with any component.
* Schema-on-read. You can save data in the raw form, project it on the fly to the desired format (schema).
* More data with a simplier algorithm is better than lots of data with a high complex algorithm

## Recommendations

### Strengths

* Hadoop is good for distributed data storage and basic MapReduce algorithms.
* Hadoop is good for batch processing of large data sets.

### Weaknesses

* Hadoop does not support streaming.
* Hadoop can be slow - it's file system based.
* Hadoop does not handle complex algorithms well.
* Hadoop does not have a REPL or support for many programming languages.

Spark is a more general purpose, flexible, faster programming environment. For
serious algorithms, use Spark.

## Hadoop Modules

* Hadoop Common - base libraries used by other Hadoop modules.
* Hadoop Distributed File System (HDFS) - block based DFS.
* Hadoop YARN - resource management, scheduling.
* Hadoop MapReduce - programming model for processing large scale data.

## Hadoop Common

Common building blocks common to other Hadoop modules.

## Hadoop Cluster

* Master (1)
	* Job Tracker
	* Task Tracker
	* NameNode - tracks data nodes. Can be setup for automatic fail-over.
	* DataNode - block based storage node.
* Slave (worker node) (n)
	* DataNode
	* TaskTracker

## HDFS : Hadoop Distributed File System

Blocks are distributed among multiple machines.

NameNode(s) are the main server used to locate data. NameNodes are used to
locate files, thus are the bottleneck. NameNodes can be federated using HDFS
federation, allowing data to be partitioned into namespaces. A single NameNode
is responsible for one or more namespaces.

HDFS was designed for mostly immutable files. Write once, read many.

HDFS can be mounted directly with FUSE on linux.

Hadoop can work with other file systems - including S3. There is no need for
rack awareness since all data is remote.

## Job Tracker / TrackTracker (The MapReduce engine)

JobTracker - job scheduler - pushes work to available TaskTracker nodes. The JobTracker knows where the data is stored and intelligently distributes jobs.


## Hadoop example

```shell

# import a file into hadoop

$ hadoop fs -put words.txt
$ hadoop fs -ls
$ hadoop fs -cp words.txt words2.txt
$ hadoop fs -get words2.txt

```

## MapReduce

* MapReduce jobs are distributed and executed across nodes in the Hadoop cluster.
* Jobs read from a a file, execute their map / combine / reduce steps, then write to a file.

### MapReduce Example

```java

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.net.URI;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.StringTokenizer;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.mapreduce.Counter;
import org.apache.hadoop.util.GenericOptionsParser;
import org.apache.hadoop.util.StringUtils;

public class WordCount2 {

  public static class TokenizerMapper
       extends Mapper<Object, Text, Text, IntWritable>{

    static enum CountersEnum { INPUT_WORDS }

    private final static IntWritable one = new IntWritable(1);
    private Text word = new Text();

    private boolean caseSensitive;
    private Set<String> patternsToSkip = new HashSet<String>();

    private Configuration conf;
    private BufferedReader fis;

    @Override
    public void setup(Context context) throws IOException,
        InterruptedException {
      conf = context.getConfiguration();
      caseSensitive = conf.getBoolean("wordcount.case.sensitive", true);
      if (conf.getBoolean("wordcount.skip.patterns", false)) {
        URI[] patternsURIs = Job.getInstance(conf).getCacheFiles();
        for (URI patternsURI : patternsURIs) {
          Path patternsPath = new Path(patternsURI.getPath());
          String patternsFileName = patternsPath.getName().toString();
          parseSkipFile(patternsFileName);
        }
      }
    }

    private void parseSkipFile(String fileName) {
      try {
        fis = new BufferedReader(new FileReader(fileName));
        String pattern = null;
        while ((pattern = fis.readLine()) != null) {
          patternsToSkip.add(pattern);
        }
      } catch (IOException ioe) {
        System.err.println("Caught exception while parsing the cached file '"
            + StringUtils.stringifyException(ioe));
      }
    }

    @Override
    public void map(Object key, Text value, Context context
                    ) throws IOException, InterruptedException {
      String line = (caseSensitive) ?
          value.toString() : value.toString().toLowerCase();
      for (String pattern : patternsToSkip) {
        line = line.replaceAll(pattern, "");
      }
      StringTokenizer itr = new StringTokenizer(line);
      while (itr.hasMoreTokens()) {
        word.set(itr.nextToken());
        context.write(word, one);
        Counter counter = context.getCounter(CountersEnum.class.getName(),
            CountersEnum.INPUT_WORDS.toString());
        counter.increment(1);
      }
    }
  }

  public static class IntSumReducer
       extends Reducer<Text,IntWritable,Text,IntWritable> {
    private IntWritable result = new IntWritable();

    public void reduce(Text key, Iterable<IntWritable> values,
                       Context context
                       ) throws IOException, InterruptedException {
      int sum = 0;
      for (IntWritable val : values) {
        sum += val.get();
      }
      result.set(sum);
      context.write(key, result);
    }
  }

  public static void main(String[] args) throws Exception {
    Configuration conf = new Configuration();
    GenericOptionsParser optionParser = new GenericOptionsParser(conf, args);
    String[] remainingArgs = optionParser.getRemainingArgs();
    if ((remainingArgs.length != 2) && (remainingArgs.length != 4)) {
      System.err.println("Usage: wordcount <in> <out> [-skip skipPatternFile]");
      System.exit(2);
    }
    Job job = Job.getInstance(conf, "word count");
    job.setJarByClass(WordCount2.class);
    job.setMapperClass(TokenizerMapper.class);
    job.setCombinerClass(IntSumReducer.class);
    job.setReducerClass(IntSumReducer.class);
    job.setOutputKeyClass(Text.class);
    job.setOutputValueClass(IntWritable.class);

    List<String> otherArgs = new ArrayList<String>();
    for (int i=0; i < remainingArgs.length; ++i) {
      if ("-skip".equals(remainingArgs[i])) {
        job.addCacheFile(new Path(remainingArgs[++i]).toUri());
        job.getConfiguration().setBoolean("wordcount.skip.patterns", true);
      } else {
        otherArgs.add(remainingArgs[i]);
      }
    }
    FileInputFormat.addInputPath(job, new Path(otherArgs.get(0)));
    FileOutputFormat.setOutputPath(job, new Path(otherArgs.get(1)));

    System.exit(job.waitForCompletion(true) ? 0 : 1);
  }
}

```