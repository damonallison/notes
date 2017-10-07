# Javascript

## TODO

* ES Versions / Standards / Features
  * ES6
    * Arrow functions
    * Classes (relationship to prototypes)
    * `let`
    * `const`

* Typescript

* Babel
  * ES6 -> ES5 compiler?

* Libraries
  * Local Storage


## Likes

* Functions are first class objects. Closures, HOF, etc.
* Ecosystem. REPL, lightweight tooling.

## Dislikes

* Dynamic typing.
* `this`
  * Dot/bracket notation makes `this` the current object.
  * If dot notation was *not* used, `this` is the global object.

* `var` scoping. Not lexical.
* Type cohesion.
* `parseInt` stops parsing on the first non-numeric character.
  * `parseInt("20 damon") // 20`

* Functions
  * You can call a function w/o passing all arguments.
  * Each function has access to an implicit `arguments` array.



### Overview

* Supports OOP via prototypes.
* Types : `Number`, `String`, `Boolean`, `Function`, `Object`, `Symbol`

* Numbers
  * All numbers are 64 bit floats.
  * `parseInt("99", 10); // convert to int`
  * `isNaN(val)` will check for `NaN`.
  * `null` : a value which must be deliberately set.
  * `undefined` : an uninitialized value.
  * `falsy` values are `false`, `0`, `""`, `NaN`, `null`, `undefined`

* Variables
  * `let` : block scoped (lexically scoped).
```
  for (let var = 0; var < 5; var++) {
    // var visible in the `for` block only.
  }
```
  * `const` : immutable. Block scoped.
  * `var` : mutable. Function scoped.

* Equality
  * `==` Type cohesion will occur with different types.
    * `123 == '123' // => true`
  * `===` No type cohesion.

* Arrays
  * `length` is always 1 higher **than the highest index**.

```
  var a = ['dog', 'cat', 'bird']
  a[100] = 'test'
  a.length // => 101

  a.forEach(function(val, index, arr) {
    // do something with the current value or arr[index]
  })
```

# Javascript - The Definitive Guide

JS was submitted to ECMA and because of trademark issues was named EcmaScript (ES). ES3 and 5 are available, 4 was not released.

Syntax from java, functions from scheme, prototype from self.

JS is case sensitive. HTML is not. JS uses lowercase names (onclick) HTML can use anything (onClick)

JS has regex literals.

JS has a strict mode? What is it?

Semicolons are optional but line termination rules could read the program not as intended. Use semicolons.

Weird OO (constructors).
Liberal implicit type conversion (opposite of go).
All numbers are 64 bit floats.

JavaScript does not do string normalization. Unicode defines a standard normalization procedure. What is it?

* What subset of JS works cross-browser? If you are developing for Chrome, Safari, or Firefox, do you care?

* The inability to play video natively in HTML was a huge obstacle to obsoleting flash.

What is HTML5?
  * An umbrella for everything, and thus it actually means nothing.
  * HTML5 : It's not a technology, it's a religion.

What's new in HTML5?
    * New, "semantic" tags. Why semantic tags? Better recognition by crawlers.
    * <nav>, <article>, <section>
    * <audio>, <video>
    * <canvas>

What's "new" in JS for HTML5?
  * geolocation
  * storage capabilities : "localStorage" "sessionStorage" "indexedDB" "webSQL"
  * Filesystem API (client side virtual file system?)
  * FileReader API : allows JS to read files being inserted via <input type="file"> (e.g., image editor)
  * Better control over the back/forward buttons.
  * Better drag and drop API.
  * "Web Workers" : background threads.
  * "Web Sockets" : full duplex socket connection.

What's next for JS?
  * Peer-to-peer (PeerConnection API) and WebRTC.
  * Web Intents
  * Mobile HW APIs.


"But let’s be honest: now HTML5 is basically an umbrella for everything, and thus it actually means nothing."
  - Kyle Simpson - JavaScript and HTML5 Now

## Links

* [Mozilla : A re-introduction to Javascript](https://developer.mozilla.org/en-US/docs/Web/JavaScript/A_re-introduction_to_JavaScript)
* [Mozilla : Javascript](https://developer.mozilla.org/en-US/docs/Learn/JavaScript)
