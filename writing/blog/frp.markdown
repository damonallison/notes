# Functional Reactive Programming #

All event types are consolidated into "signals". A signal represents an observable stream of a value that changes over time. When a value changes, the signal is updated. Listeners who subscribe to the signal are notified when the signal changes.

Signals are combined with functional programming to perform advanced processing on signal changes. Signals can be mapped into new values, combined (merged), filtered, delayed, processed on a different thread, combined, etc.

Functional Reactive Programming encourages stateless design. Signals can be occurring asynchronously and once all complete, combined into a new signal which is subscribed to. Concurrency is effortless when there is no state involved.

## Reactive Extensions (Rx) ##

Reactive extensions (Rx) is Microsoft's FRP library which other implementations are based from. The authors of Reactive Cocoa (the Objective-C FRP implementation) based Reactive Cocoa on the Rx implementation.
