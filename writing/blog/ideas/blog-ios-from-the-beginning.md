## The Beginning ##

* Jailbreak (Craig Hockenberry, Twitterific)

## Progressions ##

* Blocks (when was ARC introduced?)
* Library Management (cocoapods)
* Unit testing
* Provisioning problems

A lot as been written on the history of iOS from an industry perspective
  * All phones were horrible.
  * iPhone made Android completely reset from copying BB to iPhone.
  * iPhone had tons of hype, tons of skeptics (virtual keyboard, 2G, no stylus)
  * GSM only.

### iPhone OS 2.0 ###

* App store - great distribution.
* 800 apps, 10 million downloads the first week of the app store.


iPhone OS 3.0
  * Revenue models - subscriptions, in-app purchases


2010 iPad - iOS 3.2

  * iBooks
  * Split view controllers, popovers, iPad UI features.
  * A4 - first Apple chip.

iPhone OS 4
  * Home screen folders (developer no-op) (how many times have we been asked to "put the app on the first page")
  * Multitasking - limited.
  * Game Center

iPhone 4 :
* Antennagate
* iOS 4.2 - airplay
* Verison

iOS 5 :
* Notification center (Android copy)
* Newsstand (failure - Apple made distributors distribute apps. Should have provided an app framework?)
* Mail.app - added search
* Wifi sync / OTA software updates
* iMessage / image/video, sync'd across devices, read receipts

2011 - iCloud

* MobileMe replacement
* Ecosystem sync - notes, calendar, documents, email, apps, photos, purchases, music ($25 year)
* Document share was app specific - couldn't share documents between apps.
* Developer pain - iCloud core data

Siri
* iPhone 4S
* 3rd party data partnerships (yelp, etc)








## The Present ##

* Autolayout - rigid. HTML / XML is much better.
*

## The Future ##


Seven years ago this March, about four months before the App Store launch, Apple released the iPhone OS SDK. I didn't have an iPhone, nor did I intend to get one. But as a closet Mac guy fronting as a C# developer, I was curious. I downloaded it, opened up Xcode, created an iPhone project, and hit Cmd-R. A window popped up and for a second or two, I was looking at a fake iPhone. Then I saw an icon open and "Hello, Damon!" was staring at me. Here was my project - my white screen with something called a "UILabel" - with the string "Hello, Damon!" - running on this fake iPhone - on my Mac!








I remember looking at Objective-C, Xcode, Interface Builder, Cocoa, Foundation, and  thought the transition from .NET and C# to iPhone OS and Objective-C was going to be a long walk up the Apple learning curve.

Programming with Objective-C.

"Two letter class prefixes (like UI and NS) are reserved for use by Apple."

id loses all type checking. Attempting to call a selector that doesn't exist on the object will cause a runtime exception.

Use property access rather than direct ivar access - except in init, deallocation, and custom setters. Use ivars in init because the custom setter implementation may depend on a fully initialized object, or a derived class may override the setter.

Boolean properties should have an "is" prefix (custom getter in declaration).

Use copy for all object properties to avoid mutating state. Someone *could* pass a NSMutableString to a NSString property (must conform to NSCopying).

Protocols with optionals should inherit from the NSObject protocol. This allows code to use "respondsToSelector" on it. All protocols could inherit from NSObject in reality.

KVO is a mess. RAC for all observables. RAC subscriptions are explicit and compiler friendly.
http://khanlou.com/2013/12/kvo-considered-harmful/

Blocks reduce the need for delegation by allowing the caller to pass in callback blocks. Blocks drastically simplify state management. The callback block can capture variables in the current environment. With delegates, if a callback needs access to state, the state would need to be saved at the class level or in another context.

Block properties should always be declared with copy since they need to copy their lexical scope.

Categories can extend existing classes. They can be defined in their own  .h/.m files. They can introduce new class or instance methods, but not ivars.

In categories, ensure you use distinct names. Don't collide with an existing method name. Use a prefix (da_method_name).

Extensions are like categories in that they extend classes. However extensions are private, can define ivars, and can only be used in the classes you define (they can't be used for framework classes).

Delegation and inheritance are alternatives to categories. They allow other objects to implement behavior and thus provide reusability.

Problems with Objective-C:
* Runtime - bypass public interface if you want to. Dumb, but possible.
* Malloc.
* Naming conventions for KVC / memory management.


--------

[iOS And The iPhone – A Retrospective | Macgasm](http://www.macgasm.net/2012/09/18/the-history-of-ios-thus-far/)
