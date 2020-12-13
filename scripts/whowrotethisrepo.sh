#!/bin/bash

if [[ $1 == "-h" ]]; then
    if [[ ! -z "${SHORT_HELP_MODE}" ]]; then
        echo "for each files in git repo in current directory - show who made the first revision."
        exit 1
    fi

cat <<EOF
$0 

for each files in current git repo - show who made the first revision.
also show a summary of how many files were created per user

EOF
exit 1
fi

# find the top level directory for this git repository
TOP_DIR=`git rev-parse --show-toplevel 2>/dev/null`
if [ "x$TOP_DIR" != "x" ]; then
    cd $TOP_DIR
else 
    echo "$PWD is not a git repo"
    exit 1
fi

FILES=$(git ls-files)

for f in $FILES; do

    who_wrote_this=$(git log --pretty='%ae %ad' $f | tail -n 1)
    
    echo "$f :: $who_wrote_this"
done


WHO=""
for f in $FILES; do

    who_wrote_this=$(git log --pretty='%ae' $f | tail -n 1)

    WHO=$(echo -e "$WHO\n$who_wrote_this")

done  

echo ""
echo "summary:"
echo "$WHO" | tail -n +2 |  sort | uniq -c  






