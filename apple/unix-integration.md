# Unix integration

## Signal Processing

[Signal (IPC)](https://en.wikipedia.org/wiki/Signal_(IPC))

### Signals

* `Ctrl-C == SIGINT` : causes the process to terminate.
* `Ctrl-\ == SIGQUIT` : causes the process to terminate and dump core.

* `SIGSEGV` : A segmentation fault (memory access violation). The process attempted to access memory it doesn't own.
* `SIGABRT` & `SIGIOT` : Abort process. Typically sent to the process itself by calling `abort()`, but it could be sent outside of the process.
* `SIGFPE` : Floating point error. Usually caused by division by zero.
* `SIGHUP` : "Hangup" - the process's controlling terminal has exited.
* `SIGINT` : Interrupt the process.
* `SIGKILL` : Causes the process to terminate immediately. Usually sent as a
  last resort. if a process does not volutarily exit when receiving `SIGTERM`.
* `SIGQUIT` : Quit and perform a core dump.
* `SIGSTOP` : Stop the process to be resumed later.
* `SIGTERM` : A signal meant to stop termination. Unlike `SIGKILL`, `SIGTERM` can be caught. Nearly identical to `SIGTERM`.


#### Handling Signals

Each process must setup a signal handler using the `signal` or `sigaction` system call.

`SIGKILL` and `SIGSTOP` cannot be intercepted and handled. Signals should be handled