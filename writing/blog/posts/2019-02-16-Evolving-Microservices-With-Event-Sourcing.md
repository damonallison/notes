# Evolving Microservices with Event Sourcing

## The Beginning

On the 1st day, we built the monolith. The monolith served our business well, revenues grew, and the world was right.

On the 2nd day, we hired another team. And another. And one overseas. And the monolith grew.

On the 3rd day, we had merge conflicts. We fought thru them. And again, the monolith grew.

On the 4th day, our architect read posts from Netflix engineering on “microservices”, drank coffee, and wrote a “microservices manifesto” - laying out the battle plan to strategically break apart our monolith into a set of services (which she kept calling “enterprise capabilities”, but in reality they are just REST services which focused on one thing. We called it “common sense”).

And tear down we did. And let me tell you, we did it right. We followed “Bezos Law” - no service touched another team’s data store. Ever. Period. All communication was strictly thru REST. JSON of course - we are not animals. We had a lot of teams. And yes, we kept them small. 1.5 pizzas where we could, 2 where we must.

On the 5th day, we blinked and had 200 microservices. You can’t believe how fast we built! I’ll bet each team had 10 to 20 microservices. They are so easy to write! We had a user service. A user preference service. We even created a preference persistence service so we could completely control preferences company wide. Our retail division used it to store sale preferences. Our web division used it to store machine level system configuration. It was flexible and completely isolated. We could scale it up, down, add caching, and best of all - as long as we didn’t break interface contracts - we could change programming languages or put a new DB behind it without anyone caring. There’s just no way we could have done *anything* like that in the monolith days. Let me tell you, we made Netflix proud.

Our microservice infrastructure became so large, we started looking into building software to manage our growing environment. Of course we added a strong DevOps team. Huge win there. We built common service templates people could clone which had default tooling - authentication, caching, internationalization, logging, you name it. That provided a great base for developers, made things consistent, and sped things up nicely. We added process monitoring, SLAs, health checks, reporting, real time dashboards (which we proudly put on our 80” “command center” monitor).

We even had a service to help us find our services. We wrote custom software to do dependency checks on our services to determine how far out of date our dependencies were getting. We realized early we needed to keep our services up to date. JS moves crazy fast. Not fast in a good way, fast in a churn way. Let your services slip a major version or two on key libraries and you might need to spend a week or two getting things back on track, tests updated, you name it. It’s a lot of fatigue upgrading dependencies on 100s of projects, so we stayed diligent about keeping on top of it.

At about the same time, the market for “service mesh” software was heating up. Evidently others were running into the same problems we were - discovery, deployments, scaling, monitoring. So we bought into a service mesh and, well, meshed our services together. We could retire some of the custom service management code we wrote and just use the mesh.

On the 6th day, we . Launching version 2.0. Over 200 services had been updated over the past 6 months to accommodate the release. After all - we “launch dark” - avoiding the “big release” by shipping one piece at a time. Ship more, win more, baby! And ship we did. We had so many services, we shipped 1000s of times. So. Productive. Off the charts.

I have to admit - we fought thru contract changes between all our teams - sweating details and writing standards like “always use `Id` over `ID`”.  All dates in UTC. Prefix test identifiers with `T` by convention. Small things, but if not tackled early become a time sink. As much as we tried to keep things consistent, small nit picky gotchas sank in which took days of debugging track down between the web of calls, caches, and dependencies we had. Some services were versioned to v2, others we could keep on v1. For a while there, when a new service was launched, we sent out emails saying a new major version was updated - to go read the README for more information. They got overwhelming, so we stopped.

Most teams kept other relevant teams up to speed. After all, if they could get their callers using the new version they could retire the old one. Nobody likes to maintain backwards compatibility. But we know in reality it will take another 6 months or a year (if ever) before we can spin down old versions. As much as programmers are cutting edge, they are also lazy. Lazy is definitely a virtue. But in this case, lazy meant they weren’t going to update versions without discipline.

The coordination between teams, negotiating API contracts, was a really massive time sink I hope we can avoid next time. It was also surprisingly time consuming to *debug* across services. We didn’t have a problem with this in the monolith, for obvious reasons. Some developers setup relevant services locally, but that was really time consuming and usually broke down. We mocked where we could, but when we tested in DEV, sometimes things were broken or we had to configure test data across services just right.

Oh man. This was a fun one. Some of our “core” teams had to figure out transactions. Transactions have been around for decades, but they are an anti-pattern in microservices. Turns out when you cross system boundaries, transactions as we know them from SQL (2 phase commit) become really, really hard.

Our orders and customer “finance” teams in particular had to coordinate a pretty intricate dance when creating an order and tendering a payment. We wanted to first create an order to guarantee inventory, approve payment, and fully “accept” the order before giving the upstream web team an a-ok and order number. We came up with a series of web hooks and polling, and a rather bloody hack to roll things back if something went wrong, but ultimately got the job done.

I have to say, it was tough to coordinate releases between so many teams, so many repos.  We were playing a lot of release Tetris to understand ordering and availability of new servide functionality. Some teams were done early, others ran late. Everyone was autonomous and ran on different schedules, but we did our best to have “scrum of scrums” were managers and leads hammered out dependencies, release order, and generally plan out the course.

Each team got used to an on call schedule. Each team was responsible for ensuring their services were running. I initially felt bad for the high level guys. They were the front lines. Regardless of root cause, those guys always took the first call. They are what the customer sees.

If you have a lot of services, it stands to reason you have a lot more opportunity to fail. It’s like playing a game of dominoes. One service goes down and the services around it start to all fall down. We will get better about identifying root cause faster.

Performance was pretty good overall, I guess. 100s of HTTP requests obviously can’t compete with the in process performance we had with the monolith, but it wasn’t terrible. Every once in a while a system would slow down, taking everyone around it down with it. Some people started caching data where they could. But you know what they say - there are two hard problems in computer science: off by one errors, naming things, and cache invalidation. So, let’s say that caching made things more, um,  interesting.

I should mention one other thing that, unfortunately, became somewhat a thing. One of the beauties of microservices is each team completely controls their code, their tools, their universe. It’s one of the biggest benefits of microservices. Each team was somewhat free to choose their tech stack. I saw “somewhat” because we do want some level of consistency. Consistency scales - from a tooling perspective but more importantly from a people perspective. Devs can PR into other repos, help others, when they are familiar with the environment.

We are mostly a node shop, but a few hipsters write in go, and a few of the teams stuck with java. We have enterprise standards, but we don’t want to lock the entire company into *one* stack - after all, each stack has advantages for different parts of the system. We were all communicating with REST after all, so at the end of the day it didn’t *really* matter what language each container was running in. We limited the choices to get some of the consistency we were striving for, but at the end of the day we had a few. All in all, not bad.

But even having just three stacks (the data science team added Python as well, so four now), it became hard for engineers to work fluidly across different code bases.

## Present Day

Which brings us to today. Here we are. The 7th day. It’s been a long road, but I *feel* like are system is in a better spot than we were with our original monolith. At least I hope so. But we do need a bit of rest from all the REST.

Looking ahead, there are going to be some interesting problems coming up. Our VP is all about AI. He wants to build a data lake to feed the team of data scientists wanting to run models. He wants us to feed  all our data into essentially a massive database in real time. I don’t know how we are going to do it with our services. All our services are built on request/response. We don’t really have interfaces to just “dump” our data in real time.

If an update comes into one of our REST endpoints, we could update our local data store and send an update to the data lake - but that would require essentially every service getting updated. That isn’t going to work.

Perhaps we’ll run a cron job to pull data from each core service on a schedule. Or maybe we’ll setup DB replication to copy data at the DB layer and just bypass our services. The data wouldn’t be in the format the data scientists would want, but perhaps they could just write another job to clean it up and put it into another database. It would take 2x the storage and would take a while to run, but we could do it in AWS and a few TB of extra data storage isn’t *that* expensive. The problem I see here is HTTP wasn't meant for doing large scale data transfer. Maybe we do paging or just use HTTP to trigger a long running batch job. A hack either way to be honest.

Or how about this.. If we want to do a quick hack, we could probably restore from nightly backups. It wouldn’t be real time, but data science doesn’t need information immediately, right? Maybe overnight restore would be OK.

We also want to start capturing better analytics across our products. For example, we want to tie order and inventory data together. Maybe we can build reports based on the data lake. It’s not quite in the format that we would need to write reports either, but we could do what the data scientists will probably do and just write a script which formats the data for efficient report creation.



## Microservices Redux
The story you just read, while completely fiction, hits on many points enterprises face when adopting microservices. I’ve seen much of this working in an environment of 600+ microservices built by 300+ engineers. I’ve tried to accurately portray the transition, wins, and struggles found in microservice development as I’ve seen them.

Microservices bring many tangible benefits to an engineering practice. But like anything in life, too much of a good thing can cause problems.

Let’s look at the benefits and drawbacks of microservices.

### Microservice Benefits

A critical part of software design is about managing complexity. Larger systems are more complex than smaller ones. Complexity increases exponentially the larger they get. So keeping things small is generally preferred.

A master software designer realizes early that breaking large systems into small, autonomous, single purpose capabilities is generally a good thing. Whether those are “services”, “modules” or “functions”, smaller has benefits.

Microservices offer many advantages to both system design as well as management and team culture.

* Team autonomy. When we design systems at company scales, the systems become more about people than software. Your team structure will determine your software structure (Conway’s Law). Service boundaries provide natural team boundaries, making it relatively simple to structure teams. Boundaries and ownership are critical to running healthy teams. There is no better way to destroy productivity than having ownership and control misunderstandings between engineering teams.

Teams have full control over the tools, languages, patterns, release cycle, and versioning of their services. Autonomy and control empower teams with a sense of ownership not found when multiple teams work on the same codebase.

* Modularity. Deconstructing large systems into smaller, discrete systems make them more predictable and easier to reason about. Decomposition into logical units is the basis of good software design. Microservices, by definition, require you to think about the boundaries up front. They force you to design before building.

* Automation. Building microservices encourages and quite frankly requires strong automation and quality rigor not found in monolithic systems. Because you can't test the entire system as a whole, you are forced to write unit tests to verify quality. Because you will have so many services, you will need automation. Thankfully, there are many options available. The industry attention and overall popularity towards microservices has produced a thriving tools industry around DevOps and CI/CD.

* Mindset. The biggest benefit I feel microservices brought to software development is the cultural mindset that it encourages. Microservices encourage a fast moving, nimble culture. A culture that is quick to adapt, to create new, to consistently evolve. It encourages innovation by making it trivial to spin up new services, or to combine multiple services together into something entirely new. Strict service boundaries provide a sense of team ownership and ultimately, hopefully, a sense of team commitment and pride. That combination of nimbleness, reuse, and team autonomy enables a culture of innovation and delivery.

### Microservice Drawbacks

[image:562B57EC-D71C-4781-AFAF-775DA209C238-54225-0000615AA7C0C25B/microsserivces-complexity.jpeg]

> A fictitious drawing trying to highlight microservice complexity. It’s fictitious because databases are pointing at other databases, there’s a computer under someon’es desk, mongo’s logic is a pile of poop, all of which are not true. Mongo is awesome. And nobody would ever do a cross database reference, right? Um, right?

[image:9C998CDF-16A7-4272-BE9D-B62DD69B9BDF-54225-00006159892ACAA6/microservices-dependencies-2.png]

> A more likely microservice dependency graph. Each service has it’s own data store, services in one “cluster” reference services in another cluster, and services depend on each other across “cluster”. Often, those “clusters” are owned by the same team - so cross team deployment becomes a thing.

Microservices aren’t without their challenges. Here are a list of drawbacks I’ve seen. I offer these with a large grain of salt. Some of these drawbacks apply to system modularity in general and would exist regardless of how you modularize your software. With microservices, however, these challenges need to be dealt with at least as or even more diligently than with a single process, modular architecture.

* Operational cost. The minimalist mindset offers a saying which I feel applies to to software equally well as it applies to real life:

> The more you have, the more you have to maintain.

Microservices, individually, are very simple pieces of software. They take requests and return responses. That doesn’t mean to say the internals are simple. A service could be responsible for speech recognition, object detection, pricing prediction, or solving a host of other very challenging engineering problems with a massive codebase underneath them. However *conceptually* microservices are very simple.

As the quantity of services scale up, you run into operational overhead. Each service requires it’s own git repository, it’s own build, dependencies, bug tracker, README, wiki, documentation, etc. And even when trying to keep services identically structured and using consistent tooling, the fact is they will slowly diverge. Dependencies need to be upgraded. Builds need to be maintained, scripts need to be written to operate across 100s of repositories sequentially. Doing things manually is no longer an option.

And with the churn associated with many popular languages and platforms (e.g., javascript), being diligent about “routine” maintenance is very important.

* Performance. HTTP is not cheap. Especially as services start to depend on other services. What was once an in-process function call now needs to perform TCP connections, serialization, HTTP transfer, deserialization, and back to complete a round trip. You also need to be very careful about calling patterns. Running network requests in a tight loop is not an option. With any large dataset you’ll need to implement paging.

You are free to implement caching to reduce network burden and improve performance, but you must be extremely careful to invalidate the cache properly to avoid inconsistencies.

* Stability. Your system is only as strong as its weakest link. It’s fairly obvious the more links you have, the more failure points you have. As services start to build on other services, the services at the lowest layer become critical dependencies.

Services have the potential of being DDoSed by other services. Developers learn quickly they need to defend themselves. They need to have a “trust nobody” mindset and need to stay on the defensive. This mindset encourages *less* access, more encapsulation, because developers need to protect their systems.

* Coupling. What starts off as “loosely coupled” actually turns into “tightly coupled” when services start to depend on each other.  How can services which depend on each other be “loosely coupled”? They are tightly coupled by definition.


* Coupling (Part II). Microservice thinking claims autonomy as a key benefit. But how can services be autonomous when they have direct dependencies on each other? They are, by definition, coupled!

Microservices promote autonomous *teams*, which is critical for building culture and a sense of team ownership. That autonomy is different from system autonomy. Microservices couple systems, creating dependencies and ultimately high coupling from a software perspective.

* Higher level tooling. This isn’t really a drawback of microservices proper, it is more an operational necessity for any system as it scales. But with microservices, you need to invest in exceptional operational tooling early. You need the ability to discover, monitor, control, and centrally configure services in your environment. You’ll also need software to prevent DDoS, fault tolerance, scaling on demand, blue / green deployments, etc.

* Service granularity. Microservices, by definition, are meant to be small. Engineering discipline and thoughtful planning is required to design services with an appropriate balance of granularity. Too course grained and you’ll end up with a “macro” or “god” service spanning multiple capabilities. Too fine grained and you’ll end up spending more time maintaining and wiring services together than building the services. Service design isn’t a problem with microservices more than it would be with any other design, but because services become hard dependencies for other teams, they are expensive to change after launch.

* Transactions. Transactions are an anti-pattern in microservice design. They are, however, still quite common and necessary in many large systems. Thought needs to be put into how systems will eventually become consistent or how partially completed workflows can be resumed or “rolled back” if not complete.

* Dependency hell. Type checking does not work well across service boundaries. You *could* publish strongly typed models and API, however many teams do not - especially in dynamic languages like javascript. Even if they do, dependencies can still be difficult to manage. Releases across teams and projects need to be coordinated. Contract updates need to be agreed on between teams. Services need to maintain backwards compatibility. Breaking changes must not exist or must be planned carefully.

* Debugging. Working in a microservices environment requires you to debug across teams. Your service may be running fine, but your dependencies may not be. While a bug may be important to your team, it may not be a priority for them. You could try to open a PR against their team’s codebase to assist, but ultimately they are responsible for fixing and shipping. Your priority might not be their priority.

* Event notification. Microservices are REST driven. Requests are received, responses are returned. However many systems are event based. You want an event to be triggered to notify other systems something happened.

We could have service A directly invoke service B when an event occurs, but that becomes messy quickly. It tightly couples A and B. What if service C wants the same event, but with a different data structure format. Service A needs to be updated to call C. A now has custom logic for both B and C. Or the team behind A could mandate all callers receive a canonical event, sending all teams the same data, even if they only need a small piece of it.

The industry has solved this problem with publish / subscribe systems, event busses, message queues, and enterprise service bus architectures. This type of infrastructure exists along side, not as a part of, a microservice architecture. The point here is that microservices, by themselves, are not built with eventing as a first class citizen.

* Data transfer. Microservices, by definition, are built to encapsulate, or hide, data. They are not built to transfer data between systems. As we move into AI first development, we must design systems which encourage data transfer between systems. Access to data is paramount to data science and AI teams. We need to augment microservices with infrastructure that exposes data, not hides it.



##  Introducing Event Sourcing

So the question is:

> How can we design systems which keep the benefits of microservices without the drawbacks?

There is an important point I want you to read twice before proceeding:

> Event sourcing does *NOT* replace, but rather *COMPLIMENTS* microservices. There is no *right way* to do software, all designs have tradeoffs.

Microservices do not need to "go away". They simply aren't optimal for many large system scenarios. They are great for modularizing a system into discrete logical units, however they are not great at passing state between services.

We want a pattern which keeps the concepts of team autonomy, modularization, and single responsibility that microservices provide. However we want to eliminate the coupling and dependency management that microservices provide. We also want the ability to access the raw data across systems in order to power new applications. We don't want to hide data, we want to expose it. Data and access to it is key.

Let's turn our attention to event souring and see how the pattern can help achieve those goals.

Event sourcing is a very simple and common pattern used in software today. You’re probably familiar with it already. But if not, let’s walk through a very high level introduction.

### Events

Event sourcing is a really, really simple concept.

Event sourcing stores all state changes, called events, into a chronological data store, enabling other systems to "source" their data from said events.

That's it! But what does that mean?

Here is a simple example. Say I create a checking account. When I create a new account, a “Create” event is created and stored into an event log. I withdraw money from the account, a “Withdrawal” event is stored into the event log. I deposit money, a “Deposit” event is stored into the event log.

Here’s what the event log would look like:

> 1 - Create - #12345 - Damon Allison - $500.00
> 2 - Withdrawal - #12345 - $100
> 3 - Deposit - #12345 - $800

So each change becomes an “event”. Simple enough. We have a series of events. Big deal. We’ve had ESBs, message queues, and similar types of infrastructure for the past 30 years. What makes this novel or unique?

Events are not interesting by themselves. What is interesting is the “sourcing” piece of event sourcing.

Sourcing data from events enables the decoupling, scalability, and flexibility which help alleviate many issues common with microservices.

### Sourcing

What does “sourcing” mean?

Sourcing is the term used to indicate how a system acquires data. Think of it this way - if you grocery shop, you are “sourcing” food from the store. If you are a retailer, you are “sourcing” products from manufacturers. If you read a book, you are “sourcing” information for your report. If you are news anchor, you interview “sources” for your story. You get the idea - sourcing is the mechanism by which you acquire things. The “thing” systems source is data.

With event sourcing, you “source” data for your system from an event stream. As events arrive, you update your data store. Your data store can be in any format - relational (SQL), document (Mongo), flat (HDFS), searchable (Elastic), etc.

That’s all there is to it. Very simple, but as we’ll see, also very powerful.


## Event Sourcing - Flexible, Real Time, Decoupling
So we source our data from events. So what? What is the difference between sourcing our data from “events” or sourcing data from a user typing in a text box and saving it to a database? Or sourcing our data by having another service send us data via our service interface?

The key difference is this:

> Events, not databases, are the source of truth.

Using events as the source of truth requires you to think differently than when using a relational database as the source of truth.

Events, individually, are not very useful. They tell you the state of a particular record or set of records at a particular point in time. Events can’t be queried using T-SQL. Statistics can’t easily be calculated or reports cannot be built from a series of events, let alone across multiple event streams.

Event sourcing is flexible. Event sourcing allows the consuming system to build the data store from those events which best fits their system. This gives the consumer full flexibility to how they store their data.

For example, a search service would build an Elastic index from incoming events. A data science system may want to store event data into a Hadoop cluster. An orders system may store order data in Mongo. And since they are consuming their data independently, each consumer has full autonomy to consume and store event data however they like.

Event streams are real time. When building event driven systems, events are consumed in real time. This allows systems to be highly dynamic. No long running batch jobs or ETL processes needed.

Event sourcing decouples systems. In order to pass data between services in a microservices architecture, two services need to be coupled together. Service A sending data to service B and C. With event sourcing, the event producer knows nothing about the consumer. This decoupling makes it trivial for systems to subscribe to events from one or many event streams, making it possible to quickly innovate by combining streams.

By making data, not service boundaries, the primary way for systems to gather data, it reduces friction and work required by both the producing and consuming teams. Teams do not need to coordinate release schedules, manage dependencies, or even have to communicate. Removing organizational friction is the key to innovation and rapid success and overcomes challenges not suited for request / response REST microservices.

There are many smaller, but still very  important advantages event sourcing enables.

## Other advantages of Event Sourcing
* Audit trail
	* Event sourcing allows you to see the history of events and state changes over time.
	* Having a historical record acts as an audit trail, allowing you to trace back the history of a record over time.

* Complete Rebuild
	* The current state of a system could be rebuilt by simply replaying the events.
	* This could enable real time backup / restore or simplify disaster recovery scenarios by simply adding a second event consumer.
	* Any system which you make small changes to over time becomes more difficult to reason about. For example, making individual changes to infrastructure over time makes it difficult to rebuild from scratch. The solution to that is to template your “infrastructure as code”. Similarly, when making changes to a DB, the DB will start to gain cruft. Tables grow incorrectly because it’s “easier to just add a column here”, or fields have NULLs for all old records. Event sourcing allows you to update your data model and rebuild from scratch without building up the cruft.

* “Temporal query” - queries at different points in time.
	* You could replay events to a certain point in time, allowing you to query or examine or learn from data at various historical points.
	* You could also run multiple timelines or “what / if” scenarios in parallel to determine which of multiple algorithms would produce better results.

* Replay
	* If bugs are found, the event history could be updated by removing the incorrect event or inserting a reversing event.
	* You could change code and reprocess he events. Helpful if bugs are found.

* Scalability
	* Systems can listen for events, process them in parallel. Clients can scale up the number of receivers.

* Loosely coupled
	* Systems operate independently on only the data they care about, isolating themselves from other systems.
	* Easy to add new applications / combine streams without requiring involvement from the stream producer

* Performance
	* Event sourcing allows you to keep data local to your application, avoiding costly network connections and REST calls.
	* Writes are high performance since the writer can write to disk sequentially and the reader can read from disk sequentially.

* Stability.
	* Systems are more resilient when they are loosely coupled. Many services don't need to be available 99.99% of the time. If a service is storing customers goes offline for 15 minutes, other services which have suited customer data locally will continue to function normally. When the customer service is brought back online and reprocesses the changes which occurred while it was offline, all consumers will receive the updates. Had the services been coupled via REST, both services would have been offline.
* Debugging
		* Event sourcing enables advanced debugging and diagnostic scenarios. Events could be replayed to help debug an invalid state. Or for testing different code branches for performance state of multiple other systems.
	* You can replay events into a clean room for debugging.

### Challenges with event sourcing

Event sourcing is not a panacea. Event sourcing is all about building state from historical events. Many times, when you receive events, you have to interact with other systems. For example, if you are given an event that a customer order changed, you may want to retrieve additional information about the customer at the time the event occurred. That sounds simple, but it poses an interesting, sneaky, problem.

If the event just occurred, the customer information you pull to enrich the event from, say, a customer service, will be current. But what happens if you are replaying the event? What did the customer record contain when the original event fired? If the customer service did not understand how to return data from a historical point in time, you’re going to incorrectly apply the current customer information to the historical record, which has the potential for bugs.

SQL and transaction (OLTP) systems were not designed with historical context in mind. The database only ever has one “state” - the current state. Unlike events, which contain a state at a historical point in time, transactions systems just contain the latest. Therefore, you need to be careful when replaying events and interacting with external systems.

Two problems you encounter when dealing with external systems are external queries and external updates.

* External queries
	* If you invoke an external system when processing an event being replayed, the external system may not be able to give you same data you would have received when the event was first received.
	* The external systems need to be able answer queries from the past, or a caching / historical layer would need to be added to the gateway to remember the external system response from the original event.
* External updates
	* Updating an external system during event replay may not be possible.
	* Ensure external systems can handle event replay.

When replaying events, and downstream services are not / cannot handle replays, consider adding a `Gateway` which knows when you are handling “live” events and when you are in a replay situation. Configure the gateway to *not* query into or update external systems during replay.

* Eventual consistency
	*
	* ETAGs to determine modified data to determine if you are updating stale data (update comes, invalidating update).
	* Store -> Flush on interval for performance.



## Implementing Event Sourcing
This post is all about what event souring *is*, not how to implement it. That said, here are a few important things to consider when adopting event sourcing.

### Not “all or nothing”

Like any architectural pattern, event sourcing is just one pattern to help you design a system. Event sourcing will *not* solve AI for you, will *not* allow a customer to interact with your UI, and will certainly *not* eliminate microservices.

Event sourcing must be used in conjunction *with* microservices and other design patterns. Use event souring for its strengths - real time data flow between systems.

### Mindset

REST is all about encapsulating data. Developers have to put up walls to gate access to systems and protect their data stores.

With event sourcing, you want teams to have a *servant mindset* when it comes to data. That sounds really idealistic and philosophical, but it’s very important to the success at scale. Please listen - this is important.

You want teams to think about how to best give away data, not hide it. You want teams thinking about how their events can better enable other systems.

Reread those last two paragraphs, write them down. They are critical.

### Events as Interfaces

When events are the source of truth, they become the public interface of your system, your system boundary. You must *think very critically* about the interfaces you expose. Interfaces are *expensive* to maintain and version over time.

Spend time early designing interfaces with the future in mind. Do *not* just dump your internal data structures into an event stream. Think about versioning, data structures, entity relationships, from a consumer perspective.

Versioning is expensive. Events will need to be versioned. The more reason to design your data structures and event payloads carefully up front.

### Manage Complexity

Event sourcing has a lot of moving parts. If 10 people who used to query into a REST endpoint now have their own data stores, you have 10 new data sources. 10 new consumers and git repositories. 10 new monitors to create to ensure things are running.

Before just “throwing up another event source”, think carefully about the sources you create. Operational costs with event sourcing are not cheap.

### Design Workflows

Introducing event sourcing eliminates the coupling between microservices, but it doesn’t replace the fact that systems must interact with each other.

Rather than chaining services together to accomplish workflows, events become the trigger which advances the workflow. The workflow still exists, and it may even be harder to reason about by introducing event sourcing as a trigger rather than seeing a direct web service call.

You *must* document workflows between systems and understand how events are used to advance them.

### Think Eventually Consistent

As you transition to event sourcing, you *must* think in terms of eventual consistency. Ultimately, systems are asynchronous. Purchasing an item on Amazon does not block the UI until a package shows up at your door.

By introducing event streams, you are *forcing* things to be async. What was once a synchronous request / response may now be an async event triggered workflow.

Again, there is no better substitute than to think and design first. Event streams are going to introduce complexity and eventual consistency is one of them.


## Conclusion
Microservices have brought with them many benefits in terms of system composition, autonomy, and a mindset of automation. They have also brought us system and team coupling - especially for large systems with 100s of services.

Event sourcing is a pattern of using events to record changes and pass state between systems. Event sourcing can decouple systems by separating the producing system from the consuming system. New systems can spawn up by combining data from multiple streams. Events are published in real time, allowing systems to act to changes in real time.

Event sourcing does *not* eliminate microservices or complexity. When implementing event sourcing, you must *think critically* about both the actual events (as they are your public interface) and how the streams and systems work together to implement workflows.

There is no silver bullet in software design. At the end of the day, event sourcing is just another pattern to consider when designing systems. But one that, when used right, can make your systems more flexible, real time, and less coupled.


## Bibliography
* [Microservices - Wikipedia](https://en.wikipedia.org/wiki/Microservices)
* [Martin Fowler - Event Sourcing](https://martinfowler.com/eaaDev/EventSourcing.html)
* [Chris Kiehl - Don’t Let the Internet Dupe you, Event Sourcing is Hard](https://chriskiehl.com/article/event-sourcing-is-hard)

#tech/event-sourcing