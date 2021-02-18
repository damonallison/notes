BEGIN TRANSACTION isolation level serializable

SELECT * FROM people;

update people set count = 3;

insert into people (id, count) values (30, 1);

commit transaction;
abort;
