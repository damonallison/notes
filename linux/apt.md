# Debian

## Apt

`apt` is a high level interface for package management.

`apt-get` and `apt-cache` are lower level tools.

```bash

# Refresh the apt cache. apt-cache uses the apt metadata.
$ sudo apt update

# Find a package [-n == search names only]
$ apt search [-n] emacs

# Get information on a package
$ apt show sudo

```