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
-- numeric(p, s) (decimal(p, s))             exact numeric of selectible precision
-- real (float4)                             32 bit floating point
-- smallint                                  16 bit integer
-- text                                      variable length character string
-- timestamp (p) [without time zone]         date and time
-- timestamp (p) with time zone              date and time including time zone
-- time (p] [without time zone]              time of day (no date) 00:00:00 - 24:00:00
-- time (p) with time zone                   time of day (no date) with time zone 00:00:00:1559 24:00:00-1559
-- uuid                                      universally unique identifier

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
-- JSON
--
-- The json / jsonb data types store well formatted JSON values. Postgres includes functions and operators for working
-- with json values. USE JSONB.
--
-- json stores exact copies of JSON (with all whitespace and original key ordering, and duplicate keys are kept)
--
-- jsonb is stored in a decomposed binary format. Slightly slower to INSERT, much faster to query. jsonb also supports indexing.
--
-- With jsonb, whitespace, ordering, and duplicate keys are *not* preserved (last key wins).

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


-- Queries

-- JSON Containment Operator (%>)
--
-- The containment operator tests that one JSON document is contained within another.
--
-- %> determines if the value on the RHS is contained in the LHS JSON document
SELECT * FROM ch8_json WHERE val @> CAST('{"fname": "damon"}' AS JSONB);

-- Finds all documents for anyone who has a child named "cole".
SELECT * FROM ch8_json WHERE val @> CAST('{"children": [{"fname": "cole"}]}' AS JSONB);

-- Here we start the containment check from the children node rather than the document root
SELECT * FROM ch8_json WHERE val->'children' @> CAST('[{"fname": "cole"}]' AS JSONB);

--
-- JSON Functions and Operators
--
-- '->'    Get JSON field or array index as JSON / JSONB
-- '->>'   Get JSON field or array index as TEXT
-- '#>'    Get JSON object at specified path as JSON / JSONB
-- '#>>'   Get JSON object at specified path as TEXT

-- Finds all documents that are missing an element
SELECT * FROM ch8_json WHERE val->'children' IS NULL;

-- Gets just the first child (remember, JSONB array ordering is *NOT* guaranteed.
SELECT val->'children' FROM ch8_json WHERE val->'children' IS NOT NULL;

-- Get JSON object at the {"children"} path. This could be useful to the query above for longer paths (potentially)
-- '{"org", "address", "location"}'
SELECT val#>'{"children"}' FROM ch8_json WHERE val->'children' IS NOT NULL;


CREATE TYPE name_type AS (fname text);
SELECT * FROM json_populate_recordset(null::name_type, '[{"fname": "damon"}, {"fname": "kari"}]');

-- Exercise: Parse a JSON array field into a table.
SELECT id, fname FROM ch8_json NATURAL JOIN jsonb_to_recordset(ch8_json.val->'children') AS (fname text);

-- SQL:2016 included JSON support into the language.
--
-- With Postgres 12, the SQL standard JSON path query functionality is supported by Postgres. Note that Postgres has been
-- supporting JSON for a long time. The new SQL path operators are *not*

-- jsonpath implements support for the SQL/JSON path language in PostgreSQL to efficiently query JSON data. It provides
-- a binary representation of the parsed SQL/JSON path expression.

SELECT val->'children' FROM ch8_json WHERE jsonb_path_exists(val, '$.children[*] ? (@.fname == "cole")');
