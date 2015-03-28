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
echo "Example #1: signing 0x1234567890"
echo

echo 0x1234567890 | openssl rsautl -sign -inkey $k > $s
vrfy

echo
echo "Decrypted FORGED signature (showing padding)"
echo 0x1234567890 | python cuber.py | openssl rsautl -verify -inkey $k -hexdump -raw
echo


echo
echo "Example #2: signing '$1'"
echo

off=$(python cuboot.py "$1")
echo "$off"
off=${off##*offset=}
off=${off%%$'\n'*}

python split.py "$1" $off $i
python split.py $i.1 256 $s

openssl dgst -sha256 -binary < $i.0 | openssl rsautl -sign -inkey $k > $s
vrfy

echo
echo "Decrypted FORGED signature (showing padding)"
openssl rsautl -verify -inkey $k -hexdump -raw < $s.0
echo

rm -fr $d
