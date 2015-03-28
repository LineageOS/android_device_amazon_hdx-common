#!/usr/bin/env python
from __future__ import print_function

from cuber import forge
from struct import unpack
from hashlib import sha256


def u4(b, i):
    return unpack('<I', b[i:i+4])[0]

def up(x, p):
    return -(-x & -p)


def fixboot(fn):
    f = open(fn, "rb+")

    # read image header
    b = f.read(1024)

    if not b'ANDROID!' == b[:8]: return "Not ANDROID!"

    # get page size
    p = u4(b, 36)

    # compute DT offset
    s = p
    for i in (8, 16, 24):
        s += up(u4(b, i), p)

    # read DT header
    f.seek(s)
    d = bytearray(f.read(p))

    # fix kernel cmdline
    w = f.read(p)
    m = None
    if b'Amazon Apollo' in w:
        m = b' mdss_mdp.panel=0:qcom,mdss_dsi_jdi_dualmipi0_video:1:qcom,mdss_dsi_jdi_dualmipi1_video:'
    if b'Amazon Thor' in w:
        m = b' mdss_mdp.panel=0:qcom,mdss_dsi_novatek_1080p_video'
    if m and not m in b[64:576]:
        f.seek(64 + b[64:].find(b'\x00'))
        f.write(m)

    # convert DT from v2 to v1
    if b'QCDT' == d[:4] and 2 == u4(d, 4):
        n = 24 + 20 * u4(d, 8)
        for i in range(24, n + 1, 20):
            del d[i-4:i]
            d += bytearray(4)
        d[4] = 1
        f.seek(s)
        f.write(d)

    # compute image size
    s += up(u4(b, 40), p)

    # sign image
    f.seek(0)
    h = sha256()
    h.update(f.read(s))
    f.seek(s) ### WHY is this needed for Python2 on Windows?!?
    f.write(forge(h.digest()))
    f.write(bytearray(p - 256))
    f.close()
    print('sha256=%s' % h.hexdigest())
    print('offset=%u' % s)
    print('Your image \'' + fn + '\' is now "signed".')


if __name__ == "__main__":
    from sys import argv, stderr, exit
    from os import path

    e = 'Usage: %s [bits|boot.img]' % path.basename(argv[0])

    if 2 == len(argv) and path.exists(argv[1]): e = fixboot(argv[1])

    if e:
        print(e, file=stderr)
        exit(1)
