# 2015-02-24: RACifying Non-Reactive Code — Dave Lee’s Presentation Code
Dave Lee gave a talk titled ”RACifying Non-Reactive Code” for GitHub Reactive Cocoa Developer Conference in June 2014 (about two weeks after Apple’s Swift WWDC announcement). His presentation is a no-nonsense, fast paced ~25 minutes of walking thru the multitude of ways in which objective-c, cocoa, and the Apple frameworks present events and how to translate those events into RAC (e.g., RACSignal).

One of the first things every newcomer to RAC learns, perhaps the first a-ha! moment, is that cocoa presents a multitude of ways in which events are passed and received. It’s eye opening to realize how much these seemingly different event mechanisms have in common.

When learning about KVO for example, you don’t consider the commonality KVO has with another eventing mechanism such as delegation or target/action. But stepping back to look at these event paradigms together, to understand what they are ultimately trying to solve, makes you realize they indeed are all doing fundamentally the same thing: an event source is providing events to another object observing those events.

Now, this is one of the fundamental goals the RAC authors are trying to achieve : abstracting the 20+ years of cruft and ugliness built up in the various Objective-C eventing patterns into common, modern, and functional abstractions (i.e., RACSignal, RACSubscriber, etc). While their implementation is not perfect (hot vs.cold signals, a non-generic type system preventing you from clearly seeing what type will be delivered with an event), it goes a long way towards writing clear, concise code with less state (win, win, win!).

Dave’s talk was interesting since it showed concrete examples of the various Objective-C patterns and how they translate into RAC. As I was watching the video, I was frequently pausing it, thinking to myself “oh, I can use that in this project, I need to copy this code down”. After stopping a few times, I realized I should just start over, copy all the examples down, and keep them for reference.

Without further ado, here are the Objective-C patterns he converts to RAC:

* Blocks
* Delegates
* Notifications
* Errors
* Target-Action
* KVO
* Method Overriding
* Here is the full code. Enjoy!

[rac.m · GitHub](https://gist.github.com/damonallison/2bd89ad069c6b48b3416c028d95bdd71)
