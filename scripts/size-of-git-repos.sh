#!/bin/bash

if [[ $1 == "-h" ]]; then
    cat <<EOF
finds all subdirectories of the current directory that have git repos (that include directory .git)
shows the size of the git repository in human readable form.

this can be usefull when you have to cleanup your disk and make some space.
EOF
    exit 1
    

fi


# finds all git repositories under the curren directory and sorts them by disk space they consume
find . -name '.git' -type 'd' -print0 | xargs -0  du -sh | sort -h -k 1

#REPO_DIRS=$(find . -name '.git' -type 'd')
#
#OUT=""
#
#while IFS= read -r line; do 
#    dir=$(dirname "$line")
#    OUT="$OUT"'\n'$(du -sh "$dir")
#done <<< "$REPO_DIRS"
#
#echo -e "$OUT" | sort -h -k 1
