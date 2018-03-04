# xplat

* Cross platform can provide code and skillset reuse.
* When using Javascript, deployments do *not* always require app store releases.
* The best mobile developers will still need to know iOS and Android at a deep level.
* You are going to have custom iOS / Android code in most applications, but xplat approaches will save you from *always* needing custom code.
* Writing both apps from a single codebase simplifies things *a lot*.

## Goals

* Single codebase.
* Code / skills reuse.
* Web : Simplify deployments and maintenance. Avoid app stores, update clients via servers.

## Weaknesses

* Abstraction layers.
	* Least common denominator.
	* Does not fully exploit underlying platforms.
	* New platform features won’t be available immediately.

* There is no escaping the need to understand the underlying platforms.

## Strategy : which is best?

There is no "right" strategy for every project. The "right" strategy depends on the team, product, and company strategy.

* Strategy
	* Is mobile a competitive differentiator for the company?
	* Are the users internal or external? External is more demanding.
* Team
    * What is your current (or desired) engineering skillset?
 * Product
    * How tied into native features is the app?
		* messaging, camera, notifications, background, custom functionality
    * UX
		* Do you want a custom look/feel across both, or to follow platform conventions?
        	* If custom, favors non-native UI controls like Flutter / Web.
        	* If you want “native” look / feel
				* Favor Xamarin / React Native which use native controls.
        	* High read-only, layout heavy UI favors the web.
* Performance
	* Web apps are slower.

## xplat Approaches

### HTML / CSS / JS

With this approach, all development is done via web technologies.

* Rendering is done inside a web view.
* Native components (plugins) provide access to platform / OS / HW features.
* Ionic (Cordova) uses this approach.

#### Strengths

* Rapid development. All based on web technology.
* Cordova based. Entirely web views.
* Apps can be updated via server push.

#### Weaknesses

* Microsoft moved their JS focus from Cordova to React Native.
	* Preferred native controls over web views.
* Renders as a web view, not native controls.
* Limited SDK access thru Cordova plugins.
* Not good for complex apps.

#### Recommendation

* Use when the app requirements are mostly read only or layout heavy.
* Don't use when complex, native SDK access is needed.

### React native

React Native is a set of react extensions that render views as native iOS / Android controls.

#### Strengths

* Views compile down to native controls.
* All native libraries have abstraction layer bindings.
	* Least common denominator.
* Deployment : Push js updates w/o an App / Play Store release. (Microsoft CodePush).
	* As long as your dependencies and permissions do not change, you can update w/o an App Store release.
* Hot reload : real time code reload.
* Flux unidirectional flow > Xamarin’s MVVM.
* Simple. Relies on React's view/state management and UI redraw on state changes.

#### Weaknesses

* Javascript
* Intermediary libraries needed for native features. Not part of React Native proper.
* Native needed for:
	* Push Notifications
	* Deep Linking
	* Native UI components (Maps?) needing to be exposed to react.

#### Recommendation

* Obviously ideal for companies who have an investment in JS (everyone?) / React.
*

### Xamarin

Xamarin can be thought of as a "native" cross platform framework. Developers have access to native platforms, as well as the .NET BCL.


#### Strengths

* Full iOS / Android Platform API access **and** .NET BCL.
* C#. Type safety. No Javascript.
* Flexible xplat vs. native story
	* You can write all your code in C# / Xamarin.Forms. Xamarin.Forms is an xplat port of Windows.Forms.
	* Easily mix in native code / UI (xib) as needed.
		* 	* Xamarin.Forms compiles down to native controls.
* Can create UX that is indistinguishable from native (since it renders into native controls).


#### Weaknesses

* Feels like Microsoft is embracing Javascript / React more than Xamarin.
* Compile times and project setup is time consuming and slow.

#### Recommendations

* Consider Xamarin when you have a heavy .NET investment.
* Use if you want complete access to the underlying platform SDKs at a low level.



## Flutter

* [Easy and fast SDK for beautiful apps  - Flutter](https://flutter.io/)
* Written in Dart.


## xplat frameworks

* KendoUI
* Titanium
* Cordova (PhoneGap)
* Ionic
* React Native
* jQuery Mobile
* Xamarin


## Links

### Comparisons

* [Xamarin vs Ionic](https://www.iflexion.com/blog/cross-platform-development-wars-xamarin-vs-ionic/)
	* Recommends Ionic for "web like" applications which do not require access to native features.
	* Recommends Xamarin to .NET shops, when you want / need apps to look fully "native".
