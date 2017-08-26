# Homebrew

## General Commands

<table>
  <th>Command</th>
  <th>Description</th>
  <tr>
    <td>`$ brew help [command]`</td>
    <td>Get help for any command.</td>
  </tr>
  <tr>
    <td>`$ brew commands --include-aliases`</td>
    <td>Show a list of built-in and external commands.</td>
  </tr>
</table>


## Package Administration

<table>
  <th>Command</th>
  <th>Description</th>
  <tr>
    <td>`$ brew search [--desc] emacs`</td>
    <td>
      Search formula for `emacs`.<br>
      `--desc` will include matches against a formula's description as well as name.
  </tr>
  <tr>
    <td>`$ brew list [--versions]`</td>
    <td>
      List all installed formula.<br>
      `--versions` includes version numbers.
    </td>
  </tr>
  <tr>
    <td>`$ brew install emacs [options]`</td>
    <td>
      Install the formula.<br>
      To view the list of available options, use `brew options emacs`.
    </td>
  </tr>
  <tr>
    <td>`$ brew update [--force | -f]`</td>
    <td>
      Gets the latest version of `brew` and all formula from github.<br>
      Use `-f` to always do a slower, full update check, even if unnecessary.
    </td>
  </tr>
  <tr>
    <td>`$ brew outdated [--verbose]`</td>
    <td>
      Show outdated formula that have upgrades available.<br>
      `--verbose` to display detailed version information.
    </td>
  </tr>
  <tr>
    <td>`$ brew upgrade [--cleanup]`</td>
    <td>
      Upgrade outdated, unpinned brews.<br>
      `--cleanup` to remove previously installed formula.
    </td>
  </tr>
  <tr>
    <td>`$ brew cleanup -s [--dry-run]`</td>
    <td>
      Remove any older version of installed formula.<br>
      `-s` "scrubs the cache" - removing all cached formula.
    </td>
  </tr>
  <tr>
    <td>`$ brew leaves`</td>
    <td>
      Find "leaves" (not dependents of other formula).<br>
      **These are candidates to be deleted!**
    </td>
  </tr>
</table>


## Formula specific

<table>
  <th>Command</th>
  <th>Description</th>
  <tr>
    <td>`$ brew info [--github] emacs`</td>
    <td>
      List all installed formula.<br>
      `--github` will open the github page for the formula.
    </td>
  </tr>
  <tr>
    <td>`$ brew cat emacs`</td>
    <td>`cat` the raw formula source for `emacs`. Info on steroids.</td>
  </tr>

  <tr>
    <td>`$ brew deps --tree emacs`</td>
    <td>List all dependencies of [emacs] as a tree.</td>
  </tr>
  <tr>
    <td>`$ brew uses [--installed] pcre`</td>
    <td>
      Find formula who list `pcre` as a dependency.<br>
      `--installed` will only list installed formula who depend on `pcre`.
    </td>
  </tr>
  <tr>
    <td>`$ brew options emacs`</td>
    <td>Show the install options available for `emacs`.</td>
  </tr>
</table>

## Troubleshooting

<table>
  <th>Command</th>
  <th>Description</th>
  <tr>
    <td>`$ brew config`</td>
    <td>Show the current `brew` machine configuration.</td>
  </tr>
  <tr>
    <td>`$ brew doctor`</td>
    <td>Checks the system for potential problems.</td>
  </tr>
  <tr>
    <td>`$ brew missing`</td>
    <td>* Find any missing dependencies for installed formula.</td>
  </tr>
  <tr>
    <td>`$ brew prune`</td>
    <td>Removes dead symlinks (typically not needed, but doesn't hurt).</td>
  </tr>
</table>
