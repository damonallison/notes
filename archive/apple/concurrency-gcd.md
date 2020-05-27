# Threading Programming Guide #

## Run Loops ##

Don't use them unless absolutely necessary. Use GCD or NSOperationQueue, which
are newer, use threads more efficiently, and are much less error prone.

You cannot create or manage NSRunLoop(s). Each thread has an `NSRunLoop`
automatically created for it as needed.

NSRunLoop is *not* thread safe. You should only access the current thread's NSRunLoop.

* Is there a always single run loop per thread?

* Do threads come with their own run loop?

* Is GCD a better concurrent solution since an event can be sent to a generic
  FIFO queue (perhaps concurrent)?

A run loop is an event processing loop that is associated with a thread.

* Each thread has an associated run loop.
* Cocoa / carbon automatically sets up a run loop on †he main thread.

* Secondary threads need to set their run loops explicitly.

* You can install run loop observers on the run loop to monitor it.

### Run Loop Modes ###

* Each pass through the run loop only executes pending actions that were triggered on that run loop's mode.
* You can add custom modes to a run loop and associate input actions to that custom mode.
* Modes allow you to filter out events that were associated for a different mode.
* You might want to use a "modal" mode to keep non-modal events firing while the modal actions pile up.

---

# Concurrency Programming Guide #

* Don't attempt to roll-your-own threding. Threading is best left to the OS -
  it's in a better position to create and manage threads effectively. Use GCD or
  NSOperationQueue / NSOperation.

* NSOperationQueue : cocoa equivalent to GCD queues. They are much heavier than
  dispatch queues, but the queue can be managed (items popped off / dependencies
  between calls can be added / call graphs can be put together). Operation
  objects generate KVO events : allow you to monitor progress.

  GCD is preferred but there is a spot for NSOperationQueues - they provide
  better control, notification, and dependencies than GCD.

Keeping operations as stateless and discrete as possible will lend themselves to
parallelism really well. State and dependencies are evil.


* Blocks : introduced in OS X 10.6 / iOS 4.0.

* Serial dispatch queues are a more efficient alternative to locks when dealing
  with shared resources.

* Dispatch sources :
	* Timers
	* Signal handlers
	* File/socket descriptor events
	* Process events
	* Mach port events
	* Custom events that you trigger

Dispatch sources encapsulates a system event into a block object and adds that
block object to the dispatch queue when it occurs.

##### Operation Queues #####

Operation queues : obj-c version of a concurrent dispatch queue. (NSOperationQueue). Allows for
dependencies (one task can start when another ends). Your task must derive from
NSOperation. Operation objects provide KVO notifiations to allow for monitoring.

	* Support dependencies.
	* Support for a completion block to execute when the operation is complete.
	* KVO to monitor status / changes to the NSOperation
	* Priorities.
	* Canceling operations

By default, operations added to an NSOperationQueue are executed asynchronously. You never need to
write a concurrent operation object unless you want to manually execute the operation (i.e., not use
NSOperationQueue).



# Grand Central Dispatch #

Threading is hard. The OS is in a better position to deal with thread allocation
and optimization. Let GCD do threading.

The purpose of GCD is to abstract away threading and distribute actions across
cores. It also supports the delivery and coordination of underlying BSD events
(sources)


# Concurrency in iOS and OS X #

Queue types:

        Main : tasks execute on main thread. And again
        Concurrent : FIFO queue, multiple blocks executed simultaneously.
        Serial : FIFO queue, single block execution.


Private dispatch queues must be retained in your code.

Dispatch sources can be attached to a queue (which increments the retain count).
Cancel all sources and balance retains with releases.


## Dispatch Groups ##

Allow you to monitor a group of blocks (sync or async monitoring)
Groups are useful for monitoring a batch of blocks / waiting until a group of tasks finishes.

## Dispatch Semaphores ##

## Dispatch Sources ##

Sources raise events when actions occur (file descriptor, sockets, timers, etc..)

## Context Pointers ##
Context pointers : queues can make shared state available to all blocks executing on the queue.

        // create a function to be used as a finalizer.
        void myFinalizer(void *context) {
            // callled on finalization
        }
        dispatch_set_context(queue, data);
        dispatch_set_finalizer_f(serialQueue, &myFinalizer);


## Obtaining Queues ##

There are three global concurrent queues which differ only in priority. The
second parameter should always be 0 - its referred for future use.

        dispatch_queue_t defaultPriority = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_queue_t highPriority = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_queue_t lowPriority = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);

## Serial Queues ##

You must create your own serial queues to use. The queue name (reverse-dns) is used in debug tools.
The queue attributes (second parameter) should always be NULL (it's reserved for future use).

        dispatch_queue_t serialQueue = dispatch_queue_create("com.code42.testQueue", NULL);
        dispatch_release(serialQueue); // need to release the queue.

