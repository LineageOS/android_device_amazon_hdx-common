#!/bin/bash

if ! [ "$1" ] || ! [ -r "$1" ]
then
    echo "Usage: ${0##*/} boot-image"
    exit 1
fi

d=$(mktemp -d xmpls.XXXXXXXX)
i=$d/img
k=$d/key
s=$d/sig

vrfy() {
    echo
    echo "Decrypted REAL signature"
    openssl rsautl -verify -inkey $k -hexdump < $s
    echo
    echo "Decrypted REAL signature (showing padding)"
    openssl rsautl -verify -inkey $k -hexdump -raw < $s
    echo
}

openssl genrsa -3 2048 > $k

echo
echo "signing '$1'"
echo

off=$(python ${0%/*}/cuboot.py "$1")
echo "$off"
off=${off##*offset=}
off=${off%%$'\n'*}

python ${0%/*}/split.py "$1" $off $i
python ${0%/*}/split.py $i.1 256 $s

openssl dgst -sha256 -binary < $i.0 | openssl rsautl -sign -inkey $k > $s

rm -fr $d
