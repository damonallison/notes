# Book Review: App Architecture: iOS Application Patterns in Swift

Since iOS’s introduction in March 2008, almost 11 years ago, the core iOS MVC
architecture hasn’t materially changed. Over the years, as applications have
become more complex, the limits and shortcomings of MVC and UIKit have prompted
developers to develop and use alternative architectures.

*App Architecture: iOS Application Patterns in Swift* examines different
architectural approaches for building iOS apps. While all architectures are
slightly different, the common themes of separation of concerns, immutability,
unidirectional data flow, and testability are foundational concepts underlying
these architectures which all developers should strive for when building high
quality software.

And as always when dealing with architecture, *Keep It Simple, Stupid*.
Architecture is just a means to an end. Focus on the end. Focus on your
customer, your user.

## About Architecture

> Standards are great, everyone should have their own. - Chris Koehnen

### Architecture - A loaded term

The term “architecture” is somewhat of a four letter word. Software developers
can get pretty passionate and/or defensive when taking about software design,
architecture, or libraries like Rx that enforce a certain way of thinking. They
polarize people. Architectures and the tools that enable them can be come a
religion for many people. Don’t fall into that trap!

And then there is architecture’s close cousin - “patterns”.  Patterns by
themselves are generally helpful designs. Like architecture, when the focus on
patterns is taken to an extreme, you run the risk of going from designing
software for customer’s sake, to designing software for design’s sake. It
becomes all about how fancy the software is internally, how “pure” it is, etc.
Meanwhile, we lose sight of what the *customer* thinks is good software.
Customers don’t care what patterns you use one bit.

With that backdrop, this review will *not* focus on the merits of each
particular architecture described in the book. In fact, the authors of the book
don’t claim any preference of one architecture over another either. Smart move.
There is no *right* architecture.

### Focus on the concepts

Don’t get hung up on one particular architecture. There is no “right”
architecture. But good architectures generally follow common concepts and
patterns. It’s those concepts which transcend across architectures. Know these
fundamentals, and you’ll easily understand any architecture.

> The concepts, not a single particular implementation of them, is the most
> important for you to take away from this article.

The underlying concepts we will focus on include:

* Separation of concerns.
* Immutability.
* Unidirectional data flow.
* Interaction with UIKit and MVC.

### Architecture is important - make it first

Pro tip: Architecture is important. High quality software doesn’t just happen by
accident. Thought is put into the design. True hackers think thru their designs
carefully, treating it as an art form.

It’s so common to want to jump in, fingers to keyboard, cranking code. But do
yourself a favor. Stop and think. *Design* the system first. Understand the data
you need, the layers of the system, the communication patterns. It’s easy to
start writing code. It’s hard to think about how the system should be designed.
But over time, you’ll have to answer the hard questions. Do it early. Do it
often. Oh, and remember: KISS.

It may not seem so at the beginning, but remember that only a small part of an
application’s lifecycle is spent being built. Refactoring, maintenance, and new
features is where great architecture pays for itself in spades.

## State of iOS App Architecture
iOS has been around for 10 years now and the MVC architecture hasn’t materially
changed. UIView, UIViewController, and model objects is pretty much the extent
of it. What does iOS give us out of the box?

* View : UIView, et al.
* Controller : UIViewController and derivatives.
* Model : Core Data, PONSO (Plain Old NSObject)
* Communication : Delegation, NSNotification, KVO.

### The Big C

The view and model layers are trivial to understand and implement. Yet what
happens when applications become complex? Where does that logic go? It’s not in
the “M”. It’s not the “V”. Virtually the entire application needs to be written
somewhere. And the only place left is the Controller layer.

The long running joke among iOS developers is that MVC stands for “Massive View
Controller”. VCs can easily push into the 1000’s of lines of code - especially
for involved views.

What happens when VCs get too large?

* State becomes extremely hard to reason about.
* Unit tests are equally massive, requiring a ton of boilerplate and
  infrastructure to setup.
* More difficult to refactor.

The entire book, and the vast majority of iOS architecture discussions on the
internet, describe ways to simplify the controller layer. How to separate out
logic into discrete components and communication patterns, yet play nice with
UIKit.

### Open Source to the rescue

While Google introduced Architecture Components for Android, Apple has left iOS
architecture patterns up to the developer community to build.

Android Architecture Components introduce a set of patterns and tools for
Android developers. Having an “official” set of architecture increases the
chances of becoming a standard. If they catch on (no guarantee they will), it
may really help the Android community fight platform fragmentation, improve
documentation across the internet, and become ubiquitous the community and
across application code bases.

Apple has not offered any architectural tooling or guidance on top of `UIKit`.
The developer community has stepped in, offering iOS friendly examples of
architectures commonly found on other software platforms. Versions of MVVM, MVP,
VIPER, etc, have all been created for iOS.

All of these 3rd party architectures have come from various communities -
academia, functional programming, the web, etc. Examples include:

* Web - Elm, React, Flux
* iOS - Viper
* Functional / Rx
* MVP, MVVM


## Architecture Characteristics
Let’s take a look at the three most important characteristics you want to think
about when evaluating and/or designing your application.

* Separation of Concerns
* Unidirectional data flow (communication between layers)
* Immutability

### Separation of Concerns

The primary problem with “Massive View Controllers” is you can’t easily reason
about, or test code, when it is in a monolith.

Separate out logical layers and components (concerns) of an application.

Do you have view controllers that make network requests? That handle view
transitions? That do complex logic or calculations? All are candidates for
separation. Move that logic out of the view controller into dedicated
components.

When structuring your layers, follow the [Principles of Clean
Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
and build from the inside out. Inner most layers of your software should *not*
know about the upper layers.

### Unidirectional Data Flow (UDF)

Unidirectional data flow is a fancy term to describe how data flows thru a
system. In short - data always flows in one direction. UI actions flow down to
the model, model actions flow up to the UI.

```
Unidirectional Data Flow (UDF)
------------------------------

View -> View Action -> Interaction Logic -> Model Action -> Model

View <- View Change <- Presentation Logic <- Model Change
```

It’s easy to understand with a high level example.

Say the user taps a UIButton. The ViewController IBAction fires. Rather than
perform all logic in the view controller, the view controller simply sends the
message to a lower level layer, which perhaps executes the logic - perhaps
validation, formatting, or calculation. That layer in turn sends a message to
the next layer down, say the model layer.

If the model layer changes, it notifies it’s delegate or listener that it has
new data. The listener receives the event, prepares new data for the UI, and
notifies the view layer (View Controller, perhaps) that new data is ready to
display. The view layer updates the UIView.

Why is a unidirectional data flow so important? *It allows you to clearly reason
about your code*. In the massive view controller problem, the VC handles *all*
the logic for the application. By defining clear interfaces between layers of
the system, and *requiring* all data flow in the same direction, it’s easy to
understand where state is handled and easy to troubleshoot problems.

Unidirectional data flow is common on the web. React / Redux is built around
UDF. It’s great to see UDF being adopted by the iOS community.

### Immutability

Whenever possible, prefer immutability in your models and data structures.
Immutable data structures help prevent a whole host of state related problems.
Immutability simplifies state management across thread (you generally don’t need
to lock immutable resources), prevents accidental state manipulation, and helps
enforcing unidirectional data flow by not allowing layers to “cheat” and
manipulate existing data structures.

Always prefer immutability with your data structures. If you are used to working
with mutable data structures, it will require discipline and thought to think in
immutability, but once you get in the habit of working with immutable data
structures, you’ll be much more confident in reasoning about the state of your
application.

Also, as patterns and tools around Rx and functional programming become more
mainstream, immutability becomes a requirement. Functional programming languages
and tools expect your data structures to be immutable.

## Example Code

This whole post has been great theory, but theory can be hard to actually
understand or put into practice until you see code.

The authors of the book created a simple example iOS app in all the
architectures they described in the book. You can find the code
[here](https://github.com/objcio/app-architecture).

Again, the most important thing to think about when reading this code is to
understand how the concepts above are represented. Those concepts are the
thoughts you want running thru your head as you write *your* application. Ask
yourself:

* What layers of my application should I create? (Separation of concerns)
* How are the layers going to communicate? Rx? Delegates? (Unidirectional data
  flow)
* Who is responsible for changing a model’s state? (Immutability)

It is worth your time to read over the book examples. They are well written and
the objc.io authors are some of the best thought leaders in the iOS space.

## Final Thoughts
The book opened my eyes to the *need* for architecture in the iOS space. That
was a true gift for me. I’ve implemented many of these patterns ad-hoc, but
haven’t really formally considered architecture to any large extent. This book
reinforced the true *need* to thoughtfully consider how to design systems before
starting.

I thought the book could have been much shorter. The patterns are very similar
and the book was rather repetitive.

VIPER is a common iOS pattern *not* covered in the book. I feel a book dedicated
to iOS architectures should consider it.

I would have liked to have seen a bit more background on Rx and reactive
programming. I think Rx drastically changes how systems are designed. A bit more
background on Rx would have been helpful for people.

## Final, Final Thoughts

We as software engineers are craftsmen. iOS, even after 10 years, provides very
few primitives for us to structure our code - leaving it up to us to design and
architect our applications.

While there are many architectures, the underlying concepts of separation of
concerns, unidirectional data flow, and immutability transcend architectures.
Understand those and you’ll be on your way to writing clean, maintainable, and
testable software.


## Bibliography
* [Clean Coder
  Blog](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
  - Principles of Clean Architecture.
* [Architecting iOS Apps with VIPER ·
  objc.io](https://www.objc.io/issues/13-architecture/viper/)
  * Fight Massive VC w/ separation of concerns.
  * `I` : Interactor. Business logic.
  * `E` : Entity. Model.
  * `P` : Presenter. To drive the UI.
  * `V` : View
  * `R` : Router - for UI control flow (segues, etc)
* [The Elm Architecture · An Introduction to
  Elm](https://guide.elm-lang.org/architecture/)
* [Redux · A Predictable State Container for JS Apps](https://redux.js.org)
* [Android Architecture Components  |  Android
  Developers](https://developer.android.com/topic/libraries/architecture/)

#tech/books