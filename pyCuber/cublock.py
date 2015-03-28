#!/usr/bin/env python
from __future__ import print_function

from cuber import forge

def b(ss):
    return ('0x%02x%08x\n' % tuple([int(x,16) for x in ss])).encode('ascii')

if __name__ == "__main__":
    from sys import argv, exc_info, exit
    from os import path

    m = 'Usage: %s manfid serial' % path.basename(argv[0])
    u = 'unlock.img'


    if 3 == len(argv):
        try:
            f = open(u, 'wb')
            f.write(forge(b(argv[1:3])))
            f.close()
            m = "Your unlock code is in '%s'." % u
        except:
            m = exc_info()
        
    print(m)
