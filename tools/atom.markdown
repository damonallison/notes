# Atom Text editor #

## TODO ##

* TODO : tree view command list (review package source).
* Do not open a new window on atom launch (open last).

##### Likes #####

* Live markdown preview (fantastic).
  * BUG : Markdown focus needs to follow the editing position.


* Package / theme integration (text editor table stakes).
* Simple to navigate the project tree view.

* Packages
  * [Editor Stats](https://github.com/atom/editor-stats)
    * Fun, useless stats!


* apm package management tool.

##### Dislikes #####

* Switching between panels (cmd-k, cmd-right/left) - too difficult to find the correct arrow key by feel. Going from left / right and back with my index finger on `k` and pinky on the `arrow` keys, it's difficult for me to move between left/right. I need to rebind those keys.

* We need a better line wrapping package. The current line wrap does not auto-truncate at 80.

## Overview ##

3 main pieces of atom:

* atom core : base frame / window functionality. Goal is for a small core.
* apm : currently a front-end for atom.io. Goal is to standardize the back-end API for others to host their own package registry.
* atom shell : Chromium / node integration to host "native" apps on top of Chromium.

## Keybindings ##

#### Navigation ####

* `cmd-t`       - search list of all files.
* `cmd-b`       - search list of open files.
* `cmd-shift-b` - search list of modified or untracked files in the current git repo.
* `cmd-r` - jump to symbol
* `cmd-shift-r` - jump to symbol in project (requires ctags)
*

#### Tree View ####
* `Ctrl-0` - focus tree view.
* `Cmd-\` - toggle tree view open / closed.
* `a` - add a file
* `m` - rename file
* `delete` - delete file
* `ctrl-[` - collapse node
* `ctrl-]` - expand node


#### Packages (apm) ####

$ apm clean
$ apm rebuild
$ apm upgrade (outdated)

$ apm docs (home)
$ apm uninstall (deinstall, erase, delete, remove, rm)
$ apm list (ls)
$ apm stars (starred)



#### Code Editing ####
* alt-cmd-[         : fold
* alt-cmd-]         : unfold
* alt-cmd-shift-[   : fold all
* alt-cmd-shift-]   : unfold all

#### Files / Tabs / Panes ####
* cmd-t              : find file
* cmd-b              : find file (open buffers only)
* cmd-r              : goto symbol
* cmd-k left/right/up/down     : open file in new pane to left / right / up / down
* cmd-k cmd-left/right/up/down : switch current pane left / right / up / down

#### Project Tree View ####
* cmd-shift-\       : reveal current item in the tree view
* cmd-\             : toggle the sidebar in the tree view
* ctrl-0            : move focus to the tree view
* a                 : add file
* delete            : delete
* m                 : rename
* ctrl-]            : expand directory
* ctrl-[            : collapse directory
