# Launchd

* Config files must not be group or world writable (from man launchctl)
* Allowing non-root write access to /System/Library/LaunchDaemons will make your system unbootable (from man launchctl)

Session Types : what are these?
	Aqua, LoginWindow, Background, StandardIO, System.

Domains : system, local, network, all

LaunchDaemons : system-wide (must be owned by root)
LaunchAgents : user-specific


     ~/Library/LaunchAgents         Per-user agents provided by the user.
     /Library/LaunchAgents          Per-user agents provided by the administrator.
     /Library/LaunchDaemons         System wide daemons provided by the administrator.
     /System/Library/LaunchAgents   Mac OS X Per-user agents.
     /System/Library/LaunchDaemons  Mac OS X System wide daemons.



# Daemons and Services Programming Guide #

* NSProcessInfo : your process should support sudden termination.
* For system shutdown, the system sends SIGTERM followed by SIGKILL.

* Daemons installed globally (LaunchDaemons) must be owned by the root
  user. Agents installed for the current user (LaunchAgents) must be owned by
  that user. All daemons and agents must not be group writable or world
  writable. (That is, they must have file mode set to 600 or 400)

## Login Items ##

* Login Items are basically app shortcuts that are launched by windowserver on
  user login. We could launch SPS and SPD as a Login Item.

* Installing using Service Management Framework : not visible in system
  preferences - must be uninstalled by application.

* Installing via Shared File List (LaunchServices) : visible in system
  preferences, user can disable.

## XPC Services ##

* Geared around a *single application* (bundle specific). Since this engine will
  be used from multiple Code 42 products, it would not be appropriate for
  us. Also, we don't support the XPC communication mechanism - we have a TCP
  based process communication. Daemons are a better choice.

## Launch Daemons ##

Use this for the *root mode* service. The trick will be to understand how to
write out data that is readable by all users (put all users in a "shareplan" bsd
group?). All SPD instances can connect to the launch daemon

* Root owned.
* Does not have access to user logins.

## Launch (User) Agents ##

* User-level, launchd managed processes.
* Started by windowserver on user login.

## Notes | Questions ##

* NOTE : launch agents | daemons can support non-launch-on-demand scenarios, but
  that scenario is not recommended. Use the OnDemand plist field to specify the
  OnDemand process characteristics.

* man launchd.plist (parameters for a launchd plist file)
