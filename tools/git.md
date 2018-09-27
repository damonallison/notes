# Pro Git : Scott Chacon

## TODO

* Document <refspec>.
* How to determine a common ancestor (multiple branches)?

## Git Philosophy / Basics

* Git goals
  * Fast
  * Simple
  * Non linear (thousands of parallel branches)
  * Distributed
  * Scalable (handle large projects - Linux kernel)
  * Safe by default

* git (all DVCSs) keeps a copy of the entire repo on each client. This makes
  everything (history browsing) extremely fast since very few commands use the
  network.

* DVCS completely mirrors the repo locally. This allows for multiple workflow
  strategies, like hierarchal models (git flow).

* Everything has integrity (SHA-1 checksums) - files, tags, commits, trees,
  stashes.

* git is safe by default. If actions would result in data loss it will prevent
  it by default. For example, git will only allow you to push to a remote branch
  if the push results in the branch being fast-forwarded. If the remote branch
  cannot be fast-forwarded, the push will fail. This safety can be overridden
  (-f for most commands) but it follows git's "safe by default philosophy"

* 3 stages - committed, staged, modified. The staging area is called the index
  in git's internals.

Think of git as a database that has three trees:

* HEAD - the current commit pointer.
* Index - proposed next commit (changes that are staged).
* Working directory - your "sandbox" on the file system.

* Changes go from your working directory -> index -> history (committed)

### Git configuration

git has three levels of configuration, ranging from lowest priority (global) to
highest priority (local). If a setting is defined at multiple levels, the
highest priority value is used.

#### System - `/etc/gitconfig`

System configuration applies to all users. This is typically not needed.

`$ git config --system <setting> <value>`

#### Global - `~/.gitconfig`

Global is user wide, applying to all repos.

`$ git config --global <setting> <value>`

#### Local

Local applies to the current repository in `./git/config`

`$ git config <setting> <value>`

#### Common Configuration Values

The following variables are helpful defaults when setting up git on a new machine.

```bash
#
# User level settings
#
$ git config --global user.name "Damon Allison"
$ git config --global user.email "damon@damonallison.com"
$ git config --global core.editor "code -w"

# Always track a remote branch (--track) when doing a checkout.

$ git config --global branch.autosetupmerge=always

#
# When creating a new branch, always setup a remote tracking branch with the
# same name.
#
# `branch.<name>.remote
    # `branch.<name>.merge
#
$ git config --global branch.autoSetupMerge always

// Use Apple's "FileMerge.app" merge tool.
$ git config --global merge.tool opendiff

// Shows a list of all submodule commits as part of diff output
$ git config --global diff.submodule log

// Show a short summary of changes to your submodules
$ git config --global status.submodulesummary 1

// Have `git grep` print line number (-n) by default
$ git config --global grep.lineNumber true

// Have `git grep` always print full git path for each git match
$ git config --global grep.fullName true

// Have `git grep` always use extended regexp
$ git config --global grep.extendedRegexp true

// Stores username / password into OSX's keychain by remote serverg
$ git config --global credential.helper osxkeychain

// show all config
$ git config --list

```

#### Helpful Aliases

```bash
$ git config --global alias.sur "submodule update --init --recursive"
$ git config --global alias.llog "log --stat --graph --decorate --submodule"
$ git config --global alias.gba "branch --all
```

## Staging Area

Show a short status:
$ git status -s

Show a diff of what's in the index (staging area);
$ git diff --cached
$ git diff --check [--cached]        // checks for whitespace errors
$ git commit -v                      // add diff output to commit msg
$ git rm --cached <file>             // removes from git, keeps files on disk.

## Commit

```bash

# Adds diff output to the commit message (as comments)

$ git commit --amend
```

## Branches

```bash

# Lists all branches verbosely.
# Verbose prints the head SHA, extra verbose prints relevant aliases.
$ git branch -vv --all

# Creates a new branch from HEAD. Does *not* switch to it.
$ git branch [branch-name]

# Creates and checks out a new local branch from the current branch.
$ git checkout -b [branch-name]

# Create a local branch from a remote branch and tracks the remote.
$ git checkout --track origin/serverfix

# Lists all branches fully merged into the current branch
$ git branch --merged
```

## Fetching / Pushing

```bash

# Fetch all, pruning local branches which don't exist on the remotes
$ git fetch -v --all --tags

# Push local branch to remote. If [branch-name] is omitted
$ git push <remote-name> <branch-name>
$ git push origin branch-name

# If the local branch is *not* tracking a remote branch, adding [--set-upstream-branch | -u]
# will start tracking the remote branch.
$ git push -u origin [branch-name]

# Pushes [local-branch] (can be omitted for current branch) to [remote-branch] on [remote-name].
# This allows you to name the remote branch something different than the local branch.
$ git push [remote-name] [local-branch]:[remote-branch]
$ get push origin damonallison/issue22:damonallison/issue22-push-notifications

# Delete a local branch
$ git branch -d [branch-name]

# Delete a remote branch
$ git push origin --delete [branch-name]

```

## Remote

```bash

# List remotes
$ git remote -v

# Show all info about remote (including branches, tracking branches)
$ git remote show origin

# Adding a remote
$ git remote add [name] [url]
$ git remote add damon git@bitbicket.org:damonallison/test.git

```

## Merge ##

```bash
# Squashes all commits in [branch-name] into a single commit.
# --no-commit will not record a commit, rather leave the changes locally
# so you can make additional changes before committing.

git merge --no-commit --squash [branch-name]

# If we are in a conflicted state, this command will show commits that
# touched a file that's currently conflicted. Can be used to determine
# what caused the conflict (and give you hints on how you should resolve it).
$ git log --oneline --left-right --merge

# Show the entire diff of what's in merge conflict
# (as well as the branch that introduced the conflicting regions)
$ git log -p --left-right --merge

```

## Rebase

Rebasing takes all changes on one branch and replays them on top of another branch. Rebasing creates a linear commit history free of merge commits.

**IMPORTANT** Rebase rewrites history. Either *don't* or be careful when you rebase changes which have been pushed to a remote repository.

"In general the way to get the best of both worlds (merging vs. rebasing) is to rebase local changes you’ve made but haven’t shared yet before you push them in order to clean up your story, but never rebase anything you’ve pushed somewhere."

Rebase does the following:

1. Checks out the branch being rebased.
1. Finds all commits on the current branch not on the rebase branch, saving them as patches.
1. Applies patches to HEAD of the rebase branch.


    $ git rebase master

    Rebase server on top of the master branch without having to checkout server as well. This is the same as `git checkout server; git rebase master`. Checks out “server”, replaying all changes on “server” that are not on “master” to the tip of master.

    $ git rebase master server


Do *not* rebase commits that have been pushed up to a public server. Rebasing will abandon the previous commits. If anyone based their work on those commits,
they will have a mess on their hands.


## Logging ##

    List commits on origin/branch1 that are not on (local) branch1
    (Both of these forms are identical)

    $ git log [--no-merges] -- origin/branch1 --not branch1
    $ git log [--no-merges] origin/branch1..branch1

    Show list of all commits on aclone/master, not on master
    $ git log -p master..aclone/master

    Show list of all commits not one but not both branch (all commits since histories forked)
    --left-right will show you which ref the commit is in.
    $ git log -p --left-right master...aclone/master

    Show a full diff of all work on branch1 that is *not* in origin/branch1
    $ git diff origin/branch1...branch1

    Adds branch names, branch tree next to commit hashes.
    $ git log --graph --stat --decorate

    Reformat and filter commits.
    $ git log --pretty=oneline
    $ git log --pretty=format:"%h - %an, %ar : %s"
    $ git log --since 2.weeks (see also --until)

    View full patches for the last 2 commits.
    $ git log -p -2

* String search (`-S`). Find all commites containing `ZLIB_BUF_MAX`
    * `git log -SZLIB_BUF_MAX --online`

#### Shortlog ####

Git shortlog is meant for summarizing commits for a release (suitable for release notes)
    Show all commits on master not in v1.0.1 (in shortlog form)
    git shortlog --no-merges master --not v1.0.1

#### Describe ####

`git describe` returns a rather unique string for the current branch. In the following example, [branch-name] is 55 commits later than it's earliest tag (v1.1-something-great) and it's current HEAD hash is g2d22daf.

This would be useful for scripts / automation scenarios where you need a unique string to represent a point in time (more meaningful than a hash).

    $ git describe [branch-name]
    v1.1-something-great-55-g2d22daf

#### Log Search ####

    Shows all commits that contain "search_string" in the diff
    useful for finding particular commits that introduced the string.
    $ git log -Ssearch_string

    Shows all commits with "search string" **in the commit message**
    this does not search the patch set (use `git grep` to search the patch set)
    $ git log --grep "search string"

    Figures out the boundaries of `func_name` function, shows a diff
    of all changes to the function.
    $ git log -L :func_name:filename.c

## Tagging ##

Tags are full objects in git. Like branches, they are fetched and need to be pushed.

      $ git tag -a "4.1.5" -m "Release 4.1.5"           // Create an annotated tag w/ the current commit
      $ git tag -a "4.1.2" -m "Release 4.1.2" 75644aef  // Tag an existing commit
      $ git tag -l 4.1.*                                // Search for all tags starting with "4.1."

      $ git push origin 4.1.5                           // Pushes an individual tag.
      $ git push origin --tags                          // Pushes all tags.


## Stash

    -u (--include-untracked) = also save untracked changes as part of the stash

    Attempt to rebuild the index as it existed when stashing:
    $ git stash pop --index

    Stash only changes *not* added to the index:
    $ git stash --keep-index

    Creates a new branch, checks out the commit you were on when you stashed your work, apply the stash, and drops the stash if it applies successfully:
    $ get stash branch testbranch

    Removes all files (even untracked (those in .gitignore)):
    $ get stash --all


## Clean

Removes files from your working directory that are not tracked.

    -d = remove empty directories
    -f = force
    -x = remove all files - including those matching .gitignore
    -i = interactive
    -n = dry run (do not actually delete anything)

    Removes pretty much everything
    $ git clean -dfx

## Grep

    --count = print only total occurrences per file)
    --break = print a blank line between files
    --heading = print the filename on a separate line
    $ git grep "search-string" [commit]

## Rebase

WARNING : only rebase commits you have not pushed!

Interactive rebasing allows you to rewrite commit history.

    $ git rebase -i HEAD~3

If you are in the middle of a rebase, you can create multiple commits from a single commit (or introduce new commits in the middle of the rebase)

    < assume you're in the middle of a rebase - breaking on editing a commit >

    Undo the commit - leaving all modified files unstaged
    $ git reset HEAD^
    $ git add file1.txt
    $ git commit -m "first commit in the middle of a rebase"
    $ git add file2.txt
    $ git commit -m "second commit in the middle of a rebase"
    $ git rebase --continue

## Reset

Reset will move HEAD to a different commit and potentially update the index and working directory.

    --soft  = do not reset the index or working directory.
    --mixed = updates the index with whatever the commit pointed to
    --hard  = resets the working directory to what the commit pointed to
              *NOTE* --hard will remove unsaved work!

    Moves HEAD to ae42356, updates the index and working directory to match HEAD.
    $ git reset --hard ae42356

Reset on a single file in it's default form will simply make index look like HEAD (unstages the file).

    $ git reset file.txt

    Reset the file to a particular commit.
    $ git reset ab34521 file.txt

## rerere

rerere will keep a cache of merge resolutions (file by file) and automatically resolve conflicts it's seen before using resolutions stored in the cache. This is helpful if you want to keep rebasing and not resolving the same merge conflicts.

    $ git config --global rerere.enabled true


## Submodules ##

Submodules are a hack. Use a better dependency management system - like rubygems, maven, or cocoapods.

    Automatically initializes / updates submodules as part of the clone.
    $ git clone --recursive git@github.com:damonallison/project.git

    Initialize submodules in a git repo that contains them.
    $ git submodule init

    Add a git repo as a submodule.
    $ git submodule add git@github.com:damonallison/git-submod.git submod

    If you make changes to a submodule or add a new submodule, using `diff --submodule` will show you the submodule changes
    $ git diff --cached --submodule

    When you add a submodule, notice the `160000` mode. That is a special mode that tells git you are recording a commit as a directory entry, not a normal directory.

    ∴ git commit -am "Adding test submodule"
    [damon 7675566] Adding test submodule
    2 files changed, 4 insertions(+)
    create mode 100644 .gitmodules
    create mode 160000 submod

    Updating local submodules to the remote tracking branch's current SHA1.
    $ git submodule update --remote --merge

### Status ###

* `-` before the SHA-1 indicates the submodule is not initialized.
* `+` before the SHA-1 indicates the currently checked out submodule commit
      doesn't match the SHA-1 in the containing project.

	$ git submodule status --recursive

### Init ###

* Copies submodule names and urls from .gitmodules to .git/config

	$ git submodule init
	$ git submodule update --init  (use this if you don't want to customize any submodule locations)

### Update ##

* Clones missing submodules and checks out the commit specified in the index of
  the containing repository.

	$ git submodule update --recursive






Committing

Viewing history

    $ git log
		-p (show complete diffs)
		-<n> (show only last n commits)
		--stat (show only the overview (status) of the change (+/- per file))
        --graph (show branh lineage)
		--summary (show create/name)
		--no-merges (do not show merge commits)
        --pretty=oneline
        --author=damon@code42.com (filter output to author (works with partial author names i.e., "damon"))
	$ git log -p <path>...   -- prints entire file history

Remotes

    $ git remote -v show  (show all remotes verbosely)
    $ git remote show <name> (show detailed info about remote <name> - tracked branches, git pull branches, git push, stale branches)
    $ git remote add <name> <url>


Tags

Git has lightweight and annotated tags. Lightweight simply point to a commit.
Annotated tags, however, are stored as full objects in the Git database.
They’re checksummed; contain the tagger name, e-mail, and date; have a tagging
message; and can be signed and verified with GNU Privacy Guard (GPG).

    $ git tag -a tag-name -m "tag message"  // creates an annotated tag - a full object in git w/ commit msg, etc.
    $ git push origin --tags
    $ git tag -a v1.2 ae34aacd              // tag a previous commit
    $ git tag -d v1.2 (delete tag locally)
    $ git push origin :v1.2 (delete remote tag)

Branches

    If you have a local branch setup to track a remote branch, git pull
    will fetch and merge the remote branch into the local branch.

    $ git pull
	$ git checkout --track remote/branch

    $ git branch newbranch  (create a new branch called "newbranch")
    $ git branch -a -v            (show *all* branches (all remotes) verbosel)
    $ git checkout newbranch (switch active branch)
    < make changes >

    $ git checkout master   (switch back to the master branch)
    < make changes to this branch >
    $ git merge newbranch   (changes in newbranch will be merged back to master)

    $ git branch -d newbranch   (ensures changes in the experimental branch are in the current branch (safe delete))
    $ git branch -D newbranch   (force delete the branch, does not ensure changes are merged back)

    List branches which are merged into the current branch or [branch-name]
	  $ git branch --merged [branch-name]

    List branches which are *not* merged into the current branch or [branch-name]
	  $ git branch --no-merged [branch-name]

Collaboration

    $ git clone /mypath/myproject myclone  (create a full clone of myproject to myclone)

    <make changes to myclone>
    <make changes to myproject>

    $ git pull myclone master  (fetches changes from myclone and merges into master)
                               (note: you want to commit all local changes before initiating the pull)

    $ git fetch myclone master (fetch, but do not pull)
    $ git log -p HEAD..FETCH_HEAD  (show just the changes from the fetch since the histories forked)
    $ git log -p HEAD...FETCH_HEAD (show all changes (local and remote) since histories forked)

    $ git log --pretty=oneline
    Updating the clone with changes from the cloned source (from the clone dir)

    $ git pull


Remotes

    $ git remote add aclone ../aclonedir    (add a remote branch called aclone to the ../aclonedir directory)
    Fetches all changes from remote "aclone"
    $ get fetch aclone

    Fetches all remote refs, pruning removed branches.
    $ git fetch -p

    $ get remote rm aclone                  (remove aclone from the list of remote branches)

Archive

    git archive master --prefix='project/' | gzip > `git describe master`.tar.gz
