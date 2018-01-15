#
# Welcome to python!
#
# Damon Allison
# 01/11/2018
#

import sys

from algorithms.fibonacci import fib

def print_environment():
    print("argv == " + str(sys.argv))
    #
    # The module search path is the list of:
    # * Current directory
    # * $PYTHONPATH environment variable. Takes same format as $PATH (/usr/local:/usr/bin).
    # * Installation dependent default
    print("path == " + str(sys.path))
#
# If the file is being executed as a script, i.e. `python3 hellp.py`
# the module's __name__ property is set to __main__.
#
if __name__ == "__main__":

    print("hello from " + __name__)
    print_environment()

    if len(sys.argv) > 1:
        try:
            i = int(sys.argv[1])
            to = i + 100
            print("fib(" + str(to) + ") == " + str(fib.fib_to(to)))
            print("fibrec(" + str(i) + ") == " + str(fib.fibrec(i)))
        except ValueError:
            print("Unable to calculate fib(" + sys.argv[1] + ")")
