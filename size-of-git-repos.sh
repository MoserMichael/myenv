#!/bin/bash

# finds all git repositories under the curren directory and sorts them by disk space they consume

REPO_DIRS=$(find . -name '.git' -type 'd')

OUT=""

while IFS= read -r line; do 
    dir=$(dirname "$line")
    OUT="$OUT"'\n'$(du -sh "$dir")
done <<< "$REPO_DIRS"

echo -e "$OUT" | sort -h -k 1
