#!/usr/bin/env python
from __future__ import print_function


def w(n, b):
    if path.exists(n): raise RuntimeError("File exists", n)
    f = open(n, "wb")
    f.write(b)
    f.close()

def split(fn, off, pfx):
    f = open(fn, "rb")
    w(pfx + ".0", f.read(off))
    f.seek(off)
    w(pfx + ".1", f.read())
    f.close()

if __name__ == "__main__":
    from sys import argv, stderr, exit
    from os import path

    e = 'Usage: %s filename offset prefix' % path.basename(argv[0])

    if 4 == len(argv) and path.exists(argv[1]):
        try:
            split(argv[1], int(argv[2]), argv[3])
            e = None
        except Exception as x:
            e = repr(x)

    if e:
        print(e, file=stderr)
        exit(1)
