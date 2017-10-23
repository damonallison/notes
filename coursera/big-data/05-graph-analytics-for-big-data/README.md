# Graph Analytics for Big Data

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
    * NO. Volume
    * Velocity.

* Which of the Vs results in increased algorithmic complexity (which can cause analyses to not be able to finish running in reasonable amounts of time)?
    * NO. Velocity
    * Volume

* Which of the Vs results in challenges due to graphs created from varying kinds, formats, sources, and meanings of data?
    * Variety

* Which of the Vs causes increased interconnectivity of a graph -- which can cause problems in analysis due to density?
    * Valence

* Updating a graph with a stream of posting information on facebook is an example of which of the Vs?
    * Velocity

* Studying Amarnath's gmail interactions over time (as gmail started to be used by more and more people) is BEST defined as an impact of which of the Vs?
    * No. Volume
    * No. Variety
    * Valence?

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

3. How successful are promotions?

Determining how successful our promotions are would be critical to understand. What promotions are effective? When are promotions effective? What is our promotion interaction rate? What is the sentiment analysis regarding our promotions? Are users upset? Do users like to see promotions? What if our promotions included something free for the users?

Promotions could be an attractive way to increase user engagement, expose them to new games, or increase their enjoyment of their favorite games.


## Week 3 : Graph Analytics

