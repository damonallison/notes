# PostgreSQL

## Todo

* Data type conversion
* Primary key usage (`bigserial`)

## Docker

```shell

docker run --name pg -e POSTGRES_PASSWORD=postgres -d -p 5432:5432 postgres:13

docker exec -it pg bin/bash

```

## Creating a DB cluster

Postgres instances are called "database clusters" in the Postgres documentation.
A database cluster is a collection of databases managed by a Postgres instance.

When creating a cluster, a `postgres` database is created by default. This DB is
not required, however many tools assume it exists. You can delete it - there is
nothing special about it.

```shell
# Creating a DB instance (cluster)
$ pg_ctl initdb -D /var/lib/postgresql/damon

# Starting the Postgres instance
# If -D is not specified, $PGDATA is used
$ pg_ctl start -D /var/lib/postgresql/damon -l logfile
$ pg_ctl stop -D /var/lib/postgresql/damon

```

## Configuration

* `postgresql.conf` - main pg config file
* `pg_hba.conf` - host based authentication configuration file
* `pg_ident.conf` - config file for user name mapping

### Client Connection

Postgres does privilege management with "roles". Users are associated to roles.


* `search_path`

  The order in which schemas are searched for objects without a schema
  specified. `$user` is a special value that will add a schema which matches
  `current_user`

* `default_transaction_isolation`
* `statement_timeout` - in milliseconds by default
* `deadlock_timeout` - default to 1s. Probably want to raise it in production

### Environment Variables

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