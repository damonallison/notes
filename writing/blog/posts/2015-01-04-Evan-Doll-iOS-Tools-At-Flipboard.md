# 2015-01-04: Evan Doll: iOS Tools @ Flipboard
*[03/03/2018 : Note the Vimeo presentation link is no longer available. The tools, principles, and mindset that Evan (now back at Apple) promoted are still relevant — even in 2018. Proof (as if you need it) that strong engineering fundamentals and principles will always stand the test of time.]*

Evan Doll of Flipboard fame explained the tools they use in Flipboard development in a 2014 NSConference talk. What I like about Evan and his talk is his humility, honesty and straight forward approach. There is no hipster framework name dropping, cat pictures, or other side shows. Just an honest look into the tools and techniques they’ve used to build a very successful iOS product.

Here are my notes from the talk.

Evan Doll, prior to Flipboard, worked for Apple doing video / photo software. Also iOS system apps / UIKit. Stanford course instructor.

## Goals
* Automation: avoid crap work.
* Squash bugs: add hooks to improve debugging.
* Tools: Give yourself superpowers.

### Automation: avoid crap work
* Jenkins for automation.
* Automate all builds (build / tag / upload to HockeyApp).
* Run clang static analyzer.
* Automatic beta distribution.
* Provisioning : black magic and swearing involved.
* Pass the Spolsky test : can you make a build for testing purposes in 1 step
* Stamp app icon with version: easy to identify.
* Multiple bundle IDs for different versions of apps. Allows multiple installed builds per device.
* App Code: Unused code detection, additional warnings that clang will not catch.
* In-app debugging tools to expose app internals for debugging turned on in debug builds via flags.
* Cocoa Lumberjack

## Squash bugs: add hooks to improve debugging
* View hierarchy debugging.
* Gesture based tools / issue reporting. Double pressing the up/down volume button press to trigger the debug UI. Similar to Google&#8217;s “shake to report bug”.
* JIRA: the least bad of the bug trackers out there.
* Global keyboard shortcut handler. Flipboard hooked up a global event listener to globally listen for keyboard events to trigger actions. They use this for debugging in the simulator. Subclass UIApplication, override sendEvent to extract GSEventRef, posts NSNotification. Example : Cmd-L to send logs, etc.
* Internal feature switches
* Feature switches (debug only) to customize / streamline the debug experience. i.e., skip the login screen.
* Feature switches for UI &#8211; toggle between UI modes to determine which UI is better.
* International testing: override the default language via a defaults config value.
* Pseudo-localization: writing your own language to verify your views are handing variable string lengths and strings you’ve forgot to localize.
* WebTranslateIt: shared localized strings between iOS / Android.

### Tools: Give yourself superpowers
* Push as much app logic can server side to workaround bugs. For example, a JSON dictionary to configure the device at runtime.
* Changing help files / strings / etc.
* Add generic hooks into the app to allow you to update the app w/o deploying an app store update. (Feature flags / alternate codepaths triggered server side).
* Pivotal tracker
* Github pull requests (in-progress code)
* HipChat
* Dropbox
* Google Hangouts
* GitX + email

#personal/blog/posts