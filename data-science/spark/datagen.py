"""Generate fake data into data/names.txt

Specify a command line argument to write n number of fake names.

python3
"""

import sys
import os
import errno

from faker import Faker

FILE = "data/names.txt"

# Avoids any race condition and
import os, errno

"""Silently remove a file if it exists"""
def silentremove(filename):
    try:
        os.remove(filename)
    except OSError as e: # this would be "except OSError, e:" before Python 2.6
        if e.errno != errno.ENOENT: # errno.ENOENT = no such file or directory
            raise # re-raise exception if a different error occurred

silentremove(FILE)

count = 1
if len(sys.argv) > 1:
    count = int(sys.argv[1])

print(f"Appending {count} names to {FILE}")

f = open(FILE, "a")
fake = Faker()

for i in range(count):
    f.writelines([f"{fake.name()}\n"])
    if i % 100 == 0:
        print(f"Wrote: {i}")

f.close()