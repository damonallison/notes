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
);
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

DROP SCHEMA IF EXISTS ch5 CASCADE;
CREATE SCHEMA IF NOT EXISTS ch5;
SHOW search_path;
SET search_path to ch5;

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

-- Describing a table
SELECT * FROM information_schema.tables where table_schema = 'ch5' AND table_name = 'section3';
SELECT * FROM information_schema.columns WHERE table_schema = 'ch5' AND table_name = 'section3';
SELECT * FROM information_schema.table_constraints where table_schema = 'ch5' AND table_name = 'section3';
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

--
-- Chapter 6 - Data Manipulation
--

DROP SCHEMA IF EXISTS ch6;
CREATE SCHEMA IF NOT EXISTS ch6;
SELECT * FROM information_schema.schemata;

SET search_path to ch6;
SHOW search_path;

DROP TABLE IF EXISTS products;

CREATE TABLE IF NOT EXISTS products
(
    id    SERIAL,
    name  text NOT NULL DEFAULT '',
    price numeric NOT NULL
);
INSERT INTO products (name, price)
VALUES
    ('test', 10.0),
    ('test2', 20.0)

-- Bulk insert with INSERT INTO SELECT
INSERT INTO products (name, price)
SELECT name, price FROM products WHERE price > 10.0;

SELECT * FROM products;

--
-- INSERT, UPDATE, and DELETE have a RETURNING clause, allowing you to return columns from modified rows.
--
-- Note that RETURNING will return the rows *after* triggers have been executed. This allows you to receive
-- the *final* values as they exist in the DB (after computed by triggers).
--
-- Returns the new id value (primary key) for the rows being inserted
INSERT INTO products (name, price) VALUES ('damon', 30.0), ('kari', 30.0) RETURNING id;

-- Returns the entire rows that are being deleted
DELETE FROM products WHERE name IN ('damon', 'kari') RETURNING *;


SELECT * FROM information_schema.tables where table_schema = 'ch6' AND table_name = 'products';
SELECT * FROM information_schema.columns WHERE table_schema = 'ch6' AND table_name = 'products';
SELECT * FROM information_schema.table_constraints where table_schema = 'ch6' AND table_name = 'products';
SELECT * FROM pg_indexes WHERE tablename = 'products';

--
-- Chapter 7 - Queries
--

-- You can select *any* value or run any function with select. You don't need to specify a table or view to select
-- data from.
SELECT round((random() * 100));

DROP SCHEMA IF EXISTS ch7;
CREATE SCHEMA IF NOT EXISTS ch7;
SET search_path to ch7;
SHOW search_path;

DROP TABLE IF EXISTS scores;
DROP TABLE IF EXISTS students;
CREATE TABLE IF NOT EXISTS students (
    id SERIAL,
    fname text NOT NULL,
    lname text NOT NULL,
    CONSTRAINT pk_students_id PRIMARY KEY (id),
    CONSTRAINT unq_students_fname_lname UNIQUE (fname, lname)
);

CREATE TABLE IF NOT EXISTS scores (
    id SERIAL,
    student_id integer,
    score integer,
    CONSTRAINT pk_scores_id PRIMARY KEY (id),
    CONSTRAINT fk_scores_student_id_students_id FOREIGN KEY (student_id) REFERENCES students (id),
    CONSTRAINT score_range CHECK (score >= 0 AND score <= 100)
);

INSERT INTO students (fname, lname) VALUES ('grace', 'allison'), ('lily', 'allison'), ('cole', 'allison'), ('roxie', 'allison');

DELETE FROM scores;
INSERT INTO scores (student_id, score) SELECT id, 50 FROM students where fname = 'grace' and lname = 'allison';
INSERT INTO scores (student_id, score) SELECT id, 50 FROM students where fname = 'grace' and lname = 'allison';
INSERT INTO scores (student_id, score) SELECT id, 80 FROM students where fname = 'lily' and lname = 'allison';
INSERT INTO scores (student_id, score) SELECT id, 80 FROM students where fname = 'lily' and lname = 'allison';
INSERT INTO scores (student_id, score) SELECT id, 100 FROM students where fname = 'cole' and lname = 'allison';

--
-- FROM actually executes first in a query, building up a virtual table for the query to operate on.
--
-- If multiple tables are returned, the virtual table is a cartesian product of the multiple tables.
-- This is the same as a cross join.
--
SELECT * FROM students, scores;
SELECT * FROM students CROSS JOIN scores;

--
-- JOINs join two tables together based on an a join condition.
--
-- INNER JOIN is the default
--
SELECT s.id AS student_id, sc.id AS score_id , s.lname, s.fname
FROM students AS S INNER JOIN scores AS sc ON s.id = sc.student_id;

--
-- USING
--
-- USING is a short hand that applies when columns on both sides of the join are the same.
--
-- `A JOIN B USING (c1, c2)` is the same as `A JOIN B on A.c1 = B.c1 AND A.c2 = B.c2`
--
-- When tables are JOINed with USING, only *one* value of the USING columns are returned (since they are both the same).
-- When joined with ON, both of the join columns are returned.
--
-- This query makes no sense for the given table layout, but it does show USING.
--
SELECT * FROM students JOIN scores USING (id);

-- LEFT OUTER JOIN will return all rows from the left regardless if there are matching rows on the right.
-- RIGHT OUTER JOIN will return all rows from the right regardless if there are matching rows on the left.
-- FULL OUTER JOIN will return all rows from both tables, nulls if there are no corresponding match from the other side.
-- NULL values are returned for columns in which do not match.

-- Example: Finds all students without scores using a LEFT OUTER JOIN and the fact that NULLs are returned
-- when no matching rows exists in the right table.
SELECT * FROM students AS s LEFT OUTER JOIN scores AS sc ON s.id = sc.student_id WHERE sc.student_id IS NULL;

--
-- Subqueries
--
-- A subquery can be used as a table reference. The table reference returned in the subquery must be aliased.
--
SELECT s.*, scores.* FROM (SELECT student_id, score FROM scores) AS s INNER JOIN scores ON s.student_id = scores.student_id;

--
-- Table Functions
--
-- Table functions are functions that produce a set of rows. They are used like a table, view, or subquery in the FROM
-- clause of a query.
--
DROP FUNCTION IF EXISTS get_students_by_last_name;
CREATE FUNCTION get_students_by_last_name(text) RETURNS SETOF students AS
$$
    SELECT * FROM students where lname = $1;
$$ LANGUAGE sql;

SELECT s.* FROM get_students_by_last_name('allison') AS s;

--
-- LATERAL
--
-- Subqueries preceeded with the keyword `LATERAL` allow the subquery to reference columns provided by preceeding FROM
-- items. Without LATERAL, subqueries cannot reference any other FROM item.
--
-- NOTE: This is horribly inefficient as the subquery needs to be evaluated for *EACH* row in the FROM item providing
--       the cross-referenced columns (in this case (`s`).
--
-- JOIN is **MUCH** faster given it uses set operations.
--
-- There are some cases where LATERAL is useful. For example, providing an argument to a function that returns a table.

SELECT * FROM students as s, LATERAL (SELECT get_students_by_last_name(s.lname)) AS s2;


--
-- WHERE
--
-- After FROM builds the virtual table, WHERE is evaluated for each row. If WHERE is true (not false or NULL), it is
-- kept in the virtual table.
--

SELECT * FROM scores WHERE student_id IN (select id from get_students_by_last_name('allison'));
SELECT * FROM scores WHERE student_id IN (SELECT id from students where fname = 'grace');
--
-- Subqueries can reference the *entire* virtual table of the FROM clause.
-- Remember, WHERE is executed for EACH ROW of the virtual table.
--
-- Here, we show using `s` within a WHERE subquery.
--
-- Where you can, prefer to use JOINs to shrink the virtual table. This will reduce the input set that
-- WHERE is evaluated against.
SELECT * FROM scores AS s WHERE s.student_id IN (SELECT id FROM students WHERE id = s.student_id);

--
-- GROUP BY
--
-- GROUP BY groups rows in a table that have the same values in all the columns listed. This combines each set of rows
-- having common values into one row that represents all rows in the group.
--
-- If a table is grouped, columns *NOT* listed in the GROUP BY clause cannot be referenced except in aggregate expressions.
-- For example, score is referenced in the aggregate expression SUM ().
SELECT COUNT(*) as CT, SUM(score) as total, student_id FROM scores GROUP BY student_id;

--
-- Select Lists
--
-- After the FROM, WHERE, GROUP BY, and HAVING clauses are performed, the SELECT list is selects the columns from the
-- result that should be returned.
--
-- If the select list contains a value expression example: (a * 1.5), the column is given an alias,
-- typically matching the function that was performed. In almost all cases, you'll want to give the
-- column an alias.
--
-- DISTINCT eliminates duplicate rows. You can give DISTINCT a list of columns you want it to consider as distinct.
--
-- NOTE: `DISTINCT ON` is *NOT* part of the SQL standard - it's a PG extension.
--       You'll typically want to use GROUP BY in your queries to avoid the need to use DISTINCT ON.
--
-- `DISTINCT` *is* part of the SQL standard, so it can be used cross platform.
SELECT DISTINCT ON (student_id) student_id,  CONCAT('your score is ', SUM(score)) AS d FROM scores GROUP BY student_id;


--
-- Combining Queries
--
-- Queries can be combined using UNION, INTERSECT, and EXCEPT.
--
-- The queries must be "union compatible", which means they have the same number of columns and each corresponding
-- column have compatible data types.
--
-- UNION will combine queries, limiting duplicate rows unless UNION ALL is used
-- INTERSECT will return all rows are in both queries. Duplicates are eliminated unless `ALL` is used
-- EXCEPT will return all rows in query1 but *not* in query2. Duplicates are eliminated unless `ALL` is used
--
SELECT greeting FROM (VALUES ('hello'), ('world')) AS d (greeting)
UNION
SELECT 'hello' as greeting;

SELECT greeting FROM (VALUES ('hello'), ('world')) AS d (greeting)
UNION ALL -- ALL will include duplicates
SELECT 'hello' as greeting;

SELECT greeting FROM (VALUES ('hello'), ('hello'), ('world')) AS d (greeting)
INTERSECT
SELECT greeting FROM (VALUES ('hello'), ('hello'), ('world'), ('there')) AS d (greeting)

SELECT greeting FROM (VALUES ('hello'), ('hello'), ('world')) AS d (greeting)
INTERSECT ALL -- ALL will include duplicates
SELECT greeting FROM (VALUES ('hello'), ('hello'), ('world'), ('there')) AS d (greeting)

SELECT greeting FROM (VALUES ('hello'), ('world'), ('world')) AS d (greeting)
EXCEPT
SELECT greeting FROM (VALUES ('hello'), ('hello'), ('world')) AS d (greeting)

SELECT greeting FROM (VALUES ('hello'), ('world'), ('world')) AS d (greeting)
EXCEPT ALL -- ALL will *not* eliminate duplicates
SELECT greeting FROM (VALUES ('hello'), ('hello'), ('world')) AS d (greeting)

--
-- ORDER BY
--
-- After the SELECT list has been produced, the output table can be sorted with "ORDER BY"
--
-- The `ORDER BY` expression can be any expression that would be valid in the query's SELECT list.
-- When more than one sort expression is used, subsequent expressions are used to sort rows that are
-- equal according to previous sort expressions.
--
-- ASC (ascending) is the default.
--
-- A "NULLS FIRST" or "NULLS LAST" will sort NULLs either first or last respectively. By default, NULLs last
-- is the default for ASC. NULLS FIRST is the default for DESC.
--
-- ORDER BY can use the column aliases defined in the SELECT list.
--
-- ORDER BY can order using any column name as defined in the virtual table. You do *not* need to order by
-- a column in the SELECT list.
--
-- ORDER BY can be applied to the result of a UNION, INTERSECT, or EXCEPT query. If so, ORDER BY can only
-- use the columns returned by the SELECT list.
SELECT id as sid from scores ORDER BY score /* ASC */, sid DESC;

--
-- LIMIT and OFFSET
--
-- LIMIT and OFFSET allow you to retrieve a portion of the results.
--
-- If both LIMIT *and* OFFSET appear, OFFSET rows are skipped before starting to count LIMIT
--
-- When using LIMIT, make sure you ORDER BY the query to ensure the query has an order. The query optimizer
-- will attempt to optimize LIMIT queries, potentially returning different rows unless the query is ORDERed.
SELECT * FROM scores ORDER BY score desc LIMIT 1 OFFSET 0;


--
-- VALUES
--
-- VALUES provides a way to generate a "constant table" that can be used in a query without having to actually create
-- and populate a table on disk.
--
-- Aliases can *and should* be given to both the "table" and columns within the table.
SELECT name, greeting from (VALUES ('damon', 'hello'), ('kari', 'hi')) AS greetings (name, greeting) ORDER BY name DESC;

--
-- WITH Queries (Common Table Expressions)
--
-- CTEs can be thought of as temporary tables that exist for just one query.
--
-- CTEs allow you to break down complex queries into simpler parts. Many times, CTEs can replace
-- nested sub-expressions.
--
-- CTEs are evaluated only once. Therefore, expressions that are used multiple times can be sped up by turning
-- them into CTEs.

WITH student_ids AS (
    SELECT id from students
)
SELECT * FROM scores AS s JOIN student_ids AS ids ON s.student_id = ids.id;



--
-- Chapter 8: Data Types
--

-- Data Types
--
-- Postgres includes ANSI SQL types, as well as custom types (geometric, network addresses, etc).
-- Here are the traditional "SQL" types and a few custom types that are *not* part of the SQL standard,
-- but would be useful to generic programs (like JSON or money).
--
-- bigint (int8)                             64 bit integer
-- bigserial (serial8)                       autoincrementing 8 byte integer
-- boolean
-- character(n)                              fixed length character string
-- character varying [n] (varchar(n))        variable length character string
-- date                                      calendar date (year, month, day)
-- double precision                          64 bit floating point
-- integer                                   32 bit integer
-- json                                      textual JSON
-- jsonb                                     binary JSON data, decomposed
-- money                                     currency amount
-- numeric(p, s) (decimal(p, s))             exact numeric of selectable precision
-- real (float4)                             32 bit floating point
-- smallint                                  16 bit integer
-- text                                      variable length character string
-- timestamp (p) [without time zone]         date and time
-- timestamp (p) with time zone              date and time including time zone
-- time (p] [without time zone]              time of day (no date) 00:00:00 - 24:00:00
-- time (p) with time zone                   time of day (no date) with time zone 00:00:00:1559 24:00:00-1559
-- uuid                                      universally unique identifier
--
-- `numeric` can store numbers with up to 1000 digits and perform calculations exactly. It is recommended when
-- storing monetary amounts or other quantities where exactness is required. numeric is slow when compared to
-- integer or floating types.
--
-- Floating point (real, double precision) are IEEE Standard 754 for Binary Floating Point Arithmetic) types. They
-- are inexact, variable precision numeric types. Inexact means that they must be stored as approximations (1/3).
--
-- Rules on when to use each floating point value:
--
-- * If you require *exact* storage, use numeric.
-- * If you are storing money values, use numeric (or money, if you know what you are doing)
-- * Comparing two floating point values for equality will *not* always work as expected.
--

DROP SCHEMA IF EXISTS ch8;
CREATE SCHEMA IF NOT EXISTS ch8;
SET search_path to ch8;
SHOW search_path;

DROP TABLE IF EXISTS ch8;

CREATE TABLE IF NOT EXISTS ch8 (
    name varchar NOT NULL,
    description text NOT NULL,
    -- numeric(precision, scale)
    -- Where precision is the total count of significant digits of the entire number (both sides of decimal)
    -- Scale is the coune of digits in the fractional part. 23.4141 has a precision of 6 and scale of 4.
    quantity numeric(4,1) NOT NULL
);

SELECT * FROM information_schema.columns WHERE table_name = 'ch8';

INSERT INTO ch8 (name, description, quantity) VALUES ('damon', 'test', 100.2);
-- quantity will be rounded to the nearest .1
INSERT INTO ch8 (name, description, quantity) VALUES ('damon', 'test', 100.24);
INSERT INTO ch8 (name, description, quantity) VALUES ('damon', 'test', 100.25);
INSERT INTO ch8 (name, description, quantity) VALUES ('damon', 'test', 100.26);
INSERT INTO ch8 (name, description, quantity) VALUES ('damon', 'test', 101.24);
INSERT INTO ch8 (name, description, quantity) VALUES ('damon', 'test', 101.25);
INSERT INTO ch8 (name, description, quantity) VALUES ('damon', 'test', 101.26);
-- Zeros will be included to fill out the scale.
INSERT INTO ch8 (name, description, quantity) VALUES ('damon', 'test', 100);

-- Will fail, overflows precision (4,1)
--INSERT INTO ch8 (name, description, quantity) VALUES ('damon', 'test', 1000.9);

SELECT * from ch8;

--
-- SERIAL "types"
--
-- SERIAL types are *NOT* types. They are a notational convenience for creating unique identifier columns.
--
-- Note that it is technically possible for "holes" to exist in the sequence values. For example, if someone
-- calls `nextval` on the sequence but doesn't use the returned value, a number will be burned.

DROP TABLE IF EXISTS ch8_serial_1;
CREATE TABLE ch8_serial_1 (
    id SERIAL,  -- serial(4) : 32 bit. Use `bigserial` if you are going to have > 2^31 values (2,147,483,648) ~ 2.1 billion
    name TEXT,
    CONSTRAINT pk_ch8_serial_1 PRIMARY KEY (id)
);

-- ^ is the same as ...
CREATE SEQUENCE ch8_serial_2_id_seq AS integer;
--DROP SEQUENCE IF EXISTS ch8_serial_2_id_seq;
DROP TABLE IF EXISTS ch8_serial_2;
CREATE TABLE ch8_serial_2 (
    id integer NOT NULL DEFAULT nextval('ch8_serial_2_id_seq'),
    name text,
    CONSTRAINT pk_ch8_serial_2_id PRIMARY KEY (id)
);
-- When the sequence is owned by the table, it will be dropped when
-- it's owning table is dropped.
ALTER SEQUENCE ch8_serial_2_id_seq OWNED BY ch8_serial_2.id;

-- Returns the auto-generated id
INSERT INTO ch8_serial_2 (name) VALUES ('DAMON') RETURNING id;


--
-- Character types
--
-- character varying (n), varchar(n)   variable-length with limit
-- character(n) char(n)                fixed-length, blank padded
-- text                                variable unlimited length
--
-- When you need to store long strings, use `text` or `character varying` without specifying a length.
--
-- There is *NO* performance difference between the different character types. In most situations, `text`
-- or `character varying` should be used.
--
DROP TABLE IF EXISTS ch8_types;
CREATE TABLE IF NOT EXISTS ch8_types (
    id SERIAL PRIMARY KEY,
    fname character varying (100),
    lname text,
    bytes bytea,
    created_at timestamp without time zone DEFAULT current_timestamp,
    updated_at timestamp with time zone DEFAULT current_timestamp
);


-- WARNING:
--
-- When dealing with `character`, trailing spaces are insignificant when used
-- in comparison functions.
SELECT CAST('test ' AS character(10)) = CAST('test' AS character(10));

-- Variable characters do not have this problem
SELECT CAST('test ' AS character varying) = CAST('test' AS character varying);

--
-- Binary Types
--
-- Character strings do not allow values that are *not* strings.
--
-- Store strings as text, binary data as bytea
--
INSERT INTO ch8_types (id, fname, lname, bytes) VALUES (1, 'damon', 'allison', '\xDEADBEEF');
UPDATE ch8_types SET updated_at = '2020-01-01T10:11:13.234987-07:00'; -- Assumed to be in UTC

-- Converts a timezone value to UTC in ISO-8601 format
SELECT to_char(updated_at AT TIME ZONE 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'), * FROM ch8_types;


--
-- Date/ Time Types
--
--
-- date                                      calendar date (year, month, day)
-- interval [ fields ] [ (p) ]               time interval
-- timestamp (p) [without time zone]         date and time
-- timestamp (p) with time zone              date and time including time zone
-- time (p] [without time zone]              time of day (no date) 00:00:00 - 24:00:00
-- time (p) with time zone                   time of day (no date) with time zone 00:00:00:1559 24:00:00-1559

-- The time types accept a precision value (p) which specifies the number of fractional digits (0 - 6) retained
-- in the seconds field.
--
-- date, time, timestamp with time zone, timestamp without time zone should be the only date fields you need.
--
-- time (p) with time zone is pretty much useless. Time zones are pretty much useless. Use UTC.
--
-- Use ISO-8601 for formatting date / time values: YYYY-MM-DDTHH:MM:SS.sssZ
--
-- Timezone Rules
--
-- * DON'T USE THEM!
--   * Store everything as UTC in DATETIME WTIHOUT TIME ZONE types. Let UIs deal with timezone conversion.
-- * Internally, dates are stored as UTC.
-- * When parsing time zone input, if no time zone is started in the input string, it is assumed to be in the system's time zone.
-- * When returning time zone output, values are returned in the system time zone.
-- * To return a value in a specific time zone, use `AT TIME ZONE 'UTC``
--
-- An example of taking a local time, converting it to UTC, and returning it in ISO-8601
--
--   SELECT to_char (now()::timestamp at timezone 'UTC', 'YYYY-MM-DDTHH24:MI:SSZ'

-- Set the TimeZone to something other than UTC to illustrate how local time zones are handled.
SHOW TimeZone;
SET TimeZone='America/Chicago';

-- Will return the value in -06:00 (or -05:00 if we are on daylight savings time)
-- And return the corresponding timestamp in UTC + formatted in RFC3339 / ISO8601
SELECT CAST('2020-10-10T10:00:00' AS timestamp with time zone),
       CAST('2020-10-10T10:00:00' AS timestamp with time zone) AT TIME ZONE 'UTC',
       to_char(CAST('2020-10-10T10:00:00' AS timestamp with time zone) AT TIME ZONE 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"');


-- Timestamp is simply dropped when converting a string to a timestamp without time zone
SELECT CAST('2020-10-10T10:00:00' AS timestamp without time zone);

-- Converts a timestamp in the local time to UTC
SELECT to_char('2020-01-01T03:04:05'::TIMESTAMP AT TIME ZONE 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS""Z"');

-- To convert a local timestamp into UTC and format it in ISO-8601
SELECT to_char(CAST('2020-01-01 03:04:05' AS TIMESTAMP WITH TIME ZONE) AT TIME ZONE 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS""Z"');


-- Intervals
SELECT updated_at, updated_at - interval '2 hours' from ch8_types;


--
-- 8.14: JSON Types (json & jsonb)
--
-- The json / jsonb data types store well formatted JSON values. Postgres includes functions and operators for working
-- with json values.
--
-- json stores exact copies of JSON (with all whitespace and original key ordering, and duplicate keys are kept).
--
-- jsonb is stored in a decomposed binary format. Slightly slower to INSERT, much faster to query.
-- jsonb also supports indexing (GIN indexes).
--
-- With jsonb, whitespace, ordering, and duplicate keys are *not* preserved (last key wins). When a jsonb value is parsed,
-- it is converted to native postgres data types:
--
-- | JSON Type | PostgreSQL Type | Notes
-- | string    | text            | Any unicode character that is *not* available in the databse encoding is not allowed
-- | number    | numeric         | NaN and infinity are not allowed
-- | boolean   | boolean         | Only lowercase `true` and `false` spellings are allowed
-- | null      | (none)          | SQL NULL is a different concept
--
-- In general, use jsonb. jsonb supports more operators, including jsonpath for querying JSON documents using an XPath like
-- syntax. It's also much more efficient, as the JSON is parsed on insert only, not on the fly for each query.
--
-- Note if you need *exact* storage of JSON - i.e. supporting whitespace, duplicate keys, and key ordering, use JSON.
--
DROP TABLE IF EXISTS ch8_json;
CREATE TABLE IF NOT EXISTS ch8_json (
    id serial,
    val jsonb
);

INSERT INTO ch8_json (val) VALUES (CAST('5' AS jsonb));
INSERT INTO ch8_json (val) VALUES (CAST('"test"' AS jsonb));
INSERT INTO ch8_json (val) VALUES (CAST('{"fname": "damon", "lname": "allison"}' AS JSONB));
INSERT INTO ch8_json (val) VALUES (CAST('{"fname": "damon", "lname": "allison", "scores": [100, 50, 75]}' AS JSONB));
INSERT INTO ch8_json (val) VALUES (CAST('{"fname": "kari", "lname": "allison", "scores": [200, 80, 80]}' AS JSONB));
INSERT INTO ch8_json (val) VALUES (CAST('{"fname": "damon", "lname": "allison", "scores": [100, 50, 75], "children": [{"fname": "cole"}]}' AS JSONB));
INSERT INTO ch8_json (val) VALUES (CAST('{"fname": "kari", "lname": "allison", "scores": [200, 80, 80], "children": [{"fname": "grace"}, {"fname": "lily"}, {"fname": "cole"}]}' AS JSONB));


--
-- JSON Functions and Operators
--
-- '->'    Get JSON field or array index as JSON / JSONB
-- '->>'   Get JSON field or array index as TEXT
-- '#>'    Get JSON object at specified path as JSON / JSONB
-- '#>>'   Get JSON object at specified path as TEXT

--
-- Simple field selection
--
SELECT
    val->'fname',
    pg_typeof(val->'fname'),
    val->>'fname',
    pg_typeof(val->>'fname'),
    val->'scores'->0,
    pg_typeof(val->'scores'->0),
    val->'scores'->0,
    pg_typeof(val->'scores'->0),
    val->'children'->0->>'fname',
    pg_typeof(val->'children'->0->>'fname')
FROM
    ch8_json;


-- Finds all documents that are missing an element
SELECT * FROM ch8_json WHERE val->'children' IS NULL;

-- Gets just the first child (remember, JSONB array ordering is *NOT* guaranteed.
SELECT
    val->'children',
    val->'children'->0,
    val->'children'->0->'fname',
    val->'children'->0->>'fname',
    --
    -- #> and #>> Retrieves objects by path. They are functionally the same as -> and ->>
    -- Perhaps these operators are useful if you are building up queries in code - i.e.,
    -- serializing a path as a list.
    val #>'{"children", 0, "fname"}',
    val #>>'{"children", 0, "fname"}'
FROM
    ch8_json
WHERE val->'children' IS NOT NULL
AND val @> CAST('{"children": [{"fname": "grace"}]}' AS JSONB);

--
-- jsonb operators
--
-- jsonb @> jsonb -> boolean
-- jsonb <@ jsonb -> boolean
-- jsonb ? text -> boolean
--
-- @> and <@ are JSON containment operators
--
-- The containment operator tests that one JSON document is contained within another.
--
-- %> determines if the value on the RHS is contained in the LHS JSON document
--
SELECT * FROM ch8_json WHERE val @> CAST('{"fname": "damon"}' AS JSONB);
--
-- Finds all documents for anyone who has a child named "cole".
--
SELECT * FROM ch8_json WHERE val @> CAST('{"children": [{"fname": "cole"}]}' AS JSONB);
--
-- Here we start the containment check from the children node rather than the document root
--
SELECT * FROM ch8_json WHERE val->'children' @> CAST('[{"fname": "cole"}]' AS JSONB);

--
-- ? : Determines if a key exists at the top level
--

--
-- Returns all rows which have scores
--
SELECT * FROM ch8_json WHERE val ? 'scores';

--
-- Returns all rows which do *not* have scores
--
SELECT * FROM ch8_json WHERE NOT val ? 'scores';

--
-- @? : Returns items matching a jsonpath
--
SELECT val->'children' FROM ch8_json WHERE val @? '$.children[*] ? (@.fname == "cole")';
--
-- @@ : Returns the results of a JSON path predicate check.
--
-- Finds all records who have one ore more scores >= 200
--
SELECT * FROM ch8_json WHERE val @@ '$.scores[*] >= 200';

--
-- JSON Processing Functions
--
-- jsonb_array_elements(jsonb) : Expands the top level JSON array into a set of JSON values.
--
SELECT id, jsonb_array_elements(val->'children')->>'fname' as child FROM ch8_json;
--
-- jsonb_array_length(jsonb)
--
SELECT * FROM ch8_json WHERE jsonb_array_length(val->'children') > 0;
--
-- jsonb_populate_record(base anyelement, from_json) -> anyelement
--
-- Expands the top-level JSON object to a row having the composite type of the `base` element.
-- In typical use, the value of `base` is NULL, which means that any output columns that do not match
-- any object field will be filled with NULLs. If `base` isn't NULL, then the values it contains will
-- be used for unmatched columns.
--
DROP TYPE IF EXISTS name_type;
CREATE TYPE name_type AS (fname TEXT, lname TEXT);
SELECT fname FROM json_populate_recordset(null::name_type, '[{"fname": "damon"}, {"fname": "kari"}]');

--
-- Expands the top-level JSON array into a set of rows using a composite type defined in an alias
--
SELECT * FROM ch8_json, jsonb_to_recordset(val->'children') AS children(fname text);

--
-- SQL:2016 included JSON support into the language.
--
-- With Postgres 12, the SQL standard JSON path query language is supported by Postgres. The JSON path language
-- is to JSON what XPath is to XML.
--
-- The JSON Path Langauge
--
-- '$'   : the "context item" - the item being queried
-- .key  : accesses a particular key
-- []    : accesses an array
--
-- ? (condition) : a filter expression. Within the () expression, @ is the item being evaluated


--
-- jsonb_path_exists(target, jsonpath) : returns any item matching `jsonpath`.
--
-- This is nearly identical to the `@?` operator, but allows for additional options.
--
SELECT val->'children' FROM ch8_json WHERE jsonb_path_exists(val, '$.children[*] ? (@.fname == "cole")');

-- Finds all records who have a child starting with '[Ll]'. Note the use of flag "i" for a case-insensitive regex match
SELECT val->'children' FROM ch8_json WHERE val @? '$.children[*] ? (@.fname like_regex "^L.*$" flag "i")';

--
-- Converts an array into a table of numeric values
SELECT
    a.id,
    scores.v,
    pg_typeof(scores.v)
FROM
    ch8_json AS A CROSS JOIN LATERAL (
        SELECT CAST(v AS numeric) FROM jsonb_array_elements_text(val -> 'scores') AS scores(v)
    ) AS scores
ORDER BY a.id ASC;

--
-- Arrays
--

DROP TABLE IF EXISTS ch8_array;
CREATE TABLE ch8_array (
    id SERIAL,
    ints integer[],
    children JSONB[]
);

--
-- Array constants are defined like '{elt1, elt2, elt3}' rather than `[elt1, elt2, elt3]`.
--
INSERT INTO ch8_array (ints) VALUES ('{1, 2}');
INSERT INTO ch8_array (ints) VALUES ('{1, 2, 3}');
INSERT INTO ch8_array (ints) VALUES ('{{1}, {2}, {3}}');
INSERT INTO ch8_array (ints) VALUES ('{{1, 2}, {2, 3}, {3, 4}}');

--
-- Multidimensional arrays must have matching extents for each dimension.
--
-- INSERT INTO ch8_array (ints) VALUES('{{1}, {1, 2}}');

--
-- Accessing arrays
--
-- Postgres arrays are 1 based (by default)
--
SELECT *, array_length(ints) FROM ch8_array;
SELECT * FROM ch8_array where ints[1] = 1;

-- NULL is returned (not an error) when trying to access an element that does not exist.
SELECT ints[10] FROM ch8_array;

-- Determining an array's dimensions
SELECT array_dims(ints) from ch8_array;

--
-- Slicing
--

-- Select the second and subsequent
SELECT ints[2:] FROM ch8_array;

-- Start with the beginning, stopping after element one (takes the first element)
SELECT ints[:1] FROM ch8_array;

-- Take element 2 -> end
SELECT ints[2:] FROM ch8_array;

-- You can use array_length() to return the upper bound of an array dimension
SELECT array_upper(ints, 1) AS dim1,
       array_upper(ints, 2) as dim2 FROM ch8_array;


-- Appending an element to the end of an array.
SELECT ints || '{4}' FROM ch8_array where ints[1] = 1;
UPDATE ch8_array SET ints = ints || '{4}' WHERE ints[1] = 1;
UPDATE ch8_array SET ints = array_append(ints, 4) WHERE ints[1] = 1;

--
-- Searching in Arrays
--

--
-- ANY finds all rows whose array field contains a value
--
SELECT * FROM ch8_array WHERE 4 = ANY (ints);

-- You can also search using &&, which checks whether the LHS overlaps with the RHS
SELECT * FROM ch8_array WHERE ints && '{4}';


--
-- Examples of JSONB[]
--
INSERT INTO ch8_array (children) VALUES ('{"{\"fname\": \"damon\"}", "{\"fname\": \"kari\"}"}');
INSERT INTO ch8_array (children) VALUES ('{"{\"fname\": \"grace\", \"scores\":[50, 75, 90]}", "{\"fname\": \"lily\", \"scores\": [75, 100, 125]}"}');

SELECT children[:] FROM ch8_array WHERE children[1] @> CAST('{"fname": "damon"}' AS JSONB)


--
-- Composite types
--
-- Composite types represent the structure of a row. It's a list of field names and data types.
--
-- Creating a type is very similar to CREATE TABLE, however no constraints can be included.
--
--
CREATE TYPE full_name AS (
    fname text,
    lname text
);

--
-- All tables have a composite type of the same name automatically created, with the same name as the table,
-- to represent the table's row type.
CREATE TABLE IF NOT EXISTS ch8_composite (
    name full_name,
    iq integer
);

DELETE FROM ch8_composite;
--
-- Constructing a composite type
--
-- Literal syntax - use "" for strings.
--
-- IMPORTANT: Whitespace in type literals is significant. Whitespace is considered part of the field value.
-- If the field type is text, the space *will* be added to the column, which is a problem.
--
-- In general, AVOID THE LITERAL SYNTAX. Use ROW()
--
-- '(field1,field2,"field3",...)
--
INSERT INTO ch8_composite VALUES ('("damon","allison")', 100);
--
-- The ROW() syntax can also be used. This is much simplier than quoting.
--
INSERT INTO ch8_composite VALUES (ROW('cole', 'allison'), 100);
--
-- The ROW() keyword is optional as long as you have more than one field in the expression.
--
INSERT INTO ch8_composite VALUES (('kari', 'allison'), 100);

--
-- To access a field of a composite value, use ".".
--
-- In many cases, the parser gets confused. You must use (). () tells the parser to treat it as a referenced item,
-- not a table name.
--
SELECT (name).*, (name).fname as fname, (name).lname as lname FROM ch8_composite;

SELECT * from ch8_composite ORDER BY (name).fname;


--
-- Modifying composite values
--
INSERT INTO ch8_composite (name, iq) VALUES (ROW('lily', 'allison'), 101);
--
-- Updating an individual field of a composite value
--
-- Notice we cannot put () around (name) right after SET, but we do need () when referencing the
-- same column in the expression to the right.
--
-- Err on the side of using (), omitting them when there are errors.
UPDATE ch8_composite SET name.fname = 'grace' WHERE (name).fname = 'lily';


--
-- Range Types
--
-- Range types allow you to specify a range of values in a single value. Useful for integer types or date types.
--
--
-- int4range   - `integer` range
-- numrange    - `numeric` range
-- tsrange     - 'timestamp without time zone` range

CREATE TABLE timeslots (
    id int,
    slot tsrange
);

--
-- [  == boundary is included in range (inclusive)
-- )  == boundary is *not* included in range (exclusive)
--
-- The lower and upper bounds can be omitted.
--
-- Like composite type literals, WHITESPACE IS MEANINGFUL in range values.
-- Each range type has a constructor to create range values of that type. USE THE CONSTRUCTOR.
INSERT INTO timeslots VALUES (1, '[2020-01-01 10:00:00,2020-01-01 11:00:00)');

-- Range type constructors use [inclusive, exclusive) by default.
-- Use the 3rd parameter specify inclusiveness.
INSERT INTO timeslots VALUES (2, tsrange('2020-01-01 11:00:00', '2020-01-01 12:00:00', '[)'));

SELECT * FROM timeslots;

--
-- Domain types
--
-- Domain types are user defined data types that are based on an underlying type. Domain types can have constraints.
-- For example, limiting the types values to only positive integers

CREATE DOMAIN posint AS INTEGER CHECK (VALUE > 0);
DROP DOMAIN posint CASCADE;
DROP TABLE IF EXISTS ch8_domain;
CREATE TABLE IF NOT EXISTS ch8_domain (
    name text,
    iq posint
);

INSERT INTO ch8_domain VALUES ('damon', 100);
SELECT * FROM ch8_domain;
-- This would violate posint's check constraint
-- INSERT INTO ch8_domain VALUES ('damon', -1);


--
--
--
--
-- Chapter 9: Functions and Operators
--
--
--

DROP SCHEMA IF EXISTS ch9 CASCADE;
CREATE SCHEMA IF NOT EXISTS ch9;
SET search_path to ch9;
SHOW search_path;

CREATE TABLE IF NOT EXISTS ch9_operators (
    name text,
    iq integer,
    children text[],
    created_at timestamp without time zone DEFAULT current_timestamp,
    updated_at timestamp without time zone DEFAULT current_timestamp
);

INSERT INTO ch9_operators (name, iq, children) VALUES ('damon', 100, ARRAY['cole']);
INSERT INTO ch9_operators (name, iq, children) VALUES ('kari', 150, ARRAY['grace', 'lily']);
INSERT INTO ch9_operators (name, iq, children) VALUES (null, null, null);

SELECT * FROM ch9_operators;

--
-- NULL
--
-- SQL uses a three-valued logic system with true, false, and null (unknown).
--
--
-- Logical Operators
--
-- a     | b       | a AND b   | a OR b
-- -----------------------------------
-- TRUE  | TRUE    | TRUE      | TRUE
-- TRUE  | FALSE   | FALSE     | TRUE
-- TRUE  | NULL    | NULL      | TRUE
-- FALSE | FALSE   | FALSE     | FALSE
-- FALSE | NULL    | FALSE     | NULL
-- NULL  | NULL    | NULL      | NULL

-- Comparison functions and operators
--
-- Not equals is '<>' in SQL. '!=' is an alias.
--
SELECT * FROM ch9_operators WHERE iq <> 0;
-- BETWEEN (inclusive)
SELECT * FROM ch9_operators WHERE iq BETWEEN 0 AND 100;
-- BETWEEN SEMETRIC will order the operands low to high to prevent empty ranges
SELECT * FROM ch9_operators WHERE iq BETWEEN SYMMETRIC 100 AND 0;

-- IS NULL
SELECT * FROM ch9_operators WHERE iq IS NULL;
-- IS UNKNOWN tests whether the expression yields unknown (NULL)
SELECT * FROM ch9_operators WHERE iq <> 0 IS UNKNOWN;

--
-- Mathematical Functions and Operators
--
-- Each operator returns the same data type as it's arguments
--

-- For integral types, division is rounded towards zero
SELECT 4 / 3 = 1 AS division, 2 ^ 3 = 8 as exponentation;
SELECT -4 / 3 = 1;

-- Mathematical functions
SELECT ABS(-4) = 4;
-- ROUND() rounds to nearest integer
SELECT ROUND(-4.5) = -5, ROUND(-5.5) = -6;
-- ROUND() to nearest decimal place
SELECT ROUND(-4.505, 2) = -4.51;
-- CEIL and FLOOR return nearest integer greater or less than the argument
SELECT CEIL(42.3) = 43, FLOOR(42.3) = 42;


--
-- String Functions
--
SELECT char_length(name), length(name) FROM ch9_operators;
-- position finds the first position of a substring, or 0 if it does not exist
SELECT position('d' IN name) FROM ch9_operators;
-- regular expression match
SELECT * from ch9_operators WHERE name ~* '^[dk]a.*$';

-- substring selects a substring (1 based)
SELECT substring(name FROM 1 FOR 1) FROM ch9_operators;
-- trims a string (defaults to trimming spaces).
SELECT trim(both name) FROM ch9_operators;
-- length
SELECT length(name) from ch9_operators;
-- starts_with
SELECT * from ch9_operators WHERE starts_with(name, 'd');

-- String formatting
SELECT format('Hello, %s', name) FROM ch9_operators WHERE name IS NOT NULL;

--
-- Pattern Matching
--
-- _ matches a single character, % matches zero or more characters
--
-- NOTE: ILIKE (case insensitive search) is a PostgreSQL extension.
--
SELECT * FROM ch9_operators WHERE name ILIKE '_a%';

-- Posix regular expressions
--
-- text ~ regex -> boolean : Matches regex, case sensitive
-- text ~* regex -> boolean : Matches regex, case insensitive
-- text !* regex -> boolean : Does not match regex, case sensitive
-- text ~!* regex -> boolean : Does not match regex, case insensitive
SELECT * FROM ch9_operators where name ~* '^[dk]a.*$';

--
-- Data Type Formatting
--
SELECT to_timestamp('2020-12-05 10:00:00', 'YYYY-MM-DD HH24:MI:SS.sss');

-- The to_char() function converts numerics and timestamps to strings.
-- The syntax is rather primitive for numeric values, as you're required to enter the exact format
-- you want the numeric to be printed as (using 9 for digit, for example)
SELECT to_char(100, '999');

--
-- Date/Time Functions and Operators
--

SELECT CAST('2020-02-02 10:00:00' AS timestamp) + interval '1 day';

-- date_trunc
SELECT date_trunc('hour', current_timestamp);


-- Generate a random UUID
SELECT gen_random_uuid();


--
-- Conditional Expressions
--
-- "If your needs go beyond the capabilities of these conditional expressions, you might want
--  to consider writing a server-side function in a more expressive programming language"
--
-- PostgresSQL documentation:
-- https://www.postgresql.org/docs/13/functions-conditional.html
--

--
-- CASE
--
-- CASE can be used for avoiding a division by zero error
-- SELECT ... WHERE CASE WHEN x <> 0 THEN y/x > 1.5 ELSE 0 END;
SELECT
    CASE
        WHEN name ILIKE '%damon%' THEN 'DAMON ALLISON'
        WHEN name ILIKE '%kari%' THEN 'KARI ALLISON'
        ELSE 'OTHER'
    END
FROM ch9_operators;

-- COALESCE returns the first non-null argument. Useful for giving NULL a value
SELECT COALESCE(name, 'someone') FROM ch9_operators;

--
-- Aggregate Functions
--
SELECT avg(iq), sum(iq), max(iq), min(iq) FROM ch9_operators;

--
-- Subquery Expressions
--

--
-- [NOT] EXISTS
--
-- The EXISTS subquery is evaluated for each row, returning TRUE if 1 or more rows are returned.
--
-- EXISTS can reference variables from the surrounding query, as shown here with `OP`.
--
-- EXISTS will only execute long enough to determine if one row exists.
--
-- Return values are typically not important in EXISTS subqueries, so a common pattern
-- is to use (SELECT 1 FROM ...)
SELECT * FROM ch9_operators as OP WHERE EXISTS (SELECT 1 FROM ch9_operators WHERE char_length(OP.name) >=4);

--
-- IN
--
-- IN compares the current row to each row returned by the subquery. IN returns true if *any* matching
-- subquery row is found.
--
-- Two rows are considered equal if all of their corresponding rows are non-null and unequal. Otherwise
-- the result of that row comparison is unknown (null). If *all* the per-row results are unequal or NULL,
-- with at least one null, the result of IN is null
--
-- The subquery must return exactly one column.
--
SELECT * FROM ch9_operators AS OP WHERE name IN (SELECT name from ch9_operators where char_length(OP.name) >= 4);

-- This form of `IN` will match multiple columns. The IN subquery must return as many columns as contained in ROW()
--
-- This is useful when matching multiple values in the current row to a subquery.
SELECT * FROM ch9_operators AS OP WHERE ROW(name, iq) IN (SELECT 'damon', 100);

--
-- ANY (SOME)
--
-- ANY allows you to provide a boolean expression to compare the current row to a subquery.
--
-- ANY and SOME are synonyms. (Use ANY)

-- This is the same query as:
-- SELECT * FROM ch9_operators AS OP WHERE name IS NOT NULL AND iq IS NOT NULL;
--
SELECT * FROM ch9_operators AS OP WHERE iq >= ANY (SELECT iq FROM ch9_operators WHERE name = OP.name);

--
-- ARRAY operators
--
--
-- @>     Does the first array contain the second?
-- <@     Does the second array contain the first?
-- &&     Do the arrays overlap (have any elements in common?
-- ||     Concatenate the arrays or elements onto an array
--

SELECT * FROM ch9_operators WHERE children @> ARRAY['cole'];
SELECT * FROM ch9_operators WHERE ARRAY['grace'] <@ children;
SELECT * FROM ch9_operators WHERE children && ARRAY['lily'];
SELECT children || ARRAY['another'] from ch9_operators;

--
-- unnest expands an array into a set of rows
--
-- NOTE: It's much cleaner (and probably more efficient)
-- to use the array containment operators (children @> ARRAY['cole'])
SELECT
       name, child FROM (SELECT name, unnest(children) as child from ch9_operators) AS children
WHERE
      children.child = 'cole';

--
-- Row and Array comparisons
--
-- Row and array comparisons compare groups of values.
--
SELECT * FROM ch9_operators WHERE name in ('damon', 'kari');

--
-- Comparing rows
--

-- Omits nulls (since = omits nulls)
SELECT * FROM ch9_operators WHERE ROW(name, children) = ROW(name, children);

-- To include rows which have equal NULL values
SELECT * FROM ch9_operators WHERE ROW(name, children) IS NOT DISTINCT FROM ROW(name, children);


--
-- Sets
--
-- generate_series() allows you to create a series of rows
SELECT * FROM generate_series(0, 9) as ser;

SELECT name, generate_subscripts(children, 1) from ch9_operators;

SELECT
    children, pos, children[pos] as value
FROM
    (SELECT generate_subscripts(children, 1) AS pos, children FROM ch9_operators) as foo;

--
-- When a function in the FROM clause is suffixed by WITH ORDINALITY, a bigint column is appended
-- to the function's output columns.
--
SELECT * FROM ch9_operators AS ops CROSS JOIN unnest(ops.children) WITH ORDINALITY;


--
-- System Information (Environment) Functions and Operators
--
SELECT
    version(),
    session_user,             -- in unix, this is the "real user"
    current_user,             -- in unix, this is the "effective user"
    current_database(),       -- alias current_query
    current_query(),
    current_schema(),
    current_schemas(true);

-- Access Privilege Inquiry Information

SELECT
    has_database_privilege('damon', 'connect'),           -- CREATE, CONNECT, TEMPORARY
    has_table_privilege('ch9_operators', 'select'),       -- SELECT, INSERT, UPDATE, DELETE, REFERENCES
    pg_has_role('postgres', 'member');

--
--
--
-- Chapter 10: Type Conversion
--
--
--
DROP SCHEMA IF EXISTS ch10 CASCADE;
CREATE SCHEMA IF NOT EXISTS ch10;
SET search_path to ch10;
SHOW search_path;

DROP TABLE IF EXISTS ch10_types;
CREATE TABLE IF NOT EXISTS ch10_types (
    id SERIAL PRIMARY KEY,
    name TEXT,
    iq numeric (5,2), -- (precision, scale) - precision is the maximum length of the entire number (whole and fractional). scale is after the decimal
    f float
);

INSERT INTO ch10_types (name, iq, f) VALUES ('damon', 100.0, 5.5);

-- Postgres will implicitly cast values. Use CAST(value AS type) to explicitly cast values.
-- Here, text is implicitly converted to numeric(5,2) and float
INSERT INTO ch10_types (name, iq, f) VALUES ('damon', '200.0', '05.50');

SELECT * FROM ch10_types;

SELECT
    5 / 4,
    pg_typeof(5 / 4),
    1.0 / 3.0,
    pg_typeof(1.0 / 3.0);

--
--
--
-- Chapter 11: Indexes
--
--
-- Indexes improve query performance by avoiding table scans. They incur write and storage costs to maintain the index, but
-- provide much faster query access. Analytic databases (high read, low write) will benefit from judicious use of
-- indices.

DROP SCHEMA IF EXISTS ch11 CASCADE;
CREATE SCHEMA IF NOT EXISTS ch11;
SET search_path to ch11;
SHOW search_path;

DROP TABLE IF EXISTS ch11_indexes;
CREATE TABLE IF NOT EXISTS ch11_indexes (
    id SERIAL,
    content text,
    j JSONB,
);

--
-- Creating an index on a large table is expensive. By default, PostgreSQL allows SELECT
-- statements to happen while indexing is in progress. Writes are blocked until the index
-- is created.
--
CREATE INDEX IF NOT EXISTS idx_ch11_indexes_id ON ch11_indexes (id);

-- Multicolumn indexes should be used sparingly. In most situations, an index on a single column is sufficient
-- and saves space and time. Indexes with more than three columns are unlikely to be helpful unless the table
-- is extremely stylized.
--
-- Consider creating indexes on both `id` and `content` individually and let the query
-- planner use both indexes. This would allow you to write indexed queries that just use `id` or
-- `content` individually.
CREATE INDEX IF NOT EXISTS idx_ch11_indexes_id_content ON ch11_indexes (id, content);

DROP INDEX IF EXISTS idx_ch11_indexes_id;

INSERT INTO ch11_indexes (content, j) VALUES ('test', '{"fname": "damon", "children": ["grace", "lily", "cole"]}');

SELECT * FROM ch11_indexes;

EXPLAIN SELECT * FROM ch11_indexes WHERE id < 10 OR content = 'test';

--
-- Unique Indexes
--
-- A UNIQUE INDEX enforces uniqueness on a column's value or the uniqueness of the combined values
-- of multiple columns. UNIQUE indexes are *not* used when querying data.
--
-- UNIQUE indices are automatically created when a UNIQUE constraint or primary key is defined on a table.
--
CREATE UNIQUE INDEX IF NOT EXISTS idx_unq_ch11_indices_id ON ch11_indexes (id);
DROP INDEX IF EXISTS idx_unq_ch11_indices_id;

--
-- Determining what indexes are on a table using the pg_indexes view
--
SELECT * FROM pg_indexes WHERE tablename ilike 'ch11%';

--
-- Indexes on Expressions
--
-- Expression indexes allow you to index columns based on the results of an expression.
--
-- For example, if you frequently query a value using lower(), it would speed up performance to index
-- the lower() common value.
-- SELECT * FROM ch11_indexes WHERE lower(content) = 'test';
CREATE INDEX IF NOT EXISTS idx_ch11_indexes_content_lower ON ch11_indexes (lower(content));
EXPLAIN SELECT * FROM ch11_indexes WHERE lower(content) = 'test';

--
-- Partial Indexes
--
-- Built on part of the table - the values which match the index's predicate.
--
--
-- Why use partial indexes?
--
-- Partial indexes avoid indexing common values. If a high percentage (~2+%) of values are the same, the index
-- will be skipped anyway. A partial index allows you to index only less common values, giving the index a better
-- chance it will be used.

CREATE INDEX IF NOT EXISTS idx_partial_content_long ON ch11_indexes (content) WHERE length(content) > 5;

--
-- Index only scans
--
-- If you are *only* returning columns that are defined on the index, the main table does not need to be consulted.
--
-- An index that covers all fields in a query is called a "covering index". For example, this index "covers"
-- the following query. The table itself (heap) does not need to be contacted.
--
-- This indexes (id), but adds additional fields to cover queries that need (id, content) only.
CREATE INDEX IF NOT EXISTS idx_ch11_indexes_id_with_content ON ch11_indexes (id) INCLUDE (content);

EXPLAIN ANALYZE SELECT id, content FROM ch11_indexes where content = 'test';


--
-- Chapter 12: Full Text Search
--
--
-- Postgres contains very primitive full text search functionality. Consider lucene (elastic) or a system
-- built for search if you need to go beyond simple lexeme searches.
--
-- Textual search operators like regular expressions (~, ~*), LIKE, and ILIKE have limitations
--
-- * They do not provide linguistic support (i.e., handling derived words like satisfies and satisfy)
-- * They provide no results ordering.
--
--
-- Full Text indexing allows:
--
-- * Documents are pased into tokens (words, email addresses, etc).
-- * Tokens are normalized to lexemes. (i.e., satisfies and satified are tokenized into 'satisfy').
-- * Stop words are eliminated (i.e., a, the, and). Stop words are those which are so common they are irrelevant to search.
-- * Indexes contain 'proximity ranking', to determine how close search terms are in the document.

-- FTS uses dictionaries to:
--
-- * Define stop words.
-- * Map synonyms together (using ispell).
-- * Map phrases to a single word using a thesaurus.
-- * Map variations of a word to a single word.
-- * Map different variations of a word to a canonical form.
--

--
-- Basic Text Matching
--
DROP SCHEMA IF EXISTS ch1 CASCADE;
CREATE SCHEMA IF NOT EXISTS ch11;
SET search_path to ch11;
SHOW search_path;

CREATE TABLE IF NOT EXISTS ch12_FTS (
    id serial,
    doc text
);

-- Documents are stored in text fields.
INSERT INTO ch12_FTS (doc) VALUES (
    'this is a test document. Think of a really long article with a bunch of words. '
    'I would write about technology. Apple, Google, MIT, Microsoft, and others.'
);
INSERT INTO ch12_FTS (doc) VALUES (
    'Cooking is a very popular pasttime. In involves ingredience, patience, and creativity. '
);

-- `tsvector` and `tsquery`
--
-- tsvector:
-- * Documents must be converted into the `tsvector` data type to allow searching and ranking.
--
-- tsquery:
-- * Documents are queried with the `tsquery` type.
-- * A tsquery contains search terms (normalized lexemes) and operators (AND, OR, NOT, FOLLOWED BY)
-- * Functions exist to_tsquery, plainto_tsquery, phraseto_tsquery that convert text -> tsquery by
--   normalizing words appearing in the text.
--

-- Matches `write` from the first document
SELECT * FROM ch12_FTS WHERE to_tsvector(doc) @@ plainto_tsquery('writing');
SELECT * FROM ch12_FTS WHERE to_tsvector(doc) @@ plainto_tsquery('writing');

-- Matches `cooking` from the second document.
--
-- FTS is based on the match operator `@@`.
--
-- to_tsquery() assumes a valid tsquery expression.
-- * Words are already normalized lexemes.
-- * Terms are combined with operators (&, |, !)
SELECT * FROM ch12_FTS WHERE to_tsvector(doc) @@ to_tsquery('cook');
-- AND
SELECT * FROM ch12_FTS WHERE to_tsvector(doc) @@ to_tsquery('cooking & creativity');
-- AND NOT
SELECT * FROM ch12_FTS WHERE to_tsvector(doc) @@ to_tsquery('cooking & ! creativity');

-- Search for phrases using the `FOLLOWED BY` operator `<->`.
-- Works *only* if matches are adjacent
SELECT * FROM ch12_FTS WHERE to_tsvector(doc) @@ to_tsquery('cooking <-> very');
SELECT * FROM ch12_FTS WHERE to_tsvector(doc) @@ to_tsquery('cooking <-> popular');

SELECT to_tsvector(doc) from ch12_FTS;

--- Ranking
select ts_rank_cd(to_tsvector(doc), to_tsquery('Cooking')) as rank, doc FROM ch12_FTS ORDER BY rank desc;

--
-- Testing and Debugging
--
-- ts_debug displays information about every parsed token.
--
SELECT * FROM ts_debug('123 - a number. Damon was here.');
--
-- ts_parse parses a document, returning the tokens used.
-- tokid is the token type. `ts_debug`
SELECT * FROM ts_parse('default', '123 - a number. Damon was here.');

-- tx_lexize returns an array of lexemes known to the dictionary, an empty array if it is a stop word,
-- or NULL if it is not known.
SELECT ts_lexize('english_stem', 'cook');
SELECT ts_lexize('english_stem', 'friends');


-- Postgres allows you to create custom dictionaries. Dictionaries can be created which define:
--
-- * Stop words
-- * Synonyms
-- * Thesaurus (abbreviated as TZ): relationships between words ("cooking" -> "grilling", "frying", "making").
--   * Thesaurus contains broader terms (BT), narrower terms (NT), perferred terms, non-preferred terms, related terms.
--
-- Dictionaries are used in configurations. The default text search config used is set in the `default_text_search_config`
-- env var.
SHOW default_text_search_config;
--
-- use psql to find information about text search configuration objects.
--
-- \dF+ : list text search configurations
-- \dF+ english : describe the english configuration
-- \dFd+ : list dictionaries
-- \dFp+ : list parsers
-- \dFf+ : list templates

-- Indexing text search fields.
--
-- GIN (Generalized Inverted Indexes) are the preferred text search index type. As inverted indexes, they contain an
-- index entry for each word (lexeme), with a compressed list of matching locations.
--

--
-- Chapter 13: Concurrency Control
--
--
-- The goal of concurrency control is to allow efficient access for all sessions while maintaining data integrity.
--
-- Postgres uses Multiversion Currency Control (MVCC). MVCC minimizes lock contention in multi-user environments.
-- Using MVCC, read locks do not conflict with write locks.
--
-- Each SQL statement sees a snapshot of the data (a database version) as it was some time ago, regardless of the
-- current state of the underlying data.
--
-- Types of phenomena which occur during concurrent transactions:
--
-- "dirty read"
--    * A transaction reads data by a concurrent *uncommitted* transaction.
-- "nonrepeatable read"
--   * A transaction re-reads data it previously read and finds the data was modified by another
--     transaction. i.e., another transaction was committed between reads.
-- "phantom read"
--   * A transaction re-executes a query and obtains different results due to another recently committed transaction
-- "serialization anomaly"
--   * The result of committing a group of transactions is inconsistent with all possible orderings of running
--     those transactions one at a time.

-- Transaction Isolation Levels
-- ----------------------------
--
-- Read Uncommitted - prevents dirty reads
-- Read Committed - prevents dirty reads (same as read uncommitted in PG) (the default)
-- Repeatable read - prevents dirty reads, non-repeatable reads, and phantom reads
-- Serializable - prevents all

-- IMPORTANT:
-- Changes made to a sequence are immediately visible to all other transactions and are *not* rolled back on aborted
-- transactions.
--
--
-- In "Read Committed" (the default TX mode), UPDATE / DELETE commands will wait for any updater to commit their TX.
-- The `WHERE` clause is then re-evaluted and the UPDATE / DELETE is applied.
--
--
