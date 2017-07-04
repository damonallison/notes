## Creating A Private Framework ##

### Step 1: Create the framework ###

* Create the Framework in Xcode.

* Change the "Installation Directory" (`INSTALL_PATH`) build setting of the
  framework to `@executable_path/../Frameworks`. This path is where dyld will
  load the framework from.

* Add all headers to the "Copy Headers" framework build phase. These headers
  will be copied to Framework.framework/Headers


### Step 2: Link the Framework ###

* Add the Framework's .xcodeproj to your main application (Add Files to project,
  select .xcodeproj of framework).

* From Build Phases of your application, add the framework as a Target
  Dependency.

* From Build Phases of your application, add the framework to the "Link Binary
  With Libraries".

* From Build Phases of your application, add a "Copy Files" build phase
(Editor Menu -> Add Build Phase. Select "Frameworks" as the destination. Add
the framework.

**Build and Prosper**


		
	
## Creating a bundle ##

### Step 1 : Create the bundle ###
* New project -> Bundle

* On bundle target "Info" - set "Principal Class" == Your principal class.

* NOTE : you probably want your principal class to implement a known protocol - share this protocol 
  with the loading app so it understsands what interface to use when creating an instance of your
  principal class.

### Step 2: Link the Bundle

* Add the bundle to your .xcodeproj.

* From Build Phases of your application, add the bundle as a Target
  Dependency.

* From Build Phases of your application, add the bundle to the "Link Binary
  With Libraries".

* From Build Phases of your application, add a "Copy Files" build phase
(Editor Menu -> Add Build Phase. Select "PlugIns" as the destination. Add
the bundle.
