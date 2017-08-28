# Fish Shell

## Variables

```
-- creating a variable
set var_name value

-- path is a list, not a colon-delimited string
set PATH /usr/local/bin/path /usr/sbin $PATH

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


