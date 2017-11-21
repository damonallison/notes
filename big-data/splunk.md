# Splunk

> Splunk Enterprise is the data collection, indexing, and visualization engine for operational intelligence.

## Querying Data

* `AND` query for multiple fields.
  * `source="census.csv" sourcetype="csv" STNAME="California CENSUS2010POP > 100000"`

* Multiple logical operators
  * `(STNAME = "California" OR STNAME="Alaska") CENSUS2010POP > 1000000`

* Projecting columns with the `table` filter.
  * `STNAME = "California" | table CTYNAME,CENSUS2010POP`

* Sorting (`-`FieldName == DESC)
  * `STNAME = "California" | sort CENSUS2010POP desc | table CENSUS2010POP,CTYNAME`
  * `STNAME = "California" | sort -CENSUS2010POP | table CENSUS2010POP,CTYNAME`

### Stats

* Count the results
  * `STNAME = "California" | stats count`

* Sum totals
  * `STNAME = "California" | stats sum(CENSUS2010POP)`

* Average
* `STNAME = "California" | stats mean(CENSUS2010POP)`
