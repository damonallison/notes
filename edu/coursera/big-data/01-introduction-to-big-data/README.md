# Big Data : Course 1 : Introduction to Big Data

Bottom line : Data is proliferating exponentially. Advantage favors companies who embrace and leverage data.

This class is a high level introduction to big data for learners with no previous big data (or software) experience.

## Overview

* Data is expanding exponentially, outgrowing traditional DBMS, monolithic (batch) processing algorithms, and traditional in-house infrastructure.

* The future of computing includes:
  * Large data sets.
  * Distributed storage (NoSQL) and processing (Hadoop) across commodity clusters.
  * Intelligent. Systems must provide higher quality algorithms and analytics for better decision making.
  * Open data sources. "Data lakes" with ubiquitous access. No data in silos.
  * Less structure, higher variety in data.

## The definition of big data

What is "big data"?

It doesn't mean "a lot of data" or "too much data for a single database system". Data complexity impacts what is "big data".

Most agree the characteristics of big data are the "3 Vs" as coined by Doug Laney from Gartner:

* Volume.
* Velocity.
* Variety.

Other "Vs" include"
* Veracity (quality).
* Valence (connectness). Think graph theory.

**The goal of big data is to make better decisions.**

---

# Week 1

The goals of this course is:

* Describe the big data landscape using real world examples.
* Understand the high level workflow of big data systems.
* Describe the properties of big data (volume, velocity, veracity, etc)
* Identify big data problems, be able to understand the data science questions behind the data.
* Introduction to Hadoop's properties and how they relate to big data (HDFS, MapReduce).

## Why Big Data?

* Massive amounts of data, cheap storage, abundant cloud computing, business moving to real time.

* **Combining data sources is the key to unlocking interesting answers to
  problems.**

* Example : Healthcare
  * Pproducing data rapidly. Doubling in recent years.
	* One hospital has 120TB of data (and that's small).
	* EMR, scans, everything is going digital.
* Customer sentiment analysis can react faster using real time data, preventing a PR nightmare.
* 90% of data was generated in the last two years.
* Companies are moving to real time, predictive. This is a culture shift for companies - require moving to a real-time scalable compute infrastructure.

## Characteristics of data

* Structure. Data can be unstructured, semi-structured, or structured.
* 80-90% of data is unstructured.
* Volume. Size.
* Velocity. Speed generated.

## Sources of Big Data


### Machines (Sensors)

* Sensors. Satellites to watches.
* Sensors and machines are the largest and fastest generator of data.
* Analysis moving to on-device (in-situation collection and analysis). Not on a traditional server.
* Well structured.

### People

* Unstructured.
* Unstructured data must be a acquired, stored, cleaned before processing.

### Organizations

* Traditional DBs. Siloed.
* Used for historical analysis, future reporting.
* Benefits of sitting organizational data - historical analysis, prediction.
* Spending on data analytics correlates with your market position. You are more likely to succeed if you collect, analyze, act on data.

#### UPS

* 16 million shipments per day.
* 40 million tracking requests per day.
* Route optimization saves big money.

## Tooling

* Hadoop. Storage.
* Spark / storm. Streaming data analysis tools?
* Traditional structured data warehouses (EDW) are not good for storing unstructured, large amounts of data. They are not distributed, weren't designed for scaling.
* Graph databases, like Neo4j, find connections between unstructured data sets.
* Cassandra for KV storage.

## Integrating diverse data

* Why integrate multiple data sources? Knowledge, better decisions, better value of data.
* Integration is needed because data sources are in different formats, not compatible.
* Integration reduces complexity, more available, more collaborative between different datasets.


## Quiz 1

* Example of big data utilized in action today?
  * Social media.

* What reasoning was given for the following: why is the "data storage to price ratio" relevant to big data?
  * Access of larger storage becomes easier for everyone, which means client-facing services require very large data storage.

* What is the best description of personalized marketing enabled by big data?
  * Being able to use the data from each customer for marketing needs.

* Of the following, which are some examples of personalized marketing related to big data?
  * Facebook revealing posts that cater toward similar interests.

* What is the workflow for working with big data?
  * Big Data -> Better Models -> Higher Precision

* Which is the most compelling reason why mobile advertising is related to big data?
  * Mobile advertising benefits from data integration with location which requires big data.

* What are the three types of diverse data sources?
  * Machine Data, Organizational Data, and People

* What is an example of machine data?
  * Weather station sensor output.

* What is an example of organizational data?
  * Disease data from Center for Disease Control.

* Of the three data sources, which is the hardest to implement and streamline into a model?
  * People

* Which of the following summarizes the process of using data streams?
  * Integration -> Personalization -> Precision

* Where does the real value of big data often come from?
  * Combining streams of data and analyzing them for new insights.

* What does it mean for a device to be "smart"?
  * Connect with other devices and have knowledge of the environment.
  * Collect data and services autonomously.

* What does the term "in situ" mean in the context of big data?
  * Bringing the computation to the location of the data.

* Which of the following are reasons mentioned for why data generated by people are hard to process?
  * Very unstructured data.
  * The velocity of the data is very high.
  * Skilled people to analyze the data are hard to come by.

* What is the purpose of retrieval and storage; pre-processing; and analysis in order to convert multiple data sources into valuable data?
  * To allow scalable analytical solutions to big data.

* Which of the following are benefits for organization generated data?
  * Customer Satisfaction
  * Higher sales
  * Better profit margins
  * Improved safety

* What are data silos and why are they bad?
  * Data produced from an organization that is spread out. Bad because it creates unsynchronized and invisible data.

* Which of the following are benefits of data integration?
  * Increase data collaboration.
  * Adds value to big data.
  * Reduce data complexity.
  * Increase data availability.
  * Unify your data system.

  * What does it mean for a device to be "smart"?
    * Connect with other devices and have knowledge of the environment.
    * Collect data and services autonomously.

  * What reasoning was given for the following: why is the "data storage to price ratio" relevant to big data?
    * Access of larger storage becomes easier for everyone, which means client-facing services require very large data storage.


# Week 2

## Characteristics of Big Data

### 3 main big data dimensions

* Volume - amount
* Variety -  types of data
* Velocity - speed of generation and collection

* Veracity - quality. Watch for biases, abnormality, or uncertainty
* Valence - connectedness of data
* Value - How will big data benefit your company? What are your strategy / goals?


## Volume

* Data is growing exponentially.
* 1.3M likes / min on FB.
* 1TB == 400 hours of video.
* Petabytes are the new TB.
* Halderon Collider == 15 PB/year

* Digital data will grow by a factor of 44 a year. 35ZB. ZB == 1 trillion GB. 10^21. Astronomical scale.

* Terabyte == 1000^4
* Petabyte == 1000^5
* Exabyte == 1000^6
* Zettabyte == 1000^7
* Yottabyte == 1000^8

* What is the goal with big data? **Business insight / advantage!**

### Challenges of large volume

* Cost
* Scalability
* Performance

* Storage
* Access
* Processing

## Variety

* High variety == High complexity
* Data is becoming more varied, less structured.

### Axes of data Variety

* Structural variety : formats (images, text, video, binary)
* Media variety : how data gets delivered (image, video, audio, text)
* Semantic. Different meaning for the same thing. Age can be a number or a term like "infant, juvenile, adult".
* Availability. Data could be available in real time (sensor data, news streams) or intermittent (only when the device is on).

* Emails are examples variety.
  * Structured and instructured data (header == structured, body == unstructured)
  * Media (images, attachments)
  * Semantics : email cannot reference a previous email.
  * Availability. An email server is real time, an email repository is not.

## Velocity (Speed)

* Goal : real time action / decision making. You want the most relevant data whenever possible.
* Sensors can trigger a real time, life saving action.
* "Real time processing (streaming)" vs. "Batch processing"
  * Instantly capture streaming data -> feed to real time machines -> process real time -> act.
  * Batch == slow, out of date.

* The more data, processing in real time == expensive.
* Understand what your goals are. Do you need real time processing for better decision making? If so, you must choose real time.

* The goal of engineering is to process vast amounts of data faster, cheaper, and with better algorithms.

## Veracity (Quality)

* Vercity == quality. Garbage in, garbage out.
* Data has no value if it's not accurate or low quality.

* Factors effecting data quality
  * Accuracy.
  * Reliability of data source (not biased).
  * How it was analyzed before it's use.

* Enterprise data is very certain (ETL / schema).
* People and machine data is not as clean.
  * Unstructured data is not precise and uncertain.
  * High velocity data cannot run thru ETL, validation.

* Junk / spam data leads to bad analysis.
* Google Flu trends recommended 2x the actual volume of flu cases by overestimating based on internet data.

* Provenance = the ability to identify the sources / transformation that was done before analysis.

## Valence (Connectedness)

* Valence == connectedness.
* The more connected == the higher the valence.
* High valence is good. It can be connected to other data streams.
* Data can be indirectly related. Two professors are connected because they are both professors.
* Valence == the number of connected items / the total number of possible connections.
* Challenges
  * High valence == more dense.

## Quiz

* Amazon has been collecting review data for a particular product. They have realized that almost 90% of the reviews were mostly a 5/5 rating. However, of the 90%, they realized that 50% of them were customers who did not have proof of purchase or customers who did not post serious reviews about the product. Of the following, which is true about the review data collected in this situation?
  * Low Veracity (quality)

* As mentioned in the slides, what are the challenges to data with a high valence?
  * Complex Data Exploration Algorithms.

* What is the veracity of big data?
  * The abnormality of uncertainties of data.

* What are the challenges of data with high variety?
  * Hard in utilizing group event detection.

* Which of the following is the best way to describe why it is crucial to process data in real-time?
  * Prevents missed opportunities.

* What are the challenges with big data that has high volume?
  * Cost, Scalability, Performance

--------------------------------------------------------------------------------

## Defining the Question

### Data Science : Getting Value out of Big Data

* Data Science == Big Data -> Insight -> Action (Prediction)
* Data Science and models are constantly improving.
* Data Science : Intersection between math, business, and hacking.

* You need to pick your domain within data science to focus on.

* Characteristics of a data scientist:
  * Passion.
  * Curiosity.
  * Care about engineering solutions.
  * Relate problems to analytics.
  * Communicate well with teammates.

### Building a big data strategy

* Define your goals.
  * It *doesn't* start with collecting data.
  * What questions do you want answered?
  * Short term vs. long term.

* Create a culture with organizational buy-in. Build a culture of appreciation for big data.

* Build diverse teams.
  * Technologists.
  * Data scientist.
  * Business acumen.

* Constant training of teams on big data skills.
* Consider a "data incubator" team doing experiments.
* Share data. Don't hold data in silos.
* Create a mindset of data sharing.
* Define policies and regulations around handling data.
* Cultivate analytics-driven culture.
* Analytics + Business == Opportunities

### How does data science happen? 5 P's of Data Science

* People
  * Cross functional.
* Purpose
  * Goals / challenges laid out in your strategy.
* Process
  * Engineering -> data science.
  * **Acquire -> Prepare -> Analyze -> Report -> Act**
* Platforms (build for scale)
  * Hadoop
* Programmability
  * API / access to your data from multiple programming languages.

* Focus on solving your strategy and problems. Start with solving the problem or creating a product that solves business needs.

### Asking the Right Questions

* Step 1. Define the problem. What are you trying to solve?
* Step 2. Access the situation. What are the risks / benefits / regulations / resource availability (people, money, data), costs.
* Step 3. Define goals. Success criteria.
* Step 4. Formulate the questions. Remember - your ultimate goal is to add business value.

--------------------------------------------------------------------------------

## The Process of Data Analysis

* **Acquire -> Prepare -> Analyze -> Report -> Act**

* Acquire
  * Identify, retrieve data into distributed file systems.
* Prepare
  * Explore. Understand what data you have. Quality and format.
  * Pre-process. Clean, filtering, packaging it into a better structure.
* Analysis
  * Build models
* Communicate results
  * Report, summarize findings.
* Apply results
  * Act on your results!

### Acquiring Data

* Find out what data is available.
* Sensors, social networks, databases, scraping sites, APIs, fils, etc.

### Preparing Data : Exploring Data

* Goal : understand your data.
* Look for correlations, trends, outliers.
* Correlation graphs, trend graphs, can tell you the general direction of data (sales going up / down)
* Finding outliers help you check for data.
* Compute basic summary statistics :  (mean / median / mode / range).
* Visualize your data. Heat maps, trends, histograms.

### Preparing Data : Processing Data

* Goals
  * Clean data for better quality.
    * It helps to have domain knowledge when cleaning data, handling bad data (what data can you get rid of, for example).
  * Transform data to make it suitable for analysis.

* Scaling values : scaling values between 0 and 1.
* Transform data. Puts data into a form that can be analyzed.
* Dimensionality reduction : eliminating unnecessary data points. Principal Component Analysis (PCA).

### Step 3 : Analyzing Data

* Input Data -> Analysis Technique -> Model -> Output Data

* Analysis Techniques
  * Classification
    * Goal : predict the category of the input data.
      * Predict the weather.
      * Classify a tumor as benine or malignant (binary classification).
      * Identify a number between 1 and 10.
  * Regression
    * Using past performance to predict future results.
    * Predict the price of a stock.
    * Predicting the score on a test.
  * Association Analysis
    * Capture associations between items / events.
    * Customer purchasing behavior. Banking customers with CD accounts are interested in other accounts. Can be used for cross selling.
    * Product recommendations.
  * Clustering
    * Organize similar items into groups.
    * Grouping customers into segments.
  * Graph Analytics
    * Find connections between data.
    * Exploring spread of disease.
    * Identifying security threats by analyzing traffic data.

* Modeling
  * Select technique.
  * Build model.
  * Validating the model - apply it to new data samples.

* Evaluating the model
  * Classification
    * You know the correct output for a given input. Verify the model classified known values correctly.
  * Clustering
    * Do the generated clusters make sense for your application?
  * Association / Graph Analysis
    * Verify what the model predicted is what you would expect.

* Examine results
  * Do you need more data for better clustering? (i.e., Would your data be better if you had zip code?)
  * Is there a section of your results that doesn't make sense? Are you missing data?

### Step 4: Reporting : Communicating Results

* What are the main results?
* How does this add value to your business / goals?
* Visualize everything. Graphs and charts.
* D3, R, Tableau, Python (packages to support graphics), Google Charts

### Step 5 : Act : Turning Insights Into Action

* Data science is only valuable if your research is turned into action.
* As you implement changes, evaluate your success rate.


### Quiz

* Which of the following are parts of the 5 P's of data science and what is the additional P introduced in the slides?
  * Programmability, Platforms, Process, People, Purpose
  * Product

* Which of the following are part of the four main categories to acquire, access, and retrieve data?
  * Text Files
  * NoSQL Storage
  * Remote Data
  * Traditional Databases

* What are the steps required for data analysis?
  * Select Technique, Build Model, Evaluate

* Of the following, which is a technique mentioned in the videos for building a model?
  * Analysis

* What is the first step in finding a right problem to tackle in data science?
  * Not: Define goals
  * Not: Ask the right questions.

* What is the first step in determining a big data strategy?
  * Business Objectives

* According to Ilkay, why is exploring data crucial to better modeling?
  * Not : enables understanding of general trends, correlations, and outliers.
  * leads to understanding which allows an informed analysis of the data.

* Why is data science mainly about teamwork?
  * Data science requires a variety of expertise in different fields.

* What are the ways to address data quality issues?
  * Remove data with missing values.
  * Remove outliers.
  * Generate best estimates for invalid values.
  * Merge duplicate records.

* What is done to the data in the preparation stage?
  * Cleaning, Integrating, and Packaging

--------------------------------------------------------------------------------

# Week 3 : Foundations for Big Data Systems and Programming

> Big Data requires new programming frameworks and systems. For this course, we
> don't programming knowledge or experience -- but we do want to give you a
> grounding in some of the key concepts.

## Getting Started : Why do we worry about foundations?

* You need to understand the theory behind big data tools, why they are designed the way they are.

## What is a distributed file system?

* How information is stored in files is important for latency.
* A single HD or raid array won't scale.
* You need a distributed file system that is
  * Redundant / fault tolerant.
  * Fast. Highly concurrent.
  * Scalable.

* Data sets are intelligently distributed across nodes of the file system.

## Scalable Computing over the Internet

* Commodity clusters.
  * Cost effective.

* Data parallelism.
  * Each node in the cluster can work on a partial operation. (MapReduce)

* Failures are common.
  * Network, HDD in commodity box.

* Dealing with failure
  * Redundant data storage.
  * Data parallel job restart (you need a job scheduler).

## Programming Models for Big Data

* What is a programming model?
  * Abstractions on top of data and infrastructure.

* The programming model for big data provides programmability on top of your DFS.

### Requirements for a big data programming model

* Support big data operations.
  * Split large volumes of data.
  * Access data fast.
  * Distributed computations across nodes.

* Handle fault tolerance
  * Replicate data partitions.
  * Recover files when needed.

* Scalable
  * Easily adding more capacity (scaling out)

* Optimized for specific types of data
  * Documents, graph, key-value, multimedia.

* MapReduce
  * Support for large data volumes.
  * Handles fault tolerance and scaling out.
  * Split computations.
  * Efficient use of resources.
  * Job control : monitoring, load balancing.

## Quiz

* Which of the following is the best description of why it is important to learn about the foundations for big data?
  * Foundations allow for the understanding of practical concepts in Hadoop.

* What is the benefit of a commodity cluster?
  * Enables fault tolerance

* What is a way to enable fault tolerance?
  * Redundant Data Storage

* What are the specific benefit(s) to a distributed file system?
  * Large Storage
  * High Concurrency
  * High Fault Tolerance
  * Data Scalability

* Which of the following are general requirements for a programming language in order to support big data models?
  * Optimization of Specific Data Types
  * Support Big Data Operations
  * Enable adding of more racks
  * Handle fault tolerance

--------------------------------------------------------------------------------

# Week 3 : Getting Started With Hadoop

## Hadoop : Why, Where, and Who?

* What's in the hadoop ecosystem?
* Why is it beneficial?
* Where is it used?
* How is it used?

* Goals
  * Scalability. (Highly distributed using commodity clusters).
  * Fault tolerant.
  * Optimized for a variety of data types.
  * Facilitates a shared environment. Multiple jobs running simultaneously over the same data.
  * Provide business value, allow businesses to focus on their domain, not infrastructure.

* Main Hadoop Components
  * MapReduce
  * YARN
  * HDFS

* Hadoop tools
  * Zookeeper, Hive, Pig, Giraph, Storm, Spark, Flink, HBase, Cassandra, MongoDB

## The Hadoop Ecosystem : Welcome to the zoo

* 2004 : Google publishes in-house processing framework called MapReduce.
* 2005 : Yahoo implemented it, called it Hadoop.

* Base Layers (Stack) of Hadoop
  * HDFS : foundation
  * YARN : Job scheduler.
  * MapReduce : Programming model.

* Higher level programming models
  * Hive : SQL-like queries using MapReduce. Created at Facebook.
  * Pig : Data flow scripting using MapReduce. Created at Yahoo.
  * Giraph : Used for processing large scale graphs.
  * Storm, Spark, and Flink were created to do real time, in-memory processing of large scale data. Uses YARN.

* Some data is not represented well in a file system.
  * NoSQL is used for non-files. (Key / Value and sparse tables)
    * HBase
    * Cassandra
    * MongoDB

* Zookeeper
  * Handles synchronization, configuration, and ensures high availability.
  * Created at Yahoo to wrangle services named after animals.

* Cloudera, Hortonworks, MAPR offer commercial packages and offer production support.

## HDFS : A Storage System for Big Data

* Provides scalability, reliability.
* Largest Hadoop cluster : up to 200PB, 4500 servers, 1 billion files / blocks.
* HDFS distributes files across nodes in a cluster, providing the basis for distributed computation.
  * The default file chunk size is 64MB (configurable).
  * By default, each block is replicated three times (configurable per file).
* HDFS replicates blocks across nodes for fault tolerance.
* HDFS handles data in various formats.
  * Each file stored in HDFS be given a file type (data format). You can create your own data formats.

* NameNode / DataNode
  * NameNode == metadata. 1 per cluster.
  * DataNode == block storage. One per machine in cluster.

* HDFS's replication strategy provides fault tolerance and data locality.
* The goal with data locality is to **move computation to data**, not the other way around.

## YARN : A Resource Manager for Hadoop

* YARN : Yet Another Resource Negotiator
* YARN was not part of Hadoop 1.0.

* Main benefits of YARN
  * Run more job types (in-memory analysis, stream analysis, graph analysis).
  * Better resource (CPU, file system, memory) utilization.
  * Avoid need to move data around for computation.

* YARN provides non-mapreduce jobs on top of HDFS.
  * Previously, graph analysis had to be moved to another platform.
  * Storm for stream data analysis.
  * Spark for in-memory analysis.

* YARN Topology
  * Resource Manager : cluster-wide resource manager. 1 per cluster.
  * Node Manager : single node resource manager. 1 per node.
  * Container : an application (think docker image) that runs on each node.

* Each application gets an "application master".
  * Negotiates resources with the resource manager.
  * Talks to node managers to complete tasks.

## MapReduce : Simple Programming for Big Results

* Applications that use MapReduce
  * Hive : SQL-like
  * Pig : Data flow language.

* Parallel Programming is hard. We need a framework to abstract away parallelism.
* What is Map / Reduce?
  * Map : apply function to all inputs.
  * Reduce : summarize all elements.

* WordCount : read text file to read each word in a text file.
  * Step 1: Map each line. Each line is handled by a different node. Map returns key value pairs of each word and it's frequency in that line.
  * Step 2 : Sort and shuffle. All results for the same word are sent to the same node for reducing.
  * Step 3 : Reduce. Add values for the same key.

* All operations are done in parallel.

* MapReduce is good for applications with independent tasks.

* MapReduce is bad for
  * Frequently changing data. (Has to read the entire file for each map/reduce operation.
  * Dependent tasks. Each map reduce must be self contained.
  * Interactive analysis.

## When to reconsider Hadoop

* Hadoop is good for:
  * Future anticipated data growth.
  * Long term availability of data.
  * Many applications over the same data store.

* Hadoop is **not** good for
  * Small datasets.
  * Advanced algorithms (highly coupled data processing algorithms).
  * Infrastructure replacement.
  * Task level parallelism (different functions across different datasets).
  * Random data access.

## Cloud computing : An important big data enabler

* Makes infrastructure a commodity.
* Cloud keeps you focus on solving your problems, not building infrastructure.

* In-house
  * You're responsible for HW, networking, upgrades, real estate.
  * How to estimate?
  * Software stacks are complex.
  * Hardware issues + software issues == challenging

* Cloud
  * Focus on your domain experience, not infrastructure.
  * Excellent value prop.
  * Instant scalability.
  * Resource Management (security, networking, provisioning)

## Cloud Service Models : An exploration of choices

* Application (SaaS)
  * You you the applications by the provider.
  * Dropbox / CrashPlan.
* Platform (Paas)
  * You install your own applications.
  * GAE / Azure
* Infrastructure (IaaS)
  * You install / maintain your own OS / software.
  * EC2

## Value from Hadoop and Pre-build Hadoop images

* Pre-built software stacks (OS + libs + apps) using VMs (VirtualBox / VMWare)
* Can be deployed on the cloud.
* Cloudera, Hortonworks
* Advantages of prebuilt images
  * Quick prototypes.
  * Easy to scale.

## Quiz

* What does IaaS provide?
  * Hardware only.

* What does PaaS provide?
  * Computing Environment

* What does SaaS provide?
  * Software on demand

* What are the two key components of HDFS and what are they used for?
  * NameNode for metadata and DataNode for block storage.

* What is the job of the NameNode?
  * Coordinate operations and assigns tasks to Data Nodes

* What is the order of the three steps to Map Reduce?
  * Map, gather, reduce.

* What is a benefit of using pre-built Hadoop images?
  * Quick prototyping, deploying, and validating of projects.

* What are some examples of open-source tools built for Hadoop and what does it do?
  * Zookeeper, management system for animal named related components.

* What is the difference between low level interfaces and high level interfaces?
  * Low level deals with storage and scheduling while high level deals with interactivity.

* Which of the following are problems to look out for when you want to integrate your project with Hadoop?
  * Advanced Alogrithms
  * Infrastructure Replacement
  * Task Level Parallelism
  * Random Data Access

* As covered in the slides, which of the following are the major goals of Hadoop?
  * Provide Value for Data
  * Enable Scalability
  * Handle Fault Tolerance
  * Optimized for a Variety of Data Types
  * Facilitate a Shared Environment

* What is the purpose of YARN?
  * Allows various applications to run on the same Hadoop cluster.

* What are the two main components for a data computation framework that were described in the slides?
  * Resource Manager and Node Manager
