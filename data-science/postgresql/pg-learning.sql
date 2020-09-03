--*************************************************
-- pg-learning.sql
-- ************************************************

create database damon;

DROP VIEW IF EXISTS fam;
DROP TABLE IF EXISTS people CASCADE;
DROP TABLE IF EXISTS children CASCADE;
DROP TABLE IF EXISTS scores CASCADE;

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

-- Views are named queries that can be used as a table
--
-- Making liberal use of views is a key aspect of good SQL design.
-- Views allow you to encapsulate the details of the table structure,
-- which might change as the application evolves.
--
CREATE VIEW fam AS (
    SELECT
    p.id AS pid, p.fname AS pfname, p.lname AS plname,
    c.id AS cid, c.fname AS cfname, c.lname AS clname
    FROM
    people AS p INNER JOIN children AS c on p.id = c.parent_id
);





-- Using expressions in select statements
SELECT CONCAT(fname, ' ', lname) AS fullname FROM t;

--
-- JOIN
--
-- LEFT OUTER JOIN - returns all rows from the LHS. If no matching rows exist on the RHS, returns NULL for RHS fields
-- RIGHT OUTER JOIN - returns all rows from the RHS. If no matching rows exist on the LHS, returns NULL for LHS fields
-- FULL OUTER JOIN - returns all rows from both tables. If no matching row exists on the opposite side, returns NULL for the opposite side fields
--
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
-- IMPORTANT - when the subquery is used as an expression, it must return a single value.
--
SELECT * FROM people WHERE id = (SELECT id from people WHERE fname = 'damon');

--
-- Aggregates
--
SELECT
       SUM(s.score),
       p.fname
FROM scores AS s INNER JOIN people AS p on p.id = s.parent_id
GROUP BY p.fname
HAVING SUM(s.score) > 80;

--
-- TRANSACTIONS
--
-- PostgreSQL has the concept of `savepoints`, which allow you to rollback part of a transaction
--
BEGIN;
  UPDATE people set fname = 'test' WHERE fname = 'damon';
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
-- OVER *always* follows the window function. The window function here is "sum".
--
-- For each row in the result, the window function is computed across the rows that fall into the same
-- partition as the current row.
SELECT sum(score) OVER (PARTITION BY parent_id), parent_id FROM scores;

-- Compare that to an aggregate which computes the sum. Only a single row is returned per parent_id
SELECT parent_id, sum(score) FROM scores GROUP BY parent_id;

