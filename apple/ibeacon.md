# iBeacon

## TODO

* Determine if we consistently receive CB events while in the background.
* What is this? `[CoreBluetooth] XPC connection interrupted, resetting`

---------------


iBeacon has two basic interaction models:

1. **Region monitoring**: Actions triggered on BLE region enter/exit. Works in the foreground, background, and even when the app is killed.
1.  **Ranging**: Actions while in the proximity of a beacon. Works only in the foreground.

## iBeacon Monitoring

### Region Monitoring

When region monitoring, iOS will keep listening for beacons **at all times**. It will launch your application in the background if needed and let it execute code for a few seconds to handle the event.


* For iBeacon region monitoring, we need `Always` access to Core Location.
    * `Info.plist` needs a value for `NSLocationAlwaysUsageDescription`

* You do *not* need any `Background Modes` enabled for beacon enabled app to work in the background. (You may need one for Eddystone - which is Core Bluetooth based).



## Links

* [Estimote iBeacon Tutorial](http://developer.estimote.com/ibeacon/)
