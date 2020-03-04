#!/bin/bash

set -x

OUT=README.me
LINKBASE="https://github.com/MoserMichael/myenv"

cat README.template >${OUT}

FILES=$(ls scripts)

for f in $FILES; do
    echo "[link to $f](${LINKBASE}/scripts/$f)" >>${OUT}
    echo '```'  >>${OUT} 
    ./scripts/$f -h | sed -e 's/>/\&gt;/g' -e 's/</\&lt;/g' >>${OUT}
    echo '```'  >>${OUT} 
done
