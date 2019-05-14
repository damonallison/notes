# New Mac Setup

## System Preferences

### Become an Admin

* Users & Groups
	* `Allow this user to administer this computer`.
	* Set avatar
* Keyboard -> Use `F1`, `F2`… keys as standard function keys.
* Keyboard -> Shortcuts -> Mission Control
	* Disable “Show Desktop” (F11)
	* Disable “Show Dashboard” (F12)

## Setup sudo

```
$ sudo visudo

# Edit the line:
%admin ALL=(ALL) ALL

# To say:
%admin ALL=(ALL) NOPASSWD: ALL
```

### iCloud

* Enable iCloud in `System Preferences`.
* Open `Messages` and `FaceTime`, disable iCloud.

## App Store

* Bear (if logged in as `damon@damonallison.com`
* Xcode

## Homebrew

* [homebrew](https://brew.sh/)

```
$ brew cask install iterm2
$ brew cask install spectacle
$ brew cask install sourcetree
$ brew cask install dotnet-sdk
$ brew cask install dotnet
$ brew cask install slack


$ brew install fish
$ brew install emacs
$ brew install git
$ brew install tree
$ brew install python

# Adds alternate (beta) casks
$ brew tap homebrew/cask-versions

$ brew cask install visual-studio-code-insiders
```

## Spectacle

* `⌃⌥⌘F` - Full Screen (Editors override the default `⌥⌘F`)
* `⌃⌥⌘C` - Center
* `⌃⌥⌘→` - Right Half
* `⌃⌥⌘←` - Left Half
* `⌃⌥⌘↑` - Top Half
* `⌃⌥⌘↓` - Bottom Half

## Fish
```
# Add fish to your list of shells

sudo emacs /etc/shells

# Add this line
/usr/local/bin/fish

# Then run (makes fish the default):
$ chsh -s /usr/local/bin/fish
```

### Oh My Fish
*  [https://github.com/oh-my-fish/oh-my-fish](https://github.com/oh-my-fish/oh-my-fish)

###  Bass

Bass allows you to run bash utilities in fish. It works by capturing environment variables modified by the bash utility and replaying the changes in fish.

* [GitHub - edc/bass: Make Bash utilities usable in Fish shell](https://github.com/edc/bass)

### Theme (bobthefish)
```
$ omf install bobthefish

# bobthefish should be the new default theme. To ensure it is, run:
$ omf theme bobthefish

# Download / install powerline compatible fonts.
# Homebrew has a cask dedicated to fonts.

$ brew tap homebrew/cask-fonts

# Search for fonts

$ brew search font
$ brew cask install font-hack-nerd-font

# In iTerm -> Preferences -> Profiles -> Text -> Set Font to "Hack Nerd Font"
# In VS Code. Add "Hack Nerd Font" to the font string (JSON settings)

```

## Visual Studio Code

Settings are saved to [gist.github.com] using the [Settings Sync](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync)
plugin.

In the `Code Settings Sync` extension, enable `Auto Download` and `Auto Upload`.

`Code Settings Sync` requires a token to use with github:

```
Token: (Token stored in Bear - not in github)
```

## Node

* Follow node setup instructions at:
	* https://github.com/damonallison/javascript/blob/master/documentation/tools.md

## Anaconda

* Follow Anaconda setup instructions at:
    * https://github.com/damonallison/python-examples/blob/master/documentation/anaconda.md
