# Web API

`ASP.NET 5.2.3`

When the host authenticates a user, it creates an **IPrincipal** and assigns it
to `Thread.CurrentPrincipal`. 

If you need to support self hosting (OWIN), use an HttpModule. Otherwise, use an
HTTP Module. 

Set the principal on both the thread and HTTP context.

```
private void SetPrincipal(IPrincipal principal)
{
    Thread.CurrentPrincipal = principal;
    if (HttpContext.Current != null)
    {
        HttpContext.Current.User = principal;
    }
}
```

# T-SQL

## Transactions

* What is a Multiple Active Result Set (MARS) session? Connections must be
  enabled to support MARS.

* What is the default behavior of T-SQL statements on a newly created ADO.NET
  connection? Are they wrapped in a Tx? Is the connection set to Autocommit?

* What is the default isolation level of an ADO.NET Tx?

* Tx(s) are associated with the connection.

* By default, Tx are autocommit. Each T-SQL statement will commit when it
  completes.

* Implicit Tx will start a new Tx after the previous Tx completes. This keeps a
  stream of Txs on the connection

* Distributed Tx(s) can span DB's. Don't do this, if you can avoid it. It would
  be interesting to determine if we could coordinate a Tx between two DBs on the
  same Database Engine. (Internet and NavisphereCarriers).

### Isolation levels

* Isolation level determines how restrictive the locks are.

  * READ COMMITTED
    * Reads hold row locks during the read, release the row locks after the row has been read.
  * READ UNCOMMITTED
    * Do not issue shared locks. Another TX can write data during the read. The problem with this approach is you may receive invalid data. Another TX could update the table as you are reading, causing your read to have incorrect results.
  * REPEATABLE READ
  * SNAPSHOT
  * SERIALIZABLE


## ADO.NET

* What are the connection string options? Can you build a connection string
  programmatically? Should you?  `ConnectRetryInterval` and `ConnectRetryCount`
  are properties of the TXs.

* SQLClient supports streaming support.

* How to build a DataSet programmatically? What is the advantage of doing this
  vs. storing strongly typed objects?




## SQL Server Transactions

#### Concurrency Effects

* Lost updates : 2 or more TXs modify the same row. Last update wins.
* Uncommitted Dependency (dirty read) : A TX reads data which another TX has not committed.
* Inconsistent analysis (non-repeatable read) : A TX reads the same row twice, receiving different data each time (which another TX committed between reads).
*
* Row versioning maintains versions of each row that is modified (in temp tables). Therefore, the original rows are left in tact, allowing read operations to continue to succeed.
* Applications can specify that a TX use row versions that existed at the start of the query instead of protecting all reads with locks. This greatly reduces the the chance the read operation will block other transactions.



* How to read / set database options?

  `SELECT DATABASEPROPERTYEX('AdventureWorks2012', 'IsAutoShrink')`
  `ALTER DATABASE [DB_NAME] SET READ_COMMITTED_SNAPSHOT = ON`


SQL Server operates in one of the following transaction modes:

* Autocommit Tx. Each statement is a Tx.

* Explicit Tx. Each transaction is explicitly started with `BEGIN TRAN` and
  explicitly ended with `COMMIT` or `ROLLBACK`.

* Implicit Tx. A new Tx is automatically started when the prior Tx completes but
  each Tx is explicitly commited with `COMMIT` or `ROLLBACK`.

* Set either or both the READ_COMMITTED_SNAPSHOT and ALLOW_SNAPSHOT_ISOLATION database options ON
