# ARC #

* If we *don't* use the weakSelf/strongSelf pattern, will there be a retain cycle?

## Programming With ARC Release Notes ##

To use ARC, ensure you are using Apple LLVM Compiler 3.0. Xcode 4.2 only. Works
for iOS 4.0 and higher deployment targets.

Enable ARC at a project level by setting "Objective-C Automatic Reference Counting" build setting == YES.

Enable / Disable ARC on a per-file basic with the -fobjc-arc and -fno-objc-arc
file level compiler flags.

You cannot give a property a name starting with 'new'.

@property (strong) MyClass *myObject;   // increments the retain count
@property (weak) MyClass *myObject;     // zeroing weak reference : reference set to nil when deallocated.
  

### Variable Qualifiers ###

__strong (default)
__weak (zeroing weak reference)
__unsafe_unretained (weak reference)
__autoreleasing (for arguments passed by reference (id *) and are autoreleased on return)

Retain cycles:
    For parent->child relationships. Parent->Child should be strong Child->Parent should be weak.

__block MyViewController *myVC = [[MyViewController alloc] init];
myVC.completionHandler = ^(NSUInteger count, ...) {
  myVC = nil;
}


### Managing Toll Free Bridging ###

If you cast between CF and NS, use the __bridge cast.

id my_id;
CFStringRef my_strRef;
...
NSString *a = (__bridge NSString *)my_strRef; // no-op cast.
NSString *b = (__bridge_transfer NSString *)my_strRef;   // -1 on CFRef
CFStringRef *c = (__bridge_retained CFStringRef)my_id;   // +1 on CFRef




* * * * *

## What's new in IOS 5 (ARC) ##

ARC Rules:
    
    * Do not call retain / release / autorelease / dealloc methods in
      your code.
	  
    * Dealloc : you can implement dealloc if you need to do
      non-release type code, no need for [super dealloc].
	  
    * Do not store object pointers in C structs. Use objc classes to
      hold data structures instead of C structs.
    * Do not directly cast between object and non-object types (id ->
      void *). You must use special casts / functions to tell the
      compiler about an object's lifetime.
	  
    * You cannot use NSAutoreleasePool. Use the built in @autoreleasepool {} objc keyword.
    * You cannot create a method starting with "new". (i.e., - (Person *) newPerson; )
    
    * ARC will automatically create and fill out a -dealloc method that will [release] all ivars.

	
Zeroing weak references (__weak) :

	* Automatically set to nil when the object it points to id deallocated.
	
    * Use __unsafe_unretained to mimic old 'assign' weak reference behavior.
	
    * __weak is not available in OS X 10.6 or iOS 4 (must be __unsafe_unretained).
	
    * CAREFUL : non-zeroing weak references (__unsafe_unretained) are dangerous. Don't use them!





Property Declaration : 
    * Avoid assign wherever possible (use weak)
    @property (strong) MyClass *myClass;  // synonym for (retain)    
    @property (weak) MyClass *otherClass; // like (assign), but zeroing weak reference. 
        Set to nil, not a dangling pointer when object is deallocated.

Blocks:
    
    Blocks have special memory management requirements. Block literals must be
    copied, not retained. Therefore, it's best practice to copy, not retain
    blocks.

    Be *careful* : ARC will **NOT** copy a block literal that is converted to
    an id. This *may* have been fixed - not sure. Be careful!

	id function(void) {
		return [^{ fun(); } copy]; // copy required since block converted to id.
	}
	
	[myArray addObject:[^ { fun(); } copy]]; // block being converted to id - needs copy.
	
	
    __block will allow a block-captured variable to be modified within the block.

