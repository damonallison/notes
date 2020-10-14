# launchd

[What is launchd?](whatis)

Launchd is a framework for managing daemons, applications, processes, and scripts.

* daemon - a process running under root or a user specified with `UserName`
* agent - a process running on behalf of the logged in user


| Type | Location | Run on behalf of |
| ---- | -------- | ---------------- |
| User Agent | ~/Library/LaunchAgents | Logged in user |
| Global Agents | /Library/LaunchAgents | Logged in user |
| System Agents | /System/Library/LaunchAgents | Logged in user |
| Global Daemons | /Library/LaunchDaemons | root or `UserName` |
| System Daemons | /System/Library/LaunchDaemons | root or `UserName` |


## Defining Jobs

* `Label` (required) - The job identifier (must be unique)
* `Program` (required) - The program to start
* `RunAtLoad` (optional) - bool to start the job when loaded
* `KeepAlive` (optional) - bool to start the job when loaded and restart on failure





[whatis]: https://www.launchd.info/