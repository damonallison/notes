# Fish Shell

## TODO

* `LaunchServices` - default text editor.
* `$PATH` / global user paths.
* Redirection

Fish is a "friendly" shell which attempts to modernize the arcane world of
legacy shells. Fish improves command line completion, scripting syntax, and has
a `oh my zsh`-like package manager called `oh my fish`.

## Features

* Follows XDG directory conventions [freedesktop.org]()
  * `~/.config/fish`
* Simple
* Intelligent command line completion
    * Fish attempts to autocomplete based on historical usage and by parsing man pages.
    * Intelligent completion will auto-complete based on the command you are running.
    * For example, typing `git checkout dam` and hitting tab will attempt to autocomplete based on git branch names.
    * Arguments. Typing `grep --i` will show you `grep --include`
    * Fish will highlight invalid commands in `red`

## Configuration

```shell
# Main configuration file
~/.config/fish/config.fish

# Fish also reads commands in conf.d
~/.config/fish/conf.d/

# When looking for a command, fish attempts to autoload functions.
# Add functions to this directory
~/.config/fish/functions

```

## Quotes

Single quoted strings do *not* perform parameter expansion. Double quoted
strings do. With both single and double quoted strings, escape sequences are
ignored.



## Path

* For compatibility with other shells, $PATH will be joined with `:` when you quote it.

```shell
echo $PATH   # /Users/damon/go1.14/bin /usr/local/opt/go/libexec/bin
echo "$PATH" # /Users/damon/go1.14/bin:/usr/local/opt/go/libexec/bin
```

* To add directories to `$PATH`, use the fish variable `fish_user_paths` universal variable, which
  is automatically prepended to `$PATH` for each shell.

* Using a variable prevents you from having to mess around with config files.


```shell
# Prepends /usr/local/bin/damon to $fish_user_paths
# $fish_user_paths will automatically be prepended to $PATH when the shell launches

set -U fish_user_paths /usr/local/bin/damon $fish_user_paths
```



## Wildcards

```shell
# Single directory search
ls *.jpg

# Recursive wildcard search (nice!)
ls **.jpg

#
# Recursive delete for files matching a pattern
# -p will stop and prompt before each command
#
ls **.orig | xargs [-p] rm -v
```

## Pipes and Redirection

All three file descriptors can be redirected to a different output than its
default through redirection.

* FD 0 == stdin
* FD 1 == stdout
* FD 2 == stderr

```shell
#
# fish supports typical stdin / stdout redirection with < >
# stderr is redirected with >2
#
grep fish < /etc/shells > ~/output.txt 2> ~/errors.txt

#
# To redirect stdout and stderr into one file, you need to first redirect stdout, then stderr into stdout.
#
# 2>&1 == "redirect stderr to FD 1 (stdout)"
#
make > out.txt 2>&1
#
# As a convenience, the redirection "&>" bcan be used to redirect both stdout and stderr to the same file.
#
make &> out.txt

```

## Tab Completions

* To auto-accept a fish completion suggestion, hit `->` or `Ctrl-f`.

## Variables

* Fish has three variable scopes: `local`, `global`, and `universal`.
  * `local` variables are scoped to the function they are in.
  * `global` variables are scoped to the current shell
  * `universal` variables are shared between *all* shell instances and will be preserved across shell restarts

* Exporting
  * `-x` causes the variable to be exported exported to child processes.
  * `-u` causes the variable to be "unexported"


```shell
# Creating a variable
set myname "Damon Allison"

# Like other shells, use $ for variable substitution.
#
# Important: Variable substitution only happens in double quoted strings, not single quoted strings
echo "Hi, my name is $myname"

set -e $myname

#
# Lists
#
# *ALL* variables in fish are lists of strings. Some are simply lists of 1.
#
# Lists are separated with spaces, not ";"
#
# PATH is a list, not a colon-delimited string.
set PATH /usr/local/bin/path /usr/sbin $PATH

# Removing an item from a list. Note: lists start @ 1 in fish.
set -e PATH[1]

# Add to end of list
set PATH $PATH /hello
# OR use --append
set --append PATH /hello


# Add to beginning of list
set PATH /hello $PATH
# OR use --prepend
set --prepend PATH /hello

# To remove an item from the path (this feels like a hack)
# match all elements in $PATH which are *NOT* the element you want
set PATH (string match -v /usr/local/bin $PATH)

# Length
count $PATH

# Slices
echo $PATH[1..3]
echo $PATH[3..(count $PATH)]

# Enumeration
for val in $PATH
  echo "var == $val"
end

# Lists are 1 based
set names damon ryan allison
echo $names[1] $names[3] # damon allison


#
# Variable exports
#
# Exporting in bash makes the variable available to any forked
# child process. Fish does *not* have the export command. To export a variable
# in fish, use `set -x`

set -x myname "Damon Allison"


```

## Command Substitution

* Fish uses () rather than `` for command substitution.

```shell
echo In (pwd), running (uname)

set os (uname -a)

# Command substitution is *not* expanded within quotes. Instead, you temporarily close the quotes,
# add the command substitution, and reopen them in the same argument

touch "testing_"(date +%s)".txt"
```

## Combiners (and, or, not)

```shell
# fish supports && and || to combine commands and ! to negate them
./configure && make && make install

# fish supports `and`, `or`, and `not`. `and` and `or` are job
# modifiers and have lower precedence
cp file.txt && cp file2.txt; and echo "success"; or echo "failed"
```

## Conditionals

* Use `if`, `else if` and `else` to conditionally execute code based on the status of a command:

```shell
if grep fish /etc/shells
    echo found fish
else if grep bash /etc/shells
    echo found bash
else
    echo got nothing
end

# to compare strings or numbers, use test
if test "$fish" = "flounder"
    echo "founder"
end

if test "$number" -gt 5
    echo $number is greater than five
else
    echo $number is five or less
end

# using combiners for more complex conditions
if grep fish /etc/shells; and command -sq fish
    echo fish is installed and configured
end

# You can use "begin" and "end" to group expressions (for multiple expressions)
```

## Functions

* A function is a list of commands that may optionally take arguments.
* Arguments are *NOT* passed in via "numbered values" ($1, $2), rather in a single $argv list
* Fish does *not* have aliases. Functions take their place.

```shell
function say_hello
    echo Hello $argv
end

# To list the names of all functions, use the `functions` built-in
functions

# To see the source of a function, pass it's name to `functions`
functions say_hello

```

Functions can be auto-loaded. Any file in `$fish_function_path` with the name of
the function plus the suffix `.fish` will be autoloaded when needed.

## Configuration

* `fish` starts by executing commands in `~/.config/fish/config.fish`

* Functions can be put into an "autoloading functions" directory. All files in
  this directory will be loaded when the command is encountered.

  * `~/.config/fish/functions/ll.fish`


## Abbreviations (aliases)

Abbreviations are stored in a variable called `fish_user_abbreviations`. Add abbreviations to `fish.config`

```
if status --is-interactive
    set -g fish_user_abbreviations
    abbr --add first 'echo my first abbreviation'
    abbr --add second 'echo my second abbreviation'
    # etcetera
end
```
