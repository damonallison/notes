# Graph Analytics for Big Data

## Feedback

* Explain the general syntax of Cypher's node-relationship-node pattern
  before jumping into examples.
    * Example : What is the difference between a `-` and `->`?


## Week 1 : Introduction and Welcome

* Goals
    * Understand how data can be modeled as graphs.
    * Tools / techniques for working with graph data.

* Graphs are all about relationships.
    * The web, facebook, LinkedIn, twitter, are all examples of graphs.
    * Even relationships in a family can be modeled as a graph.
    * The internet is a graph.


## Week 2 : Introduction to Graphs

#### What is a graph?

##### Differences between a graph and a chart.

* A (line, pie) "graph" is *not* a graph. They are chart.
* Charts are *graphs of a function*. They plot one input to one output.
* A `graph` in the graph theory sense is a network of edges and vertices.

##### Graph Theory

* Graph Analytics is based on Graph Theory.

* Graph Theory came from an urban planning problem.
    * Prussia (Konnisberg) : 7 bridges.
    * Devise a walk through the city with only crossing each bridge once.
    * Euler determined it was not possible given an odd number of bridges.

* The computer science defintion / application of graph analytics builds on the mathematical definition of graph theory.

* Graph Theory (Mathematical Defintion of Graph Theory)
    * V : vertices
    * E : edges

* The Computer Science defintion of graph theory
    * Adds a data structure to represent the mathematical graph.
    * Adds operations to manipulate the graph.
        * `add_edge`, `add_vertex`, `get_neighbor(v3)`
    * Vertices and Edges can be represented in a matrix (table).

#### Why Graphs?

* Grahps describe entities and relationships between entities.

### Lesson 2 : Big Data Graphs in the Real World

#### Why Graphs? Example 1 : Social Networking (Twitter)

* Tweets are graphs.

* Nodes (entities)
    * Users
    * Tweets
    * URLs
    * Hashtags
    * Retweets

* Edges (actions)
    * Users `create` tweets.
    * Tweets `respond` to other tweets.
    * Tweets are `retweeted`.
    * User `mentions` another user.
    * Tweets `contains` hashtags.
    * User `follows` another user.

* What data can we derive from this?
    * Behavioral psychology : study behavior.
        * Are users violent? A cause for concern?
        * Are users addicted to the game?
        * Sentiment analysis. Are users happy? Would they recommend your product to others?
        * Who are influencers? (target marketing)

* Why graphs?
    * Graphs can be used to graph conversations across nodes.
    * We could find groups of "happy" or "upset" users.
    * Determine who is interacting with others.
    * Who are the influencers?

#### Why Graphs? Example 2 : Biological Networks.

* Graphs model experiment results.
    * Protein / gene relationships.
    * Gene / gene interactions
    * Cell / cell signaling.

* Biological entities are represented as graphs.
    * Animal kingdom taxonomy.
    * Anatomy.
    * Terms in research are related.

* Data Integration
    * Data sets are assembled from many different research projects.
    * Researchers assemble multiple data sources to find patterns, relationships.

* Why Graphs?
    * Discover unknown relationships.
        * Indirect association between diseases. Path finding can find previously unknown gene connections, disease correlation.
        * Exploration for further research.

### Why Graphs? Example 3 : Human Information Network Analysis (Personal Network)

* LinkedIn
    * Graphs can find clusters.

* Could LinkedIn's "professional" network be overlayed on top of another network (facebook, email, calendar)?
    * Examples (smart assistant)
        * Match making : "You are going to this tech meetup. So is Jeff. You both worked at Medtronic. Want me to make an introduction?"

* Why graphs?
    * Job candidate pairings.
    * Find influencers (who to target?).
    * Threat detection (militant groups / terrorists).

### Why Graphs? Example 4 : Smart Cities

* Cities have networks. They form a physical infrastructure.
    * Transportation networks
    * Power / broadband
    * Water / sewer

* Why graphs?
    * Urban Planners - analyze traffic, flow.
    * Planning for "smart hubs".
    * Energy company - where to place infrastructure for optimal energy delivery?

### The purpose of analytics

* Discover patterns / insights / make predictions.
* Discover relationships between multiple data sources.
* Build mathematical models for predicting behavior.
* Explain why emergent phenomena exist and what their contributing factors are.


### Graphs and the V's of Big Data

* Volume, Velocity, Variety,
* Lesser known "V" : Valence.
* How do these impact graph analytics?

* Volume
    * Graph size exceeds ram.

* Velocity
    * As time goes on, the graph increases.
    * Each FB interaction creates edges.
    * Edges stream into facebook at massive velocity.

* Variety
    * Higher variety, the more non-uniform and complex.
    * Different data sources do not have the same nodes / edges. You must define the relationships between data sources.
    * The number of operations and infrences between nodes becomes more complex.

* Valence
    * Increasing valence == increases connectedness.
    * High valence == highly related.
    * High valence == parts of a graph becomes denser.
    * Example : Gmail.
        * Over time, with more data, parts of your gmail graph will grow more dense.
        * Why?
            * The number of edges between certain nodes increases (your close friends).
            * Events draw people together. (Projects, conferences)
    * As density increases in places, it becomes hard to traverse thru the dense parts.
        * (More about this will be explained later)

* Graph size impacts analytics.
    * Increases algorithmic complexity.
    * Data to analysis time is too high (too much data).
    * Size of results is exponential in the number of nodes.


### Quiz : Introduction to Graphs

* Which of the following are graphs? (check all that apply)
    * The graph, **not** the pie chart.

* Which of the following is the correct adjacency matrix for this graph?
    * The option where "From A -> B == 1"

* Which of the following content would be objects (or nodes) in a graph that represents the activity in a facebook page?
    * location, comment text, post text
    * You are looking for **entities** not **actions** (edges).

* Based on the videos, which kinds of analysis might one be able to perform on a tweet graph?
    * All answers

* The key reason mentioned in the video that biology applications need Big Data analytics is...
    * The integration of multiple data sources from different researchers and of different sources of information.

* Which of the Vs BEST describes the result in constant increasing in the number of edges in a graph, sometimes causing challenges in knowing when one has found "an answer" to one's analysis question?
    * Velocity.

* Which of the Vs results in increased algorithmic complexity (which can cause analyses to not be able to finish running in reasonable amounts of time)?
    * Volume

* Which of the Vs results in challenges due to graphs created from varying kinds, formats, sources, and meanings of data?
    * Variety

* Which of the Vs causes increased interconnectivity of a graph -- which can cause problems in analysis due to density?
    * Valence

* Updating a graph with a stream of posting information on facebook is an example of which of the Vs?
    * Velocity

* Studying Amarnath's gmail interactions over time (as gmail started to be used by more and more people) is BEST defined as an impact of which of the Vs?
    * Valence

* Which of the Vs is most relevant to the kinds of graph analysis you are interested in? Tell us why in a sentence or 2. (Any response will be counted correct.)
    * I'm the most interested in variety. I think combining multiple data sources can yield interesting new insights about objects.

### Graded Assignment : Graphs in Everyday Life

* Graph : XBox network

* Nodes : Player / Game / Chat
* Player -> Connected To -> Player
* Player -> Plays -> Game
* Player -> Comment -> Chat (Game specific chat)
* Comment -> Links to -> Player


1. What is player sentiment on the platform as a while and within each game?

Happy players are critical for a successful platform. In order to analyze player sentiment, we could monitor game session history and chat participation. We can generally conclude that the more a player plays a game, the more they enjoy the game. We can also determine based on chat participation what their general attitude is toward the game. We can compare sentiment analysis across games to understand how genre impacts sentiment. We can also monitor sentiment to determine impact platform changes have on sentiment. For example, we can determine the impact price increases, decreases, new players, new levels have on player sentiment.

2. What behavioral patterns exist on the platform as a whole and within each game?

Behavioral patterns dictate the type of users who play each game. Are players playing daily for 10 minutes? Are they playing one day a week for 8 hours a day? Why is this important? If we can determine the behavioral patterns, we can better target promotions, know when we can do system maintenance or expect peak usage, and determine what type of game we should make next (casual or hardcore).

* Frequency of game sessions.
    * Multiple times per day?
    * Date driven: weekend only?
* Length of game sessions, length between sessions.

3. How successful are promotions?

Determining how successful our promotions are would be critical to understand. What promotions are effective? When are promotions effective? What is our promotion interaction rate? What is the sentiment analysis regarding our promotions? Are users upset? Do users like to see promotions? What if our promotions included something free for the users?

Promotions could be an attractive way to increase user engagement, expose them to new games, or increase their enjoyment of their favorite games.


## Week 3 : Graph Analytics

* What are the fundamental differences between a graph and a relational database?

### Big Data and Graph Analytics

#### Focusing on Graph Analytics Techniques

* The first thing you should do when building a graph is to define the information model.
    * What are the nodes / edges / node types / edge types?

* Node / Edge Types (a.k.a., Labels)
    * Classifications of a Node / Edge
    * In the twitter example, you could have URL Nodes, Media Nodes, Retweet Nodes based on the node type.
    * Edges could be "interaction", "causes" types.

* Node / Edge Schema
    * Properties / Values of a node / edge.

* Edge Property : Weight
    * Priority or strength of a connection.
    * "Distance" in a road network.
    * "Strength" of a physical connection.
    * "Confidence" in a connection.

* Structural Properties
    * Loops : an edge that points to itself.
    * People send emails to themseves. A website has a link to itself.

* Multigraphs
    * A graph with more than one edge between two nodes.
    * An email recipient is also a spouse.


### Path Analytics

#### Path Analytics

* Walk : traversing nodes and edges in a graph.
* Path : a walk where we do not repeat node (acyclic : no cycles).
* Cycle : a path where the start / end node are the same.
* Trail : a walk with no repeating edges.
* Reachability : a node is reachable a walk between two nodes exists.
* Diameter : Maximum pairwise distance between nodes.

#### THe Basic Path Ananlysis Question : WHat is the Best Path?

* Determining the best path
    * What function to optimize for (maximum or minimum)?
        * Time, distance, road conditions.
    * What constraints exist?
        * Paricular nodes / edges need to be traversed?
        * Nodes / edges to avoid?
        * What preferences to optimize for?

#### Applying Dijkstra's Algorithm

* Core Rule
    * The next node picked to include in the path is the one that has the lowest cost to add from the current node.
    * Dijkstra's algorithm is expensive for large graphs.

#### Inclusion and Exclusion Constraints

* Constraints simplify the number of possible paths.
* Constraints can split the problem into multiple problems, which can be parallelized.

## Quiz : Path Analytics

* A graph representing tweets would have only “one type” (e.g. label) of node.
    * False

* In a network representing the world wide web nodes would likely represent:
    * Webpages

* In a network representing the world wide web edges (or links) would likely represent
    * Hyperlinks

* In an email network, which might reasonably be represented by weight on edges?
    * average number of emails sent from one user to another in a week

* A loop in a graph is where:
    * where there is an edge from a node to itself.

* An example of a loop in a graph could occur when:
    * Someone emails themself

* When trying to represent a relationship between Maria and Julio who have more than one relationship to each other (e.g., tennis partner, co-worker, emergency contact) which of the following would be needed in a graph representing those relationships
    * Multiple edges between Maria and Julio

* In many applications paths (where we go from one node to another without repeating nodes) are more useful than walks (where we can repeat a node when going from one node to another).
    * True

* Trails (paths without repeated edges) can be interesting in which of the following problem applications?
    * Routing to avoid using the same bridge or road.

* Suppose we have an email network where the edges of a graph represent the number of emails from one user to another. If I was going to ask if Maria had sent any emails that (either directly or through forwarding from others) reached Julio, I would ask if:
    * Julio’s node was reachable from Maria node

* If I want to find the diameter of a graph, I should start by finding the shortest path between each set of nodes.
    * False

* What is the diameter of this graph?
    * 3

* This question is about "best paths". To find the most discussed email in an email network, would we be looking to minimize a function or maximize a function?
    * Maximize

* Which are the two kinds of constraints on paths discussed in the video on basic path analytics? (check 2) Hint: remember the example of Amarnath needing to get to work by taking his son to school.
    * Inclusion of nodes and/or edges.
    * Exclusion of nodes and/or edges.

* What are examples of preference constraints in the Google Maps application?
    * Avoid highways.
    * Avoid roads under construction.

* Which of the statements below is true?
    * Dijsktra's algorithm is computationally inefficient (has high computational complexity).

* In the video on "Inclusion and Exclusion Constraints" we learn that adding constraints can actually make our analysis job easier. For example, when we require that a given node be included on a path, which of the following impacts now make the analysis job easier? (Choose 2)
    * Splitting the task into 2 independent shortest path problems
    * Reduction of the size of the graph


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

### Connectivity Analysis

* How robust is the graph?
    * How easy is it to "break" / "hack" the graph?
    * i.e., taking out a core node destroys the network.
    * Biological networks have redundancy. Thank God.

* Connectedness
    * A "connected" graph allows you to reach any node from any other node.
    * "Islands" of connected nodes can form.
    * "Strongly connected" graph : a direct path exists between all nodes.
    * "Weakly connected" graph : connected after converting a direct graph to a undirected graph (i.e., we can traverse backwards or forwards on an edge, irregardless of the direction of the edge.)

* Degree : the count of edges connected to that node (coming in or going out if the graph is directed).

#### Disconnecting a graph

* Finding the nodes and or edges that will disconnect a graph.
* The number of nodes / edges that must be removed is the "degree" of connectedness.
    * For example, if it takes removing 3 nodes to disconnect the graph, the degree of connectedness is 3.
* Target higher degree nodes. Higher degree nodes make the network more vulnerable.

#### Connectedness : Indegree and Outdegree

* Indegree : the number of edges pointed to a node.
* Outdegree : the number of edges pointed from a node.
* Degree : indegree + outdegree

* Listeners : high indegree, low outdegree.
* Talkers : high outdegree, low indegree.
* Communicators : high outdegree, high indegree.

### Community (cluster) Analytics

#### Community Analytics and Local Properties

* What is a community?
    * A dense subgraph whose nodes are highly connected within the cluster nodes.

* Community analytics questions
    * "Static" Analysis
        * What are the communities at time T?
        * Who belongs to a community?
        * How closely knit is this community?

* Temporal / Evolution Analysis
    * How did this community form?
    * Which communities are stable?
    * What are the `transient` communities? How did they form / dissolve?

* Predictive Analysis
    * Will this community grow / continue?
    * Are dominant roles emerging?

* Detecting a community
    * Determine where subgraphs exist with a high intra-cluster density, low extra-cluster density.

* Local Properties
    * Clique : the perfect community. Every node has an edge to every other node.
    * Near Clique (`n` clique) : Maximal subgraph that the distance of each pair of vertices is not larger than `n`.
        * For example, for `n` of 2, the distance between each vertice must be <= 2. A clique does not include intermediate nodes (unless they can reach all other clique nodes in `n` or less).
    * Near Clan : (`n` clan) The maximal subgraph where any node can reach any other node with <= n distance.
    * `k-core`: density based measurement. Maximal subgraph in which each vertex is adgacent to at least `k` other vertices in a subgraph.

#### Global Property : Modulatity

* Global measure of cluster quality.
    * A highly modular graph is subject to drastic change with just a few differences.
    * Louvain Method

* Evolving communities
    * Communites can grow, contract, merge, split, born, die.
    * Examples
        * Mergers / acquisitions.
        * Product / team spin off.

#### Centrality Analytics

* Centrality determines how "centered" a node is in a graph.

* Why are centers important?
    * Influencers in a social network.
    * Junction station in a transport network.
    * Central server in a computer network.

* Key player problems
    * Which nodes, if removed, would maximally disrupt communication among the remaining nodes?
        * Which city should we immunize to prevent the spread of infection?
    * Which node is maximally connected to all other nodes? (Influencers)

* Centrality : measures how centered a `node` is.
* Centralization : measures the network's centrality. Degree of variation between centrality scores among nodes.
    * As the number of nodes with high centrality increases (orange nodes) the centralization of a network *decreases*. There is less variation in the centrality values of the nodes in the network.
        * High centralization == all nodes have similar centrality.

* Degree centrality
    * Node degree:  # of incoming edges / total possible edges.
    * Group degree: # of edges into the group / # of non-group members

* Closeness
    * Low shortest-path distances to all other nodes gives the node a low `closeness` value (they are closer).
    * Information flows first thru low-closeness nodes.
    * Low closeness nodes are high influencers.

* Betweenness Centrality
    * A measure of how "between" a node is. Similar to other centrality metrics, a more central node will have a higher betweenness centrality.

## Quiz

* The example given in the lectures of when a power network loses power in large portions of its service area was an example of what?
    * an attack which causes disconnection of the graph

* Is the following graph strongly connected, weakly connected or neither?
    * Strongly

* Is the following graph strongly connected, weakly connected or neither?
    * Weakly (disregards edge direction)

* If you were going to look for a node which would be most likely to be the target of an attack to disconnect a network, what would be the best characteristic to look for?
    * high degree nodes

* What is the in-degree of node B?
    * 3

* In the graph below, which node is the greatest listener?
    * B

* In the graph below, which nodes are the greatest communicators? (Hint: there's a tie)
    * A, C (the most incoming and outgoing nodes)

* Which of the following are the three type of analytics questions asked about communities?
    * Static, Evolution, Prediction

* What type of community analytics question is the following? Did a community form on twitter around the 2014 World Cup in Brazil?
    * Evolution

* Which type of community analytics question is the following? How tightly knit was the 2014 World Cup twitter community on July 13, 2014 (the day of the finals)?
    * Static

* What is the internal degree of the node indicated in the graph below?
    * 3

* Which of the two graphs below is more modular?
    * A

* Which of the following community tracking phases usually occurs when a company spins off a start-up?
    * Split

* An influencer in a network is defined as:
    * a node which can reach all other nodes quickly

* Which of the following are the 2 core “key player” problems that centrality analytics can address?
    * A set of nodes which can reach (almost) all other nodes.
    * Which nodes' removal will maximally disrupt the network.

* What kind of centrality would you want to analyze in a graph if you wanted to inject information that flows through the shortest path in a network and have it spread quickly?
    * Closeness

* What kind of centrality would you want to analyze in a graph if you wanted maximize commodity flow in a network?
    * Degree

* What kind of centrality identifies "hubness"?
    * Between-ness (higher measures given to "hub" nodes)


### Week 3 : Optional Videos

* Bi-directional Dijkstra algorithm : work from the target node backwards and the origin node forward in parallel.
* Goal directed Dijkstra algorithm
    * Rather than use the lowest default edge weight when traversing nodes, determine which node is closest to the goal.
    * Each edge is re-weighted based on it's proximity to the target.
    * The closer to the target, the lower the edge weight.
    * The algorithm chooses the lowest edge weight.

* Key player problems
    * What node, if removed, would cause maximum disruption?
    * What node can reach the maximum number of nodes in a small number of steps? (Influencer node)

### Graph Analytics Techniques

This modules uses Neo4j to analyze graphs. Neo4j's query language is called `Cypher`.

### Basic Querying, Path Analysis, and Centrality Analysis

```
$ neo4j start

http://localhost:7474
user : neo4j
pass : asdfasdf
```

#### Loading CSV

```
// Import simple road network
LOAD CSV WITH HEADERS FROM "file:///big-data/test.csv" AS line
MERGE (n:MyNode {Name:line.Source})
MERGE (m:MyNode {Name:line.Target})
MERGE (n) -[:TO {dist:line.distance}]-> (m)

//Script to import global terrorist data

LOAD CSV WITH HEADERS FROM "file:///big-data/terrorist_data_subset.csv" AS row
MERGE (c:Country {Name:row.Country})
MERGE (a:Actor {Name: row.ActorName, Aliases: row.Aliases, Type: row.ActorType})
MERGE (o:Organization {Name: row.AffiliationTo})
MERGE (a)-[:AFFILIATED_TO {Start: row.AffiliationStartDate, End: row.AffiliationEndDate}]->(o)
MERGE(c)<-[:IS_FROM]-(a);
```


```
//
// Delete **everything**
//

//
// Deletes all nodes w/ relationships
//
match (a)-[r]->() delete a,r;

//
// Deletes all nodes w/o relationships
//
match (a) delete a

//
// Manually creating a graph
//
// N1:ToyNode : introduces N1 with type `ToyNode`
// :ToyRelation : introduces a relation with type `ToyRelation`
//
create (N1:ToyNode {name: 'Tom'}) - [:ToyRelation {relationship: 'knows'}] -> (N2:ToyNode {name: 'Harry'}),
(N2) - [:ToyRelation {relationship: 'co-worker'}] -> (N3:ToyNode {name: 'Julian', job: 'plumber'}),
(N2) - [:ToyRelation {relationship: 'wife'}] -> (N4:ToyNode {name: 'Michele', job: 'accountant'}),
(N1) - [:ToyRelation {relationship: 'wife'}] -> (N5:ToyNode {name: 'Josephine', job: 'manager'}),
(N4) - [:ToyRelation {relationship: 'friend'}] -> (N5);

//
// View the entire graph
//
match (n)-[r]->(m) return n, r, m

//
// Select a single toy node (by property)
//
match (n:ToyNode {name:'Julian'}) return n


//
// Counting the number of nodes
//
match(n:MyNode) return count(n);

//
// Counting the number of edges.
//
match(n)-[r]->() return count(r);

//
// Finding leaf nodes (no outgoing edges)
// (m) is the target node, which has no outgoing edges.
//
match (n:MyNode)-[r:TO]->(m) WHERE NOT ((m) --> ()) return m;

//
// Finding root nodes
// M has no incoming edges
//
match(m)-[r:TO]->(n:MyNode) where NOT (()-->(m)) return m;

//
// Finding all properties of a node
//
match (n:Actor) return *;

//
// Finding the types of a node
//
match (n) where n.Name = 'Afghanistan' return labels(n);

//
// Finding the label of an edge
//
match (n {Name: 'Afghanistan'})<-[r]-() return distinct type(r);

//
// Finding 2nd neighbors of D
//
match (a)-[:TO*..2]-(b) WHERE a.Name='D' return distinct a, b;



//
// Finding triangles
//
match (a)-[:TO]->(b)-[:TO]->(c)-[:TO]->(a) return a, b, c;

//
// Finding loops
//
// A loop is an edge which originates from and points to the same node.
//
match (n)-[r]->(n) return n, r limit 10;

//
// Finding multigraphs
//
// A multigraph is any two nodes with > 1 edge between them
//
match (n)-[r1]->(m), (n)-[r2]-(m) where r1 <> r2 return n, r1, r2, m limit 10

//
// Finding the induced subgraph given a set of nodes
//
// An induced subgrah is a subset of nodes / edges.
// Here, we return the graph for nodes A-E.
//
match (n)-[r:TO]-(m)
where n.Name in ['A', 'B', 'C', 'D', 'E'] and
      m.Name in ['A', 'B', 'C', 'D', 'E']
return n, r, m;


--



//
// Adding a relationship
//
// 1. Find the source node in the relationship as a variable `n`
// 2. Add a relation to a new ToyNode, "Joyce"
match(n:ToyNode { name: 'Julian' })
merge(n)-[:ToyRelation { relationship: 'finacee' }] -> (m:ToyNode {name: 'Joyce', job: 'store clerk'})

// Modify a node
match (n:ToyNode) where n.name = 'Harry' set n.job = 'drummer'
// Turns a value into an array
match (n:ToyNode) where n.name = 'Harry' set n.job = n.job + ['lead guitarist']
```


#### Path Analytics

```

//
//Finding all paths between specific nodes.
//
// Note : TO* will return an arbitrary number of edges between
//        the source and destination nodes.
//
match p=(a)-[:TO*]-(c) where a.Name='H' and c.Name='P' return p limit 1;
match p=(a)-[:TO*]-(c) where a.Name='H' and c.Name='P' return p order by length(p) asc limit 1;

//
// Finding the length between specific nodes:
//
match p=(a)-[:TO*]-(c) where a.Name='H' and c.Name='P' return length(p) limit 1;

//
// Finding a shortest path between specific nodes:
//
match p=shortestPath((a)-[:TO*]-(c)) where a.Name='A' and c.Name='P' return p, length(p) limit 1

//
// All Shortest Paths:
//
// Extract all nodes from path `p` into PATHS
//
MATCH p = allShortestPaths((source)-[r:TO*]-(destination))
WHERE source.Name='A' AND
      destination.Name = 'P'
RETURN EXTRACT(n IN NODES(p)| n.Name) AS Paths

//
// All Shortest Paths with Path Conditions:
//
// Specifies constraints : only return paths with > 5 length.
//
MATCH p = allShortestPaths((source)-[r:TO*]->(destination))
WHERE source.Name='A' AND
      destination.Name = 'P' AND
      LENGTH(NODES(p)) > 5
RETURN EXTRACT(n IN NODES(p)| n.Name) AS Paths,length(p)

//
// Diameter of the graph:
//
// Diameter : longest continuous path between 2 nodes in a graph.
//
match (n:MyNode), (m:MyNode)
where n <> m
with n, m
match p=shortestPath((n)-[*]->(m))
return n.Name, m.Name, length(p)
order by length(p) desc limit 1

//
// Extracting and computing with node and properties:
//
// This example calculates the edge distance between two nodes.
//
match p=(a)-[:TO*]-(c)
where a.Name='H' and c.Name='P'
return extract(n in nodes(p)|n.Name) as Nodes, length(p) as pathLength,
reduce(s=0, e in relationships(p)| s + toInteger(e.dist)) as pathDist limit 1

//
// Dijkstra's algorithm for a specific target node:
//

MATCH (from: MyNode {Name:'A'}), (to: MyNode {Name:'P'}),
path = shortestPath((from)-[:TO*]->(to))
WITH REDUCE(dist = 0, rel in rels(path) | dist + toInteger(rel.dist)) AS distance, path
RETURN path, distance

//
// Dijkstra's algorithm SSSP:
//
// Single source shortest path algorithm.
//
// The shortest path with sums of weights. Not the least weight path in the entire network.
//
MATCH (from: MyNode {Name:'A'}), (to: MyNode),
path = shortestPath((from)-[:TO*]->(to))
WITH REDUCE(dist = 0, rel in rels(path) | dist + toInt(rel.dist)) AS distance, path, from, to
RETURN from, to, path, distance order by distance desc

//
// Graph not containing a selected node.
//
// Say we want to avoid a particular node.
//
match (n)-[r:TO]->(m)
where n.Name <> 'D' and m.Name <> 'D'
return n, r, m

//
// Shortest path over a Graph not containing a selected node:
//
// Retrieve all paths from A -> P which do not include D
//
match p=shortestPath((a {Name: 'A'})-[:TO*]-(b {Name: 'P'}))
where not('D' in (extract(n in nodes(p)|n.Name)))
return p, length(p)

//
// Graph not containing the immediate neighborhood of a specified node.
//
// Find all paths where D or it's neighbors are not included.
//
match (d {Name:'D'})-[:TO]-(b)
with collect(distinct b.Name) as neighbors
match (n)-[r:TO]->(m)
where
not (n.Name in (neighbors+'D')) and
not (m.Name in (neighbors+'D'))
return n, r, m;

//
// Find all leaf nodes not in neighborhood of D.
//
match (d {Name:'D'})-[:TO]-(b)-[:TO]->(leaf)
where not((leaf)-->())
return (leaf);

match (d {Name:'D'})-[:TO]-(b)<-[:TO]-(root)
where not((root)<--())
return (root)

//
// Graph not containing a selected neighborhood:
//
// Eliminate all 2nd neighbors of F
//
match (a {Name: 'F'})-[:TO*..2]-(b)
with collect(distinct b.Name) as MyList
match (n)-[r:TO]->(m)
where not(n.Name in MyList) and not (m.Name in MyList)
return distinct n, r, m```
```

#### Connectivity Analysis

```

//
// Find the outdegree of all nodes
//
match (n:MyNode)-[r]->()
return n.Name as Node, count(r) as Outdegree
order by Outdegree
union
match (a:MyNode)-[r]->(leaf)
where not((leaf)-->())
return leaf.Name as Node, 0 as Outdegree

//
// Find the indegree of all nodes
//
match (n:MyNode)<-[r]-()
return n.Name as Node, count(r) as Indegree
order by Indegree
union
match (a:MyNode)<-[r]-(root)
where not((root)<--())
return root.Name as Node, 0 as Indegree

//
// Find the degree of all nodes
//
match (n:MyNode)-[r]-()
return n.Name, count(distinct r) as degree
order by degree


//
// Find degree histogram of the graph
//
match (n:MyNode)-[r]-()
with n as nodes, count(distinct r) as degree
return degree, count(nodes) order by degree asc

//
// Save the degree of the node as a new node property
//
match (n:MyNode)-[r]-()
with n, count(distinct r) as degree
set n.deg = degree
return n.Name, n.deg

//
// Construct the Adjacency Matrix of the graph
//
match (n:MyNode), (m:MyNode)
return n.Name, m.Name,
case
when (n)-->(m) then 1
else 0
end as value

//
// Construct the Normalized Laplacian Matrix of the graph
//
match (n:MyNode), (m:MyNode)
return n.Name, m.Name,
case
when n.Name = m.Name then 1
when (n)-->(m) then -1/(sqrt(toInt(n.deg))*sqrt(toInt(m.deg)))
else 0
end as value

```


## Quiz

* Which of the following is a Cypher command used to combine two or more query results?
    * `union`. `merge` is used to build the graph.

* For a graph network whose nodes are all of type "MyNode", which has both incoming and outgoing edges, and which has both root and leaf nodes, what will the following Cypher code return in a Neo4j report? `match (n:MyNode)<-[r]-() return n`
    * All nodes except root nodes.

* The Cypher query language shares some commands in common with SQL.
    * True

* The following query will return a graph containing whatever loops might exist. `match (n)-[r]-(n) return n, r`
    * True

* Which Cypher pattern is used to represent a node?
    * `()`

* Neo4j is a ...
    * Graph database

* Which Cypher command launches a Neo4j database search?
    * `MATCH`

* Cypher does not include a specific command to find the shortest path in a graph network.
    * False

* Cypher includes a 'diameter' command to find the longest path in a graph network.
    * False


### Cypher Assessment

LOAD CSV WITH HEADERS FROM "file:///big-data/gene_gene_associations_50k.csv" AS line
MERGE (n:TrialGene {Name:line.OFFICIAL_SYMBOL_A})
MERGE (m:TrialGene {Name:line.OFFICIAL_SYMBOL_B})
MERGE (n) -[:AssociationType {AssociatedWith:line.EXPERIMENTAL_SYSTEM}]-> (m)


* Calculate the number of nodes in the graph.
    * `match(n) return count(n);`

* Calculate the number of edges in the graph
    * `match(n)-[r]->() return count(r);`

* Calculate the number of loops in the graph
    * `match (n)-[r]->(n) return count(r)`

* Submit the following query and report the results.
     * `match (n)-[r]->(m) where m <> n return distinct n, m, count(r)`

* Interpret the results of the query in Step 4 above.
    * The results show the number of relationships between two different genes.

* Submit the following query and report the results:
    * `match (n)-[r]->(m) where m <> n return distinct n, m, count(r) as myCount order by myCount desc limit 1`
    * Finds the pair of genes with the most relationships.

* Run the following query and interpret the results:
    * `match p=(n {Name:'BRCA1'})-[:AssociationType*..2]->(m) return p`
    * Finds the second neighbors of `BRCA1`.

* Count how many shortest paths there are between the node named ‘BRCA1’ and the node named ‘NBR1’.

```
MATCH p = allShortestPaths((source)-[r:AssociationType*]->(destination))
WHERE source.Name='BRCA1' AND
      destination.Name = 'NBR1'
RETURN count(p), length(p)

// To view the nodes in each of the shortest path, use extract()
MATCH p = allShortestPaths((source)-[r:AssociationType*]->(destination))
WHERE source.Name='BRCA1' AND
      destination.Name = 'NBR1'
RETURN extract(n in nodes(p)|n.Name) as Nodes;
```

* Find the top 2 notes with the highest outdegree.
    * `SNCA` & `BRCA1`

```
match (n)-[r]->()
return n.Name as Node, count(r) as Outdegree
order by Outdegree desc
union
match (n)-[r]->(leaf)
where not((leaf)-->())
return leaf.Name as Node, 0 as Outdegree
Order by Outdegree desc limit 2
```

* Modify one of the Cypher queries we provided and create the degree histogram for the network, then calculate how many nodes are in the graph having a degree of 3.
    * `821`

```
//
// Find degree histogram of the graph
//
match (n)-[r]-()
with n as nodes, count(distinct r) as degree
return degree, count(nodes) order by degree asc
```

## Quiz : Practicing Graph Analytics in Neo4j with Cypher

* What is the number of nodes returned?
    * 9656
* What is the number of edges?
    * 46621

* The number of loops in the graph is:
    * 1221

* The query `match (n)-[r]->(m) where m <> n return distinct n, m, count(r)` gives us
    * the count of all non loop edges between every adjacent node pair.

* The query `match (n)-[r]->(m) where m <> n return distinct n, m, count(r) as myCount order by myCount desc limit 1` produces what?
    * the pair of nodes with the maximum number of multi-edges between them

* The query `match p=(n {Name:'BRCA1'})-[:AssociationType*..2]->(m) return p` produces what?
    * The neighbors’ neighbors of the node whose name is ‘BRCA1’

* How many non-directed shortest paths are there between the node named ‘BRCA1’ and the node named ‘NBR1’?
    * 9

* The top 2 nodes with the highest outdegree are:
    * SNCA and BRCA1

* Applying the example queries provided to you, create the degree histogram for the network. How many nodes in the graph have a degree of 3?
    * 821




--------------------------------------------------------------------------------

## Week 5 : Computing Platforms and Graph Analysis

### Programming Model For Graphs

* GraphX (spark)
* Giraph (hadoop)

#### Parallel Programming Model for Graphs

* A parallel programming model involves multiple processes executing simultaneously.
* In a parallel system, the following two questions need to be determined:
    * How will processes communicate?
        * Share memory
        * Pass messages
    * How is parallelism achieved?
        * Task parallel : decomposing large tasks into small tasks.
        * Data parallel : the data is partitioned and executed on in parallel

* Bulk Synchronous Parallelism (BSP)
    * Multiple processes
    * A router is responsible for message passing between processes.
    * Barrier synchronization : puts all processes into a consistent state before next step of processing can continue.

* In BSP for graphs, processes are broken up around each vertex.
    * "Think like a vertex"
    * Each vertex is computed individually, in parallel.

* What can a vertex do?
    * Can find its own `id`.
    * Get / set its value.
    * Get/count its edges.
    * Get/set a specific edge values. By edge id
    * Add / remove an edge.
    * Start / stop computing

* What can an edge do?
    * Get its id.
    * Get/set it's value.
    * Get the ID of the target vertex.


#### Pregel : The system that changed graph processing

* 2010 : Google paper : Pregel : A System for Large-Scale Graph Processing
    * Powers Page Rank.

* GraphLab
    * Different than Pregel in that each vertex can access state of it's incoming edge, update it's value asynchronously (without having to wait for all nodes to complete).

* Vertex split
    * In a deep cluster, certain vertices are split to enable more efficient phase.
        * Vertex "copies" are created which work on individual machines.
        * Each copy is merged together to compute the value of the original vertex.

#### Giraph and GraphX - Programming Model Details

* Giraph / GraphX
    * BSP on Hadoop / Spark
    * Provides infrastructure on top of BSP.
        * Provides I/O for data input / export from / to SQL, Neo4J, HBase, Hive, text file.
        * Provides an API for accessing the graph (retrieving nodes / edges, etc).
        * Infrastructure to handle process coordination (aggregation)

* Aggregates are important.
    * Who keeps the aggregates in Giraph?
        * The "Aggregator" (Default Master Compute)

* Why not implement Giraph using MapReduce?
    * Too much disk requirement - each step needs to write to a file.

* What happens if Giraph runs out of memory?
    * Not all partitions are kept in memory, others swapped to disk.
    * If there are too many messages, messages are also stored on disk (associated with their vertex).


#### Examples of Analytics (Using GraphX)

* Developed by AmpLab (U.C. Berkeley)
* Vertex / Edge tables stored in `Vertex` and `Edge` tables within spark.
* `VertexRDD[A]` are all vertices with a property `A`.
* `EdgeRDD[ED, VD]` contain a source vertex, destination vertex, and edge attribute.

* Triplets
    * Node - Edge - Node

## Hands on
* Facebook is a graph of strong clusters (communities) with dense interactions with a few nodes spanning different communities. This makes the graph look like broccoli.


## Quiz

* In this code snippet below from the Hands On exercise on importing data, '100L + row...' adds 100 to the value of every country ID. Which of the following statements are true regarding this decision? (Note: you may select more than one)
    * Another option would have been to add 100 to the metropolis keys as they were imported, and leave the country keys as they were originally numbered.
    * This step was needed to create unique keys between the country and the metropolis datasets.
    * Another option would be to add 500 to the country keys.

* In the metro example, what is an in-degree in relation to a country? Hint: this was covered in the Building a Degree Histogram Hands On exercise.
    * A continent

* In the Hands On exercise on network connectedness and clustering, Antarctica was easy to identify. Why?
    * It is the green dot that that has no connections, or it is the least connected cluster.

* In the Facebook graph example, the visualization looked like broccoli. Why?
    * Social networks have communities or pockets of people who interact densely.



