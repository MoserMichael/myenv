#!/bin/bash

set -x

OUT=README.md
LINKBASE="https://github.com/MoserMichael/myenv/blob/master/scripts/"

cat template >${OUT}

cat  >>${OUT} <<EOF

# short description of aliases and scripts 

EOF

echo '```'  >>${OUT} 

ALIASES="$ALIASES $FILES"

bash -ci "show" >>${OUT} 
#bash -ci "show" | sed -e 's/>/\&gt;/g' -e 's/</\&lt;/g' >>${OUT} 
echo '```'  >>${OUT} 


FILES=$(ls scripts)

cat >>${OUT} <<EOF

# scripts in more detail

EOF


for f in $FILES; do
    echo "[link to $f](${LINKBASE}/$f)" >>${OUT}
    echo '```'  >>${OUT} 
    ./scripts/$f -h  >>${OUT}
    #./scripts/$f -h | sed -e 's/>/\&gt;/g' -e 's/</\&lt;/g' >>${OUT}
    echo '```'  >>${OUT} 
done



