#!/bin/bash

set -x

OUT=README.md
LINKBASE="https://github.com/MoserMichael/myenv/blob/master/scripts/"

cat template >${OUT}

FILES=$(ls scripts)

for f in $FILES; do
    echo "[link to $f](${LINKBASE}/scripts/$f)" >>${OUT}
    echo '```'  >>${OUT} 
    ./scripts/$f -h | sed -e 's/>/\&gt;/g' -e 's/</\&lt;/g' >>${OUT}
    echo '```'  >>${OUT} 
done


cat  >>${OUT} <<EOF

# Aliases and functions added in .bashrc

EOF

echo '```'  >>${OUT} 
bash -ci "show" | sed -e 's/>/\&gt;/g' -e 's/</\&lt;/g' >>${OUT} 
echo '```'  >>${OUT} 

