--
--
drop database if exists tx_test;
create database tx_test;

drop table if exists people;
create table people (
    id int primary key,
    count int
);
insert into people (id, count) values (1, 1);
insert into people (id, count) values (2, 1);


begin transaction isolation level repeatable read

SELECT * FROM people;

-- If TX2 adds a new row to the DB, that row will *not* be updated.
update people set count = 2;

commit transaction;
abort transaction;



begin transaction isolation level serializable

SELECT * FROM people;

-- If TX2 adds a row to the DB, the TX will fail
update people set count = 2;

commit transaction;
abort transaction;

