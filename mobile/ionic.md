# Ionic

* Ionic is simply set of UI Components. That's it. You can download / use ionic
  components w/o a full angular / react / vue app.
* Full web view programming model w/ cordova support for native features.
* Supports Angular natively, React and Vue support coming with v4.
* Ionic 4 moved to web components, making it UI framework agnostic (Angular, React, Vue).
* Major releases every 6 months, minor every month, patch every other week.
* Uses `WKWebView` on iOS, `Web View` on Android.

* AppFlow
  * Build / deploy from a centralized dashboard.

## Key Features

* UI Component library. Themeable, iOS (UIKit) / Android (Material) platform
  aware (Called "Platform Continuity").
  
* Web defaults to material.
* Navigation - Angular Router
* ionic lab - iOS / Angular side by side.

## TODO

### Angular / Ionic

* Get app running in DevApp.
* Ionic Native (just Cordova?)
* AppFlow starter plan.
* @ionic/angular - integration into core angular libraries (router)
* Navigation - Angular Router
* npm packages (run / deploy iOS to the sim) - ios-sim ios-deploy
* Angular lifecycle events
  * Ionic lifecycle events (ionView[Will|Did]Enter, ionView[Will|Did]Leave)
* Storage (LocalForage)
  * SQLite on mobile. Avoids iOS / Android sweeping caches on low disk space.
  * On web, uses IndexedDB, WebSQL, localstorage in that order.
  
* Cordova

* Jasmine (unit tests)

### Web 

* Web Components

### Delve

* iOS / Android setup (iOS provisioning, Android Studio + SDK / `adb`)


```shell

// Enable cordova
$ ionic integrations enable cordova --add

// Setup iOS / Android native project
$ ionic cordova prepare ios
$ ionic cordova prepare android


```

```

//
// Detect if you are on device vs web
//
this.platform.ready().then(() => {
  if (this.platform.is('cordova')) {
    // make your native API calls
  } else {
    // fallback to browser APIs
  }
});

```
