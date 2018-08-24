# rvm cheatsheet

rvm get head     // update rvm

rvm list         // list installed rubies
rvm list known   // list all rubies


rvm --default use ruby-2.5.1     // use ruby-2.5.1 by default for all new shells
rvm [--default] use system       // switch back to the OS default


## Gemsets

rvm gemsets list
rvm gemset create ios
rvm gemset use ios                  // switch to the ios gemset
rvm --default use ruby-2.5.1@ios    // use the `ios` gemset by default. (use a named gemset with an rvm action using `@gemset`

)



