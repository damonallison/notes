# Fish Shell

## Wildcards

```shell
# Single directory search
ls *.jpg

# Recursive wildcard search (nice!)
ls **.jpg
```

## Pipes and Redirection

```shell
# fish supports typical stdin / stdout redirection with < >
# stderr is redirected with >2

grep fish < /etc/shells > ~/output.txt 2> ~/errors.txt
```

## Tab Completions

* To auto-accept a fish completion suggestion, hit `->` or `Ctrl-f`.

## Variables

```shell
# Creating a variable
set myname "Damon Allison"

echo "Hi, my name is $myname"

# PATH is a list, not a colon-delimited string.
# Lists are separated with spaces, not ";"
set PATH /usr/local/bin/path /usr/sbin $PATH

# Removing an item from a list. Note: lists start @ 1 in fish.
set -e PATH[1]

# Exporting. Exporting in bash makes the variable available to any forked
# child process. Fish does *not* have the export command. To export a variable
# in fish, use `set -x`

set -x myname "Damon Allison"

# Add to end of list
set --append PATH /hello

# Add to beginning of list
set --prepend PATH /hello

for val in $PATH
  echo "var == $val"
end
```

## Command Substitution

Fish uses () rather than `` for command substitution.

```shell
echo In (pwd), running (uname)

set os (uname -a)

```

## Combiners

```shell
# fish supports && and ||
./configure && make && make install

# fish supports `and`, `or`, and `not`. `and` and `or` are job
# modifiers and have lower precedence
cp file.txt && cp file2.txt; and echo "success"; or echo "failed"
```

## Conditionals

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


