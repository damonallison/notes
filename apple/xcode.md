# XCode

## Environment

### Provisioning Profiles

```bash

#
# Provisioning profiles can be downloaded from https://developer.apple.com
# or via XCode -> Preferences -> Account
#

$ ~/Library/MobileDevice/Provisioning\ Profiles

```

### Importing Keys

There is a bug in macOS which prevents importing a public key into Keychain. The following command will import a public key (`.pem`) into Keychain.

```bash

#
# Import key into Keychain
#
# Note: This keychain will be named "Imported Public Key" since the .pem
# doesn't contain any naming.
#
$ security import pub_key.pem -k ~/Library/Keychains/login.keychain


```