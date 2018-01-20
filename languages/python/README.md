# Python

* PEP 8: Python style guide.
* Does the community use type annotations?

## Likes

* Dynamic. Fast REPL. No compliation.

## Dislikes

* Dynamic. No type checking, type information.
* The core data structures (except tuple) are mutable by default.
    * Swift's `val` and `var` are much more clear, safe.
* Built-in functions vs. objects. Built-ins should be on objects.
    * `del` seems like a complete hack. Put `delete` on all data structure types.
    * `sorted`
    * `zip`
    * `enumerate`
* Heterogeneous lists.


## Comments

* Primary Collection Types : List, Tuple (immutable), Set, Dictionary
    * Any hashable object can be a dictionary key. (How does it enforce?)