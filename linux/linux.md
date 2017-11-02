# dnf

## Switches

```
--debuglevel=[0-10]
--version
--help [-h]
--verbose [-v]
--refresh  # set metadata as expired before running the command
```

## Cleaning

```
# Cleans out caches, metadata, and packages
$ dnf clean all

# Download and caches (in binary format) metadata for all known repos.
$ dnf makecache

# Removes all leaf packages which are not referenced and originally installed as a dependency to another package.
$ dnf autoremove
```

## Updating

```
# Checks if updates are available
$ dnf check-update [<package-specs>...]

# Upgrades packages to match the latest version available
$ dnf distro-sync [<package-spec>...]


$ dnf search emacs
$ dnf install emacs
```


## List command

```
$ dnf list upgrades [list upgrades available to the installed packages]
$ dnf list installed
$ dnf list autoremove [list packages which will be removed by the `dnf autoremove` command]

$ dnf provides <provide-spec>
finds the package providing <provide-spec>

$ dnf reinstall <package-spec>
$ dnf remove <package-spec>

$ dnf repolist

$ dnf group list [shows the available groups]
$ dnf group info <group-spec>
```