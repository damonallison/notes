# Week 1 : Big Data - Capstone Project

* Week 1/2 : Data Analysis w/ Splunk / Open Office
* Week 3/4 : KNIME, MLLib / Gephi
* Week 5   : Reports / Slides

##  Final Project

* 10 minute slide presentation w/ written script.
    * [Presentation](https://docs.google.com/presentation/d/1OO82dc8Mv0rPeml3ZdVnIXF3IUXWpiS4XZ9nUA-Ems8/edit?usp=sharing)

* Technical appendix. Built each week, reviewed with peers.

Analyze game data. Game play / social behavior/ ad targeting.

* Does Robinson use splunk to analyze log data?
* How does splunk compare to the ELK stack?

## Introcution to the Capstone Project

### Catch the Pink Flamingo : Game Play Introduction

* Must have at least 1 point in every map grid cell to advance levels.
* Missions change in real time.
* Example : "Catch the flamingos on land with stars on their belly"
* User gets `+1` for a score tap, `+2` for an invalid tap.
* Level 1 : Training level. (no team)
* After level 1, user joins (or creates) a team. Teams of 1 are allowed.


#### Data Elements

##### Ranking of Users

* Users are ranked on speed and accuracy.
* Other users can see a user's map..
* Users are categorized into "rising star", "veteran", "coach", "social butterfly", "hot flamingo"

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
* GameClicks : keep track of each user click. Hit flamingo? Correct?

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
    * `source="/home/cloudera/big-data/big-data-capstone/flamingo-data/buy-clicks.csv" | stats count by userId | sort by -count`

