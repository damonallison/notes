# Swift #

## Recommendations ##

* Concurrency built into the language (goroutines).

## Questions ##

* What are the case statement pattern matching rules.
* How to determine a variable type @ runtime (`AnyObject`)
* Do we have control over function scoping (private / package / public?)
* How to create and use a framework (module).
* Basic data structure definition - hash, equality, copy.
* Weak / unowned references when dealing with ARC. What are the rules?

## Dislikes ##

* Does not take a hard stand on convention (unlike go). Semicolons are optional.
* Parameter names for methods are used when you call the method (required for Obj-C? interop?)
* `mutating` func.

## Differences (Undecided if these are good or bad) ##

* Enums can have methods associated with them.


-------------

## Next Steps ##

* Protocols
* Namespaces / packages
* Concurrency (channels?)
* Generics
* Extensions
* Structs


### Generic swift Questions ###

* What is the global scope? Are all functions defined in the "global scope" in all files callable from all other files?

* Modules: How to create / import a module / framework?
* Modules: What is an umbrella header?
* Modules: What is a module.modulemap file?

* Strong reference cycles and capture lists. If you store a closure on an instance. This needs to be broken (guard?)

* Functions : Why are functions written as `print(_:separator:delimiter)`. Why does the first parameter receive the wildcard name and type names are omitted?

* Closures : is it common to annotate *all* non-escaping closures with `@noescape`?
* "Marking a closure with `@noescape` lets you refer to `self` implicitly within the closure. What does this mean - couldn't you refer to `self` in all closures?



#### Objects ####

* How to use `Swift.reflect(_:)`

* How to hide local class vars from the class's public interface?
    * What are the access rules in swift? (private, public, etc..)

* What is protocol composition?
* How do extensions work at the compiler level?
  * For example, why will value types with extensions receive default initializers or memberwise initializers
    if other initializers are defined in an extension?

* Primitive types : lists and API. (All value types?)
    * Swift style guide (formatting tools like godoc?)

* How can we view playgrounds or write playgrounds that have rich comments /
documentation in them?

* What are the Objc attributes for interoperating with swift (read the swift interop book)

#### Tools ####

* Need to master Xcode.
    * Pane switching, closing, and navigation.

## Projects

* Write a framework, use it from another app. Proves we can create reusable modules and enforce access levels.
* Write Array.sort(isOrderedBefore:(String, String) -> Bool). Use bubble sort or merge sort.
