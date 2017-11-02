## appledoc ##

	/**
	 * Tweet-sized high-level documentation for this class/method.
	 *
	 * Reference other classes like `NSString` with ticks.
	 *
	 * @note this will appear in a letterbox inside the appledoc output
	 *
	 * @see anotherFunction:withParam1:param2
	 * @param param1 Some integer field.
	 * @param param2 Some `NSString` field.
	 * @return An int
	 */
	- (int) myMethod:(int)param1 withString:(NSString *)param2 {

	}

## Apple Environment Notes ##

~/Library/MobileDevice/Provisioning Profiles

~/Library/MobileDevice/Software Images
~/Library/iTunes/iPhone Software Update
	* Only images download / installed through iTunes.

## Apple Suggestions ##

* Open up iCloud outside of iOS. Make it a generic data sync layer (does the daemon process
  architecture prevent an app-level sync solution?).

* Why does iOS only offer static libraries - so you can't update | load the .dylib without going
  through Apple?

* What are the standard library and interface directories?

# iOS App Programming Guide #

* App lifecycle discussion | backgrounding | long running background tasks (location / voip).
* Main run loop : UIApplication receives run loop events first, could be used to intercept / track
  events.
* Most events (in controls) are packaged into action messages (raw events aren't dealt with).

# iOS Technology Overview #

* Storyboards preferred over nib. (Xcode 4 user's guide for info on storyboards (UIStoryboard).
* Game kit for establishing P2P connectivity.

* SystemConfiguration.framework : Reachability | current network status | ability to reach a server,
  etc.

## Application Sandbox ##

(See File System Programming Guide) /App/MyApp.app /Documents /Library /tmp

* Exception handling (try / catch in objc - really for programmer errors only?


## Core Data Programming Guide ##

You can use multiple MOC's in an app. Each MOC can have a copy of an object. Inconsistencies during save can result. Just use 1 MOC in an app unless you *really* need multiple.

How to use CD with GCD? What is CD's multi-threading story?

* Don't use > 1 model / persistent store / managed object context (unless r/rw)

* What are the data stores (memory / SQLite / XML).

* Do you use a single managed object context? Or one context for read-only,
  another for change tracking?

* Q : What does "abstract" do when defining a model object?
  A : Abstract entities cannot be instantiated.

### Technology Overview ###

* Change tracking / undo support (document model roots?).
* Relationship maintenance.
* Faulting / memory optimization - lazy loading.
* Automatic property validation (extending KVO validation)
* Schema migration tools (how do they work?)
* Integration with cocoa bindings.
* Core data automatically synthesizes the appropriate collection accessors for to-many
  relationships.
* Multi-writer conflict resolution (same object existing in multiple MOCs?)

### Core Data Basics ###

* Persistent object stores (SQLite / XML / memory, others?)

Persistence Stack
	Managed Object Model : the schema (Xcode data model) - instance of NSManagedObjectModel.
	Managed Object Context
	Persistent Store Coordinator
        * Coordinates multiple physical stores - some entities into one store, some in another store)
	Persistent Object Store

	NSManagedObject

### Managed Object Model ###

* Xcode -> xcdatamodeld -> *.xcdatamodel.d (resource bundle) -> momc -> complied into a deployment
  directory (momd) -> mom deployment file.

* Any model changes makes old stores incompatible - those stores won't load.
* You can keep old models - creating a "versioned model" will allow you to open all versions.

* Transient properties : are not saved to CD.

* Fetched properties : weak, one-way relationships ("recent customers") - customers don't have a
  corresponding "recent" relationship.

### Managed Objects ###




## Data ##

CD was designed around a "document model" - change tracking / undo support.

How does data validation work? Try saving a string -> int field. Overrun fields. Break
relationships.

Why would someone *ever* use multiple MOCs?

CD problems:
* *not* designed for multi-user.
* Schema migration is not trivial - requires code (how to write version translation code?).

* How to handle errors to [save]? Is it possible to "detach" an object.

* NSExpression - what is this?

* It would be great (but expensive) if we could pass a filter block as an NSPredicate.
* If we can't do blocks : at least a regex.
* How do we do a multi-table join? Walk the OM?



## ARC ##

* Retainable objects: Arc is available on objc objects and blocks. Not available on CF or C objects
  (int *). See toll-free-bridging for __bridge attributes that tell ARC what the ownership semantics
  are.

* Weak referendes are not supported in 10.6.

* You cannot use object pointers (void *) in C structures.
* No casual casting between id and void *.

* Do not use NSAutoreleasePool : use @autoreleasepool blocks.
* You cannot create an accessor (property or method) that starts with 'new'.

* Weak references : does not retain the object, sets to nil when there are no strong references to
  the object.
* ARC does *not* guard against retain cycles. One side of the cycle must be weak.

* ARC object qualifiers :

	__strong : the default. Will stay alive as long as there is a pointer to it.  __weak : a
	reference that does not keep the object alive. The reference is set to nil when there are no
	strong references to the object.  __unsafe__unretained : does not keep the object alive, does
	not get set to nil when all strong references are gone. The pointer is left dangling.
	__autoreleasing : used to denote arguments that are passed by reference (id *) and are
	autoreleased on return.

Delegate implementation -- use __weak

@implementation MyClass { __weak id<MyDelegate> delegate; }


* Blocks:

	* Set __block variables to nil to break the retain cycle. (needs better understanding)

* Toll-Free Bridging
	* __bridge : transfers a variable between objc and CF with no transfer of ownership.
	* __bridge_retained : casts an objc pointer to a CF pointer. You must call CFRelease().
	* __bridge_transfer : (CFBridgingRelease) moves a non-Objc pointer to objc and transfers
      ownership to ARC.

- (void)logFirstNameOfPerson:(ABRecordRef)person {

    NSString *name = (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSLog(@"Person's first name: %@", name); [name release]; }

- (void)logFirstNameOfPerson:(ABRecordRef)person {

    NSString *name = (NSString *)CFBridgingRelease(ABRecordCopyValue(person,
    kABPersonFirstNameProperty)); NSLog(@"Person's first name: %@", name); }

## NSTableView | NSOutlineView ##

* NSTableColumn : .identifier used to uniquely identify the column (used from delegate |
  viewForTableColumn)

NSTableView NSTableViewRow :

* OutlineView (start here)
* SourceView : finder
* TableViewPlayground
* DragNDropOutlineView

## iOS Stuff ##

* How to download older versions of the SDK (where do they go on disk?)

# OS X Reading Plan #

Cocoa Fundamentals Guide:

	https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/CocoaFundamentals/Introduction/Introduction.html#//apple_ref/doc/uid/TP40002974


Cocoa Event Handling Guide:

Event Messages : events sent from HW / I/O Kit to your app (mouse, keyboard, trackpad).  Action
Messages : application level events (target/action) sent from one control to another.


### Mouse ###

* Mouse moved events happen so fast, the bog down the event queue. By default NSWindow will not
  watch for them. Set [NSWindow setAcceptsMouseMovedEvents:YES]; to receive the mouse moved events.

* Mouse moved events are *always* sent to the first responder, not the view under the mouse.

### Keyboard ###

Key event priority:

1. Key equivalent : performKeyEquivalent is sent down the view hierarchy. If nobody handles it, it
is sent to NSMenu objects.

2. Keyboard Interface Control (tab / shift-tab) : moves focus between controls.  To programmatically
	manipulate the key loop, use IB or [NSView setNextKeyView].

3. Keyboard action : (beginningOfLine, etc..)

4. Characters for insertion as text.


### Action Messages (target/action) ###

[NSApplication sendAction:to:from]; // if to (target) nil, action goes up the responder chain.


### Responders ###

[NSView setAcceptsFirstResponder:NO]; [NSWindow makeFirstResponder:];



Mac App Programming Guide App lifecycle, full screen, iCloud, implementing preferences...

	https://developer.apple.com/library/mac/#documentation/General/Conceptual/MOSXAppProgrammingGuide/Introduction/Introduction.html#//apple_ref/doc/uid/TP40010543

*********************************************************************************************************
*********************************************************************************************************

# Cocoa Bindings #

* Implement NSEditorRegistration protocol on a NSTextField to indicate start|end of an editing
  session. Here is another test line and another and ano


* Use a value transformer.

* NSArrayController : subclass to customize sorting | filtering.

* All bindings are based on KVC | KVO.  (See Key-Value Coding Programming Guide)

* Why use NSController at all?

	* NSController instances manage their current selection | placeholder values (acts as an
      intermediary)


NSEditorRegistration protocol : objectDid[Begin|End]Editing

NSObjectController contentObject

	 | NSArrayController | NSTreeController | NSUserDefaultsController

bind contentArray => selection.weapons arrangedObjects.name selection.weapons