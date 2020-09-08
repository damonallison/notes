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

DROP VIEW IF EXISTS fam;
DROP TABLE IF EXISTS people CASCADE;
DROP TABLE IF EXISTS children CASCADE;
DROP TABLE IF EXISTS scores CASCADE;

--
-- postgres calls tables "relations" internally.
--
CREATE TABLE IF NOT EXISTS people (
    id integer primary key,
    fname varchar,
    lname varchar
);
CREATE TABLE IF NOT EXISTS children (
    id integer primary key,
    parent_id integer references people(id),
    fname varchar,
    lname varchar
);

CREATE TABLE IF NOT EXISTS scores (
    id integer primary key,
    parent_id integer references people(id),
    score integer
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
    SELECT
    p.id AS pid, p.fname AS pfname, p.lname AS plname,
    c.id AS cid, c.fname AS cfname, c.lname AS clname
    FROM
    people AS p INNER JOIN children AS c on p.id = c.parent_id
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
SELECT
       p.fname, p.lname, c.fname, c.lname
FROM
     people as p INNER JOIN children as c ON (c.parent_id = p.id);


-- Finds all people w/o children
SELECT
       *
FROM
     people as p LEFT OUTER JOIN children as c ON (c.parent_id = p.id)
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
SELECT
    p.id,
    (SELECT SUM(score) FROM scores where parent_id = p.id)
FROM people as P;

--
-- Aggregates
--
SELECT
       SUM(s.score),
       p.fname
FROM scores AS s INNER JOIN people AS p on p.id = s.parent_id
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
SELECT sum(score), parent_id FROM scores INNER JOIN people ON people.id = scores.parent_id GROUP BY parent_id;



-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Part II : The SQL Language
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

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
SELECT
    COUNT(*) as count,
    SUM(ALL score) AS total,
    SUM(ALL score * .9) AS discount,
    SUM(ALL score ORDER BY id desc) FILTER (WHERE score > 50) as ordered_sum,
    SUM(DISTINCT score) AS uniq
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
FROM people P LEFT JOIN scores S on P.id = S.parent_id;

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
SELECT ARRAY[1, 2] AS uncasted, CAST(ARRAY[1, 2] AS integer[]) AS casted;
SELECT ARRAY[[1, 2], [3, 4]];

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
LANGUAGE SQL IMMUTABLE STRICT;

-- Am example showing a function call using named (first) and positional (second) parameters
select concat_lower_or_upper(b => 'allison', a => 'damon', upper => false) AS lower,
       concat_lower_or_upper('damon', 'allison') AS upper;



select concat_lower_or_upper('damon', upper => false, b => 'allison') AS lower,
       concat_lower_or_upper('damon', 'allison') AS upper;
