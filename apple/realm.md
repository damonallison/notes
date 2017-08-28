## Realm

* Designed for mobile. Who cares - just design it right.
* What data types are allowed on Realm `Object`s?

* You can only use an object on the thread which it was created.
  * Watch cross-thread object access - passing it into global state, etc.

* Realm parses all models defined in your code at launch. They must all be valid,
  even if they are not used. When parsing models, each object must have an `init()`
  constructor which must succeed. **All non-optional properties must have a default value**.

* Realm supports the following property types: Bool, Int8, Int16, Int32, Int64,
  Double, Float, String, NSDate truncated to the second, and NSData.

* String, NSDate, NSData **can** be optional. `Object` properties **must** be optional.

* Objects can be linked to each other using `Object` and `List` properties.

* Sublcassing is possible. Seems error prone. Don't do it.

* Why would you *ever* want to create an object from an array of values? That would
  rely on the position of the variables to match the array order. So flaky.

* Reads are *not* blocked while write TXs are in progress.


* The Realm "new file" plugin is a complete waste of time.


    import RealmSwift

    class Person: Object {


    // Specify properties to ignore (Realm won't persist these)

    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
    }






## Error Handling

* Propagate the error.
* Handle in a do/catch.
* Handle the error as an optional.
* Assert the error will not occur.
