#!/bin/bash

#---
# add other filter functions here
#---

function sfilter_shell()
{
     find . -type f \( -name '*.sh' \) -print0 2>/dev/null 
}

function sfilter_cpp() {
     find . -type f \( -name '*.cpp' -o -name '*.cxx' -o -name '*.hpp' -o -name '*.hxx' -o -name '*.h' \) -print0 2>/dev/null 
}

function sfilter_go() {
     find . -type f \( -name '*.go' -o -name '*.mod' \) -print0 2>/dev/null 
}

function sfilter_git() {
     git status . 2>&1 >/dev/null
     if [ $? != 0 ]; then
        echo "Error: current directory is not part of a git tree"
        exit 1
     fi
     git ls-files -z 
}

function sfilter_py() {
     find . -type f \( -name '*.py' -o -name '*.py3' \) -print0 2>/dev/null 
}

show_filters() {
    declare -F | awk '{ print $3 }' | grep sfilter_ |  sed -e 's/sfilter_\(.*\)/\1/g' | tr '\n' ' '
}


function Help {
    if [[ $1 != "" ]]; then
        echo "Error: $*"
    fi

    if [[ ! -z "${SHORT_HELP_MODE}" ]]; then
        echo "-s <source filter> -f <from> -t <to> [-v -h] : find replace in multiple files"
        exit 1
    fi

cat <<EOF
$0 -s <source filter> -f <from> -t <to> [-v -h]

apply replace to multiple input ifles

-s <source filter>      : specify input files; available values: $(show_filters)
-f <from>               : replace from
-t <to>                 : replace to
-r                      : report how many files were changed.

source filter runs find and then it pipes it into sed to replace it.

EOF

exit 1
}

REPORT_CHANGES=false
while getopts "hvrs:f:t:" opt; do
  case ${opt} in
    h)
	Help
        ;;
    s)
        SOURCE_FILES="$OPTARG"
        ;;
    f)
        FROM="$OPTARG"
        ;;
    t)
        TO="$OPTARG"
        ;;
    v)
	set -x
	export PS4='+(${BASH_SOURCE}:${LINENO})'
	VERBOSE=1
        ;; 
    r)
        REPORT_CHANGES=true
        ;;
    *)
        Help "Invalid option"
        ;;
   esac
done	

if [[ "$FROM" == "" ]]; then
    Help "No -f option"
fi

if [[ "$TO" == "" ]]; then
    Help "No -t option" 
fi

if [[ "$SOURCE_FILES" == "" ]]; then
    Help "No -s option" 
fi

function escape_me {
    local TMP="$1"

    TMP=$(echo $TMP | sed -e 's/#/\#/g' -e 's# #\\ #g' -e 's#&#\\&#g')

    echo "$TMP"
}


FROM=$(escape_me "$FROM")
TO=$(escape_me "$TO")

FILTER="sfilter_${SOURCE_FILES}"

echo $(show_filters) | grep $SOURCE_FILES >/dev/null
if [ $? != 0 ]; then
    Help "Filter ${SOURCE_FILES} does not exit. add a function sfilter_${SOURCE_FILES} to $0"
fi


function just_find_and_replace() 
{
    # that one does the job, but one doesn't have an indication of how many files changed.
    $FILTER | xargs -0 sed -i 's#'"$FROM"'#'"$TO"'#g'
}


function find_replace_and_report_substitutions() {
   local foundfiles
   local substitutedfiles
   
   local test_file=$(mktemp /tmp/check-find-replace.XXXXXX) 
   trap 'rm -f '"${test_file}"'' INT TERM HUP EXIT
    
   foundfiles=0
   substitutedfiles=0
   while IFS= read -r -d '' line; do 
        
        sed -i -e 's#'"$FROM"'#'"$TO"'#w '$test_file'' $line

        if [ -s $test_file ]; then
            ((substitutedfiles+=1))
        fi

        ((foundfiles+=1))
   done < <($FILTER)

cat <<EOF
files modified: ${substitutedfiles}
files found by filter: ${foundfiles}
EOF

}

if [ "$REPORT_CHANGES" == "true" ]; then
    find_replace_and_report_substitutions 
else    
    just_find_and_replace
fi





