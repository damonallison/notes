# xplat

## Goals / Strengths

* Single codebase.
* Reuse well known programming environments (JS or C#).
* Simplify deployments and maintenance.

## Weaknesses

* Abstraction layer.
	* Least common denominator.
	* Does not fully exploit underlying platforms.
* New platform features won’t be available immediately.

## Strategy : Should we use cross platform tools? Which ones?

 * Product
    * What are the goals of your app?
    * How tied into native features is the app (messaging, camera, custom native frameworks, etc).
    * UX : Do you want a custom look/feel across both, or to follow platform conventions?
        * If custom, favors non-native UI controls like Flutter / Web.
        * If you want “native” look / feel, favors Xamarin / React Native which use native controls.
        * High read-only, layout heavy UI favors the web.

* Team
    * What is your current engineering skillset?


## Xamarin

* Feels like Microsoft is embracing Javascript / React more than Xamarin.

* Flexible xplat vs. native story
	* You can write all your code in C# / Xamarin.Forms. Xamarin.Forms is an xplat port of Windows.Forms.
	* Easily mix in native code / UI (xib) as needed.
		* 	* Xamarin.Forms compiles down to native controls.

* Full iOS / Platform API access.
* C#. Type safety. No Javascript.

## React native

* Views compile down to native controls.
* All native libraries have abstraction layer bindings.
	* Least common denominator.
* Deployment : Push js updates w/o an App / Play Store release.
* Hot reload : real time code reload.
* Flux unidirectional flow > Xamarin’s MVVM
* Javascript.
* Native needed for:
	* Push Notifications
	* Deep Linking
	* Native UI components (Maps?) needing to be exposed to react.

## Ionic (Angular) / Cordova

* Cordova based. Entirely web views.

* Microsoft moved from Cordova to React Native.
	* Preferred native controls over web views.

* Renders as a web view, not native controls.

## Flutter

* [Easy and fast SDK for beautiful apps  - Flutter](https://flutter.io/)
* Written in Dart.
