--*************************************************
-- pg-learning.sql
--
-- Notes taken from the PostgreSQL documentation at:
-- https://www.postgresql.org/docs/13/index.html
-- ************************************************


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Part I : Tutorial
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

create database damon;

-- NOTE: `DROP TABLE IF EXISTS` is *not* standard SQL
--
-- CASCADE recursively drops dependencies. However, it will *NOT* drop user defined functions that depend
-- on the object being dropped. These functions will break.
--
-- `DROP TABLE my_colors CASCADE` will *NOT* drop the get_color() function
--
-- CREATE FUNCTION get_color(val) RETURNS text AS
--  'SELECT name FROM my_colors WHERE id = val'
--  LANGUAGE SQL
--
-- For safety, drop dependencies manually from the bottom up.
--
DROP TABLE IF EXISTS people CASCADE;
DROP TABLE IF EXISTS children CASCADE;
DROP TABLE IF EXISTS scores CASCADE;

--
-- postgres calls tables "relations" internally.
--
CREATE TABLE IF NOT EXISTS people
(
    id    integer primary key,
    fname varchar,
    lname varchar
);
CREATE TABLE IF NOT EXISTS children
(
    id        integer primary key,
    parent_id integer references people (id),
    fname     varchar,
    lname     varchar
);

CREATE TABLE IF NOT EXISTS scores
(
    id        integer primary key,
    parent_id integer references people (id),
    score     integer
);

insert into people (id, fname, lname) values (1, 'damon', 'allison');
insert into people (id, fname, lname) values (2, 'kari', 'allison');
insert into people (id, fname, lname) values (3, 'roxie', 'allison');

insert into children (id, parent_id, fname, lname) values (1, 1, 'cole', 'allison');
insert into children (id, parent_id, fname, lname) values (2, 2, 'grace', 'allison');
insert into children (id, parent_id, fname, lname) values (3, 2, 'lily', 'allison');


insert into scores (id, parent_id, score) values (1, 1, 40);
insert into scores (id, parent_id, score) values (2, 1, 60);
insert into scores (id, parent_id, score) values (3, 2, 60);
insert into scores (id, parent_id, score) values (4, 3, 60);
insert into scores (id, parent_id, score) values (5, 2, 60);

--
-- Views are named queries that can be used as a table
--
-- Making liberal use of views is a key aspect of good SQL design.
-- Views allow you to encapsulate the details of the table structure,
-- which might change as the application evolves.
--
CREATE OR REPLACE VIEW fam AS (
    SELECT p.id    AS pid,
           p.fname AS pfname,
           p.lname AS plname,
           c.id    AS cid,
           c.fname AS cfname,
           c.lname AS clname
    FROM people AS p
             INNER JOIN children AS c on p.id = c.parent_id
);

--
-- Expressions
--
-- Using expressions in select statements allow you to manipulate
-- table columns before they are returned.
--
SELECT CONCAT(fname, ' ', lname) AS fullname FROM people;

--
-- JOIN
--
-- LEFT OUTER JOIN - returns all rows from the LHS. If no matching rows exist on the RHS, returns NULL for RHS fields
-- RIGHT OUTER JOIN - returns all rows from the RHS. If no matching rows exist on the LHS, returns NULL for LHS fields
-- FULL OUTER JOIN - returns all rows from both tables. If no matching row exists on the opposite side, returns NULL for the opposite side fields
--
-- All parent and child relationships.
SELECT p.fname,
       p.lname,
       c.fname,
       c.lname
FROM people as p INNER JOIN children as c ON (c.parent_id = p.id);


-- Finds all people w/o children
SELECT * FROM people as p
         LEFT OUTER JOIN children as c ON (c.parent_id = p.id)
WHERE c.id IS NULL;

SELECT * FROM people, children;


--
-- Subqueries
--
-- Subqueries allow you to execute additional queries to provide data the top level query.
--
-- IMPORTANT - when the subquery is used as an expression (like it is here with `=`,
-- it must return a single value. This is called a "scalar subquery".
--

-- A (rather contrived) example of a "scalar subquery"
SELECT * FROM people WHERE id = (SELECT id from people WHERE fname = 'damon');

-- An example of a subquery which returns a set of values. A non-scalar subquery.
SELECT * FROM people where ID IN (SELECT DISTINCT parent_id FROM children);

--
-- A subquery can refer to variables from the surrounding query, which will act as constants
-- during any one evaluation of the subquery.
--
-- This is the same functionality as JOIN, however it's probably *much* slower as it's executing
-- a subquery for each row.
SELECT p.id,
       (SELECT SUM(score) FROM scores where parent_id = p.id)
FROM people as P;

--
-- Aggregates
--
SELECT SUM(s.score),
       p.fname
FROM scores AS s
         INNER JOIN people AS p on p.id = s.parent_id
GROUP BY p.id
HAVING SUM(s.score) >= 100;

--
-- Transactions
--
-- PostgreSQL has the concept of `savepoints` (not shown here),
-- which allow you to rollback part of a transaction
--
BEGIN;
UPDATE people SET fname = 'test' WHERE fname = 'damon';
ROLLBACK;

--
-- Window Functions
--
-- Window functions perform a calculation across a set of table rows that are somehow related to the current row.
-- This is *different* than an aggregate function. With window functions, all original rows are returned in the result.
--
-- Window functions allow the query to access more than just the current row of the query result.
--
-- The "OVER" clause tells SUM() to compute over the window frame, not the entire table.
--
-- OVER *always* follows the window function in the SQL statement. The window function here is "sum".
--
-- For each row in the result, the window function is computed across the rows that fall into the same
-- partition as the current row.
SELECT sum(score) OVER (PARTITION BY parent_id), parent_id FROM scores;

-- Compare that to an aggregate which computes the sum. Only a single row is returned per parent_id
SELECT sum(score), parent_id
FROM scores
         INNER JOIN people ON people.id = scores.parent_id
GROUP BY parent_id;



-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Part II : The SQL Language
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--
-- Chapter 4: SQL Syntax
--

-- Identifiers identify names of tables, columns or other DB objects.
-- They are sometimes referred to as "names".
--
-- If identifiers conflict with SQL keywords, they can be quoted (in double quotes).
-- This is useful when your identifier is a SQL key word.
--
-- SQL key words (SELECT, UPDATE) and identifiers (table / column names) are case insensitive.
--
-- Here "first" and "update" are identifiers.
-- Quoting an identifier makes it case sensitive.
-- Unquoted identifiers are always folded lower case and are case insensitive.
--
-- Constants
WITH ex AS (
    -- Uses double quotes to specify "update" as an identifier.
    SELECT 'one' as first, 'update' as "update"
)
SELECT * FROM ex;

SELECT 4 as "my-int";
--
--

--
-- Constants
--
-- A Constants can be strings, bit strings, and numbers. By default, they are implicitly typed, but they can be
-- explicitly typed.
--
-- String constants are enclosed in 'single quotes'. Use '' to escape a single ' within the string.
--
-- Numeric constants that does *not* contain a decimal point is implicitly typed as `integer`, if it fits into 32 bits,
-- `bigint` if it fits into 64 bits, else `numeric`
--
SELECT 'Don''t do that' AS str, 4. as flt, 4 as num;

--
-- Expressions
--
-- Aggregate expressions reduce multiple inputs to a single output value.
--
-- Aggregate expressions can only appear in the result list or the HAVING clause.
--
-- Most aggregate functions (except count(*)) ignore NULL
--
-- COUNT(*)  - yields the total number of input rows
-- COUNT(f1) - yields the total number of input rows where f1 IS NOT NULL
-- COUNT(DISTINCT(f1)) - yields the total number of distinct non-null values of f1
--
-- *Some* aggregate functions (array aggregations) depend on ordering.
-- To specify an order, the aggregate expression can include an "ORDER BY" clause.
--
-- Aggregate functions can have a FILTER clause. Only the input rows which match the filter
-- clause will be fed to the aggregate function.
--
SELECT COUNT(*)                                                  as count,
       SUM(ALL score)                                            AS total,
       SUM(ALL score * .9)                                       AS discount,
       SUM(ALL score ORDER BY id desc) FILTER (WHERE score > 50) as ordered_sum,
       SUM(DISTINCT score)                                       AS uniq
FROM scores;


--
-- Window Function Calls
--
-- A window function call represents aggregation like functions over some portion
-- of the rows selected by a query.
--
-- Windowed functions are *not* like aggregate functions. With windowed functions,
-- each row in the result set is returned. With aggregate functions, only a *single*
-- value is returned.
--
SELECT p.fname, p.lname, SUM(s.score) OVER (PARTITION BY p.id)
FROM people P
         LEFT JOIN scores S on P.id = S.parent_id;

--
-- Type Casting (Use CAST())
--
-- The historical psql convention for casting uses `::type`
-- '4'::float4
--
-- CAST(val AS type) is SQL compliant
--
-- Both type casts are equivalent, CAST is simply SQL compliant.
--
SELECT 4::float8 AS psql, CAST(4 AS float4) as sqll;


--
-- Arrays
--
-- Arrays can be multi-dimensional. However, they must be rectangular (lame).
--
-- The array element type can be casting the array constructor to the
-- desired type (integer[] here).
--
SELECT ARRAY [1, 2] AS uncasted, CAST(ARRAY [1, 2] AS integer[]) AS casted;
SELECT ARRAY [[1, 2], [3, 4]];

-- It's possible to construct an ARRAY from the results of a subquery
SELECT ARRAY(SELECT score from scores);

--
-- CASE
--
SELECT CASE
           WHEN score > 50 THEN 'high'
           ELSE 'low'
           END,
       parent_id
FROM scores;



--
-- Functions
--
-- Functions can have named or positional arguments.
--
-- Positional arguments are called without names.
-- Positional argeuments must be specified in the order they are defined on the function declaration.
--
--   concat_lower_or_upper('damon', 'allison')
--
-- Named arguments are matched to function parameters by name and can be written in any order.
--
--   concat_lower_or_upper(b => 'allison', a => 'damon')
--
-- Postgres also supports "mixed" notation, where *some* parameters are positional, others are named.
-- When using mixed notation, positional parameters must preceed named parameters.
--
--   concat_lower_or_upper('damon', upper => false, b => 'allison')
--
CREATE FUNCTION concat_lower_or_upper(a text, b text, upper boolean DEFAULT true) RETURNS text AS
$$
SELECT CASE
           WHEN $3 THEN UPPER($1 || ' ' || $2)
           ELSE LOWER($1 || ' ' || $2)
           END;
$$
    LANGUAGE SQL IMMUTABLE
                 STRICT;

-- Am example showing a function call using named (first) and positional (second) parameters
select concat_lower_or_upper(b => 'allison', a => 'damon', upper => false) AS lower,
       concat_lower_or_upper('damon', 'allison')                           AS upper;



select concat_lower_or_upper('damon', upper => false, b => 'allison') AS lower,
       concat_lower_or_upper('damon', 'allison')                      AS upper;


--
-- Chapter 5: Data Definition
--

--
-- Common Data Types
--
-- integer (int)
-- numeric (float)
-- text (strings)
-- date (date only)
-- time (time only)
-- datetime (date and time)

DROP TABLE IF EXISTS ch5;

--
-- Default values can be an expression, which will be evaluated when the default value is inserted.
--
-- For example `CURRENT_TIMESTAMP` is set when the row is created.
--
-- Generating unique keys is typically done by calling nextval() on a sequence object:
-- id integer DEFAULT nextval('product_id_seq')
--
-- Postgres provides a `SERIAL` shorthand that will generate successive unique IDs for you.
--
CREATE TABLE IF NOT EXISTS ch5(
    id SERIAL,
    name text,
    price numeric DEFAULT 9.99,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP
)
INSERT INTO ch5 (name, price) VALUES ('test', 78.20);

SELECT * FROM ch5;

-- Generated Columns
--
-- Columns can be generated from other columns. Columns that fit this pattern are called "Generated" columns.
-- Generated columns can be stored or virtual. STORED generated columns are persisted with the table, virtual are
-- not - they are computed when read.
--
-- Postgres only implements STORED generated columns.
--
-- You cannot INSERT or UPDATE a generated column manually.
--
CREATE TABLE IF NOT EXISTS ch5_2 (
    height_cm numeric,
    height_in numeric GENERATED ALWAYS AS ( height_cm / 2.54 ) STORED
);

INSERT INTO ch5_2 (height_cm) VALUES (2);
SELECT * FROM ch5_2;


--
-- Constraints
--
-- Constraints provide additional restrictions on a column's value.
--
-- Constraints are satisfied if the columns they refer to are NULL. They will *NOT* prevent NULLs
-- from entering the table. Use NOT NULL on the column definition.
--
-- You *CAN* call functions in a check constraint. Makes sure the function you call is IMMUTABLE
-- and IDEMPOTENT. It MUST return the same result when given the same row.
--
-- NOT NULL tip:
-- * MOST* columns should be `NOT NULL`!
--
--
-- PRIMARY KEY
--
-- * The PRIMARY KEY constraint indicates that a column or group of columns are unique and NOT NULL.
-- * PRIMARY KEY will create a unique index on the column(s) and will force the columns to be NOT NULL.
--
-- FOREIGN KEY
--
-- A FK constraint specifies that values in a column or group of columns must match values appearing in
-- some row of another table. This is the basis for referential integrity between the two tables.
--
-- FKs must reference columns that are part of a PK or have a UNIQUE constraint on them.
-- Because a DELETE or UPDATE from the referenced table requires a table scan of the referencing tables, it is a
-- good idea to add indexes to the referencing columns as well.
--
-- By default, foreign keys prevent rows from being deleted in the referenced table when rows in other
-- tables refer to it. Specifying ON DELETE CASCADE will also delete any rows that reference the row
-- being deleted.
--
-- FK options include:
--
-- ON DELETE CASCADE
-- ON DELETE SET NULL
-- ON DELETE SET DEFAULT
--
-- Similar to ON DELETE, there is also an ON UPDATE clause (with the same options)
--
-- There are some tricky rules around NULL values. In general, declare PK and FK columns as NOT NULL. This will require
-- that all columns always satisfy the constraints.
--
--

--
-- Schemas
--
-- Databases contain schemas, which contain tables, functions, data types, and operators.
-- Unlike databases, schemas are not rigidly separated. Users can access objects in any of the schemas
-- in the database they are connected to, if they have privileges to do so.
--
-- Reference objects in a schema with `schema_name`.`object_name`
--
-- You typically do *not* want to write the schema prefix out when writing SQL queries. That would unnecessarily tie
-- the objects to a particular schema. Rather, set the `search_path` to the schema(s) you want your SQL to search
-- when identifying objects. The first schema in `search_path` will be the schema where new objects are created.
--
-- To determine what schema is the default schema, use `search_path`.
--
-- pg_catalog
--
-- Each database contains a `pg_catalog` schema, which contains the system tables and built-in data types.
-- pg_catalog is the first schema in the search path. Don't prefix your objects with `pg_` - which will conflict
-- with system tables.
--
SHOW search_path;
SET search_path to ch5;

DROP SCHEMA IF EXISTS ch5 CASCADE;
CREATE SCHEMA IF NOT EXISTS ch5;

DROP TABLE IF EXISTS section3;
DROP TABLE IF EXISTS section3_2;

CREATE TABLE IF NOT EXISTS section3 (
    id SERIAL PRIMARY KEY,
    product_no TEXT NOT NULL,
    price numeric NOT NULL CONSTRAINT positive_price CHECK (price > 0 AND price < 1000),
    -- Constraints can be added without being associated with a column.
    -- Postgres calls independent constraints "table constraints" as opposed to "column constraints"
    CONSTRAINT redundant_price CHECK (price > 0),
    --
    -- UNIQUE constraints can include multiple columns.
    -- Note that UNIQUE constraints are *NOT* enforced when both columns are NULL
    --
    CONSTRAINT product_price_unique UNIQUE (product_no, price)
);

CREATE TABLE IF NOT EXISTS section3_2 (
    id SERIAL PRIMARY KEY,
    product_id integer NOT NULL,
    FOREIGN KEY (product_id) REFERENCES section3 (id) ON DELETE CASCADE
);

INSERT INTO section3 (product_no, price) VALUES ('radio', 1.0);
INSERT INTO section3 (product_no, price) VALUES ('computer', 12.11);
-- INSERT INTO section3 (product_no, price) VALUES (NULL, 12.11);
-- INSERT INTO section3 (price) VALUES (-1);


INSERT INTO section3_2 (product_id) VALUES (2);
DELETE FROM section3_2 WHERE id = 2;

SELECT * FROM section3;
SELECT * FROM section3_2;

SELECT * FROM information_schema.tables where table_schema = 'ch5' AND table_name = 'section3';
SELECT * FROM information_schema.columns WHERE table_schema = 'ch5' AND table_name = 'section3';
SELECT * FROM information_schema.table_constraints where table_schema = 'ch5' AND table_name = 'section3';
--
SELECT * FROM pg_indexes WHERE tablename = 'ch5_3';

--
-- Inheritance (don't use it unless you *really* want pain)
--
-- NOTE: SQL:1999 and later defines an inheritance feature, which is *different* than PG's implementation.
--
-- Warning: Indexes (including UNIQUE constraints) and foreign key constraints only apply to single tables, not to
-- their children. Thus, child tables can bypass the parent table's constraints.
--
-- In the example below, we can "break" the PRIMARY KEY constraint of `cities` by inserting multiple rows into
-- `capitals` with the same name.
--
-- Foreign keys which reference cities.name would *not* allow the FK to reference capital names. There is *no* workaround
-- for this.
--
CREATE TABLE IF NOT EXISTS cities (
    name text PRIMARY KEY,
    population numeric NOT NULL,
    elevation integer NOT NULL
);
CREATE TABLE IF NOT EXISTS capitals (
    state char(2) NOT NULL UNIQUE
) INHERITS (cities);

SELECT * FROM capitals;
INSERT INTO capitals (name, population, elevation, state) VALUES ('St. Paul', 544453, 1000, 'MN');
INSERT INTO capitals (name, population, elevation, state) VALUES ('St. Paul', 544453, 1000, 'WA');

-- By default, selecting from the base table will include data from all tables which inherit from it
SELECT * FROM cities;
-- To select only records that were inserted into the base table, not derived tables, use `FROM ONLY`
SELECT * FROM ONLY cities;

--
-- Table Partitioning
--
-- Partitioning allows you to split one logically large table into multiple physical pieces.
--
-- Benefits:
-- * Performance. Reads that are limited to a single partition only deal with that partition.
-- * Bulk loads / deletes can be accomplished by adding / removing a partition.
--
-- When to partition? When the size of a table exceeds the physical memory of a server.
--
-- Partition types:
--
-- * Range Partitioning: The table is partitioned based on a key column or set of columns, with *no* overlap between
--   the ranges of values. Examples - date ranges, IDs.
-- * List Partitioning: Partition by listing which values go in each partition.
-- * Hash Partitioning: Each partition has a modulus and remainder. Each partition will hold rows which the hash value
--   of the partition key divided by the specified modulus will produce the remainder.
--
--
-- To create a partitioned table:
--
-- 1. Create the "base" table with a partitioning method. Range partitioning can include multiple columns.
-- 2. Create partitions. Inserting data into the parent table that does *not* map to one of the existing partitions
--    will case an error. An appropriate partition must be added manually.
--
--
-- If a table is partitioned, INSERTs will *fail* if the inserting row would not fall into a partition. The
-- partitioned table itself does *not* hold any data. All data is contained in partitions.
--
CREATE TABLE log_items (
    id SERIAL,
    severity INT NOT NULL,
    key text NOT NULL,
    val text NOT NULL,
    created_at timestamp DEFAULT current_timestamp
x
) PARTITION BY RANGE (created_at);

--
-- Creating indices on the partitioned table will automatically create one index on each partition
-- (and all partitions you create later).
--
CREATE INDEX ON log_items (created_at);
CREATE INDEX ON log_items (key);

CREATE TABLE IF NOT EXISTS log_items_y2020m09 PARTITION OF log_items FOR VALUES FROM ('2020-09-01') TO ('2020-10-01');
CREATE TABLE IF NOT EXISTS log_items_y2020m10 PARTITION OF log_items FOR VALUES FROM ('2020-10-01') TO ('2020-11-01');
CREATE TABLE IF NOT EXISTS log_items_y2020m11 PARTITION OF log_items FOR VALUES FROM ('2020-11-01') TO ('2020-12-01');
CREATE TABLE IF NOT EXISTS log_items_recent PARTITION OF log_items FOR VALUES FROM ('2020-12-01') TO ('2030-01-01');

ALTER TABLE log_items DETACH PARTITION log_items_recent;
ALTER TABLE log_items ATTACH PARTITION log_items_recent FOR VALUES FROM ('2020-12-01') TO ('2030-01-01');

INSERT INTO log_items (severity, key, val) values (1, 'test', 'event');
INSERT INTO log_items (severity, key, val, created_at) values (1, 'test', 'event', '2020-11-15');
INSERT INTO log_items (severity, key, val, created_at) values (1, 'test', 'event', '2020-11-15');


SELECT * FROM log_items_recent;
EXPLAIN SELECT * FROM log_items WHERE created_at > '2020-10-01';
DROP TABLE log_items_recent;

