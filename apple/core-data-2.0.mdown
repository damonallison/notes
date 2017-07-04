# Core Data 2nd Edition : Marcus Zarra #

[Core Data 2nd Edition - Marcus S. Zarra (O'Reilly)][cd-book]


### Core Data - Likes ##

* CD handles managing relationships for us. You only need to set one side of the relationship, CD automatically wires up the other side.

### Questions ###

* CD could use a framework for versioning / upgrading the CD stack, initializing it on a background queue, etc.
* CD could use a framework for dealing with MOCs using GCD.


# Introduction #

* Billed as “the most efficient solution to data persistence” - really? (Page 1)
* Allows us to eliminate a lot of boilerplate model code (persistence, etc)
* Think of CD as an object graph (relationships, etc) not a SQLite front-end.

**Do *not* use CD before iOS 6 / OS X 10.8 - CD was buggy (Page 10)**

## Chapter 1 ##

CD “Stack” == NSManagedObjectModel / NSPersistenceStoreCoordinator / NSManagedObjectContext.

You’ll typically only work with the MOC once the stack has been instantiated.

NSManagedObjectModel - compiled, binary version of the data model. Compiled to a “.mom” file using `momc`

MOC is not thread safe. Each thread needs it’s own MOC.


NSManagedObject methods to override

* willTurnIntoFault : release any transient resources associated with the NSManagedObject.
* awakeFromInsert : set default values or run "init" code to setup the only. Only called once for the entire lifetime of the NSManagedObject.
* awakeFromFetch : setup transient objects. **Warning** if you set a relationship on the NSManagedObject - ensure you set both sides of the relationship.


## Chapter 5 - Threading ##

Golden Rule : Contexts and their resulting objects *must* be accessed only on
the thread that created them. Create a MOC on *each thread* that will interact
with core data.

NSManagedObjectID is thread safe - use to pass "objects" between contexts.

* Parent/Child and **peformBlock** and **performBlockAndWait** are 10.8 only.
* All MOC's participating in a parent/child relationship must use the *initWithConcurrencyType* initializer.
    NSMainQueueConcurrency type : only runs on main thread, all access must be done in performBlock.
    NSPrivateQueueConcurrencyType : runs on private queue, all acess must be done in performBlock.
    NSConfinementConcurrencyType : runs on thread that created it. performBlock not required, but all calls against this MOC must be done on the thread that created the MOC.

Recommended approach

Parent : private queue -> associated with the PSC.
    Child : main queue (for UI) (no disk hit / main thread block on save). Call save on the parent queue to actually write to disk.
    Child : additional private queue based children.


* Saving a child MOC will push changes to it's parent.
* Saving a parent MOC will *not* push changes to children.


### Parent / Child MOCs ###

Ultimately, only the parent context has access to the PSC.

Private
    Main (UI only)
    Other Private

"It is best to treat children as "snapshots" of the data taken at the time the child was created.

performBlock && performBlockAndWait will execute the block on the MOC's thread.



# Reference #

* [Core Data 2nd Edition - Marcus S. Zarra (O'Reilly)][CD]
* [Core Data Programming Guide (Apple)][Apple-CD-ProgGuide]

## Other stuff to read ##

[Core Data Migration / Versioning Guide][Migration-Guide]

* * * * * * * * * * *

[Apple-CD-ProgGuide]: https://developer.apple.com/library/ios/#documentation/Cocoa/Conceptual/CoreData/cdProgrammingGuide.html
[cd-book]: http://pragprog.com/book/mzcd2/core-data

[Migration-Guide]: https://developer.apple.com/library/prerelease/ios/documentation/Cocoa/Conceptual/CoreDataVersioning/Articles/Introduction.html#//apple_ref/doc/uid/TP40004399



## Core Data Migration ##

* How to determine if a store matches a model?


## Core Data Migration Guide ##

* Lightweight migration : CD infers mapping. What changes are lightweight?

* ManagedObjectModels have a "versionIdentifiers" property. For humans only.


* Compatiblity  
  * Entity : name, parent, isAbstract, properties (className, userInfo *not* compared)
  * Property : name, isOptional, isTransient, isReadOnly
    Attributes: attributeType
    Relationships : destinationEntity, minCount, maxCount, deleteRule, inverseRelationship.

    userInfo, validationPredicates *not* compared.

  * "versionHash" (entity / property) : used to compare store -> model.
  * "versionHashModifier" : allows you to force differences in the model.

### Lightweight Migration ###

* CD automatically infers mapping - can typically do this using straight SQL - no
  need to load data.

* There is a "renaming identifier" to force a canonical name.

* NSMigrationManager :
  * MOM for destination store.
  * MOM for source.
  * Mapping model.

3-stage migration
  1. Creation step. Creates destination instances for source instances.
     Only attributes (not relationships) are set on the destination objects.
  2. Recreate relationships
  3. Apply validation

