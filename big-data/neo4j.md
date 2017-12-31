# Neo4j

* Neo4j is a graph database implemented in Java and Scala.
* Neo4j is ACID compliant, support write ahead logging (WAL) / recovery.
* Neo4j's query syntax called `cypher` is very SQL-like, however contains graph specific functionality.

## Graph Databases

* The big idea of graph databases.
    * Graph databases store relationships as first class citizens, speeding up `join` operations.

### Compared to RDBMSs

* RDBMSs performance slows exponentially, especially when introducing `join` tables to handle `many-to-many` relationships.

* Each node contains a list of relationship records which are used to improve performance.

* Differences between RDBMS / Graph database data structures.
    * Graph databases allow you to create entities without technical primary key fields (IDs).
    * Foreign key fields are not needed. Relationships make them unnecessary.
    * Joinss tables are not necessary. They become relationships.

### Compared to NoSQL

* Document databases have one dedicated, aggregated, view of your data (the document).
* It's expensive (or difficult) to join across document stores.
* Graph databases give you the ability to alter the document structure by adding new relationships.

### Property Graph Model

* The property graph model defines the nodes and relationships (the graph).
* Golden rule in graphs : "no broken links". Deleting a node deletes all relationships associated with that node.

#### Nodes

* Nodes contain attributes (KV pairs)
* Nodes can contain labels. Labels can be used to attach metadata.

#### Relationships

* Relationships have:
    * A direction.
    * A type.
    * A start node.
    * An end node.
    * Properties (KV pairs).


