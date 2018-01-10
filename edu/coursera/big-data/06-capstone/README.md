# Week 1 : Big Data - Capstone Project

* Week 1/2 : Data Analysis w/ Splunk / Open Office
* Week 3/4 : KNIME, Spark, MLLib / Gephi
* Week 5   : Reports / Slides

### Feedback (Capstone Project)

* Teach the splunk query syntax prior to writing queries.
    * Same as `Cypher` when learning `Neo4j`. We didn't learn cypher first.

##  Final Project

* 10 minute slide presentation w/ written script.
    * [Presentation](https://docs.google.com/presentation/d/1OO82dc8Mv0rPeml3ZdVnIXF3IUXWpiS4XZ9nUA-Ems8/edit?usp=sharing)

* Technical appendix. Built each week, reviewed with peers.

Analyze game data. Game play / social behavior/ ad targeting.

## Introduction to the Capstone Project

### Catch the Pink Flamingo : Game Play Introduction

* Players (or teams?) must have at least 1 point in every map grid cell to advance levels.
* Missions change in real time.
* Example : "Catch the flamingos on land with stars on their belly"
* User gets `+1` for a score tap, `-2` for an invalid tap.
* Level 1 : Training level. (team by yourself)
* After level 1, user joins (or creates) a team. Teams of 1 are allowed.

#### Data Elements

##### Ranking of Users

* Users are ranked on speed and accuracy.
* Other users can see a user's map.
* Users are categorized into categories:
    * "rising star", "veteran", "coach", "social butterfly", "hot flamingo"

##### Ranking of Teams

* Teams are ranked / shown publicly.
* 30 member team max / min 1.
* Players ask to join a team, require 80% of team members to approve.
* Teams can recruit and outvote a player.
* Users who switch teams bring their points to a new team.

##### In-game Purchases

* Binoculars to spot mission specific flamingos.
* Special flamingos which count for > 1 point.
* Ice blocks to freeze a mission for 20 secionds.
* Trading cards to transfer extra points between grid cells.

##### Game Completion

* The game never ends. We must keep making it more challenging.


### A conceptual Schema for Catch the Pink Flamingo

#### ERD (User / Team / Session)

* User
    * timestamp (creation date)
* Team
    * strength
* Team Assignment :user / team assignment
* LevelEvents
* User_Sessions : Which users are playing during a session. teamLevel / platform.
* AdClicks / BuyClicks : tied to a session.
* GameClicks : keep track of each user click - in particular if the click was a "hit" or a "miss".

#### Graph (Chat)

* User / Team / Chat Session / Chat Item
* Each team has a single chat session at a time.
* A "Chat Item" is a unique message. No text is analyzed as part of this project.



## Acquiring, Exploring, and Preparing the Data

* Splunk installs into: `/opt/splunk`
* `$ splunk start`
* `http://localhost:8000`
* username : admin
* password : asdfasdf

* What operating systems are users using?
    * `source="/home/cloudera/big-data/big-data-capstone/flamingo-data/user-session.csv" | stats count by platformType`
* What are the two most commonly clicked ads?
    * `source="/home/cloudera/big-data/big-data-capstone/flamingo-data/ad-clicks.csv" | stats count by adCategory | sort 2 -num(count)`
* What are the two most commonly purchased products?
    * `source="/home/cloudera/big-data/big-data-capstone/flamingo-data/buy-clicks.csv" | stats count by buyId | sort 2 -num(count)`
* What is the average team size?
    * `source="/home/cloudera/big-data/big-data-capstone/flamingo-data/team-assignments.csv" | stats count by team | stats avg(count)`
* How many users made a purchase?
    * `source="/home/cloudera/big-data/big-data-capstone/flamingo-data/buy-clicks.csv" | stats count values(userId)`
* Who made the most purchases?
    * `source="/home/cloudera/big-data/big-data-capstone/flamingo-data/buy-clicks.csv" | stats count by userId | sort 1 by -count`

### Aggregate Calculations

* What is the hit ratio?
    * `source="/home/cloudera/big-data/big-data-capstone/flamingo-data/game-clicks.csv" | stats avg(isHit)`

* Find min / max price and total price paid by users
    * `source="buy-clicks.csv" | stats min(price), max(price), sum(price)`

* Filtering w/ Aggregation
    * Average team level for windows users
        * `source="user-session.csv" platformType="windows" sessionType="end" | stats avg(teamLevel)`
    * Average team level for iPhone or mac.
        * `source="user-session.csv" (platformType="iphone" OR platformType="mac") sessionType="end" | stats avg(teamLevel)`

* Filter and projection using `table`
    * `table` allows you to select (project) which fields to return.
    * `source="user-session.csv" sessionType=end teamLevel=2 platformType=android | table userId, platformType | sort num(userId)`

### Quiz : Data Exploration With Splunk

* The ad-click events are listed in the file ad-clicks.csv. Each advertisement that is clicked on by a user generates $0.50 of revenue. What is the total amount of revenue generated by the ad-click events?
    * How many ads were clicked on?
    * `source="ad-clicks.csv" | count` == 16323 == `8161.50`

* How many different categories of advertisements are there?
    * `source="ad-clicks.csv" | stats count by adCategory` = 9

* Let’s say electronics generates $0.75, and the other types of advertisements generate $0.40. What is the total amount of revenue?
    * Electronics = 1097 * .75 == 822.75
    * Rest = (16323 - 1097) = 15226 * .40 = 6090.40
    * 822.75 + 6090.40 = `6913`.15

* The file buy-clicks.csv lists the in-app purchases and the price of each purchase. When a user purchases an item, the company gets 2% of the price. How much revenue does the company make from the purchases in buy-clicks.csv?
    * What is the total revenue paid by users?
        * `source="buy-clicks.csv" | stats sum(price)` = 21407 * .02 = `428.14`

* How many distinct items can be purchased?
    * Note that this answer is not correct. There could be products advertised which were *not* purchased. We **should** query into `ad-clicks.csv`, however `ad-clicks` does not have a field for the product being advertised.
    * `source="buy-clicks.csv" | stats count by (buyId)` == 6

* How much does the most expensive item cost?
    * `source="buy-clicks.csv" | stats max(price)` == 20.0

* What is the buyId of the item that is purchased the most?
    * `source="buy-clicks.csv" | stats count by buyId | sort - count` == 2

### Peer Graded Assignment : Data Exploration Technical Appendix

* Provide a quick review of the data files available for analysis.
* Report your key findings from your aggregation analysis.
* Report on your key findings from your filtering analysis.

* Filtering and aggregation example grouping by a field. Note the `by userId`.
    * What is the isHit ratio for users 417 and 12?
    * `source="game-clicks.csv" userId = 417 OR userId = 12 | stats avg(isHit) by userId`



## Week 2

### Classification in KNIME (Review)

* Goal: predict low humidity days.
    * High air pressure + high temp (warm) + wind from the East (dry) == low humidity

### Assignment

* Read in the data from the file combined_data.csv. Identify the number of samples.
    * 4619

* Filter samples (i.e., rows) to only contain those with purchases and identify that number. NOTE: You will need to add a new node to your KNIME workflow for this. The new node should be placed between the File Reader and Color Manager nodes.
    * 1411

### Decision Tree Analysis

* What makes a user a HighRoller? Draw some insights from your analysis. Hint: Look at the resulting decision tree.
    * The OS the player uses.

* Give 2 recommendations to increase revenue you would propose based on these insights.
    * Offer promotions to iOS / Android users.
    * Reposition development effort around iOS / Android products.


## Week 3 : Clustering Analysis

```

//
// You must be in the `capstone` project directory when running
// pyspark. ./lib/ contains spark-csv
//

cd /home/cloudera/big-data/courseraDataSimulation/capstone/readings
$ pyspark --packages com.databricks:spark-csv_2.10:1.5.0

```

### Discussion Question: How would you cluster users?

* Revenue
    * What are the characteristics of users who have the most revenue?
    * What are the characteristics of users who click the most ads?

    * Example characteristics
        * Platform type.
        * Team level.

* Gaming characteristics
    * Team level
    * Frequency of player (daily, occassionally, one and done)
    * Chat behavior)
* Gaming style
    * Completionist, hoarder, minimalist.

* What are the characteristics of users with the most buy clicks?

### Discussion Question: How many clusters would you split the data into (2-3, or 20+)?

* What is the variation / number of features you are looking at?
    * The more clusters, the less variation between clusters.



## Week 4: Graph Analytics w/ Neo4j

```
// NOTE : Files must be copied to the neo4j sandbox located at
    /usr/local/Cellar/neo4j/3.3.0/libexec/import


//
// Create node constraints on all nodes
//
CREATE CONSTRAINT ON (u:User) ASSERT u.id IS UNIQUE;
CREATE CONSTRAINT ON (t:Team) ASSERT t.id IS UNIQUE;
CREATE CONSTRAINT ON (c:TeamChatSession) ASSERT c.id IS UNIQUE;
CREATE CONSTRAINT ON (i:ChatItem) ASSERT i.id IS UNIQUE;

///////////////////////////////////////////////////////////////////////////////
//
// chat_create_team_chat
//
///////////////////////////////////////////////////////////////////////////////

// 0 == userId
// 1 == teamId
// 2 == teamChatSessionId
// 3 == timestamp

// Creates the User, Team, and TeamChatSession nodes (if they do not already exist))
// Creates a "CreatesSession" relationship between the user and chat session.
// Creates a OwnedBy relation between the user and the chat session.

LOAD CSV FROM "file:///big-data/datasets/big-data-capstone/chat/chat_create_team_chat.csv" AS row
MERGE (u:User {id: toInteger(row[0])})
MERGE (t:Team {id: toInteger(row[1])})
MERGE (c:TeamChatSession {id: toInteger(row[2])})
MERGE (u)-[:CreatesSession{timeStamp: row[3]}]->(c)
MERGE (c)-[:OwnedBy{timeStamp: row[3]}]->(t);


///////////////////////////////////////////////////////////////////////////////
//
// chat_join_team_chat
//
///////////////////////////////////////////////////////////////////////////////

LOAD CSV FROM "file:///big-data/datasets/big-data-capstone/chat/chat_join_team_chat.csv" AS row
MERGE (u:User {id: toInteger(row[0])})
MERGE (c:TeamChatSession {id: toInteger(row[1])})
MERGE (u)-[:Joins{timeStamp: row[2]}]->(c);

///////////////////////////////////////////////////////////////////////////////
//
// chat_leave_team_chat
//
///////////////////////////////////////////////////////////////////////////////

LOAD CSV FROM "file:///big-data/datasets/big-data-capstone/chat/chat_leave_team_chat.csv" AS row
MERGE (u:User {id: toInteger(row[0])})
MERGE (c:TeamChatSession {id: toInteger(row[1])})
MERGE (u)-[:Leaves{timeStamp: row[2]}]->(c);

///////////////////////////////////////////////////////////////////////////////
//
// chat_item_team_chat
//
///////////////////////////////////////////////////////////////////////////////

LOAD CSV FROM "file:///big-data/datasets/big-data-capstone/chat/chat_item_team_chat.csv" AS row
MERGE (u:User {id: toInteger(row[0])})
MERGE (c:TeamChatSession {id: toInteger(row[1])})
MERGE (ci:ChatItem {id: toInteger(row[2])})
MERGE (u)-[:CreateChat{timeStamp: row[3]}]->(ci)
MERGE (ci)-[:PartOf{timeStamp: row[3]}]->(c);

///////////////////////////////////////////////////////////////////////////////
//
// chat_mention_team_chat
//
///////////////////////////////////////////////////////////////////////////////

LOAD CSV FROM "file:///big-data/datasets/big-data-capstone/chat/chat_mention_team_chat.csv" AS row
MERGE (ci:ChatItem {id: toInteger(row[0])})
MERGE (u:User {id: toInteger(row[1])})
MERGE (ci)-[:Mentioned{timeStamp: row[2]}]->(u);

///////////////////////////////////////////////////////////////////////////////
//
// chat_respond_team_chat
//
///////////////////////////////////////////////////////////////////////////////

LOAD CSV FROM "file:///big-data/datasets/big-data-capstone/chat/chat_mention_team_chat.csv" AS row
MERGE (ci1:ChatItem {id: toInteger(row[0])})
MERGE (ci2:ChatItem {id: toInteger(row[1])})
MERGE (ci2)-[:ResponseTo{timeStamp: row[2]}]->(ci1);

```

#### Example Queries

```

//
// List the first 10 users (by Id)
///
MATCH (user:User)
RETURN user.id
ORDER BY user.id DESC LIMIT 10;

//
// Who created the last 10 chat items?
//
MATCH (user:User)-[:CreateChat]->(ci:ChatItem)
RETURN user.id, ci.id
ORDER BY ci.id DESC LIMIT 10;


```


(User)    <------ RespondsTo ---------\
   \
    ------------- CreateChat ---------> (ChatItem)
   \
    ------------- Leaves     ---------> (TeamChatSession)
   \
    ------------- Joins      ---------> (TeamChatSession)  --------> OwnedBy ------> (Team)


#### Assignment Questions

##### Question 1

* Find the longest conversation chain in the chat data using the "ResponseTo" edge label.

###### How many chats are involved in it?

```
MATCH p=(:ChatItem)-[:ResponseTo*]->(:ChatItem)
RETURN LENGTH(p)
ORDER BY LENGTH(p) DESC LIMIT 1
```

###### How many users participated in this chain?

```
MATCH p=(:ChatItem)-[:ResponseTo*]->(:ChatItem)
WITH p as Path
ORDER BY LENGTH(p) DESC LIMIT 1
MATCH (u:User)-[:CreateChat]->(ci:ChatItem)
WHERE ci IN NODES(Path)
RETURN COUNT(DISTINCT u);
```


##### Question 2: Do the top 10 the chattiest users belong to the top 10 chattiest teams?


###### Identify the top 10 chattiest users.

```
MATCH (u:User)-[r:CreateChat]->(ci:ChatItem)
RETURN u.id, COUNT(r) AS ChatCount
ORDER BY ChatCount DESC LIMIT 10
```

####### Identify the top 10 chattiest teams.

```
MATCH (u:User)-[r:CreateChat]->(ci:ChatItem)-[po:PartOf]->(c:TeamChatSession)-[:OwnedBy]->(t:Team)
RETURN t.id, count(po) as ChatItemTotal
ORDER BY ChatItemTotal DESC LIMIT 10
```

##### Question 3: How active are groups of users?

If we can identify the highly interactive users / neighborhoods, we could target them with direct advertising.

###### Construct the Neighborhood

Connect two users when:
1. One user `Mentioned` another user in a `ChatItem`.
1. One user `CreateChat` in response to a `ChatItem`.

Create a new edge called `InteractsWith` between users to satisfy either of these conditions.

Query for the first connection:

```
MATCH (u1:User)-[:CreateChat]->(i:ChatItem)-[:Mentioned]->(u2:User)
MERGE (u1)-[:InteractsWith]->(u2)
```

Query for the second connection:

```
MATCH (u1:User)-[:CreateChat]->(i1:ChatItem)-[:ResponseTo]-(i2:ChatItem)
WITH u1, i1, i2
MATCH (u2:User)-[:CreateChat]->(i2)
MERGE (u1)-[:InteractsWith]->(u2)


//
// Delete all self-referencing loops (someone responding to their own chat)
//
MATCH (u1)-[r:InteractsWith]->(u1) DELETE r
```

###### Find the clustering coefficient of the 10 chattiest users.

* What is a clustering coefficient?
    * A scoring mechanism to find users having dense neighborhoods.

```
number of edges of all neighbors
--------------------------------
# of neighbors * (# of neighbors - 1) == (all possible edges)
```

* Chattiest users
    * `394,2067,209,1087,554,516,1627,999,668,461`

```

// The number of edges it has with other members on the same list
match (u1:User)-[r1:InteractsWith]->(u2:User)
where u1.id <> u2.id
with u1, collect(u2.id) as neighbors, count(distinct(u2)) as neighborAmount
match (u3:User)-[r2:InteractsWith]->(u4:User)
where (u3.id in neighbors) AND (u4.id in neighbors) AND
(u3.id <> u4.id) return u3.id, u4.id, count(r2)

//
// Find the cluster coefficient for a given user.
//
// A cluster coefficient is how active a user's neighbors
// are with eachother.
//

MATCH (u1:User)-[:InteractsWith]->(u2:User)
WHERE u1.id = 394
WITH COLLECT(DISTINCT u2.id) as Neighbors, COUNT(DISTINCT(u2.id)) as NeighborCount
MATCH (u3:User), (u4:User)
WHERE
    u3.id IN (Neighbors)
AND
    u4.id IN (Neighbors)
AND
    u3 <> u4
WITH u3, u4, Neighbors, NeighborCount,
CASE
    WHEN (u3)-[:InteractsWith]->(u4)
        THEN 1
    ELSE
        0
END
AS Degree
RETURN
    SUM(Degree) As Degree,
    NeighborCount,
    SUM(Degree) * 1.0 / (NeighborCount * (NeighborCount - 1)) AS Coefficient

```
394 = 0.916
2067 = 0.767
209 = 0.952
1087 = 0.7666
554 = 0.809
516 = 0.952
1627 = 0.767
999 = 0.819
668 = 1.0
461 = 1.0


394 = 3 / 6 = 0.5
2067 = 20 / 5 * 4 = 1.0
209 = 20 / 5 * 4 = 1.0
1087 = 18 / 6 * 5 = 18/30 = .60



match (u1:User)-[r1:InteractsWith]->(u2:User)
where u1.id <> u2.id
AND u1.id = 394
with u1, collect(u2.id) as neighbors, count(distinct(u2)) as neighborAmount
match (u3:User)-[r2:InteractsWith]->(u4:User)
where
    (u3.id in neighbors) AND (u4.id in neighbors) AND (u3.id <> u4.id)
with u1, u3, u4, neighborAmount, case when (u3)-->(u4) then 1 else 0 end as value
return u1, sum(value)*1.0/(neighborAmount*(neighborAmount-1)) as coeff order by coeff desc limit 10

For each user:
* Get the list of neighbors.
* For each neighbor, find the number of edges it has with other members on the same list.
* Add the edges for all neighbors, divide by k * (k - 1).


## Week 5

* The hard work is complete. It's time to present findings.
* Pretend you are presenting to your board of directors.

## Week 6

### Recommendations

* Mobile only (depending on cost associated with Mac / Linux / Windows)
* Target iOS users with new features, new promotions.
    * iOS users are spending more money. Understand why.
    * Research the iOS user demographic, behaviors, beliefs, values.
    * Develop ad campaigns and special products focused toward iOS users.

* Ads are effective.
    * Research *why* users click the ads they do.
    * Watch spam! More != better.
*