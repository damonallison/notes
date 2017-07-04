# Apple Programming : Core Fundamentals #

### Annoyances ###

* **So** much energy is dedicated to memory management. Huge problem. Anything that distracts you from the domain environment is a problem.

* CoreFoudation / Foundation bridging and use of both frameworks is painful. CF<->NS "toll-free bridging". CF needs to be deprecated entirely.

## Foundation ##

#### Objective-C Language ####

* NSInvocation
* NSMethodSignature
* NSNotification / NSNotificationQueue
* NSObjCRuntime

#### Data Types ####

* NSDecimal / NSDecimalNumber


#### Data Structures ####

* NSArray
* NSDictionary
* NSHashTable
* NSMapTable


* Predicates
  * NSComparisonPredicate
  * NSCompoundPredicate
  * NSExpression

* NSIndexPath
* NSIndexSet

#### Concurrency ####

* NSCache (concurrency?)
* NSDistributedLock
* NSLock
* NSOperation / NSOperationQueue

#### I/O ####

* NSFileHandle
* NSFileManager
* NSFilePresenter
* NSFileVersion (OSX versioning?)
* NSFileWrapper

#### Networking ####

* NSHost
*

## Object Serialization ##

* NSArchiver
* NSCoding
* NSJSONSerialization
* NSKeyedArchiver


***********************
***********************
## Objective-C ##

* Enumeration / fast enumeration
* KVO / KVC
* NSKeyValueCoding / NSKeyValueObserving

## Classes / Objects ##

* Difference between **id** and **NSObject**?
* NSObject : hashing and equality.


* What types are supported by .plist? How to get a non-supported object type to serialize into a .plist (custom object serialization)?

## Memory Management ##

* Allocation zones
  * NSDefaultMallocZone

* ARC

## Object Literals ##

Introduced in Apple LLVM Compiler 4.0.

### NSNumber ###

@42        // [NSNumber numberWithInt:42]
@42U       // [NSNumber numberWithUnsignedInt:42U
@42L       // [NSNumber numberWithLong:42L]
@42LL      // [NSNumber numberWithLongLong:42LL]

@3.14      // [NSNumber numberWithDouble:3.14]
@3.14F     // [NSNumber numberWithFoat:3.14F]

@YES       // [NSNumber numberWithBool:YES]
@NO        // [NSNumber numberWithBook:NO]
