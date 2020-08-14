# Ubuntu

## apt

"Advanced Package Tool" is Debian and Ubuntu's package manager. 

```shell
#
# apt-get
#
# apt-get synchronizes packages from their sources. Packages are fetched 
# from the locations specified in /etc/apt/sources.list
# 
# Always update before doing an `upgrade` or `dist-upgrade`
#
apt-get update

#
# Upgrades currently installed packages *only*
#
# New versions of currently installed packages that cannot be upgraded
# without changing the install status of another package will be left at
# their current version.
#
apt-get upgrade

#
# Installs or upgrades a single package
#
apt-get install emacs

#
# Upgrades all installed packages and updates dependencies
# where appropriate
#
apt-get dist-upgrade

#
# Updates the package cache and checks for broken dependencies
#
apt-get check

#
# Cleans out the local repository of cache files
#
apt-get clean

# Cleans and removes package files that can no longer be downloaded
apt-get autoclean

# Removes pacakges that were installed to satisfy other dependencies
# for other packages and are no longer needed
apt-get autoremove

#
# apt-cache does *not* update the system, but allows you to search
# and inspect package metadata
#
apt-cache search emacs

# Information about a particular package
apt-cache showpkg emacs

```

## snap

```shell

snap help --all

snap find [app]
snap info snap-name
snap list
snap install
snap remove

# print configuration options for the snap
snap get snap-name


```