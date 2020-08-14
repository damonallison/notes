# New Mac Setup

## System Preferences

### Become an Admin

* Users & Groups
	* `Allow this user to administer this computer`.
	* Set avatar

#### Function Keys

If you are on a Mac w/o a touch bar:
* Keyboard -> Use `F1`, `F2` keys as standard function keys.

If you are on a Mac w/ a touch bar:
* Keyboard -> `Touch Bar shows: F1, F2, etc. Keys`

* Keyboard -> Shortcuts

* Mission Control - Disable all shortcuts mapped to Fn keys
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

## Set screenshots dir to /tmp

```shell
# On Mohave or later

Cmd-Shift-5 -> Options -> Save to -> Other Location -> /tmp
```

## App Store

* Bear (if logged in as `damon@damonallison.com`
* Xcode
* Microsoft To Do

## Homebrew

* [homebrew](https://brew.sh/)

```
$ brew cask install iterm2
$ brew cask install spectacle
$ brew cask install sourcetree
$ brew cask install dotnet-sdk
$ brew cask install dotnet
$ brew cask install slack
$ brew cask install postman

$ brew install fish
$ brew install emacs
$ brew install git
$ brew install tree
$ brew install python
$ brew install htop

// gotop - a better version of top (written in go)
$ brew tap cjbassi/gotop
$ brew install gotop

// mas - a command line tool for interating with the Mac App Store
$ brew install mas

# Adds alternate (beta) casks
$ brew tap homebrew/cask-versions

$ brew cask install visual-studio-code
```

## Configuration

Download the `config` repository from https://github.com/damonallison/config

```shell
# Symlink configuration files (assuming config was downloaded to ~/ateam)

ln -s ~/ateam/config/.ssh ~/.ssh
chmod 400 ~/.ssh/id_rsa ~/.ssh/id_rsa.pub

ln -s ~/ateam/config/.bash_profile .bash_profile
ln -s ~/ateam/config/.bashrc .bashrc
ln -s ~/ateam/config/.emacs .emacs
```
## iTerm

* Pastel color pallet (makes blues less dark)

```shell
Preferences -> Profiles -> Colors -> Color Presets -> Pastel (Dark Background)
```

* Setup option keys to act as meta (allows for full word delete)

```shell
Preferences -> Profiles -> Keys -> Left Option(⌥) Key -> Esc+
Preferences -> Profiles -> Keys -> Right Option(⌥) Key -> Esc+
```

* Setup `Status Bar` (mini map)

```shell
Preferences -> Profiles -> Session -> Status bar enabled
Configure status bar
```

* Change default font to `Hack Nerd Font Mono` or something else.

```shell
Preferences -> Profiles -> Text -> Font
```

* Open new windows with a larger default size

```shell
Preferences -> Profiles -> Window -> Settings for New Windows: 140x80 (16" mbp)
```

## Spectacle

* `⌃⌥⌘F` - Full Screen (Editors override the default `⌥⌘F`)
* `⌃⌥⌘C` - Center
* `⌃⌥⌘→` - Right Half
* `⌃⌥⌘←` - Left Half
* `⌃⌥⌘↑` - Top Half
* `⌃⌥⌘↓` - Bottom Half

## RVM

```shell

# install gpg
$ brew install gpg

# install RVM - follow directions on https://rvm.io/

$ rvm list known

# install the latest major version
$ rvm install ruby-2.6
$ rvm list # to see what version you have installed

# create a gemset
$ rvm --create 2.6.3@damon

# make the gemset the default
$ rvm use ruby-2.6.3@damon --default
```

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

NOTE: You *may* not need this.

Bass allows you to run bash utilities in fish. It works by capturing environment variables modified by the bash utility and replaying the changes in fish.

* [GitHub - edc/bass: Make Bash utilities usable in Fish shell](https://github.com/edc/bass)

```shell
$ omf install bass
```
### Theme (bobthefish)

```shell

$ omf update
$ omf install bobthefish

# bobthefish should be the new default theme. To ensure it is, run:
$ omf theme bobthefish
```

## Fonts

* Download / install powerline compatible fonts. Homebrew has a cask dedicated to fonts.

```shell
$ brew tap homebrew/cask-fonts

# Search for fonts

$ brew search font
$ brew cask install font-hack-nerd-font

# In iTerm -> Preferences -> Profiles -> Text -> Set Font to "Hack Nerd Font"
# In VS Code. Add "Hack Nerd Font" to the font string (JSON settings)
```

## git

```shell
$ git config --global core.editor emacs
$ git config --global core.name "Damon Allison"
$ git config --global core.email "damon@damonallison.com"

# Use FileMerge.app as the default merge tool
$ git config --global merge.tool opendiff
```
## Node

* Follow node setup instructions at:
	* https://github.com/damonallison/javascript/blob/master/documentation/tools.md

## Anaconda

* Follow Anaconda setup instructions at:
    * https://github.com/damonallison/python-examples/blob/master/documentation/anaconda.md

