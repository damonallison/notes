# Advanced Mac OS X Programming #

## Comments ##

* Chapter 3 : Blocks

  Need to find better information on block object, variable capture, etc.

* Chapter 4 : Command Line Programs

  Show readers the Framework (NS) way to access process info, arguments, environment.
  [NSProcessInfo processInfo]

* GCD queues have auto-release pools. When do they drain? After each block, or
  after the queue is emptied?

* Need a better description of self capture - when will self be captured, when to __weak?

* When do we need to use Block_copy (if ever)?

* Where did he get his material for block operations?
* Enum declaration the "new" way (specify type)
* Clang modules.
* Arc.

* What do the various system library paths mean?
		/Library/Frameworks
		/System/Library/Frameworks
		~/Library


## Compiler Tools ##

Notes on clang, xcode build settings, arc, and other compiler tools.



## Clang ##

* What are the clang options / switches for compilation? The goal is to fully
  understand what clang's options are.

#### Preprocessor ####

	// <> == included as a "system" header
	// What is the system path used to resolve "system" headers?
    #include <stdio.h>


## Chapter 6 : Libraries ##

** When embedding frameworks, how to tell dyld to load from the private Frameworks dir, not /Library/Frameworks?

Golden Rule :
	Include frameworks inside your application bundle. Do not go down the route of trying to install frameworks into /Library/Frameworks - this requires permission escalation and is a general pain. Disk space / RAM is plentiful enough.

Library types:

	Static Library

		Static libraries are compiled directly into the application. They are very simple to work with. The downsides:

			1. The same library will be compiled into all applications and loaded into each process's memory space at runtime.

		Using a static library:
			-L Library/Directory :: tell the compiler what directory to look in.
			-l foo (libfoo.a) :: tell the compiler what library to load (lib and .a are inferred)

	Dynamic Library

		* Smaller executables.
		* Loaded on demand.

		Downsides:
			* Dynamic libraries do not contain headers / assets / etc.

	Framework
		* A dynamic library w/ headers / assets / etc.
		* Frameworks do *not* get split up
			(lib to /usr/lib, headers to /usr/include)
