## Objective-C Runtime Programming Guide ##

Notes from the : [Objective-C Runtime Programming Guide][objc-rpg]

### Questions ###

* What is a "dynamic shared library"? Bundle? .so?
* NSInvocation : dynamically build / invoke a selector.
* NSObject (review) (methodForSelector: respondsToSelector: ...)
* Implement examples of runtime usage to fully inspect a class.

* "Modern" runtime was introduced with Objective-C 2.0 (OS X 10.5 / all iOS apps)

What makes ObjC 2.0 modern?
* The "modern" runtime supports instance var synthesis for declared properties.

## High Level Comments ##

Runtime introspection and dynamic programming is viewed as a powerful tool. In reality, the flexability causes complexity. You violate strongly typed contracts. The compiler cannot help you.

The compiler is responsible for generating code that interacts with the runtime. 

## Interacting w/ the runtime ##

How do you interact with the runtime? 3 ways:

* Write source code. Compilation will create the data structures and objc_ messages to pass.

* Overriding NSObject functions (description, isEqual, hash). NSObject also
  defines methods that query the runtime for information. Calling these
  functions on NSObject will invoke the runtime. Examples:

	`isKindOfClass`
	`isMemberOfClass`
	`respondsToSelector`

* Calling runtime functions directly (obj-c runtime functions are in
  /usr/include/objc). The runtime functions allow you to replicate what the
  compiler does when compiling objc code

## Messaging ##

The compiler creates a structure for each class. Each class structure contains:

	* A pointer to the superclass.
	* A class "dispatch table".

When a new class is created, memory is allocated for it and instance variables
are initialized. Each object has an **isa** pointer. The "isa" pointer is a
pointer to it's class's structure.

Each method invocation includes two hidden parameters: `self` and `cmd`.

* `self` is how the receiver's instance variables are made available to the
  method definition.

* Dynamic Loading - you can dynamically load bundles at runtime. This would be
  great for a plugin architecture.

* You can load / link new modules at runtime. See NSBundle on how to load
  bundles.

## Message Forwarding ##

Message forwarding allows you to forward a non-implemented method to a different
object. Typically, if you wanted to forward your method implementation another
class, you'd inherit from that class and override the methods. Unfortunately,
overriding is not always possible. If, for example, your object already inherits
from a base, you can't override the additional class. Also, what if you want to
forward a future message you have not accounted for at compile time? Overriding
`forwardInvocation:` allows us to intercept and forward a method to an arbitrary
class.

In this respect, *forwarding mimics features you typically want from multiple
inheritance*, without the object being part of the inheritance
hierarchy. While inheritance encourages large, multifaceted objects, forwarding
allows you to decompose problems into smaller objects - where messages could be
forwarded to multiple child objects.

	//
	// Override forwardInvocation: to forward objects
	// The runtime will only invoke `forwardInvocation` if the method
	// is *not* defined in the receiver's class.
	//
	- (void)forwardInvocation:(NSInvocation *)invocation {
		if ([otherObject respondsToSelector:[invocation selector]]) {
			[invocation invokeWithTarget:otherObject];
		}
		else {
			[super forwardInvocation:invocation];
		}
	}

	//
	// Note that if you forward a method, `respondsToSelector:` will
	// return NO for the selector you are forwarding (`respondsToSelector`)
	// will *only* look at the class definition.
	//
	// If you want your objects to act as if they respond to forwarded
	// selectors, you must override `respondsToSelector` to respond
	// appropriately.
	//
	- (BOOL)respondsToSelector:(SEL)selector {
		if ([super respondsToSelector:selector]) {
			return YES;
		}
		else {
			// Test whether you can forward the method. If so,
			// return YES;
		}
		return NO;
	}

	//
	// You also want to implement `instancesRespondToSelector`
	// and `methodSignatureForSelector` that returns the correct
	// signature from the object you are forwarding on to.
	//
	- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
		NSMethodSignature *signature =
		[super methodSignatureForSelector:selector];
		if (!signature) {
			// try your "surrogate" - the object you are forwarding messages to.
			signature = [surrogate methodSignatureForSelector:selector];
		}
		return signature;
	}




[objc-rpg]: https://developer.apple.com/library/mac/documentation/cocoa/conceptual/ObjCRuntimeGuide/Introduction/Introduction.html
