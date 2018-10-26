# Big Data : Course 4 : Machine Learning With Big Data

This course is a high level introduction to ML (in regards to big data).

## Important Notes

There were two tools used in this class to examine data.

* KNIME : Graphical drag/drop/configure tool.
  * Advantages
    * No programming.
    * Visualizations / graphs out of the box.
    * Pre-canned "nodes" for functionality.
  * Disadvantages
    * Scalability to large data sets.
    * Eclipse (big, ugly IDE)

* Spark : python based.
  * Advantages
    * Python
    * Scale
  * Disadvantages
    * Graphs
    * Not as simple to find pre-canned blocks of functionality (i.e., KNIME nodes)

## Questions

* What is a model?
  * A model is the result of running an algorithm on a set of training data, producing the rules and logic that allows you to get predictions on new data.

## Week 1

### Machine Learning with Big Data

#### Welcome to ML with Big Data

* Two ML tools used during the course
  * KNIME : graphical / visual approach to ML.
  * Spark MLLib

#### Summary of Big Data Integration / Processing

High level data science pipeline:
* Acquire -> Prepare -> Analyze -> Report -> Action

The Hadoop ecosystem (distributed, fault tolerant, scalable) was created to address big file storage (HDFS) and processing (YARN / MapReduce).

##### Hadoop Architecture

* Data Management and Storage
  * HDFS (file storage)
  * MongoDB (document storage)
  * Redis (K/V storage)
  * Lucene (vector)
  * Vertica (Column store)
  * Solr (text management)

* Data Integration and Processing
  * YARN (resource scheduling)
  * MapReduce
  * Spark / SparkSQL / SparkML

* Coordination and Workflow Management
  * Automates execution of Big Data workflows (pipelines).
  * Zookeeper

### Machine Learning Overview and Applications

#### Machine Learning Overview

* What is Machine Learning?
  * Computers (models) that can learn from data, without being explicitly programmed.
  * The volume and quality of training data improves ML performance.
  * ML discovers patterns, helps to improve decisions.

* ML is interdisciplinary
  * Computer Science / AI
  * Math / Statistics
  * Domain Knowledge

* Examples of ML
  * Credit card fraud detection.
  * Image recognition.
  * Speech recognition.
  * Handwriting recognition (OCR).
  * Product recommendations.
  * Targeting ads

* Terminology. There are many, many terms used in data science. Ultimately, they essentially mean the same thing : extracting meaning from data.
  * Machine Learning
    * The term used for models which learn from data.
  * Data Mining
    * Used in the DB context. Finds patterns in data.
    * Focused more on databases than models, but typically use the same algorithms as ML.
  * Predictive Analytics
    * Used in the business context. To predict future events.
    * Uses the same techniques used in ML.
  * Data Science
    * Processing / analyzing data to extract meaning.

* **The core techniques for extracting value from data do not change between terms. The same algorithms are used across terms.**

#### Categories of ML Techniques

* Categories of ML
  * Classification
  * Regression
  * Cluster Analysis
  * Association Analysis

* Classification
  * Goal : predict category for input data.
  * Examples:
    * Predict if it will rain tomorrow.
    * Is a loan application high or low risk?
    * Is consumer sentiment positive, negative, or neutral?

* Regression
  * Goal : predict numeric value.
  * Examples:
    * What will a stock price be tomorrow?
    * What will demand of a product be during Christmas?
    * Predict the amount of rain tomorrow.
    * Load recommender : what is the likelihood a load will be taken by a carrier?

* Classification and regression use the same analysis techniques. The difference is the output being generated. With classification, you bucket your prediction into a class. With regression, you are finding a numeric value.

* Cluster Analysis (Clustering)
  * Goal : Organize similar items into groups.
  * Examples:
    * Segment customers into groups (teens, seniors, adults).
    * Segment tweets into new topics.

* Association Analysis
  * Goal : Find rules to capture associations between items.
  * Examples:
    * Financial : Market Basket Analysis. Understanding that people who have CDs are more likely to buy other financial products.
    * Retail : Beer / Diapers were associated together. Putting the items together on the shelf increased sales of both.
    * Recommend items based on purchase history (hoses and garden soil are related).
    * Identify web pages accessed together.

* Supervised vs. Unsupervised Approaches
  * Supervised
    * Target (what the model is predicting) is provided.
    * "Labeled" data. Each sample is labeled into a category.
    * Classification and regression are supervised.
  * Unsupervised
    * Target is unknown. For example, we don't know what news stories will be found by analyzing tweets.
    * Samples are *not* labeled into a category.
    * The groups are created during analysis.
    * Cluster analysis and association analysis are unsupervised.


### Machine Learning Process

#### Goals and Activities in the ML Process

* First thing : What are your goals?
* Note that the ML process is iterative. You'll frequently need to tweak, rerun various steps in the process.

* High level ML process
  * Acquire -> Prepare -> Analyze -> Report -> Act

* Acquire
  * Goal : identify and obtain all data related to the problem.
  * What are the data sources?
    * Files, DBs, internet, devices.
  * Integrating data sources will require work.

* Prepare
  * Explore your data. Goal : understand your data.
    * What are the correlations, general trends, or outliers?
    * Describe your data.
      * Summary statistics of the data (avg, mean, median, range, std dev). Goal is to determine if there are outliers or if the data is not clean.
      * Visualization will help you understand your data as well.
  * Pre-process data
    * Goal : Create data for analysis.
    * Clean data, select data you want to use, transform data into a structure better suited for analysis.

* Analyze
  * Goal : Build an ML model, analyze data, understand results.
  * Select techniques -> Construct model -> Evaluate results.

  * Report (Communicate)
    * Graphs / charts / tables / etc.

  * Act (Reply Results)
    * What does the data tell you?
    * How are we going to implement?

#### Cross Industry Standard Process for Data Mining (CRISP-DM)

* A well adopted methodology for data mining.

* What is CRISP-DM?
  * Business Understanding
  * Data Understanding
  * Data Preparation
  * Modeling
  * Deployment

* Business Understanding
  * Define the problem / opportunity.
  * What are the goals of the project?
  * What is the risk / cost / benefit of the project?

* Data Understanding
  * Acquire and explore data.

* Data Preparation
  * Prepare data for modeling.
  * Address quality issues, make data suitable for processing.

* Modeling
  * Determine type of problem (classification, regression, etc)

* Evaluation
  * Access model performance.
  * Evaluate model with respect to success criteria. Determine if the model is good or not.
    * Clean up data?
    * More data needed?

* Deployment
  * Produce final report / document project findings.
  * Deploy the model into the application / business.
  * Monitor performance over time.

### Scalability and Tools

#### Scaling up Machine Learning Algorithms

* How do we scale big data and machine learning?
  * Scale up **not the big data approach**.
    * Bigger machines, more hardware, specialized hardware (GPU).
    * Costly. We'll eventually reach a limit (and it's a low bar).
  * Scale out
    * Commodity, distributed clusters of machines processing in parallel.
    * Distribute data and processing across machines (Hadoop / Spark (MLLib)).

#### Tools Used In This Course

* KNIME (Konstance (University in Germany) Information Miner)
  * The basic unit of functionality within KNIME is a "Node". Nodes exist for:
    * Reading files
    * Creating a model
    * Generating a plot
  * Each node has input and output ports.
  * Nodes are combined into a workflow.

* Spark MLLib
  * MLLib provides common ML routines to run on Spark.
  * Can be used from all Spark-friendly languages : `Java`, `Scala`, `Python`, `R`

## Quiz 1 : Machine Learning Overview

* What is NOT machine learning?
  * Explicit, step-by-step programming

* Which of the following is NOT a category of machine learning?
  * Algorithm Prediction

* Which categories of machine learning techniques are supervised?
  * classification and regression

* In unsupervised approaches,
  * the target is unknown or unavailable.

* What is the sequence of the steps in the machine learning process?
  * Acquire -> Prepare -> Analyze -> Report -> Act

* Are the steps in the machine learning process apply-once or iterative?
  * Iterative

* Phase 2 of CRISP-DM is Data Understanding. In this phase,
  * we acquire as well as explore the data that is related to the problem.

* What is the main difference between KNIME and Spark MLlib?
  * KNIME is a graphical user interface-based machine learning tool, while Spark MLlib provides a programming-based distributed platform for scalable machine learning algorithms.


--------------------------------------------------------------------------------

## Week 2

### Data Exploration

#### Data Terminology

There are many terms used in the "data science" landscape to describe the same two concepts.

* "Variable" or "Value" : A "column" in your database. (a.k.a, Feature, Column, Dimension, Attribute, Field.)
  * Numeric variables : ints, floats, can be only positive or negative.
  * Categorical Variables : An "enum" of potential values. "qualitative variables" or "nominal variables"
* "Sample" : A "row" in your dataset. (a.k.a. Row, record)

#### Data Exploration

* Why explore data? `To understand your data`.
* EDA : Exploratory Data Analysis. Fancy term to mean "research your data".

* How to explore data?
  * Stats. Gather summary statistics on your data set. (i.e., Aggregates, Outliers, mean, etc)
  * Graphs.

* What to look for?
  * Trends, correlations, and outliers.

* Data Exploration -> Data Understanding -> Informed Analysis

#### Data Exploration Thru Summary Statistics

* Categories of summary statistics
  * Location (mean, median)
  * Spread (distance)
  * Shape

* Measures of Location
  * Describes the central or typical value of a dataset.
  * mean / median / mode

* Spread
  * How dispersed the data is from the mean.
  * min / max / std dev (low std dev - values close to mean) / variance / range

* Shape
  * Describe the shape of the distribution of values.
  * Skewness. (0 == normal - bell shaped curve. > 0, data skewed right)
  * kurtosis - measures the tails of a curve. High peaks == outliers.

* Measures of dependence
  * Measures of dependence tell you how related two variables are (e.g., height and weight).
  * Example : correlation (between 0-1). Higher correlation == higher dependence.

* Statistics on categorical variables
  * Contingency table. Describes the frequency of values across samples.

* Data Validation Checks
  * When exploring data, consider writing a validation program (or queries) to ensure the data is valid, does not have missing values, data is within proper ranges, etc.

#### Data Exploration thru plots

* Histogram
  * Shows the distribution of a variable across "bins".
  * Tells you the "central tendency" of a variable - where most values lie.
  * Tells you the skewness of a variable.

* Line plot
  * How data changes over time.
  * Shows patterns in variables (traffic spikes in the AM).

* Scatter Plot
  * Shows relationship between two variables (one on X axis, another on Y axis).
  * Positive / Negative / Non-linear / No correlation.

* Bar Plot
  * Shows distribution of a categorical variables.
  * Can be used to compare multiple categorical variables (Grouped Bar Chart / Stacked Bar Chart).

* Box Plot
  * Shows distribution of a numeric variable.
  * The "Box" represents the middle 50% of the data.
  * A small box, large tails, tells you the data is very centralized.

## Quiz

* Which of these statements is true about samples and variables?
  * All of these statements are true.

* Other names for 'variable' are
  * feature, column, attribute

* What is the purpose of exploring data?
  * To gain a better understanding of your data.

* What are the two main categories of techniques for exploring data? Choose two.
  * Summary statistics
  * Visualization

* Which of the following are NOT examples of summary statistics?
  * data sources, data locations

* What are the two measures for measuring shape as mentioned in the lecture? Choose two.
  * Skewness
  * Kurtosis

* Which of the following would NOT be a good reason to use a box plot?
  * To show correlations between two variables.

* All of the following are true about data visualization EXCEPT
  * Is more important than summary statistics for data exploration

## Quiz - Data Exploration in KNIME and Spark

* What is the maximum of the average wind speed measurements at 9am (to 2 decimal places)?
  * `df.describe("avg_wind_speed_9am").show()`
  * 23.55

* How many rows containing rain accumulation at 9am measurements have missing values?
  * Use `df.describe().toPandas().transpose()` to see the count of `rain_accumulation_9am` - compare that count with the total number of rows in the table (number count).
  * 1095 - 1089 = 6

* What is the correlation between the relative humidity at 9am and at 3pm (to 2 decimal places, and without removing or imputing missing values)?
  * `df.stat.corr("relative_humidity_9am", "relative_humidity_3pm")`

* If the histogram for air temperature at 9am has 50 bins, what is the number of elements in the bin with the most elements (without removing or imputing missing values)?
  * in KNIME, modify the histogram plot to have 50 mins, find highest.
  * 57

* What is the approximate maximum max_wind_direction_9am when the maximum max_wind_speed_9am occurs?
  * Look at the scatter plot. X = max_wind_direction_9am, Y = max_wind_speed_9am.
  * The max wind speed gets up to around 28. When that happens, the wind direction is around 70 (E/NE).
  * 70


## Data Preparation for Machine Learning

### Data Preparation

* Goal : Prepare data for analysis.
  * Fix garbage in == garbage out.

* Data rarely ready to be analyzed. It needs to be cleaned / cleansed.

* Cleaning data : Fixing data quality issues
  * Missing values
  * Duplicate data
  * Inconsistent data.
  * Noise
  * Outliers

* Wrangle data
  * Feature selection == combine / removing unneeded columns.

  * Feature transformation
    * Scaling (all values for a column between 0 and 1)
    * Dimensionality reduction
      * Reducing columns to only those needed for analysis.

### Data Quality

* How quality is your data?
  * Poor quality
* Quality issues
  * Missing data
    * Optional values, code bugs, code collection issues.
  * Duplicate data
  * Invalid data
    * Negative age, invalid state.
  * Noise
    * Anything that can distort data. Example : background noise, completely white image.
  * Outliers
    * Sensor failure, code bugs.
    * Don't just remove outliers! Some datasets (fraud detection) **focus on** outliers.

### Addressing Data Quality Issues

* Removing Missing Data
  * Dropping samples may skew results (you're dropping real data!)
  * Imputing (Defaulting) Data
    * Imputing data means providing default values for rows w/ missing data.
      * Mean, median, mode, or a sane domain default are all possible choices.
* Duplicate data
  * Delete the older record.
  * Merge duplicate records.
* Invalid data
  * Replace w/ good data from a different data store. (i.e., Address normalization)
  * Use reasoning and domain knowledge to correct the data. (i.e., defaulting to a known default value).
* Noise
  * Filter out noise (background noise).
* Outliers
  * Remove them if they are not the focus of the analysis. (i.e., outlier sensor readings).
  * **Some algorithms want outliers**. (i.e., fraud detection)

* Domain Knowledge
  * **Required** for addressing data quality issues.

### Feature Selection (Feature Engineering)

* Goal : only select the features (data) that provides the best characteristics for the problem being analyzed.
  * Smaller the better, but don't exclude meaningful features.

* Adding features

* Removing features
  * If features are correlated (purchase price, sales tax). You can derive tax from purchase price - considering removing tax.
  * If a feature contains a lot of missing values, consider removing it.
  * Security : removing SSN, sensitive data.

* Combining features
  * Deriving and creating new features based on existing data.

* Recoding features
  * Computing new features.
  * You could derive new features from existing data.
    * Examples
      * Determining (via algorithm) if a user is a student and saving that flag with each student.
      * Separating out addresses into proper address, city, state, zip fields.

### Feature Transformation

* Feature transformation means manipulating input data into a new set of values more suitable for analysis.
* Use with caution! You don't want to ruin / skew the data you are transforming.

* Scaling
  * Turning a column from a raw value into a range between 0-1.
  * Scaling gives columns with different units of measure equal weights for easier comparison.
  * Example
    * Height (5' 11") and Weight (175) have completely different units. To simplify analysis, scaling both columns to ranges between 0-1 gives both columns "equal weight" which is useful for comparison / analysis.

* Zero-Normalization (a.k.a. Standardization)
  * Transforming results to have 0 mean, with a stddev of 1.
  * This converts each value to a number of standard deviations from the mean (with the mean == 0).
  * This is useful when their are outliers.

* Filtering
  * Remove "noise" in data
  * Examples
    * Removing noise from images.
    * High / low pass audio filter.
* Aggregation
  * Summarize data to reduce the number of data points / reduce noise.
  * Examples
    * Tracking stock prices. Use daily changes, not hour or minute.


### Dimensionality Reduction

* Dimensionality reduction - removing "dimensions" (or columns) of your data.
* Removing dimensions allow you to focus on the important data.

* Curse of dimensionality
  * The more dimensions you need to analyze, you exponentially increase the number of results.
  * Example : If you have 3 dimensions, you need a 3D plot. Simplifying it to 2D simplifies graphing / charting.

* Principal Component Analysis
  * PCA : Map data from high dimensional space into a lower dimension, keeping only useful dimensions.
  * "Principal Component" is the most relevant dimension of the data variation (the dimension that gives you the most value during analysis).
  * Finds a new coordinate system
    * PC1 captures the greatest variance.
    * PC2 captures 2nd greatest variance.
  * PCA could make the result more difficult to input. You don't have the original values in your data (salary, age, occupation, etc).

### Quiz : Data Preparation

* Which of the following is NOT a data quality issue?
  * Scaled data

* Imputing missing data means to:
  * replace missing values with something reasonable.

* A data sample with values that are considerably different than the rest of the other data samples in the dataset is called an/a _____________.
  * Outlier

* Which one of the following examples illustrates the use of domain knowledge to address a data quality issue?
  * Either
    * Drop samples w/ missing values.
    * Merge duplicate records while retaining relevant data.

* Which of the following is NOT an example of feature selection?
  * Replacing a missing value with the variable mean.

* Which one of the following is the best feature set for your analysis?
  * Feature set with the smallest set of features that best capture the characteristics of the data for the intended application

* The mean value and the standard deviation of a zero-normalized feature are
  * mean = 0 and standard deviation = 1

* Which of the following is NOT true about PCA?
  * PCA is a dimensionality reduction technique that removes a feature that is very correlated with another feature.

### Quiz : Handling Missing Values in KNIME and Spark

* If we remove all missing values from the data, how many air pressure at 9am measurements have values between 911.736 and 914.67?
  * In KNIME, create a "Missing Value" node which defaults to removing the row when any missing value is found.
  * Connect a histogram to the "Missing Value" node, with binning and aggregation columns of `air_pressure_9am`.
  * Execute and look @ the histogram.
  * `77`

* If we impute the missing values with the minimum value, how many air temperature at 9am measurements are less than 42.292?
  * In KNIME, set the "Missing Value" node default to "Minimum". Look at the `air_temp_9am` histogram.
  * `28`

* How many samples have missing values for air_pressure_9am?
  * In spark, look @ the total count of `df` (1095) to the count of `air_temp_9am` using the summary statistics for DF
    * `df.describe().toPandas().transpose()`
    * `1095 - 1092 == 3`

* Which column in the weather dataset has the most number of missing values?
  * `rain_accumulation_9am`

* When we remove all the missing values from the dataset, the number of rows is 1064, yet the variable with most missing values has 1089 rows. Why did the number of rows decrease so much?
  * Because the missing values in each column are not necessarily in the same row


--------------------------------------------------------------------------------

## Week 3

### Classification?

#### What is Classification?

Classification is the process of assigning a category to a given input. For example, given a certain set of facts about the weather, determining that the facts mean it's rainy outside. Other categories (or "classes") for weather may include sunny, cloudy, snowy, etc.

* Goal : given input variables, predict category.
* Input Values => Model => Category (a.k.a., target variable)

* Target Variable
  * Each sample is given a "target" value.
  * The "target variable" is also known as:
    * Target
    * Label
    * Output
    * Class Variable
    * Class
    * Category

* Classification is supervised.
  * With supervised ML, each sample has a label (or target).

* Types of classification
  * Binary classification. Target variable has two values (i.e., 0/1).
  * Multi-class classification. Target value has multiple values (think enum - red, green, blue, purple)

#### Building and applying a classification model

* What is a machine learning model?
  * A function which maps inputs -> outputs.
  * Example : y = mx + b

* Building a classification model (a.k.a., a "classifier").
  * The model's goal is to predict the target given the input variables.
  * With a properly "trained" model, the model will know with high probability which target will be produced for given input values.
  * Classification models break inputs into categories.
    * The model must form the boundaries separating the categories.
    * Training the model will adjust the model to find the boundaries.

* Building vs. applying a model
  * Training Phase
    * Model is constructed and parameters are adjusted.
    * Typically done with training data.
  * Testing Phase
    * The model is used with non-training test data to see how it does.

### Classification Algorithms

* kNN
  * "k nearest neighbors"
    * Classify based on neighbors (graph theory).
* Decision Tree
  * Multiple decisions paths on a tree.
* Naïve Bayes
  * Probabilistic approach. Applying a function to determine probability of a sample.

#### k-Nearest Neighbors

* How does kNN work?
  * Given a sample, find the nearest k samples. These are the "neighbors".
  * Using the labels of neighbors, label the new sample.
    * In event of ties, a tie breaker may be required (random?).

* Distance Measure
  * Need to measure "closeness" for each sample. That will vary based on the input data.

* kNN Classification
  * kNN does *not* require a separate training phase.
  * Can generate complex decision boundaries (allowing for complex decisions to be made).
  * Acceptable to noise since only a few points are used to label new samples.
  * Can be slow
    * Distance of all nodes must be evaluated to determine the label of a new sample.

#### Decision Trees

* Decision Tree Overview
  * Divide all samples into regions as pure as possible. Each region has the same class.

* Classification using Decision Tree
  * Build a tree of decisions.
  * Each sample runs through each decision in the tree, eventually landing on a leaf node.
  * Tree depth == max distance between root and leaf nodes.
  * Tree size == total decision and leaf nodes.

* Constructing Decision Tree
  * Partition samples to create subsets.
  * The subsets should be as pure as possible.
  * "Tree Induction" is a term for the act of building a decision tree.

* How to determine the best split?
  * Goal : subsets as homogeneous (pure) as possible.

* Impurity Measure
  * The measure of purity in a set. This measure determines the best possible split.
  * Gini index. The lower the gini index (impurity), the more pure.

* What variable to split on?
  * The decision tree will test and split on all variables.

* When to stop splitting a node?
  * When all samples have the same class label. (Completely pure - very rare in the real world).
  * The number of samples in each node reaches a minimum.
    * There are not enough samples in each category.
  * When the impurity difference between nodes is too small (the nodes have too much in common).
  * Max tree depth you define is reached.

* Decision Boundaries
  * Rectilinear : decision boundaries are based on only one variable. They are parallel to a graph axis.

* Decision Tree for Classification
  * Resulting tree is often simple and easy to interpret.
  * Good starting model to get an idea. The tree is a simple model. It's a good starting point.
  * Computationally inexpensive.

#### Naïve Bayes

* Overview
  * Based on probability.
  * Why is it called "Naive"?
    * It assumes that each variable in the calculation is independent.
    * There are times when variables in the calculation correlate (smoking, cancer).
    * Because Bayes does not consider the interaction between two variables, it is naïve.

* Probability of Event
  * P(A) = # ways A can occur / total possible outcomes
  * Example:
    * Probability of rolling 6?
      * P(6) = 1/6

* Joint Probability
  * Probability of multiple variables occurring together.
  * Example:
    * Probability of rolling 2 sixes?
      * P(6, 6) = 1/6 * 1/6 == 1/36

* Conditional probability
  * Probability of A occurring, given B has already occurred.
  * P(A | B) = P (A,B) / P(B)
  * Example:
    * Given a single die of 6, probability of another 6?
    * P(6 | 6) = 1/36 / 1/6 == 1/6

* Bayes Theorem
  * P(B | A) = (P(A | B) * P(B)) / P(A)

* Classification with probabilities
  * Given a feature vector X (X1, X2, X3), determine which class is more probable.
    * Look thru each class - determine probability.
    * The class with the highest probability is the class for vector X.

* Bayes Theorem for Classification
  * Important : assume X is a vector of values.
    * Example : income, debt, credit score, marital status, age.
  * P(C | X) = (P(X | C) * P(C)) / P(X)
  * In English: The probably that the sample X will be in class C is..
    * The probability of X given class C * the probability of C, divided by the probability of X.
    * The probability of X is constant (there are a constant set of input values) and can be ignored.
    * The probability of X given C and the probability of C by itself can be determined from the data.

* Finding the probability of a class (P(C))
  * Number of samples in the class / the total number of samples.
  * Example:
    * 10 green, 10 blue.
    * Probability of green or blue = 10/20 = .5

* Estimating the probability of X for C.
  * Use the "independence assumption".
    * Treat each feature (value) in X independently.
      * P(X | C) = P(X1 | C) * P(X2 | C) * P(X3 | C)
  * Example: Given X (income, debt, credit score, ...) is the chance "Good" the loan will be paid off?
  * P (income | "Good") * P (debt | "Good") * P(credit score | "Good")

* Estimating P(Xi | C)
  * P(Home Owner = Yes | Loan Default = No) = 3/7
    * What is the probability of being a home owner who has not defaulted on a loan?
  * P(Marital Status = Single | Loan Default = Yes) = 2/3
    * What is the probability of being single who has defaulted on a loan?

Home Owner | Marital Status | Loan Default
Yes        | Single         | No
No         | Married        | No
No         | Single         | No
Yes        | Married        | No
No         | Divorced       | Yes
No         | Married        | No
Yes        | Divorced       | No
No         | Single         | Yes
No         | Married        | No
No         | Single         | Yes

* Naïve Bayes Classification
  * Fast and Simple. Iterative processing is not necessary.
  * Scales well.
  * Independence assumption may not hold true.
    * In practice, it still works quite will.
  * Does not model interaction between features.

### Quiz : Classification

* Which of the following is a TRUE statement about classification?
  * Classification is a supervised task.

* In which phase are model parameters adjusted?
  * Training phase

* Which classification algorithm uses a probabilistic approach?
  * naive bayes

* What does the 'k' stand for in k-nearest-neighbors?
  * the number of nearest neighbors to consider in classifying a sample

* During construction of a decision tree, there are several criteria that can be used to determine when a node should no longer be split into subsets. Which one of the following is NOT applicable?
  * The value of the Gini index reaches a maximum threshold.
  * NOTE : Gini measures **impurity**. You want to stop on a *low* gini index (highly pure).

* Which statement is true of tree induction?
  * All of these statements are true of tree induction.

* What does 'naive' mean in Naive Bayes?
  * The model assumes that the input features are statistically independent of one another. The 'naïve' in the name of classifier comes from this naïve assumption.

* The feature independence assumption in Naive Bayes simplifies the classification problem by
  * allowing the probability of each feature given the class to be estimated individually.

## Hands On

The goal : build a classification model (decision tree) to predict days with low humidity.

## Quiz

* KNIME: In configuring the Numeric Binner node, what would happen if the definition for the humidity_low bin is changed from]

```
] -infinity ... 25.0 [
to
] -infinity ... 25.0 ]
```

(i.e., the last bracket is changed from [ to ] ?
  * The definition for the humidity_low bin would change from excluding 25.0 to including 25.0

* KNIME: Considering the Numeric Binner node again, what would happen if the “Append new column” box is not checked?
  * The relative_humidity_3pm variable will become a categorical variable

* KNIME: How many samples had a missing value for air_temp_9am before missing values were addressed?
  * 5

* KNIME: How many samples were placed in the test set after the dataset was partitioned into training and test sets?
  * Right click the partition node, select "Second partition". That shows all data in the second partition.
  * 213

* KNIME: What are the target and predicted class labels for the first sample in the test set?
  * Right click the predictor node. Look at the "classified data". Both the target and predicted columns exist.
  * Both are humidity_not_low

* Spark: What values are in the number column?
  * Integer values starting at 0

* Spark: With the original dataset split into 80% for training and 20% for test, how many of the first 20 samples from the test set were correctly classified?
  * 19

* Spark: If we split the data using 70% for training data and 30% for test data, how many samples would the training set have (using seed 13234)?
  * 730

--------------------------------------------------------------------------------

## Week 4 : Evaluation of Machine Learning Models

### Overfitting : What is it and how would you prevent it?

* `Error Rate` (a.k.a., misclassification rate or just `error`)
  * The rate at which the classifier prediction does not match the actual target.
* `Generalization`
  * How well your model performs on test data.
  * Generalization is the measurement of overall model quality.
  * You want `Good Generalization` (low error rate).

* `Overfitting`
  * Low training error, high test error == `Poor Generalization`
  * The model is modeling the noise in the training data (its trying to be too accurate and is thus missing the general trends).
  * The model is trained *exactly* for the training data, not for understanding the underlying data.
  * The model has too many parameters. It is too complex. You need to simplify the model, but keep the accuracy high.

* `Underfitting`
  * The model doesn't understand the training *or* test data.
  * The model is broken. It needs to be fixed.

#### Overfitting in decision trees (and how to avoid it)

* Goal : simplify the model! Prune the tree.

* `Pre-pruning`
  * Stop growing the tree to avoid overfitting.
  * Stop when number of records is < a min threshold (don't expand until nodes are large enough)
  * Stop expanding when the impurity measure is < a min threshold (don't expand when the node is good!)

* `Post-pruning`
  * Grow tree to maximum size, then prune the tree.
  * Remove nodes bottom up.
  * Replace leaf nodes which, if removed, do not increase the error rate.

* **Post pruning produces better results (but more expensive).**
  * Post pruning has the entire picture of the tree to use when determining what to remove.

#### Using a validation set

In order to determine when to stop training a model, the model is executed against a `Validation` data set. The goal of the validation data set is to determine when to stop training to avoid overfitting.

* Model selection
  * The process of determining which version of a model to use.
  * As you are building a model, you constantly validate it using validation data.
  * When the model starts to increase error rates on validation data, training can stop (you are overfitting).
  * This is the model version you want to select.

* How to create / use a validation set?
  * `Holdout Method`
    * Keep ("hold") part of the training data to use as validation data.
    * Make sure the training / holdout sets have the same distribution of data!
  * `Repeated Holdout / Random Subsampling`
    * Repeat holdout method several times.
    * Randomly select a different Holdout set each iteration.
    * Average validation errors over all repetitions.
  * `K-Fold Cross Validation (a.k.a. "CV")`
    * Use a different portion of the training data for validation.
    * Average the error rate across all partitions.
    * The model with the lowest average error rate across partitions is selected.
    * *This is popular*
  * `Leave-One-Out Cross Validation`
    * Use the K-Fold algorithm, but only validate one sample.

* Datasets used in model building
  * Training : Adjust model parameters.
  * Validation : Determine when training should stop.
  * Test : Evaluate model performance. Must **not** be used to train model.

* **All datasets must include a realistic (and similar) distribution of data matching the real world.**


### Model Evaluation Metrics and Methods

#### Metrics to Evaluate Model Performance

* There are a few common ways to evaluate if a model is working.
  * Accuracy / error rate.
  * Precision & Recall
  * F-Measure

* Types of binary classification errors
  * True Positive (TP) : The actual label and predicted labels are true.
  * True Negative (TN) : The actual label and predicted labels are false.
  * False Positive (FP) : The actual label is false, the predicted label is true.
  * False Negative (FN) : The actual label is true, the predicted labvel is false.

* Accuracy Rate
  * # correct predictions / # total predictions

* Error Rate
  * 1 - Accuracy Rate

* Limitations with accuracy
  * `Class Imbalance Problem`
    * There are not enough samples in a given class to accurately build a model.
    * Example : "Is this tumor cancerous?"
      * Assume only 3% of samples are cancerous.
      * If the model predicted **all** samples as negative, it would have a 97% accuracy rate. That is excellent.
      * In reality, it can't identify any samples as positive.

* Precision & Recall
  * Precision (measure of exactness) = TP / (TP + FP)
    * Precision answers : "How many selected items are relevant?"
  * Recall (measure of completeness) = TP / (TP + FN)
    * Recall answers : "How many relevant items are selected?"

  * Goal : Maximize both precision and recall.

* F-Measure
  * We want to measure precision and recall together.
  * The F-Measure is single value which combines both.
  * F(1) = 2 * (Precision * Recall) / (Precision + Recall)
    * F(1) : precision and recall are equally weighted.
    * F(2) : weights recall more.
    * F(0.5) : weights precision more.

*

#### Confusion Matrix

* Confusion matrix
  * The confusion matrix puts binary outcomes into a table.
  * The table is a more intuitive way to look at accuracy / error rates.

```
TP = 3   FN = 2
FP = 1   TN = 4
```

* Accuracy rate
  * The diagional is the accuracy rate: (TP + TN) / # samples
  * The reverse diagional is the eror rate (FP + FN) / # samples

* Misclassifications in the confusion matrix
  * High FP = classifying negatives is problematic.
  * High FN = classifying positives is problematic.

## Quiz : Model Evaluation

* A model that generalizes well means that
  * The model performs well on data not used in training.

* What indicates that the model is overfitting?
  * Low training error and high generalization error

* Which method is used to avoid overfitting in decision trees?
  * Pre-pruning and post-pruning

* Which of the following best describes a way to create and use a validation set to avoid overfitting?
  * All of these

* Which of the following statements is NOT correct?
  * The test set is used for model selection to avoid overfitting.

* How is the accuracy rate calculated?
  * Divide the number of correct predictions by the total number of predictions

* Which evaluation metrics are commonly used for evaluating the performance of a classification model when there is a class imbalance problem?
  * precision and recall

* How do you determine the classifier accuracy from the confusion matrix?
  * Divide the sum of the diagonal values in the confusion matrix by the total number of samples.


## Quiz : Hands On

* KNIME: In the confusion matrix as viewed in the Scorer node, low_humidity_day is:
  * the target class label

* KNIME: In the confusion matrix, what is the difference between low_humidity_day and Prediction(low_humidity_day)?
  * low_humidity_day is the target class label, and Prediction(low_humidity_day) is the predicted class label

* KNIME: In the Table View of the Interactive Table, each row is color-coded. Blue specifies:
  * that the target class label for the sample is humidity_not_low

* KNIME: To change the colors used to color-code each sample in the Table View of the Interactive Table node:
  * change the color settings in the Color Manager node

* KNIME: In the Table View of the Interactive Table, the values in RowID are not consecutive because:
  * the RowID values are from the original dataset, and only the test samples are displayed here

* Spark: To print out the accuracy as a percentage, use the following code:
  * print ("Accuracy = %.2g" % (accuracy * 100))

* Spark: In the last line of code in Step 4, the confusion matrix is printed out. If the “transpose()” is removed, the confusion matrix will be displayed as:

```
array([[87., 14.],
       [26., 83.]])
```


--------------------------------------------------------------------------------

## Week 5 : Regression, Cluster Analysis, and Association Analysis

### Regression

#### Regression Overview

* Similar to classification, however the output is a value, not a category.
* Regression is supervised - the target is known.
* Goal: given inputs, predict a value.
* Examples:
  * Predict a housing / stock price.
  * Predict power usage for next month.
  * Predict tomorrow's temperature.

* Regression uses the same training / validation / test data sets as classification.


#### Linear Regression

* Linear regression captures the relationship between input / output values.
* Linear regression finds the best linear fit between two variables.
  * The `regression line` is the best fit linear line (y = mx + b).

* Least squares method
  * Finds the regression line that minimizes the error between the regression line and samples.

* Simple linear regression - single input variable.
* Multiple linear regression - multiple input variables.

### Cluster Analysis

#### Cluster Analysis (Clustering)

* Goal: organize similar items into groups.
* Clustering is unsupervised.
  * There are no pre-defined labels or clusters for each input source.

* Examples:
  * Divide customer base into segments based on purchased history.
  * Grouping news articles into topics.

* Similarity measures - how to measure the distance (similarity) between two samples
  * Euclidean distance (straight line distance)
  * Manhattan distance (measure between up / down only)
  * Cosine distance (the cosine of the angle between two points)

* When comparing distance, it helps to normalize input variables (i.e., 0.0 - 1.0).

* Cluster analysis
  * There is no "correct" clustering results. The created clusters will depend entirely on the input data.
  * Clusters don't have lables.
  * After clustering, examine data within the cluster to determine what labels to apply.
  * Once clusters have labels, samples in the clusters can be used as labeled data for classification or regression.
  * Cluster analysis can be used for anomaly detection.
    * If a sample clearly does not fit in any cluster, it is an anomaly.

#### k-Means Clustering

* The goal of k-Means clustering is to cluster samples together based on a set of variables.

* The k-Means clustering algorithm
  * Select k initial cluster centers (centroids).
    * The initial centroids could be random or evenly distributed across the sample space.
  * Repeat the following until your stop criteria is met:
    * Assign each sample to the cluster based on the closest centroid.
    * Recalculate new cluster centroids.

* Where to place initial centroids?
  * The position of the initial centroids will influence final clusters.
  * Run k-means multiple times - favor centroids which produce the lowest WSSE (overall error rate).

* Evaluating cluster results (WSSE)
  * Clusters are considered "more correct" when the samples are tightly grouped within a cluster and clusters are far away.
  * In order to quantify the results, measure "Within-Cluster Sum of Squared Error"
    * Find the error for each cluster.
      * Sum of sequared error for each sample. (error = distance between sample and centroid)
    * Sum the error for all clusters.

* Using WSSE
  * Smaller is not always better.
  * Larger k values will *always* reduce WSSE. Make sure WSSE is compared for the same value of k.

* Choosing value for `k`
  * Visualization techniques. Is there natural grouping of data (graphs, etc).
  * Is there a domain (number of product categories) that you want to use?
  * Data analysis
    * "Elbow method"
      * Run k-Means using multiple values for `k`.
      * Plot `WSSE` for each value of `k`.
      * If the resulting graph has an "elbow" (i.e., the error rate starts to level off), the elbow indicates that further splitting the data set into clusters does not reduce the error. **Use the elbow value for k**.

* When to stop iterating?
  * No changes to centroids (thus no changes to sample assignments).
  * Number of samples changing custers is below a threshold.

* Interpreting Results
  * The cluster centroids are the strongest sample within a cluster. Use them to represent the cluster.
  * Example : if the clusters differ in age, the samples are partially being clustered by age.


#### Association Analysis

* Goal: Find rules to capture associations between items.
* Example: People who buy diapers also buy beer.

* Association Analysis Examples
  * "Market Basket Analysis" : What items are purchased together?
  * Recommended items.
  * Identify effective treatments for medical conditions.

* Association Analysis Overview
  * Given "item sets" (groups of items), determine which items occur together.

* Steps
  * Create item sets.
    * {bread}, {butter}, {bread, milk}
  * Identify frequent item sets
    * {bread}, {bread, milk}
  * Generate rules
    * {bread, milk} => {diapers}

* Association analysis is unsupervised.
* The rules created by association analysis may not be useful.
* **You need to analyze the rules to determine which ones make sense.

#### Steps in Association Analysis

* Rule Terms
  * Support
    * The frequency the item exists in item sets. Remove item sets which do not have support.
  * Rule
    * X -> Y (if antecedent then consequent)
  * Rule Confidence
    * confidence(X -> Y) = support(X U Y) / support(X)
    * The confidence in rule (X -> Y) == the support for X and Y together divided by the support for X.
    * This measures how often Y occurs in transations that contain X.

* Create item sets / prune.
  * Create 1 item sets. (Prune all sets w/ support < your threshold>)
  * Create 2 item sets.
  * Create n-1 item sets.

* Rule Generation & Pruning
  * How do you determine what rules you want to keep?
    * Set a minimum confidence threshold. (Only keep rules with high confidence).
    * Starting with a 3 item set.
      * Assume : {bread, milk, diaper}
      * 1. Create a rule {bread, milk} -> {diaper}
      * 2. Find the confidence in the rule:
      * 3. Filter out all rules below your confidence threshold.
```
conf (x -> y) = supp(X U Y) / supp(X)
supp({bread, milk, diaper}) == 3/5
supp(X) == 3/5
Confidence = 3/5 / 3/5 == 1
```

* Association Analysis Steps
  * Create item sets from data.
  * Identify frequent item sets using support.
  * Rules generated from frequent item sets are pruned using confidence.

## Quiz

* What is the main difference between classification and regression?
  * In classification, you're predicting a category, and in regression, you're predicting a number.

* Which of the following is NOT an example of regression?
  * Determining whether power usage will rise or fall

* In linear regression, the least squares method is used to
  * Determine the regression line that best fits the samples.

* How does simple linear regression differ from multiple linear regression?
  * In simple linear regression, the input has only one variable. In multiple linear regression, the input has more than one variables.

* The goal of cluster analysis is
  * To segment data so that differences between samples in the same cluster are minimized and differences between samples of different clusters are maximized.

* Cluster results can be used to
  * All of these choices are valid uses of the resulting clusters.

* A cluster centroid is
  * The mean of all the samples in the cluster

* The main steps in the k-means clustering algorithm are
  * Assign each sample to the closest centroid, then calculate the new centroid.

* The goal of association analysis is
  * To find rules to capture associations between items or events

* In association analysis, an item set is
  * A transaction or set of items that occur together

* The support of an item set
  * Captures the frequency of that item set

* Rule confidence is used to
  * Prune rules by eliminating rules with low confidence

## Hands On

* What percentage of samples have 0 for rain_accumulation?
  * 157812 / 158726 = 99.1%

* Why is it necessary to scale the data (Step 4)?
  * Since the values of the features are on different scales, all features need to be scaled so that no one feature dominates the clustering results.

* If we wanted to create a data subset by taking every 5th sample instead of every 10th sample, how many samples would be in that subset?
  * 317,452

* This line of code creates a k-means model with 12 clusters. What is the significance of “seed=1”?
  `kmeans = KMeans (k=12, seed=1)`
  * This sets the seed to a specific value, which is necessary to reproduce the k-means results

* Just by looking at the values for the cluster centers, which cluster contains samples with the lowest relative humidity?
  * Cluster 9
  * Try cluster 4 - maybe they are 0 basing the list?


* What do clusters 7, 8, and 11 have in common?
  * They capture weather patterns associated with high air pressure
  * Try "warm and dry" - maybe they are 0 basing the list?


```
featuresUsed = ['air_pressure',
                'air_temp',
                'avg_wind_direction',
                'avg_wind_speed',
                'max_wind_direction',
                'max_wind_speed',
                'relative_humidity']
        pressure         temp    avg_wind_dir avg_wind_speed max_wind_dir max_wind_speed relative_hum
array([ 0.50746307, -1.08840683, -1.20882766, -0.57604727, -1.0367013 , -0.58206904,  0.97099067]),
array([ 0.14064028,  0.83834618,  1.89291279, -0.62970435, -1.54598923, -0.55625032, -0.75082891]),
array([ 0.3334222 , -0.99822761,  1.8584392 , -0.68367089, -1.53246714, -0.59099434,  0.91004892]),


array([ 0.14064028,  0.83834618,  1.89291279, -0.62970435, -1.54598923, -0.55625032, -0.75082891]),
array([-0.0339489 ,  0.98719067, -1.33032244, -0.57824562, -1.18095582, -0.58893358, -0.81187427]),
array([ 0.3051367 ,  0.67973831,  1.36434828, -0.63793718,  1.631528  , -0.58807924, -0.67531539])]
        ```

* If we perform clustering with 20 clusters (and seed = 1), which cluster appears to identify Santa Ana conditions (lowest humidity and highest wind speeds)?
  * Cluster 12

* We did not include the minimum wind measurements in the analysis since they are highly correlated with the average wind measurements. What is the correlation between min_wind_speed and avg_wind_speed (to two decimals)? (Compute this using one-tenth of the original dataset, and dropping all rows with missing values.)
  * `df.stat.corr("min_wind_speed'", "avg_wind_speed")`
  * 0.97
