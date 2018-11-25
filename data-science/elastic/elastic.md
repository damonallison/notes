# Elastic

* A JSON document search engine based on Lucene.

* Elastic is distributed. Documents are put into indexes. Indexes are sharded.

* The interface into Elastic is HTTP / JSON.

* Elastic has HTTP endpoints for managing servers, indexes, issuing queries,
  everything.

## Indexes

* Each index can contain multiple types. The following adds a "user" typed
  document to the "twitter" index. The doucment has an "_id" of 1.

```json

PUT twitter/user/1
{
    "user" : "kimchy",
    "post_date" : "2019-11-15T12:12:12",
    "message" : "trying out Elastic"
}

```

* Indexes are automatically created when they are first accessed (by default).
  Automatic index creation can be disabled by administrators.

* Type mappings are schema free and are dynamic. New fields and objects are
  automatically added to the mapping as they are encountered.

* Documents are versioned.