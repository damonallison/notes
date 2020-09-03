# postgresql

* Data types / type aliases
* Working with dates
* Aggregate functions

## Docker

```shell

docker run --name pg -e POSTGRES_HOST_AUTH_METHOD=trust -d -p 5432:5432 postgres:13

```
## Configuration

* `PGHOST` - tells `psql` where to connect
* `PGPORT` - tells `psql` what port to connect on

## Tools

```shell

# createdb - a command line tool for creating databases
$ createdb -h localhost -p 5432 -U postgres -w damon2

# dropdb - a command line tool for dropping a database
$ dropdb -h localhost -p 5432 -U postgres -w damon2 
```