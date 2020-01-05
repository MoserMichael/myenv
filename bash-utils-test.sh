#!/bin/bash

set -e

. bash-utils.sh

trace_on_total

title_msg_init  "BashUtilsTest" 5


title_msg "tokenize into global array" "global variable TOKEN_ARRAY"

tokenize "a1 b2 c3 d4 e5" ' '


for element in "${TOKEN_ARRAY[@]}"
do
    echo "$element"
done


title_msg "tokenize and call callback function"

function show_it
{
    echo "process token: $1"
}

tokenize_iterate "a1 b2 c3 d4 e5" ' ' show_it


title_msg "tokenize multiline variable"

INPUT_LINES=`cat <<EOF
first line
second line 
third line
EOF
`
dump_it "$INPUT_LINES"

tokenize_iterate "$INPUT_LINES" $'\n' show_it

title_msg "file size"

fsize=$(file_size $0)
echo "this script $0 is $fsize bytes long"

title_msg "range of integers (inclusive)"

for i in $(range 3 7); do
    echo "range $i"
done
