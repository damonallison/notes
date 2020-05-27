# Daemons / Agents #

## Types of background items ##

#### Login Item ####
Started by launchd (not managed by launchd) : run in user context : can present UI.

Login items are typically used for launching apps : menu bar for example. Could be used to register a hotkey.

#### XPC Service ####

Helper applications that other applications use. Apple is positioning them in
a sandbox perspective as helper applications that only require limited
permissions, reducing the security footprint.

#### Launch Daemon ####

Managed by launchd. One launch daemon per system. Runs as root. Has no knowledge of users. Cannot present UI.


#### Launch Agent ####

A user level launch daemon. Managed by launchd, UI not recommended.

### Communicating with Daemons ###

* XPC - easy, only available for communication within the same bundle.
* IPC via sockets / pipes
* RPC (Distributed Objects, Mach RPC) -- don't use
* Memory mapping -- don't use


## Daemon Lifecycle ##

launchd :
	Launches on demand. Handles dependencies.

Terminating an application : each process is sent SIGTERM folloed by SIGKILL.
applicationShouldTerminate in cocoa.


## Adding Login Items ##

There are two ways to install a login item. The difference is the user control over their uninstallation.

1. Install using the Service Management framework.

	* Helper apps are installed in Contents/LoginItems/Bundle.app
	* Set LSUIElement or LSBackgroundOnly key in Info.plist of the helper's app bundle.

	* Use SMLoginItemSetEnabled() to start the app and enable at login or terminate app and remove from login.
	*

2. Use Shared File List (LS... API)

## XPC Services ##

XPC services are sold as process separation for stability and lowering the
attack vector on an app. (i.e., use helper tools that can run sandboxed and are
thus more secure).




Communicating x-process:

	1. NSXPCConnection (10.8 and newer)
	2. XPC Services API : C based (10.7 and newer)


XPC connections are bi-directional. All XPC methods must return void (they are async). Callback blocks can be passed in.

@protocol FeedMeAWatermelon
    - (void)feedMeAWatermelon: (Watermelon *)watermelon reply:(void (^)(Rind *))reply;
@end

All objects passed in NSArray | NSDictionary classes passed through XPC need to be "white-listed". All objects must conform to NSSecureCoding.


https://developer.apple.com/library/mac/#documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/Introduction.html#//apple_ref/doc/uid/10000172i

Service : supports a full GUI application.
Daemon  : no GUI (httpd).


[services-deamons]: https://developer.apple.com/library/mac/#documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/Introduction.html#//apple_ref/doc/uid/10000172i


