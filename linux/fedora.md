# Fedora

## Update dnf

```bash

# Upgrades all system packages
$ sudo dnf distro-sync
```

## Setup VirtualBox Guest Additions

### Install Dependencies

```shell

#
# Install kernel-devel - allows GA to build modules against the kernel
#
$ sudo dnf install kernel-devel

#
# Install GA dependencies
#
$ sudo dnf install gcc make perl


### Install GA

* Machine -> Install Guest Additions menu item.
* Open the `Files` application in Fedora. Open the CD ROM drive.
* Click the `Install Software` button in the window chrome.
