#!/usr/bin/env python
from __future__ import print_function


def b2l(b):
    l = 0
    for i in bytearray(b):
        l <<= 8
        l |= i
    return l

def l2b(l, n):
    b = bytearray(n)
    for i in range(n-1,-1,-1):
        b[i] = 0xFF & l
        l >>= 8
    return b
    

def forge(a, b = 2048):
    na = len(a) << 3
    if not na:
        raise ValueError('Zero length bytearray: nothing to sign')

    sh = b - na - 88
    if 0 > sh:
        raise IndexError('Input bytearray too long for key + padding')

    s3 = (0x0001FFFFFFFFFFFFFFFF00 << na) | b2l(a)

    lo = 1 << ((b - 16) // 3)
    hi = lo << 1
    fs = None

    while True:
        s = (lo + hi + 1) >> 1
        w = (s * s * s) >> sh

        if w == s3:
            fs = s
            sh -= 8
            s3 <<= 8
            continue

        if s == lo or s == hi:
            if fs:
                return l2b(fs, b >> 3)
            else:
                raise RuntimeError('No perfect cube in available range.')

        if w < s3: lo = s
        else: hi = s



if __name__ == "__main__":
    from sys import platform, argv, stderr, exit
    from os import isatty, read, write

    if platform.startswith('win'):
        from msvcrt import setmode
        from os import O_BINARY
        setmode(0, O_BINARY)
        setmode(1, O_BINARY)


    def use():
        print('Usage: %s [bits] [<data] [>sig]\n' % path.basename(argv[0]),
              file=stderr)
        exit(1)


    if 2 < len(argv) or isatty(0): use

    if 1 == len(argv):
        b = 2048
    else:
        try:
            b = int(argv[1])
        except ValueError:
            use
        
    a = forge(read(0, (b >> 3) - 11), b)

    if isatty(1): print(format(b2l(a),'0512x'))
    else: write(1, a)
