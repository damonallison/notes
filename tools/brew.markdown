# Homebrew #

## Administration ##

$ brew update                   # update the system software.
$ brew outdated                 # show outdated formulas.
$ brew upgrade                  # update all outdated formulae.
$ brew cleanup --force          # remove any older version of installed formulae.
$ brew doctor                   # look for specific problems.
$ brew missing                  # find any missing dependencies.
$ brew prune                    # removes dead symlinks (typically not needed, but doesn't hurt)
$ brew leaves                   # find any "leaves" (not dependents of other formulas).
                                # these are candidates to be deleted!

### Formula specific ###

$ brew -S git                   # search for git
$ brew info <formula>
$ brew deps --tree <formula>    # show a formula's dependencies
$ brew uses <formula>           # show which formulas depend on <formula>
$ brew options <formula>        # show options that a formula allows.
$ brew install 
    --use-gcc                   # attempt to use GCC (useful when LLVM is the default)
    --use-llvm                  # attempt to compile using the LLVM front-end.
