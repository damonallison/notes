# postgresql

* Data types / type aliases / domains
* Triggers / rewrite rules
* Views
* Functions
* Identity best practices (SERIAL vs. UUID)


* `IF / THEN / ELSE`

* `IMMUTABLE` functions
  * Functions and operators marked as `IMMUTABLE` can be evaluated when the query
    is planned rather than when it is executed.
  * Why would you *not* make functions `IMMUTABLE`

## Docker

```shell

docker run --name pg -e POSTGRES_HOST_AUTH_METHOD=trust -d -p 5432:5432 postgres:13

```
## Configuration

* `PGHOST` - tells `psql` where to connect
* `PGPORT` - tells `psql` what port to connect on

## Tools

```shell

#
# All of these commands assume you are running as the `postgres` (non-root) user
#
# Either `su` to the user interactively or use a single `su` command
#
# Example
$ su postgres -c 'pg_ctl start -D /var/lib/postgresql/damon -l serverlog'

# Creating a DB instance (cluster)
$ pg_ctl initdb -D /var/lib/postgresql/damon

# Starting a DB server in a docker container.
# Note the -D [DATADIR] value is considered the instance "name".
$ pg_ctl start -D /var/lib/postgresql/damon -l serverlog'

# createdb - a command line tool for creating databases
$ createdb -h localhost -p 5432 -U postgres -w damon2

# dropdb - a command line tool for dropping a database
$ dropdb -h localhost -p 5432 -U postgres -w damon2

# Connect to the new DB
$ psql
```